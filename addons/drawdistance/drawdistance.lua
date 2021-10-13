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

addon.name      = 'drawdistance';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Adds slash commands to alter the games scene rendering distances.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- DrawDistance Variables
local drawdistance = T{
    ptr = 0,
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
        { '/drawdistance help', 'Displays the addons help information.' },
        { '/drawdistance (setentity | setmob | sete | setm) <n>', 'Sets the entity draw distance.' },
        { '/drawdistance (setworld | setw) <n>', 'Sets the world draw distance.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the draw distance pointer..
    drawdistance.ptr = ashita.memory.find('FFXiMain.dll', 0, '8BC1487408D80D', 0, 0);
    if (drawdistance.ptr == 0) then
        error(chat.header('drawdistance'):append(chat.error('Error: Failed to locate draw distance pointer.')));
        return;
    end
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/drawdistance') then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /drawdistance help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /drawdistance (setentity | setmob | sete | setm) <n> - Sets the entity draw distance.
    if (#args == 3 and args[2]:any('setentity', 'setmob', 'sete', 'setm')) then
        local ptr = ashita.memory.read_uint32(drawdistance.ptr + 0x0F);
        ashita.memory.write_float(ptr, tonumber(args[3]));
        return;
    end

    -- Handle: /drawdistance (setworld | setw) <n> - Sets the world draw distance.
    if (#args == 3 and args[2]:any('setworld', 'setw')) then
        local ptr = ashita.memory.read_uint32(drawdistance.ptr + 0x07);
        ashita.memory.write_float(ptr, tonumber(args[3]));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);