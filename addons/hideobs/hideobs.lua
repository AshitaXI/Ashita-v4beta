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

addon.name      = 'hideobs';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Hides the current game window from OBS display stream capturing.';
addon.link      = 'https://ashitaxi.com/';

require('common');
require('win32types');
local chat  = require('chat');
local ffi   = require('ffi');
local C     = ffi.C;

ffi.cdef[[
    enum {
        WDA_NONE                = 0x00000000,
        WDA_MONITOR             = 0x00000001,
        WDA_EXCLUDEFROMCAPTURE  = 0x00000011,
    };

    BOOL GetWindowDisplayAffinity(HWND hWnd, DWORD *pdwAffinity);
    BOOL SetWindowDisplayAffinity(HWND hWnd, DWORD dwAffinity);
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
        { '/hideobs help', 'Displays the addons help information.' },
        { '/hideobs', 'Toggles hiding the current game window from OBS display capturing.' },
        { '/hideobs (hide | h)', 'Hides the current game window from OBS display capturing.' },
        { '/hideobs (show | s)', 'Shows the current game window in OBS display capturing.' },
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
    if (#args == 0 or not args[1]:any('/hideobs')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /hideobs help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Obtain the game window handle..
    local hwnd = ffi.cast('HWND', AshitaCore:GetProperties():GetFinalFantasyHwnd());

    -- Handle: /hideobs - Toggles hiding the current game window from OBS display capturing.
    if (#args == 1) then
        local affinity = ffi.new('DWORD[1]');
        if (C.GetWindowDisplayAffinity(hwnd, affinity) == 1) then
            if (affinity[0] == C.WDA_NONE) then
                affinity[0] = C.WDA_EXCLUDEFROMCAPTURE;
                print(chat.header(addon.name):append(chat.message('OBS Display Capture now set to: ')):append(chat.success('Hide')));
            else
                affinity[0] = C.WDA_NONE;
                print(chat.header(addon.name):append(chat.message('OBS Display Capture now set to: ')):append(chat.success('Show')));
            end
            C.SetWindowDisplayAffinity(hwnd, affinity[0]);
        else
            print(chat.header(addon.name):append(chat.error('Failed to obtain the current display affinity; cannot continue.')));
        end
        return;
    end

    -- Handle: /hideobs hide - Hides the current game window from OBS display capturing.
    if (#args == 2 and args[2]:any('hide', 'h')) then
        C.SetWindowDisplayAffinity(hwnd, C.WDA_EXCLUDEFROMCAPTURE);
        print(chat.header(addon.name):append(chat.message('OBS Display Capture now set to: ')):append(chat.success('Hide')));
        return;
    end

    -- Handle: /hideobs show - Shows the current game window in OBS display capturing.
    if (#args == 2 and args[2]:any('show', 's')) then
        C.SetWindowDisplayAffinity(hwnd, C.WDA_NONE);
        print(chat.header(addon.name):append(chat.message('OBS Display Capture now set to: ')):append(chat.success('Show')));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);