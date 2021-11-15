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

addon.name      = 'blumon';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Monitors for learnt Blue Mage spells and announces them with color.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Message Basic
    if (e.id == 0x0029) then
        -- Obtain the message id..
        local msg = struct.unpack('H', e.data, 0x18 + 0x01);
        if (msg == 419) then
            -- Obtain the message information..
            local spellId   = struct.unpack('L', e.data, 0x0C + 0x01);
            local sender    = struct.unpack('H', e.data, 0x14 + 0x01);
            local target    = struct.unpack('H', e.data, 0x16 + 0x01);

            -- Obtain the player entity..
            local player = GetPlayerEntity();
            if (sender == player.TargetIndex and target == player.TargetIndex) then
                local name = AshitaCore:GetResourceManager():GetString('spells.names', spellId);
                if (name == nil) then
                    name = spellId;
                end

                print(chat.header(addon.name) + chat.color1(72, '>>> ') +
                    chat.success('Learned new spell: ') + chat.header(tostring(name)));
            end
        end
    end
end);