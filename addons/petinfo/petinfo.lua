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
addon.author    = 'atom0s & Tornac & Skyrant';
addon.version   = '1.3';
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

    imgui.SetNextWindowBgAlpha(0.8);
    imgui.SetNextWindowSize({ 250, -1, }, ImGuiCond_Always);
    if (imgui.Begin('PetInfo', petinfo.is_open, bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_NoNav))) then
        -- Obtain and prepare player information..
        local x, _  = imgui.CalcTextSize("99/99");
        local playerName = GetPlayerEntity().Name;
        
        local mainJob = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", AshitaCore:GetMemoryManager():GetPlayer():GetMainJob());
        local jobLevel = AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel();
        local subJob = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", AshitaCore:GetMemoryManager():GetPlayer():GetSubJob());
        local subJobLevel = AshitaCore:GetMemoryManager():GetPlayer():GetSubJobLevel();
        
        local SelfHP = AshitaCore:GetMemoryManager():GetParty():GetMemberHP(0);
        local SelfHPMax = AshitaCore:GetMemoryManager():GetPlayer():GetHPMax();
        local selfHPPercent = SelfHP / SelfHPMax;

        local SelfMP = AshitaCore:GetMemoryManager():GetParty():GetMemberMP(0);
        local SelfMPMax = AshitaCore:GetMemoryManager():GetPlayer():GetMPMax();
        local selfMPPercent = SelfMP / SelfMPMax;

        local SelfTP = AshitaCore:GetMemoryManager():GetParty():GetMemberTP(0);
        local SelfTPPercent = SelfTP / 3000;

        local currentExp = AshitaCore:GetMemoryManager():GetPlayer():GetExpCurrent();
        local totalExp = AshitaCore:GetMemoryManager():GetPlayer():GetExpNeeded();
        local expPercent = currentExp / totalExp;

        local inventory = AshitaCore:GetMemoryManager():GetInventory();
        if (inventory == nil) then
            UpdateTextVisibility(false);
            return;
        end

        local usedBagSlots = inventory:GetContainerCount(0);
        local maxBagSlots = inventory:GetContainerCountMax(0);
        local bagSlotPercent = usedBagSlots / maxBagSlots;

        if ( bagSlotPercent > 0.5 ) then
            bagSlotColor = {0.33,0.66,0.33,1.0};
        elseif ( bagSlotPercent > 0.75 ) then
            bagSlotColor = {0.66,0.66,0.33,1.0};
        else
            bagSlotColor = {0.33,0.66,0.33,1.0};
        end

        -- Display the player information..
        imgui.Text(playerName .. ' ' .. mainJob .. '(' .. jobLevel .. ')' .. '/' .. subJob .. '(' .. subJobLevel .. ')' );
        imgui.SameLine();
        imgui.SetCursorPosX(imgui.GetCursorPosX() + imgui.GetColumnWidth() - x - imgui.GetStyle().FramePadding.x);
        imgui.Text(usedBagSlots .. '/' .. maxBagSlots);

        imgui.Separator();
        imgui.Text('XP:');
        imgui.SameLine();
        imgui.PushStyleColor(ImGuiCol_PlotHistogram, {1.0,0.88,0.33,1.0});
        imgui.ProgressBar(expPercent, { -1, 16 });
        imgui.PopStyleColor(1);

        imgui.Separator();
        imgui.Text('HP:');
        imgui.SameLine();
        imgui.ProgressBar(selfHPPercent, { -1, 16 });
        
        imgui.Text('MP:');
        imgui.SameLine();
        imgui.PushStyleColor(ImGuiCol_PlotHistogram, { 0.0, 0.49, 1.0, 1.0 });
        imgui.ProgressBar(selfMPPercent, { -1, 16 });
        imgui.PopStyleColor(1);

        imgui.Text('TP:');
        imgui.SameLine();
        imgui.PushStyleColor(ImGuiCol_PlotHistogram, { 0.0, 0.6, 0.14, 1.0 });
        imgui.ProgressBar(SelfTPPercent, { -1, 16 }, tostring(SelfTP));
        imgui.PopStyleColor(1);
        imgui.Separator();
        
        -- Obtain the player pet entity..
        local pet = GetEntity(player.PetTargetIndex);
        if (pet == nil or pet.Name == nil) then
            petinfo.target = nil;
            return;
        end
        -- Obtain and prepare pet information..
        local petmp = AshitaCore:GetMemoryManager():GetPlayer():GetPetMPPercent();
        local pettp = AshitaCore:GetMemoryManager():GetPlayer():GetPetTP();
        local dist  = ('%.1f'):fmt(math.sqrt(pet.Distance));

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
                return;
            else
                dist = ('%.1f'):fmt(math.sqrt(target.Distance));
                x, _ = imgui.CalcTextSize(dist);
                
                if (target.Name ~= nil) then
                    imgui.Separator();
                    imgui.Text(target.Name);
                    imgui.SameLine();
                    imgui.SetCursorPosX(imgui.GetCursorPosX() + imgui.GetColumnWidth() - x - imgui.GetStyle().FramePadding.x);
                    imgui.Text(dist);
                    imgui.Separator();
                    imgui.Text('HP:');
                    imgui.SameLine();
                    imgui.ProgressBar(target.HPPercent / 100, { -1, 16 });
                else
                    return;
                    --imgui.Text('no target');
                end
            end
        end
    end
    imgui.End();
end);