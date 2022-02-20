--[[
* Addons - Copyright (c) 2021 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

addon.name      = 'repeater';
addon.author    = 'atom0s & Felgar';
addon.version   = '1.0';
addon.desc      = 'Allows setting a command to be repeated automatically.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- Repeater Variables
local repeater = T{
    freq = ashita.time.qpf(),
    last = ashita.time.qpc(),

    enabled = false,
    delay   = 5000, -- The delay between command executions.
    jitter  = 0,    -- The 'randomness' added to the delays to make the usage less 'bot-like'.
    cmd     = '',   -- The command to execute.
};

-- Update the random seed..
math.randomseed(os.time());

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/repeater help', 'Displays the addons help information.' },
        { '/repeater', 'Displays the addons current settings.' },
        { '/repeater start', 'Starts repeating the set command.' },
        { '/repeater stop', 'Stops repeating the set command.' },
        { '/repeater (command | cmd | set) <command>', 'Sets the command to repeat.' },
        { '/repeater (delay | cycle) <amount>', 'Sets the delay (in milliseconds) between repeating the command execution.' },
        { '/repeater jitter <amount>', 'Sets the additional maximum randomness (in milliseconds) added to the delay, if desired. (To act less bot-like.)' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/repeater', '/repeat', '/rp')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /repeater - Displays the current addon settings.
    if (#args == 1) then
        print(chat.header(addon.name):append(chat.message('Command set to: ')):append(chat.success(repeater.cmd)));
        print(chat.header(addon.name):append(chat.message('Delay set to: ')):append(chat.success(repeater.delay)):append(chat.success('ms')));
        print(chat.header(addon.name):append(chat.message('Jitter set to: ')):append(chat.success(repeater.jitter)):append(chat.success('ms')));
        return;
    end

    -- Handle: /repeater help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /repeater start - Starts repeating the set command.
    if (#args == 2 and args[2]:any('start')) then
        if (repeater.cmd == nil or repeater.cmd:len() == 0) then
            print(chat.header(addon.name):append(chat.error('You must set a command first.')));
            return;
        end

        repeater.last = ashita.time.qpc();
        repeater.curr = ashita.time.qpc();
        repeater.enabled = true;

        print(chat.header(addon.name):append(chat.message('Starting...')));
            
        -- Execute the set command first run..
        AshitaCore:GetChatManager():QueueCommand(1, repeater.cmd);
            
        return;
    end

    -- Handle: /repeater stop - Stops repeating the set command.
    if (#args == 2 and args[2]:any('stop')) then
        repeater.enabled = false;

        print(chat.header(addon.name):append(chat.message('Stopped.')));
        return;
    end

    -- Handle: /repeater (command | cmd | set) <command> - Sets the command to repeat.
    if (#args >= 3 and args[2]:any('command', 'cmd', 'set')) then
        repeater.cmd = e.command:sub(e.command:find(' ', e.command:find(' ') + 1) + 1);

        print(chat.header(addon.name):append(chat.message('Command set to: ')):append(chat.success(repeater.cmd)));
        return;
    end

    -- Handle: /repeater (delay | cycle) <amount> - Sets the delay (in milliseconds) between repeating the command execution.
    if (#args >= 3 and args[2]:any('delay', 'cycle')) then
        repeater.delay = math.max(args[3]:num_or(1000), 0);

        print(chat.header(addon.name):append(chat.message('Delay set to: ')):append(chat.success(repeater.delay)):append(chat.success('ms')));
        return;
    end

    -- Handle: /repeater jitter <amount> - Sets the additional maximum randomness (in milliseconds) added to the delay, if desired. (To act less bot-like.)
    if (#args >= 3 and args[2]:any('jitter')) then
        repeater.jitter = math.max(args[3]:num_or(1000), 0);

        print(chat.header(addon.name):append(chat.message('Jitter set to: ')):append(chat.success(repeater.jitter)):append(chat.success('ms')));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: d3d_beginscene
* desc : Event called when the Direct3D device is beginning a scene.
--]]
ashita.events.register('d3d_beginscene', 'beginscene_cb', function ()
    if (not repeater.enabled) then return; end

    -- Obtain the current time info..
    repeater.curr = ashita.time.qpc();

    -- Calculate the difference (in ms)..
    local diff = (repeater.curr.q - repeater.last.q) * 1000.0 / repeater.freq.q;

    -- Check if the delay time has passed..
    if (diff >= repeater.delay) then
        repeater.last = repeater.curr;

        -- Handle jitter randomness..
        if (repeater.jitter > 0) then
            repeater.last.q = repeater.last.q + math.randomrng(0, repeater.jitter) * 10000;
        end

        -- Execute the set command..
        AshitaCore:GetChatManager():QueueCommand(1, repeater.cmd);
    end
end);
