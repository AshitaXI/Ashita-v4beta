--[[
* Addons - Copyright (c) 2023 Ashita Development Team
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

addon.name      = 'affinity';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Allows setting the current process affinity mask in-game.';
addon.link      = 'https://ashitaxi.com/';

require('common');
require('win32types');

local chat  = require('chat');
local ffi   = require('ffi');

ffi.cdef[[
    HANDLE GetCurrentProcess(void);
    BOOL GetProcessAffinityMask(HANDLE hProcess, PDWORD_PTR lpProcessAffinityMask, PDWORD_PTR lpSystemAffinityMask);
    BOOL SetProcessAffinityMask(HANDLE hProcess, DWORD_PTR dwProcessAffinityMask);
]];

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
        { '/affinity help', 'Displays the addons help information.' },
        { '/affinity get', 'Prints the current process affinity.' },
        { '/affinity set <mask>', 'Sets the process affinity.' },
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
    if (#args == 0 or args[1] ~= '/affinity') then
        return;
    end

    e.blocked = true;

    -- Handle: /affinity help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /affinity get - Prints the current process affinity.
    if (#args == 2 and args[2]:any('get')) then
        local p_mask = ffi.new('DWORD_PTR[1]');
        local s_mask = ffi.new('DWORD_PTR[1]');

        if (ffi.C.GetProcessAffinityMask(ffi.C.GetCurrentProcess(), p_mask, s_mask) == 0) then
            print(chat.header(addon.name):append(chat.error('Failed to obtain the process affinity mask.')));
        else
            print(chat.header(addon.name):append(chat.message('Current process affinity mask: ')):append(chat.success(('%d (%08X)'):fmt(p_mask[0], p_mask[0]))));
        end

        return;
    end

    -- Handle: /affinity set <mask> - Sets the process affinity.
    if (#args == 3 and args[2]:any('set')) then
        local mask = args[3]:num_or(0);

        if (ffi.C.SetProcessAffinityMask(ffi.C.GetCurrentProcess(), mask) == 0) then
            print(chat.header(addon.name):append(chat.error('Failed to set the process affinity mask.')));
        else
            print(chat.header(addon.name):append(chat.message('Set current process affinity mask to: ')):append(chat.success(('%d (%08X)'):fmt(mask, mask))));
        end

        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);