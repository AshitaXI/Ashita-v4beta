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

addon.name      = 'craftmon';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Displays crafting results immediately upon starting a synth.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

--[[
* Returns the crafting result based on the animation id.
*
* @param {number} id - The craft animation id.
* @return {table} A table containing a color code and string representing the craft result type.
--]]
local function get_craft_result(res)
    return switch(res, {
        [0] = function () return { 1, 'Normal Quality', }; end,
        [1] = function () return { 39, 'Break', }; end,
        [2] = function () return { 5, 'High-Quality', }; end,
        [3] = function () return { 5, 'High-Quality', }; end,
        [4] = function () return { 5, 'High-Quality', }; end,
        [switch.default] = function ()
            return { 4, ('Unknown Quality (%d)'):fmt(res), };
        end
    });
end

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Synthesis Animation
    if (e.id == 0x0030) then
        -- Obtain the local player..
        local player = GetPlayerEntity();

        -- Ensure the packet was for the local player..
        if (player ~= nil and player.TargetIndex == struct.unpack('H', e.data_modified, 0x08 + 0x01)) then
            local res = get_craft_result(struct.unpack('b', e.data_modified, 0x0C + 0x01));
            print(chat.header(addon.name) + chat.color1(81, '>>> ') + chat.message('Craft result: ') + chat.color1(res[1], res[2]));
        end
    end

    -- Packet: Synthesis Results
    if (e.id == 0x006F) then
        -- Ensure the craft result was successful..
        local result = struct.unpack('b', e.data_modified, 0x04 + 0x01);
        if (result == 0) then
            -- Obtain the items resource information..
            local item = AshitaCore:GetResourceManager():GetItemById(struct.unpack('H', e.data_modified, 0x08 + 0x01));
            if (item ~= nil) then
                local c = struct.unpack('b', e.data_modified, 0x06 + 0x01);
                print(chat.header(addon.name) + chat.color1(81, '>>> ') + chat.message('Craft result: ') + chat.color1(72, item.Name[1]) + chat.message(' - Quantity: ') + chat.success(c));
            end
        end
    end
end);