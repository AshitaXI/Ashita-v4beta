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

addon.name      = 'onevent';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Reacts to chat based events with customized commands.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- OnEvent Variables
local onevent = {
    events = T{ },
    paused = false,
};

--[[
* Returns the remaining part of the onevent command with the main command removed.
*
* @param {string} cmd - The command to remove the onevent command from.
* @return {string} The remaining command string.
--]]
local function remove_cmd(cmd)
    return cmd:sub(cmd:find('/onevent add') and 14 or 9);
end

--[[
* Returns the onevent command split into its trigger and action.
*
* @param {string} cmd - The command to obtain the trigger and action from.
* @return {string, string} The command trigger and command action split from the full command.
--]]
local function split_cmd(cmd)
    cmd = remove_cmd(cmd);

    local t, a = cmd:match('([^,]+) | ([^,]+)');
    if (a == nil or a == cmd) then
        t, a = cmd:match('([^,]+)|([^,]+)');
    end

    return t, a;
end

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    isError = isError or false;

    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/onevent add <trigger>|<action>', 'Adds a new trigger to react to.' },
        { '/onevent (remove | rem | delete | del) <trigger>', 'Deletes an existing registered trigger from the known list.' },
        { '/onevent (removeall | remall | deletall | delall)', 'Deletes all current registered triggers.' },
        { '/onevent list', 'Lists the current registered triggers to react to.' },
        { '/onevent help', 'Displays the addons help information.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Helpers that pause OnEvents trigger parsing while processing a command.
--]]
local function pause() onevent.paused = true; end
local function unpause() onevent.paused = false; end

--[[
* Command event callback handler.
*
* @param {userdata} e - The event args of the command event.
--]]
local function cmd(e, args)
    -- Handle: /onevent add <trigger>|<action>
    -- Handle: /onevent add <trigger> | <action>
    if (#args >= 3 and args[2]:any('add')) then
        -- Parse the trigger and action from the command..
        local trigger, action = split_cmd(e.command);
        if (action == nil) then
            print(chat.header(addon.name):append(chat.error('Error: Could not parse the required action from the given command!')));
            return;
        end

        -- Update existing trigger entry if available..
        for k, v in pairs(onevent.events) do
            if (v[1] == trigger) then
                v[2] = action;
                print(chat.header(addon.name):append(chat.message(('Updated existing trigger: %s => %s'):fmt(chat.success(trigger), chat.success(action)))));
                return;
            end
        end

        -- Register the new trigger..
        table.insert(onevent.events, { trigger, action });
        print(chat.header(addon.name):append(chat.message(('Registered new trigger: %s => %s'):fmt(chat.success(trigger), chat.success(action)))));
        return;
    end

    -- Handle: /onevent remove <trigger>
    -- Handle: /onevent rem <trigger>
    -- Handle: /onevent delete <trigger>
    -- Handle: /onevent del <trigger>
    if (#args >= 3 and args[2]:any('remove', 'rem', 'delete', 'del')) then
        local trigger = e.command:sub(e.command:find(' ', e.command:find(' ') + 1) + 1);

        for x = 1, #onevent.events do
            if (onevent.events[x][1] == trigger) then
                table.remove(onevent.events, x);
                print(chat.header(addon.name):append(chat.message(('Removed trigger: %s'):fmt(chat.success(trigger)))));
                return;
            end
        end

        print(chat.header(addon.name):append(chat.error(('No existing trigger found to remove: %s'):fmt(chat.success(trigger)))));
        return;
    end

    -- Handle: /onevent removeall
    -- Handle: /onevent remall
    -- Handle: /onevent deleteall
    -- Handle: /onevent delall
    if (#args >= 2 and args[2]:any('removeall', 'remall', 'deleteall', 'delall')) then
        onevent.events = T{ };
        print(chat.header(addon.name):append(chat.message(('Removed all registered triggers!'))));
        return;
    end

    -- Handle: /onevent list
    if (#args >= 2 and args[2]:any('list')) then
        if (#onevent.events == 0) then
            print(chat.header(addon.name):append(chat.message(('No triggers currently registered.'))));
        end

        for _, v in pairs(onevent.events) do
            print(chat.header(addon.name):append(chat.message(('Trigger: %s => %s'):fmt(chat.success(v[1]), chat.success(v[2])))));
        end

        return;
    end

    -- Handle: /onevent help
    if (#args >= 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Treat all other sub commands as an error..
    print_help(true);
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command args..
    local args = e.command:args();

    -- Ensure the command is for onevent..
    if (#args >= 1 and not (args[1]:ieq('/onevent') or args[1]:ieq('/oe'))) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Skip invalid command attempts..
    if (#args <= 1 or e.command:contains('<st')) then
        return;
    end

    -- Process the command while pausing the addon from interpreting new chat..
    (function () end):dispatch(pause, cmd, unpause)(e, args);
end);

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ashita.events.register('text_in', 'text_in_cb', function (e)
    if (onevent.paused) then return; end

    onevent.events:ieach(function (v)
        if (e.message_modified:contains(v[1])) then
            AshitaCore:GetChatManager():QueueCommand(1, v[2]);
        end
    end);
end);