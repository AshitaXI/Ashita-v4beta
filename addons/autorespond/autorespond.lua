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

addon.name      = 'autorespond';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables marking yourself as AFK and automatically responding to tells with a set message.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- AutoRespond Variables
local autorespond = T{
    afk = true,
    msg = 'Sorry, I\'m not currently here. Leave a message after the beep! ~',
};

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
        { '/autorespond', 'Toggles auto-responding on and off.' },
        { '/autorespond help', 'Displays the addons help information.' },
        { '/autorespond (disable | off)', 'Turns auto-responding off.' },
        { '/autorespond (enable | on)', 'Turns auto-responding on.' },
        { '/autorespond (msg | message) <msg>', 'Sets the auto-respond message.' },
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
    if (#args == 0 or args[1] ~= '/autorespond') then
        return;
    end

    -- Handle: /autorespond - Toggles autorespond on and off.
    if (#args == 1) then
        autorespond.afk = not autorespond.afk;
        print(chat.header(addon.name):append(chat.message('Auto-responding is now: ')):append(chat.success(autorespond.afk and 'Enabled' or 'Disabled')));
        return;
    end

    -- Handle: /autorespond help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /autorespond (disable | off) - Turns off auto-responding.
    if (#args == 2 and args[2]:any('disable', 'off')) then
        autorespond.afk = false;
        print(chat.header(addon.name):append(chat.message('Auto-responding is now: ')):append(chat.success('Disabled')));
        return;
    end

    -- Handle: /autorespond (enable | on) - Turns on auto-responding.
    if (#args == 2 and args[2]:any('enable', 'on')) then
        autorespond.afk = true;
        print(chat.header(addon.name):append(chat.message('Auto-responding is now: ')):append(chat.success('Enabled')));
        return;
    end

    -- Handle: /autorespond (msg | message) <msg> - Sets the auto-respond message.
    if (#args >= 3 and args[2]:any('msg', 'message')) then
        autorespond.msg = e.command:sub(e.command:find(' ', e.command:find(' ') + 1) + 1);
        print(chat.header(addon.name):append(chat.message('Auto-respond message set to: ')):append(chat.success(autorespond.msg)));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Chat
    if (e.id == 0x0017) then
        -- Ensure the message is a tell..
        local mode = struct.unpack('b', e.data_modified, 0x04 + 0x01);
        if (mode == 0x03 and autorespond.afk) then
            -- Respond to the user..
            local name = struct.unpack('c15', e.data_modified, 0x08 + 0x01);
            AshitaCore:GetChatManager():QueueCommand(1, ('/tell %s %s'):fmt(name:trim('\0'), autorespond.msg));
        end
    end
end);