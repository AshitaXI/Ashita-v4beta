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

addon.name      = 'move';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Window helper to adjust position, size, border, etc.';
addon.link      = 'https://ashitaxi.com/';

require('common');
require('win32types');

local chat  = require('chat');
local ffi   = require('ffi');
local C     = ffi.C;

--[[
* FFI API Definitions
--]]
ffi.cdef[[
    BOOL AttachThreadInput(DWORD idAttach, DWORD idAttachTo, BOOL fAttach);
    BOOL GetClientRect(HWND hWnd, LPRECT lpRect);
    DWORD GetCurrentThreadId();
    HWND GetForegroundWindow();
    BOOL GetWindowRect(HWND hWnd, LPRECT lpRect);
    LONG_PTR GetWindowLongA(HWND hWnd, int nIndex);
    DWORD GetWindowThreadProcessId(HWND hWnd, LPDWORD lpdwProcessId);
    BOOL SetForegroundWindow(HWND hWnd);
    LONG_PTR SetWindowLongA(HWND hWnd, int nIndex, LONG_PTR dwNewLong);
    BOOL SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, UINT uFlags);
    BOOL ShowWindow(HWND hWnd, int nCmdShow);

    enum {
        SWP_NOSIZE          = 0x0001,
        SWP_NOMOVE          = 0x0002,
        SWP_NOZORDER        = 0x0004,
        SWP_FRAMECHANGED    = 0x0020,
        SWP_SHOWWINDOW      = 0x0040,
    };

    enum {
        SW_MAXIMIZE = 3,
        SW_SHOW     = 5,
        SW_MINIMIZE = 6,
    };

    enum {
        GWL_STYLE   = -16,
        GWL_EXSTYLE = -20,
    };

    enum {
        WS_SYSMENU          = 0x00080000,
        WS_OVERLAPPEDWINDOW = 0x00CF0000,
        WS_VISIBLE          = 0x10000000,
        WS_POPUP            = 0x80000000,

        WS_EX_TOPMOST       = 0x00000008,
    };

    enum {
        HWND_TOP        = 0,
        HWND_TOPMOST    = -1,
        HWND_NOTOPMOST  = -2,
    };
]];

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
* @param {string} cmd - The command that caused the print_help to happen.
--]]
local function print_help(isError, cmd)
    isError = isError or false;

    if (isError) then
        print(chat.header('Move'):append(chat.error('Invalid command syntax for command: ')):append(chat.success(cmd)));
    else
        print(chat.header('Move'):append(chat.message('Available commands for the move addon are:')));
    end

    local p_cmd = print:compose(function (syntax, desc)
        return chat.header('Move'):append(chat.error('Usage: ')):append(chat.message(syntax)):append(chat.color1(6, desc));
    end);

    p_cmd('/bringtofront - ', 'Brings the game window to the front.');
    p_cmd('/maximize - ', 'Maximizes the game window.');
    p_cmd('/minimize - ', 'Minimizes the game window.');
    p_cmd('/move <x> <y> - ', 'Moves the game window to the given position.');
    p_cmd('/move (position | pos) <x> <y> - ', 'Moves the game window to the given position.');
    p_cmd('/move size <w> <h> - ', 'Resizes the game window to the given dimensions.');
    p_cmd('/topmost - ', 'Toggles the game window to be the top-most window.');
    p_cmd('/windowframe - ', 'Toggles the game windows border/frame.');
