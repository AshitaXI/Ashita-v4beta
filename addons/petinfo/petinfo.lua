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

addon.name      = 'petinfo';
addon.author    = 'atom0s & Tornac';
addon.version   = '1.2';
addon.desc      = 'Displays information about the players pet.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local imgui = require('imgui');

-- PetInfo Variables
local petinfo = T{
    is_open = { true, },
    target  = nil,
};

--[[
* Returns the entity that matches the given server id.
*
* @param {number} sid - The entity server id.
* @return {object | nil} The entity on success, nil otherwise.
--]]
local function GetEntityByServerId(sid)
    for x = 0, 2303 do
        local ent = GetEntity(x);
        if (ent ~= nil and ent.ServerId == sid) then
            return ent;
        end
    end
    return nil;
end

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Action
    if (e.id == 0x0028) then
        -- Obtain the player entitiy..
        local player = GetPlayerEntity();
        if (player == nil or player.PetTargetIndex == 0) then
            petinfo.target = nil;
            return;
        end

        -- Obtain the player pet entity..
        local pet = GetEntity(player.PetTargetIndex);
        if (pet == nil) then
            petinfo.target = nil;
            return;
        end

        -- Obtain the action main target id if the actor is the player pet..
        local aid = struct.unpack('I', e.data_modified, 0x05 + 0x01);
        if (aid ~= 0 and aid == pet.ServerId) then
            petinfo.target = ashita.bits.unpack_be(e.data_modified:totable(), 0x96, 0x20);
            return;
        end

        return;
    end

    -- Packet: Pet Sync
    if (e.id == 0x0068) then
        -- Obtain the player entitiy..
        local player = GetPlayerEntity();
        if (player == nil) then
            petinfo.target = nil;
            return;
        end

        -- Update the players pet target..
        local owner = struct.unpack('I', e.data_modified, 0x08 + 0x01);
        if (owner == player.ServerId) then
            petinfo.target = struct.unpack('I', e.data_modified, 0x14 + 0x01);
        end

        return;
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    -- Obtain the player entity..
    local player = GetPlayerEntity();
    if (player == nil) then
        petinfo.target = nil;
        return;
    end

    -- Obtain the player pet entity..
    local pet = GetEntity(player.PetTargetIndex);
    if (pet == nil or pet.Name == nil) then
        petinfo.target = nil;
        return;
    end

    imgui.SetNextWindowBgAlpha(0.8);
    imgui.SetNextWindowSize({ 250, -1, }, ImGuiCond_Always);
    if (imgui.Begin('PetInfo', petinfo.is_open, bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_NoNav))) then
        -- Obtain and prepare pet information..
        local petmp = AshitaCore:GetMemoryManager():GetPlayer():GetPetMPPercent();
        local pettp = AshitaCore:GetMemoryManager():GetPlayer():GetPetTP();
        local dist  = ('%.1f'):fmt(math.sqrt(pet.Distance));
        local x, _  = imgui.CalcTextSize(dist);

        -- Display the pets information..
        imgui.Text(pet.Name);
        imgui.SameLine();
        imgui.SetCursorPosX(imgui.GetCursorPosX() + imgui.GetColumnWidth() - x - imgui.GetStyle().FramePadding.x);
        imgui.Text(dist);
        imgui.Separator();
        imgui.Text('HP:');
        imgui.SameLine();
        imgui.ProgressBar(pet.HPPercent / 100, { -1, 16 });
        imgui.Text('MP:');
        imgui.SameLine();
        imgui.PushStyleColor(ImGuiCol_PlotHistogram, { 0.0, 0.49, 1.0, 1.0 });
        imgui.ProgressBar(petmp / 100, { -1, 16 });
        imgui.PopStyleColor(1);
        imgui.Text('TP:');
        imgui.SameLine();
        imgui.PushStyleColor(ImGuiCol_PlotHistogram, { 0.0, 0.6, 0.14, 1.0 });
        imgui.ProgressBar(pettp / 3000, { -1, 16 }, tostring(pettp));
        imgui.PopStyleColor(1);

        -- Display the pets target information..
        if (petinfo.target ~= nil) then
            local target = GetEntityByServerId(petinfo.target);
            if (target == nil or target.ActorPointer == 0 or target.HPPercent == 0) then
                petinfo.target = nil;
            else
                dist = ('%.1f'):fmt(math.sqrt(target.Distance));
                x, _ = imgui.CalcTextSize(dist);

                local tname = target.Name;
                if (tname == nil) then
                    tname = '';
                end

                imgui.Separator();
                imgui.Text(tname);
                imgui.SameLine();
                imgui.SetCursorPosX(imgui.GetCursorPosX() + imgui.GetColumnWidth() - x - imgui.GetStyle().FramePadding.x);
                imgui.Text(dist);
                imgui.Separator();
                imgui.Text('HP:');
                imgui.SameLine();
                imgui.ProgressBar(target.HPPercent / 100, { -1, 16 });
            end
        end
    end
    imgui.End();
end);