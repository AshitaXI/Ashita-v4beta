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

addon.name      = 'mipmap';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Removes the recent patch made by SE to alter how mipmaps are configured.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- mipmap Variables
local mipmap = {
    backup = nil,
    ptr = 0,
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the required pointer..
    mipmap.ptr = ashita.memory.find('FFXiMain.dll', 0, 'FEC8895E20F6D81AC0895E1C83C00288462A', 0x00, 0x00);
    if (mipmap.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end

    -- Backup the patch data..
    mipmap.backup = ashita.memory.read_array(mipmap.ptr, 0x12);

    -- Overwrite the function..
    local patch = {
        0x89, 0x5E, 0x20,                           -- mov [esi+20h], ebx   ; original code restored
        0x89, 0x5E, 0x1C,                           -- mov [esi+1Ch], ebx   ; original code restored
        0xC7, 0x46, 0x2A, 0x06, 0x00, 0x00, 0x00,   -- mov [esi+2A], 6      ; forced mipmap setting
        0x90, 0x90, 0x90, 0x90, 0x90,               -- nop {5}
    };
    ashita.memory.write_array(mipmap.ptr, patch);
    print(chat.header(addon.name):append(chat.message('Function patched; mipmaps should work as normal.')));
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
mipmap.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (mipmap.ptr ~= 0 and mipmap.backup ~= nil) then
        ashita.memory.write_array(mipmap.ptr, mipmap.backup);
    end
    mipmap.backup = nil;
    mipmap.ptr = 0;
end);