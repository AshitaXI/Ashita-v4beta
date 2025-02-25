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

addon.name      = 'fastswap';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Fixes a state issue with the client when trying to swap jobs too fast.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

local fastswap = {
    ptr = 0,
    gc  = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    fastswap.ptr = ashita.memory.find('FFXiMain.dll', 0, '6A006A006800010000E8????????83C40C85C075??32C0C3', 0x00, 0x00);
    if (fastswap.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required function.')));
        return;
    end

    ashita.memory.write_uint8(fastswap.ptr + 0x03, 0x01);
    print(chat.header(addon.name):append(chat.message('Function patched; fast job swaps should work properly now.')));
end);

-- Garbage Collection Cleanup
fastswap.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (fastswap.ptr ~= 0) then
        ashita.memory.write_uint8(fastswap.ptr + 0x03, 0x00);
    end
    fastswap.ptr = 0;
end);