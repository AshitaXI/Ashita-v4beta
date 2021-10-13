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

addon.name      = 'peekaboo';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Forces all entities the client obtains data for to be visible.';
addon.link      = 'https://ashitaxi.com/';

local ffi = require('ffi');
require('common');

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Handle players that may be invisible..
    if (e.id == 0x000D) then
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        if (bit.band(p[0x0A], 0x04) == 0x04 and bit.band(p[0x23], 0x20) == 0x20) then
            p[0x23] = 0;
        end
    end

    -- Handle mob/npc entities..
    if (e.id == 0x000E) then
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        if (p[0x01] >= 0x1C and p[0x20] ~= 0x01) then
            p[0x20] = 0;
        end
    end
end);