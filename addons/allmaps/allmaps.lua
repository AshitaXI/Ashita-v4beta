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

addon.name      = 'allmaps';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables the ability to see every map via /map without needing the key items. Also works for viewing map waypoints.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- AllMaps Variables
local allmaps = {
    map = {
        ptr     = 0,
        backup  = nil,
    },
    view = {
        ptr     = 0,
        backup  = nil,
    },
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the main map command pointer..
    local pointer = ashita.memory.find('FFXiMain.dll', 0, '50??????????83C4048886????????0FBF8E????????8A', 0x01, 0);
    if (pointer == 0) then
        error(chat.header('allmaps'):append(chat.error('Error: Failed to locate required map function pointer.')));
        return;
    end

    -- Store the pointer and backup the patch data..
    allmaps.map.ptr = pointer;
    allmaps.map.backup = ashita.memory.read_array(allmaps.map.ptr, 5);

    -- Find the map view function pointer.. (Used for viewing waypoints/markers.)
    pointer = ashita.memory.find('FFXiMain.dll', 0, '50??????????83C4048886????????0FBF96????????8A', 0x01, 0);
    if (pointer == 0) then
        error(chat.header('allmaps'):append(chat.error('Error: Failed to locate required map waypoint view function pointer.')));
        return;
    end

    -- Store the pointer and backup the patch data..
    allmaps.view.ptr = pointer;
    allmaps.view.backup = ashita.memory.read_array(allmaps.view.ptr, 5);

    -- Patch the functions..
    local patch = { 0xB8, 0x01, 0x00, 0x00, 0x00 };
    ashita.memory.write_array(allmaps.map.ptr, patch);
    ashita.memory.write_array(allmaps.view.ptr, patch);
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
allmaps.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (allmaps.map.ptr ~= 0) then
        ashita.memory.write_array(allmaps.map.ptr, allmaps.map.backup);
    end
    if (allmaps.view.ptr ~= 0) then
        ashita.memory.write_array(allmaps.view.ptr, allmaps.view.backup);
    end

    allmaps.map.ptr = 0;
    allmaps.view.ptr = 0;
end);