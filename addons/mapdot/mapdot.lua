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

addon.name      = 'mapdot';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables seeing enemies on the compass on all jobs.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- MapDot Variables
local mapdot = T{
    ptr = 0,
    backup = nil,
    shown = false,
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the compass pointer..
    mapdot.ptr = ashita.memory.find('FFXiMain.dll', 0, 'A1????????85C074??D9442404D80D????????8B4C2404', 0, 0);
    if (mapdot.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end

    -- Backup the patch data..
    mapdot.backup = ashita.memory.read_array(mapdot.ptr + 0x34, 0x03);

    -- Patch the memory..
    local patch = { 0x90, 0x90, 0x90, };
    ashita.memory.write_array(mapdot.ptr + 0x34, patch);

    -- Set the map to show all dots..
    local map = ashita.memory.read_uint32(mapdot.ptr + 0x01);
    if (map == 0) then
        return;
    end

    map = ashita.memory.read_uint32(map);
    if (map == 0) then
        return;
    end

    ashita.memory.write_uint8(map + 0x2F, 1);
    mapdot.shown = true;
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if(mapdot.ptr == 0 or mapdot.shown == true) then
        return;
    end

    -- Set the map to show all dots..
    local map = ashita.memory.read_uint32(mapdot.ptr + 0x01);
    if (map == 0) then
        return;
    end

    map = ashita.memory.read_uint32(map);
    if (map == 0) then
        return;
    end

    ashita.memory.write_uint8(map + 0x2F, 1);
    mapdot.shown = true;
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
mapdot.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (mapdot.ptr ~= 0 and #mapdot.backup > 0) then
        ashita.memory.write_array(mapdot.ptr + 0x34, mapdot.backup);
    end
    mapdot.ptr = 0;
end);