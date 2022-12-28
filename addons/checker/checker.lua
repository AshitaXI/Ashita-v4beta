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

addon.name      = 'checker';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Displays additional information when using /check on a monster.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

--[[
* Returns the string wrapped in a colored parenthesis.
*
* @param {string} str - The string to wrap.
* @return {string} The wrapped string.
--]]
chat.headerp = function (str)
    return ('\30\81(%s\30\81)\30\01'):fmt(str);
end

-- Checker Variables
local checker = T{
    conditions = T{
        [0xAA] = chat.message('High Evasion, High Defense'),
        [0xAB] = chat.message('High Evasion'),
        [0xAC] = chat.message('High Evasion, Low Defense'),
        [0xAD] = chat.message('High Defense'),
        [0xAE] = '',
        [0xAF] = chat.message('Low Defense'),
        [0xB0] = chat.message('Low Evasion, High Defense'),
        [0xB1] = chat.message('Low Evasion'),
        [0xB2] = chat.message('Low Evasion, Low Defense'),
    },
    types = T{
        [0x40] = chat.color1(67,'too weak to be worthwhile'),
        [0x41] = 'like incredibly easy prey',
        [0x42] = chat.color1(2,'like easy prey'),
        [0x43] = chat.color1(102,'like a decent challenge'),
        [0x44] = chat.color1(8,'like an even match'),
        [0x45] = chat.color1(68,'tough'),
        [0x46] = chat.color1(76,'very tough'),
        [0x47] = chat.color1(76,'incredibly tough'),
    },
    widescan = T{ },
};

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Zone Enter / Zone Leave
    if (e.id == 0x000A or e.id == 0x000B) then
        checker.widescan:clear();
        return;
    end

    -- Packet: Message Basic
    if (e.id == 0x0029) then
        local p1    = struct.unpack('l', e.data, 0x0C + 0x01); -- Param 1 (Level)
        local p2    = struct.unpack('L', e.data, 0x10 + 0x01); -- Param 2 (Check Type)
        local m     = struct.unpack('H', e.data, 0x18 + 0x01); -- Message (Defense / Evasion)

        -- Obtain the target entity..
        local target = struct.unpack('H', e.data, 0x16 + 0x01);
        local entity = GetEntity(target);
        if (entity == nil) then
            return;
        end

        -- Ensure this is a /check message..
        if (m ~= 0xF9 and (not checker.conditions:haskey(m) or not checker.types:haskey(p2))) then
            return;
        end

        -- Obtain the string form of the conditions and type..
        local c = checker.conditions[m];
        local t = checker.types[p2];

        -- Obtain the level override if needed..
        if (p1 <= 0) then
            local lvl = checker.widescan[target];
            if (lvl ~= nil) then
                p1 = lvl;
            end
        end

        -- Mark the packet as handled..
        e.blocked = true;

        -- Build the chat output..
        local msg = T{};
        msg:append(chat.header('checker') - 1);
        msg:append(chat.message(entity.Name));
        msg:append(chat.color1(82, string.char(0x81, 0xA8)));
        msg:append(chat.headerp('Lv. ' .. chat.color1(82, p1 > 0 and tostring(p1) or '???')));

        if (m == 0xF9) then
            msg:append(chat.color1(5, 'Impossible to gauge!'));
        else
            msg:append(t);
            msg:append(#c > 0 and c:enclose('\30\81(', '\30\81)\30\01') or c);
        end

        print(msg:concat(' '));
        return;
    end

    -- Packet: Widescan Results
    if (e.id == 0x00F4) then
        local idx = struct.unpack('H', e.data, 0x04 + 0x01);
        local lvl = struct.unpack('b', e.data, 0x06 + 0x01);

        checker.widescan[idx] = lvl;
        return;
    end
end);