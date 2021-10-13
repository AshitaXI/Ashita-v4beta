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

addon.name      = 'filterscan';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Allows filtering widescan results for specific entities.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local dats = require('ffxi.dats');

-- FilterScan Variables
local filterscan = T{
    filter = T{ },
    npcs = T{ },
};

--[[
* Updates the npc list with the current zones information.
*
* @param {number} zid - The zone id to load the npcs of.
* @param {number} zsubid - The zone sub id to load the npcs of.
* @return {boolean} True on success, false otherwise.
--]]
local function update_npcs(zid, zsubid)
    -- Clear the previous npc information..
    filterscan.npcs = T{ };

    -- Obtain the npc list dat for the given zone..
    local file = dats.get_zone_npclist(zid, zsubid);
    if (file == nil or file:len() == 0) then
        return false;
    end

    -- Open the DAT for reading..
    local f = io.open(file, 'rb');
    if (f == nil) then
        return false;
    end

    -- Obtain the file size..
    local size = f:seek('end');
    f:seek('set', 0);

    -- Validate the file by its size and expected entry count alignment..
    if (size == 0 or ((size - math.floor(size / 0x20) * 0x20) ~= 0)) then
        f:close();
        return false;
    end

    -- Parse the file for npc entries..
    for x = 0, ((size / 0x20) - 0x01) do
        local data = f:read(0x20);
        local name, id = struct.unpack('c28L', data);
        table.insert(filterscan.npcs, { bit.band(id, 0x0FFF), name });
    end

    f:close();
    return true;
end

--[[
* Returns the npc name for the given target index using the zones npc dat information.
*
* @param {number} tidx - The target index to return the name for.
* @return {string|nil} The npc name for the given index, nil if not found.
--]]
local function name_from_index(tidx)
    if (filterscan.npcs:len() == 0) then
        return nil;
    end

    for _, v in pairs(filterscan.npcs) do
        if (v[1] == tidx) then
            return v[2];
        end
    end

    return nil;
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Load the current zone npc list if the player is logged in..
    if (AshitaCore:GetMemoryManager():GetPlayer():GetLoginStatus() == 2 and AshitaCore:GetMemoryManager():GetParty():GetMemberIsActive(0) > 0) then
        if (update_npcs(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0), 0)) then
            print(chat.header(addon.name):append(chat.message('Loaded zone npc list.')));
        end
    end
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/filterscan') then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Clear the previous filter..
    filterscan.filter:clear();

    -- Obtain the filter from the command..
    local filter = e.command:gsub('/filterscan', ''):trim();

    for t in filter:gmatch('[^,]+') do
        if (t ~= nil) then
            filterscan.filter:insert(t:lower():trim());
        end
    end

    print(chat.header(addon.name):append(chat.message('Widescan filter set to: ')):append(chat.success(filter:len() == 0 and '(None; filter is empty.)' or filter)));
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Zone Enter
    if (e.id == 0x000A) then
        -- Ignore mog house zoning..
        if (struct.unpack('b', e.data_modified, 0x80 + 0x01) == 1) then
            return;
        end

        -- Obtain the zone id from the packet..
        local zid = struct.unpack('H', e.data_modified, 0x30 + 0x01);
        local zsubid = struct.unpack('H', e.data_modified, 0x9E + 0x01);

        -- Update the zone npc list..
        if (update_npcs(zid, zsubid)) then
            print(chat.header(addon.name):append(chat.message('Loaded zone npc list.')));
        end
    end

    -- Packet: Zone Leave
    if (e.id == 0x000B) then
        filterscan.npcs:clear();
    end

    -- Packet: Widescan Entry
    if (e.id == 0x00F4) then
        -- Ensure a filter is set..
        if (table.getn(filterscan.filter) == 0) then
            return;
        end

        -- Obtain the npc information..
        local tidx = struct.unpack('H', e.data_modified, 0x04 + 0x01);
        local name = name_from_index(tidx);

        if (name == nil) then
            return;
        end

        local n = name:lower();
        local i = tostring(tidx);

        -- Find matching filter results to allow..
        for _, v in pairs(filterscan.filter) do
            if (n:find(v) ~= nil or tidx == tonumber(v, 16) or v == i) then
                return false;
            end
        end

        -- Filter the entry from showing..
        e.blocked = true;
    end
end);