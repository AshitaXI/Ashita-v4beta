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

addon.name      = 'truesight';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Removes entity occlusion and makes invisible players half-transparent instead.';
addon.link      = 'https://ashitaxi.com/';

require 'common';

ashita.events.register('d3d_present', 'd3d_present_cb', function ()
    for x = 0, 2302 do
        local ent = GetEntity(x);
        if (ent) then
            -- Remove occlusuion testing..
            ent.Render.Flags4 = bit.bor(ent.Render.Flags4, 0x01);

            -- Make invisible players half-transparent instead..
            if (x >= 1024 and x <= 1791) then
                if (bit.band(ent.Render.Flags2, 0x40) == 0x40) then
                    ent.Render.Flags2 = bit.band(ent.Render.Flags2, bit.bnot(0x40));
                    ent.Render.Flags4 = bit.bor(ent.Render.Flags4, 0x40000);
                end
            end
        end
    end
end);
