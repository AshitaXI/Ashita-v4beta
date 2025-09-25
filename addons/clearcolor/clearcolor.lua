--[[
* Addons - Copyright (c) 2025 Ashita Development Team
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

addon.name      = 'clearcolor';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Enables modding the background color of the scene.';
addon.link      = 'https://ashitaxi.com/';

require 'common';

local chat  = require 'chat';
local imgui = require 'imgui';

local window = T{
    pointer = 0,
    is_open = T{ true, },
    is_enabled = T{ true, },
    color = T{ 0, 0, 0, 0 },
};

local function hsv_to_u32(c)
    return math.d3dcolor(c[4] * 255, c[1] * 255, c[2] * 255, c[3] * 255);
end

ashita.events.register('load', 'load_cb', function ()
    window.pointer = ashita.memory.find(0, 0, 'A1????????0508030000C3', 0, 0);
    if (window.pointer == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end
end);

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/clearcolor')) then
        return;
    end

    e.blocked = true;

    if (#args >= 1) then
        window.is_open[1] = not window.is_open[1];
        return;
    end
end);

ashita.events.register('d3d_present', 'ui_render_cb', function ()
    if (window.is_enabled[1]) then
        local ptr = ashita.memory.read_uint32(window.pointer + 1);
        if (ptr ~= 0) then
            ptr = ashita.memory.read_uint32(ptr);
            if (ptr ~= 0) then
                ashita.memory.write_uint32(ptr + 0x308, hsv_to_u32(window.color));
            end
        end
    end
    if (not window.is_open[1]) then
        return;
    end
    if (imgui.Begin('ClearColor - by atom0s', window.is_open)) then
        imgui.Checkbox('Enabled?', window.is_enabled);
        imgui.ColorEdit4(('Clear Color'), window.color)
    end
    imgui.End();
end);