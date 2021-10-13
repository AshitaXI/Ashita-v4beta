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

addon.name      = 'filterless';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Disables the bad language filter for private servers.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- Filterless Variables
local filterless = T{
    ptr = 0,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the game configurations pointer..
    filterless.ptr = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????85C975??83C8??C38B44240450E8????????C3', 0, 0);
    if (filterless.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (filterless.ptr == 0) then
        return;
    end

    -- Read into the configuration pointer..
    local ptr = ashita.memory.read_uint32(filterless.ptr + 0x02);
    if (ptr == 0) then
        return;
    end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then
        return;
    end

    -- Disable the chat filter..
    ashita.memory.write_uint32(ptr + 0x04, 0x01);
end);