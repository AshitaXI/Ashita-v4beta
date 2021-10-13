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

addon.name      = 'cleancs';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Hides Ashita rendered elements while in a cutscene.';
addon.link      = 'https://ashitaxi.com/';

require('common');

-- CleanCS Variables
local cleancs = T{
    visible = true,
};

--[[
* Sets the various Ashita rendered elements visibility.
*
* @param {boolean} visible - The visibility to set.
--]]
local function set_visibility(visible)
    AshitaCore:GetFontManager():SetVisible(visible);
    AshitaCore:GetPrimitiveManager():SetVisible(visible);
    AshitaCore:GetGuiManager():SetVisible(visible);

    cleancs.visible = visible;
end

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Menu Event Update / Release
    if (e.id == 0x0052) then
        local type = struct.unpack('b', e.data_modified, 0x04 + 0x01);
        if (type > 0) then
            set_visibility(true);
        end
        return;
    end
end);

--[[
* event: packet_out
* desc : Event called when the addon is processing outgoing packets.
--]]
ashita.events.register('packet_out', 'packet_out_cb', function (e)
    -- Packet: Action
    if (e.id == 0x001A) then
        local action = struct.unpack('b', e.data_modified, 0x0A + 0x01);
        if (action == 0) then
            set_visibility(false);
        end
        return;
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    local player = GetPlayerEntity();
    if (player ~= nil) then
        if (player.StatusServer == 4 and cleancs.visible) then
            set_visibility(false);
        elseif (player.StatusServer ~= 4 and not cleancs.visible) then
            set_visibility(true);
        end
    end
end);