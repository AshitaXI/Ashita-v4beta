--[[
* Addons - Copyright (c) 2025 Ashita Development Team
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

addon.name      = 'chime';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Play in-game chime based sound effects from a slash command.';
addon.link      = 'https://ashitaxi.com/';

require 'common';
require 'win32types';

local chat  = require 'chat';
local ffi   = require 'ffi';

ffi.cdef[[
    typedef void (__cdecl* YmSePlayChime_f)(int32_t, float, bool);
]];

local chime = T{
    ptrs = T{
        func = ashita.memory.find(0, 0, 'A1????????5685C00F??????????6A006A046A40E8????????8BF083C40C8BCE', 0, 0),
    },
};

if (not chime.ptrs:all(function (v) return v ~= nil and v ~= 0; end)) then
    error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer(s).')));
    return;
end

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
        { '/chime <id> <power> <force>', 'Plays a chime sound effect.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Plays a given chime sound.
*
* @param {number} id - The id of the sound to play.
* @param {number} power - The power (volume) of the sound.
* @param {boolean} force - Flag set to true to force the sound to play.
--]]
local function play_chime(id, power, force)
    if (power > 1.0) then
        power = 1.0;
    end

    local func = ffi.cast('YmSePlayChime_f', chime.ptrs.func);
    if (func == nil or func == 0) then
        return;
    end

    func(id, power, force);
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/chime') then
        return;
    end

    e.blocked = true;

    -- Handle: /chime <id> <power> <force>
    if (#args == 4) then
        if (args[2]:len() ~= 4) then
            print(chat.header(addon.name):append(chat.error('Error: Invalid chime name length!')));
        end

        local id = 0;
        args[2]:chars():map(string.byte):reverse():each(function (v, k)
            id = bit.bor(id, bit.lshift(v, (k - 1) * 8));
        end);

        play_chime(id, args[3]:num_or(1.0), args[4]:any('1', 'true'));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);