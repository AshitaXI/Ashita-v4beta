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

addon.name      = 'chamcham';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Enables coloring models based on their entity type.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local d3d8 = require('d3d8');
local imgui = require('imgui');

-- ChamCham Variables
local chamcham = {
    offset = 0x0660,
    is_open = { false, },
    color_mob = { 1.0, 0.0, 0.0, 1.0 },
    color_npc = { 0.0, 1.0, 0.0, 1.0 },
    color_pc = { 0.0, 0.0, 1.0, 1.0 },
};

--[[
* Applies the cham color to an entity based on its type.
*
* @param {object} e - The entity object to apply the cham to.
--]]
local function apply_cham(e)
    if (e == nil) then
        return;
    end

    -- Obtain the entity spawn flags..
    local f = e.SpawnFlags;
    local c = chamcham.color_pc;

    -- Determine the entity type and apply the proper color..
    if (bit.band(f, 0x0001) == 0x0001) then
        c = chamcham.color_pc;
    elseif (bit.band(f, 0x0002) == 0x0002) then
        c = chamcham.color_npc;
    else
        c = chamcham.color_mob;
    end

    ashita.memory.write_uint32(e.ActorPointer + chamcham.offset, d3d8.D3DCOLOR_COLORVALUE(c[3], c[2], c[1], c[4]));
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/chamcham')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Toggle the chamcham window..
    chamcham.is_open[1] = not chamcham.is_open[1];
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    -- Draw the chamcham editor window if enabled..
    if (chamcham.is_open[1]) then
        imgui.SetNextWindowSize({ 375, 105, }, ImGuiCond_Always);
        if (imgui.Begin('ChamCham', chamcham.is_open, bit.bor(ImGuiWindowFlags_NoResize, ImGuiWindowFlags_NoCollapse))) then
            imgui.ColorEdit4('Mob Color', chamcham.color_mob);
            imgui.ColorEdit4('NPC Color', chamcham.color_npc);
            imgui.ColorEdit4('PC Color', chamcham.color_pc);
        end
        imgui.End();
    end

    -- Apply the cham colors..
    for x = 0, 2303 do
        local e = GetEntity(x);
        if (e ~= nil and e.ActorPointer ~= 0) then
            apply_cham(e);
        end
    end
end);