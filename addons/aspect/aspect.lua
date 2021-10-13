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

addon.name      = 'aspect';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Forces the games aspect ratio to match the windows resolution.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- Aspect Variables
local aspect = T{
    ptr = 0,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the aspect ratio configuration pointer..
    aspect.ptr = ashita.memory.find('FFXiMain.dll', 0, 'A1????????85C074??D9442404D80D????????D80D', 1, 0);
    if (aspect.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate aspect pointer; cannot adjust aspect ratio.')));
        return;
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    -- Obtain the game window size..
    local w = AshitaCore:GetConfigurationManager():GetUInt32('boot', 'ffxi.registry', '0001', 800);
    local h = AshitaCore:GetConfigurationManager():GetUInt32('boot', 'ffxi.registry', '0002', 600);

    -- Read into the aspect pointer..
    local ptr = ashita.memory.read_uint32(aspect.ptr);
    if (ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to read aspect pointer; cannot adjust aspect ratio.')));
        return;
    end
    ptr = ashita.memory.read_uint32(ptr);

    -- Write the new aspect ratio..
    ashita.memory.write_float(ptr + 0x2F0, (h / (w * 0.25 * 3.0)));
end);