end

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when the addon is processing a command.
----------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command args..
    local args = e.command:args();
    local hWnd = ffi.cast('HWND', AshitaCore:GetProperties():GetFinalFantasyHwnd());

    -- Handle: /bringtofront
    if (#args >= 1 and (args[1]:ieq('/bringtofront'))) then
        e.blocked = true;

        ashita.tasks.oncef(1, function ()
            -- Get the current thread with input on the system..
            local hWndCurr = ffi.cast('HWND', C.GetForegroundWindow());
            local tThis = C.GetCurrentThreadId();
            local tCurr = C.GetWindowThreadProcessId(hWndCurr, nil);

            -- Adjust the thread input..
            if (tThis ~= tCurr) then
                C.AttachThreadInput(tThis, tCurr, 1);
            end

            -- Set the game window to the foreground..
            AshitaCore:SetFocus(AshitaCore:GetProperties():GetFinalFantasyHwnd());
            AshitaCore:SetForegroundWindow(AshitaCore:GetProperties():GetFinalFantasyHwnd());

            local hWndInsert = ffi.cast('HWND', C.HWND_TOP);
            C.SetWindowPos(hWnd, hWndInsert, 0, 0, 0, 0, bit.bor(C.SWP_NOMOVE, C.SWP_NOSIZE, C.SWP_SHOWWINDOW));

            -- Adjust the thread input..
            if (tThis ~= tCurr) then
                C.AttachThreadInput(tThis, tCurr, 0);
            end
        end);

        return;
    end

    -- Handle: /maximize and /minimize
    if (#args >= 1 and (args[1]:ieq('/maximize') or args[1]:ieq('/minimize'))) then
        e.blocked = true;

        ashita.tasks.oncef(1, function ()
            local flag = args[1]:ieq('/maximize') and C.SW_MAXIMIZE or C.SW_MINIMIZE;
            C.ShowWindow(hWnd, flag);
        end);

        return;
    end

    -- Handle: /move
    if (#args >= 1 and args[1]:ieq('/move')) then
        e.blocked = true;

        -- Handle: /move help
        if (#args >= 2 and args[2]:ieq('help')) then
            print_help(false);
            return;
        end

        -- Handle: /move <x> <y>
        -- Handle: /move (position | pos) <x> <y>
        if (#args == 3 or (#args == 4 and (args[2]:ieq('pos') or args[2]:ieq('position')))) then
            ashita.tasks.oncef(1, function ()
                local x = args[#args == 3 and 2 or 3]:num_or(0);
                local y = args[#args == 3 and 3 or 4]:num_or(0);

                C.SetWindowPos(hWnd, nil, x, y, 0, 0, bit.bor(C.SWP_NOZORDER, C.SWP_NOSIZE));
            end);

            return;
        end

        -- Handle: /move size <x> <y>
        if (#args == 4 and args[2]:ieq('size')) then
            ashita.tasks.oncef(1, function ()
                local rclient = ffi.new('RECT');
                local rwindow = ffi.new('RECT');
                C.GetClientRect(hWnd, rclient);
                C.GetWindowRect(hWnd, rwindow);

                local w = args[3]:num_or(800) + ((rwindow.right - rwindow.left) - rclient.right);
                local h = args[4]:num_or(600) + ((rwindow.bottom - rwindow.top) - rclient.bottom);

                C.SetWindowPos(hWnd, nil, 0, 0, w, h, bit.bor(C.SWP_NOMOVE, C.SWP_NOZORDER));
            end);

            return;
        end

        -- Print the addon help..
        print_help(true, args[1]);
        return;
    end

    -- Handle: /topmost
    if (#args == 1 and args[1]:ieq('/topmost')) then
        e.blocked = true;

        ashita.tasks.oncef(1, function ()
            local style         = C.GetWindowLongA(hWnd, C.GWL_EXSTYLE);
            local top           = (bit.band(style, C.WS_EX_TOPMOST) == C.WS_EX_TOPMOST) and C.HWND_NOTOPMOST or C.HWND_TOPMOST;
            local hWndInsert    = ffi.cast('HWND', top);

            C.SetWindowPos(hWnd, hWndInsert, 0, 0, 0, 0, bit.bor(C.SWP_NOMOVE, C.SWP_NOSIZE));
        end);

        return;
    end

    -- Handle: /windowframe
    if (#args == 1 and args[1]:ieq('/windowframe')) then
        e.blocked = true;

        ashita.tasks.oncef(1, function ()
            local style = C.GetWindowLongA(hWnd, C.GWL_STYLE);
            if (bit.band(style, C.WS_OVERLAPPEDWINDOW) == C.WS_OVERLAPPEDWINDOW) then
                style = bit.bor(C.WS_POPUP, C.WS_VISIBLE, C.WS_SYSMENU);

                local rclient = ffi.new('RECT');
                C.GetClientRect(hWnd, rclient);

                local w = rclient.right - rclient.left;
                local h = rclient.bottom - rclient.top;

                C.SetWindowLongA(hWnd, C.GWL_STYLE, style);
                C.SetWindowLongA(hWnd, C.GWL_EXSTYLE, 0);
                C.SetWindowPos(hWnd, nil, 0, 0, 0, 0, bit.bor(C.SWP_NOMOVE, C.SWP_NOSIZE, C.SWP_NOZORDER, C.SWP_FRAMECHANGED));
                C.SetWindowPos(hWnd, nil, 0, 0, w, h, bit.bor(C.SWP_NOMOVE, C.SWP_NOZORDER));
            else
                style = bit.bor(C.WS_OVERLAPPEDWINDOW, C.WS_VISIBLE);

                local rclient = ffi.new('RECT');
                local rwindow = ffi.new('RECT');
                C.GetClientRect(hWnd, rclient);

                local bw = rclient.right - rclient.left;
                local bh = rclient.bottom - rclient.top;

                C.SetWindowLongA(hWnd, C.GWL_STYLE, style);
                C.SetWindowLongA(hWnd, C.GWL_EXSTYLE, 0);
                C.SetWindowPos(hWnd, nil, 0, 0, 0, 0, bit.bor(C.SWP_NOMOVE, C.SWP_NOSIZE, C.SWP_NOZORDER, C.SWP_FRAMECHANGED));
                C.GetClientRect(hWnd, rclient);
                C.GetWindowRect(hWnd, rwindow);

                local w = bw + ((rwindow.right - rwindow.left) - rclient.right)
                local h = bh + ((rwindow.bottom - rwindow.top) - rclient.bottom);
                C.SetWindowPos(hWnd, nil, 0, 0, w, h, bit.bor(C.SWP_NOMOVE, C.SWP_NOZORDER));
            end
        end);

        return;
    end
end);