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

addon.name      = 'changecall';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Replaces all call commands with the selected call id instead.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- ChangeCall Variables
local changecall = T{
    id = 14,
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
        { '/changecall help', 'Displays the addons help information.' },
        { '/changecall <id>', 'Sets the new call id to be used.' },
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
    if (#args == 0 or args[1] ~= '/changecall') then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /changecall help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /changecall <id>
    if (#args == 2) then
        local id = e.command:gsub('/changecall', ''):trim();
        if (id == nil or #id == 0 or tonumber(id) == nil) then
            changecall.id = 0;
        else
            changecall.id = tonumber(id);
        end

        print(chat.header('changecall'):append(chat.message('Calls will now be replaced with: ')):append(chat.success(('<call%s>'):fmt(tostring(changecall.id)))));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ashita.events.register('text_in', 'text_in_cb', function (e)
    -- Replace the calls within the message if found..
    local p = '<((c|nc|sc)all|(c|nc|sc)all([0-9]+))>';
    local m = ashita.regex.search(e.message_modified, p);
    if (m ~= nil) then
        e.message_modified = ashita.regex.replace(e.message_modified, p, ('<call%s>'):fmt(tostring(changecall.id)));
    end
end);