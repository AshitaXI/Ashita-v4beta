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

addon.name      = 'instantah';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Removes the delay from auction house interactions.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- InstantAH Variables
local instantah = {
    ptr = 0,
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the required pointer..
    instantah.ptr = ashita.memory.find('FFXiMain.dll', 0, '668BC1B9????????0FAFC233D2F7F1', 0x00, 0x00);
    if (instantah.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end

    -- Patch the function..
    ashita.memory.write_uint8(instantah.ptr + 0x27, 0xEB);
    print(chat.header(addon.name):append(chat.message('Function patched; auction results should now be instant.')));
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
instantah.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (instantah.ptr ~= 0) then
        ashita.memory.write_uint8(instantah.ptr + 0x27, 0x74);
    end
    instantah.ptr = 0;
end);