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

addon.name      = 'macrofix';
addon.author    = 'atom0s & Sorien';
addon.version   = '1.0';
addon.desc      = 'Removes the macro bar delay when pressing CTRL or ALT.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- MacroFix Variables
local macrofix = T{
    ptrs = T{
        [1] = { pattern = '83C41084C074??8BCEE8????????84C074??8A460CB9????????3AC3',     off = 0x05, cnt = 0, patch = { 0xEB } },
        [2] = { pattern = '83C41084C074??8BCEE8????????84C074??807E0C02',                 off = 0x05, cnt = 0, patch = { 0xEB } },
        [3] = { pattern = '2B46103BC3????????????68????????B9',                           off = 0x05, cnt = 0, patch = { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 } },
        [4] = { pattern = '2B46103BC3????68????????B9',                                   off = 0x05, cnt = 0, patch = { 0x90, 0x90 } },
        [5] = { pattern = '83C41084C0????8BCEE8????????84C0????8A460C84C0????8B461485C0', off = 0x07, cnt = 0, patch = { 0xE9, 0x9B, 0x00, 0x00, 0x00, 0xCC, 0xCC } },
        [6] = { pattern = '83C41084C0????8BCEE8????????84C0????8A460C84C0????8B461485C0', off = 0x07, cnt = 1, patch = { 0xE9, 0xCD, 0x00, 0x00, 0x00, 0xCC, 0xCC } },
    }
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Locate all pointers and backup patch data..
    macrofix.ptrs:ieach(function (v)
        local ptr = ashita.memory.find('FFXiMain.dll', 0, v.pattern, v.off, v.cnt);
        if (ptr == 0) then
            error(chat.header(addon.name):append(chat.error('Error: Failed to locate a required pointer.')));
        end

        -- Backup the original function data..
        v.ptr = ptr;
        v.backup = ashita.memory.read_array(v.ptr, #v.patch);
    end);

    -- Apply patches to the found addresses..
    macrofix.ptrs:ieach(function (v)
        ashita.memory.write_array(v.ptr, v.patch);
    end);
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
macrofix.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    -- Restore patches to the found addresses..
    macrofix.ptrs:ieach(function (v)
        if (v.ptr ~= 0 and v.backup ~= nil and #v.backup > 0) then
            ashita.memory.write_array(v.ptr, v.backup);
        end

        v.ptr = 0;
        v.backup = nil;
    end);
end);