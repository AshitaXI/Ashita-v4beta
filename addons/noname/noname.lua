--[[
* Addons - Copyright (c) 2022 Ashita Development Team
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

addon.name      = 'noname';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Removes the local player name.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- noname Variables
local noname = T{
    pointer = 0,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Locate the needed patterns..
    local ptr = ashita.memory.find('FFXiMain.dll', 0, '83E1F789882801000033C0668B4608', 0, 0);
    if (ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate a required pointer.')));
        return;
    end

    -- Store the pointer..
    noname.pointer = ptr;

    -- Patch the player entity update function to prevent removing the invis name mask on updates..
    ashita.memory.write_uint8(noname.pointer + 0x02, 0xF8);
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    -- Restore original entity update patch..
    if (noname.pointer ~= 0) then
        ashita.memory.write_uint8(noname.pointer + 0x02, 0xF7);
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    local e = GetPlayerEntity();
    if (e ~= nil and e.ActorPointer ~= 0 and e.Type == 0) then
        local f = e.Render.Flags2;
        if (bit.band(f, 0x08) ~= 0x08) then
            e.Render.Flags2 = bit.bor(e.Render.Flags2, 0x08);
        end
    end
end);