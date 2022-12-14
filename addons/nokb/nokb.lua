--[[
* Addons - Copyright (c) 2022 Ashita Development Team
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

addon.name      = 'nokb';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Disables knockback effects applied to the local player.';
addon.link      = 'https://ashitaxi.com/';

require('common');

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Action
    if (e.id == 0x0028) then
        -- Handle mob skills finishing..
        if (ashita.bits.unpack_be(e.data_modified_raw, 82, 4) == 0x0B) then
            -- Obtain the local player entity..
            local player = GetPlayerEntity();
            if (player == nil) then
                return;
            end

            -- Read the target count affected by the action..
            local n = ashita.bits.unpack_be(e.data_modified_raw, 9, 0, 8);
            local b = 150;

            -- Loop the targets affected by the action..
            for x = 0, n - 1 do
                local id = ashita.bits.unpack_be(e.data_modified_raw, 0, b + 0, 32);

                -- Prevent the local player from being knocked back..
                if (id == player.ServerId) then
                    ashita.bits.pack_be(e.data_modified_raw, 0, b + 60, 3);
                end

                -- Skip over additional effect information if present..
                if (bit.band(ashita.bits.unpack_be(e.data_modified_raw, b + 121, 1), 0x01)) then
                    b = b + 37;
                end

                -- Skip over spike effect information if present..
                if (bit.band(ashita.bits.unpack_be(e.data_modified_raw, b + 122, 1), 0x01)) then
                    b = b + 34;
                end

                -- Step over the general target data to the next target block..
                b = b + 123;
            end
        end
    end
end);
