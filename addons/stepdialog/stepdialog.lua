--[[
* Addons - Copyright (c) 2024 Ashita Development Team
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

addon.name      = 'stepdialog';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Manually invoke the key press to continue the current chat dialog.';
addon.link      = 'https://ashitaxi.com/';

require 'common';
require 'win32types';

local chat  = require 'chat';
local ffi   = require 'ffi';

ffi.cdef[[
    typedef void (__thiscall* TkEventMsg2_OnKeyDown_f)(int32_t, int16_t, int16_t);
]];

local stepdialog = T{
    ptrs = T{
        func = ashita.memory.find('FFXiMain.dll', 0, '538B5C240856578B7C24148BF15753E8????????8B0D????????3BF174', 0, 0),
        this = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????85C90F??????????8B410885C00F', 2, 0),
    },
};

if (not stepdialog.ptrs:all(function (v) return v ~= nil and v ~= 0; end)) then
    error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer(s).')));
    return;
end

--[[
* Invokes the TkEventMsg2::OnKeyDown function directly.
--]]
local function step_dialog()
    if (stepdialog.ptrs.func == nil or stepdialog.ptrs.func == 0 or
        stepdialog.ptrs.this == nil or stepdialog.ptrs.this == 0) then
        return;
    end

    -- Obtain the current TkEventMsg2 object pointer..
    local ptr = ashita.memory.read_uint32(stepdialog.ptrs.this);
    if (ptr == nil or ptr == 0) then
        return;
    end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == nil or ptr == 0) then
        return;
    end

    -- Obtain the TkEventMsg2::OnKeyDown function pointer..
    local func = ffi.cast('TkEventMsg2_OnKeyDown_f', stepdialog.ptrs.func);
    if (func == nil or func == 0) then
        return;
    end

    -- Invoke the function with an enter press..
    func(ptr, 5, 0xFFFF);
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/stepdialog') then
        return;
    end

    e.blocked = true;

    step_dialog();
end);
