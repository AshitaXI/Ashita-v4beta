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

addon.name      = 'gateway';
addon.author    = 'atom0s & bluekirby0';
addon.version   = '1.0';
addon.desc      = 'Forces all doors to always be open.';
addon.link      = 'https://ashitaxi.com/';

-- Enable jitting..
local ffi = require('ffi');
local jit = require('jit');
jit.on();

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    if (e.id == 0x000E) then
        local ptr = ffi.cast('uint8_t*', e.data_modified_raw);
        if (ptr[0x1F] == 0x09) then
            ptr[0x1F] = 0x08;
        end
    end
end);