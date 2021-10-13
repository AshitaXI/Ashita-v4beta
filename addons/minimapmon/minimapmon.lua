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

addon.name      = 'minimapmon';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Hides the Minimap plugin under certain conditions, such as standing still.';
addon.link      = 'https://ashitaxi.com/';

require('common');

-- MinimapMon Variables
local mmm = T{
    last_x  = 0,
    last_y  = 0,
    last_z  = 0,
    moving  = false,
    zoning  = false,
    tick    = 0,
    opacity = T{
        last        = 1,
        map         = 1,
        frame       = 1,
        arrow       = 1,
        monsters    = 1,
        npcs        = 1,
        players     = 1,
    }
};

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Zone Leave
    if (e.id == 0x000B) then
        mmm.zoning = true;
        return;
    end

    -- Packet: Inventory Update Completed
    if (e.id == 0x001D) then
        mmm.zoning = false;
        return;
    end
end);

--[[
* event: d3d_beginscene
* desc : Event called when the Direct3D device is beginning a scene.
--]]
ashita.events.register('d3d_beginscene', 'beginscene_cb', function (isRenderingBackBuffer)
    -- Check for zoning..
    if (not isRenderingBackBuffer or mmm.zoning) then
        return;
    end

    -- Obtain the local player entity..
    local p = GetPlayerEntity();
    if (p == nil) then
        return;
    end

    -- Determine if the player is moving..
    local x = p.Movement.LocalPosition.X;
    local y = p.Movement.LocalPosition.Y;
    local z = p.Movement.LocalPosition.Z;

    if (mmm.last_x == x and mmm.last_y == y and mmm.last_z == z) then
        mmm.moving = false;
    else
        mmm.moving = true;
    end

    -- Update the last known coords..
    mmm.last_x = x;
    mmm.last_y = y;
    mmm.last_z = z;
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (mmm.zoning) then
        return;
    end

    -- Throttle monitoring..
    if (os.clock() >= mmm.tick + 0.05) then
        mmm.tick = os.clock();

        -- Fade the Minimap plugin if the player is standing still..
        if (mmm.moving == false) then
            mmm.opacity.map         = math.clamp(mmm.opacity.map - 0.1, 0, 1);
            mmm.opacity.frame       = math.clamp(mmm.opacity.frame - 0.1, 0, 1);
            mmm.opacity.arrow       = math.clamp(mmm.opacity.arrow - 0.1, 0, 1);
            mmm.opacity.monsters    = math.clamp(mmm.opacity.monsters - 0.1, 0, 1);
            mmm.opacity.npcs        = math.clamp(mmm.opacity.npcs - 0.1, 0, 1);
            mmm.opacity.players     = math.clamp(mmm.opacity.players - 0.1, 0, 1);
        else
            mmm.opacity.map         = 1;
            mmm.opacity.frame       = 1;
            mmm.opacity.arrow       = 1;
            mmm.opacity.monsters    = 1;
            mmm.opacity.npcs        = 1;
            mmm.opacity.players     = 1;
        end

        -- Update the opacity if it has changed..
        if (mmm.opacity.last ~= mmm.opacity.map) then
            mmm.opacity.last = mmm.opacity.map;

            -- Build the event packet..
            local data = struct.pack('Lffffff', 0x01, mmm.opacity.map, mmm.opacity.frame, mmm.opacity.arrow, mmm.opacity.monsters, mmm.opacity.npcs, mmm.opacity.players);

            -- Raise the minimap event for opacity updates..
            AshitaCore:GetPluginManager():RaiseEvent('minimap', data:totable());
        end
    end
end);