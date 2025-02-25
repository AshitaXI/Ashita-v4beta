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

addon.name      = 'ahgo';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables opening the AH from anywhere and enables being able to move with the AH open.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- AHGo Variables
local ahgo = {
    auction = {
        ptr = 0,
        backup = 0,
    },
    shops = {
        ptr = 0,
        backup = 0,
    },
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the ahgo auction pointer..
    local pointer = ashita.memory.find('FFXiMain.dll', 0, 'DFE02500410000DDD8????8B46086A0150', 0, 0);
    if (pointer == 0) then
        error(chat.header('ahgo'):append(chat.error('Error: Failed to locate required auction pointer.')));
        return;
    end

    -- Store the pointer and read the current byte as a backup..
    ahgo.auction.ptr = pointer + 0x09;
    ahgo.auction.backup = ashita.memory.read_uint8(ahgo.auction.ptr);

    -- Find the ahgo shops pointer..
    pointer = ashita.memory.find('FFXiMain.dll', 0, 'DFE02500410000DDD8????B301', 0, 0);
    if (pointer == 0) then
        error(chat.header('ahgo'):append(chat.error('Error: Failed to locate required shop pointer.')));
        return;
    end

    -- Store the pointer and read the current byte as a backup..
    ahgo.shops.ptr = pointer + 0x09;
    ahgo.shops.backup = ashita.memory.read_uint8(ahgo.shops.ptr);

    -- Patch the functions to allow movement while the AH or shops are open..
    ashita.memory.write_uint8(ahgo.auction.ptr, 0xEB);
    ashita.memory.write_uint8(ahgo.shops.ptr, 0xEB);
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/ah') then
        return;
    end

    e.blocked = true;

    -- Open the AH via packet injection..
    local packet = T{ 0x4C, 0x1E, 0x00, 0x00, 0x02, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x04, }:extend(('\0'):rep(49):bytes());
    AshitaCore:GetPacketManager():AddIncomingPacket(0x4C, packet);
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
ahgo.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (ahgo.auction.ptr ~= 0) then
        ashita.memory.write_uint8(ahgo.auction.ptr, ahgo.auction.backup);
    end
    if (ahgo.shops.ptr ~= 0) then
        ashita.memory.write_uint8(ahgo.shops.ptr, ahgo.shops.backup);
    end

    ahgo.auction.ptr = 0;
    ahgo.shops.ptr = 0;
end);