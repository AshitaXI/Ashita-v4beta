--[[
* Addons - Copyright (c) 2024 Ashita Development Team
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

addon.name      = 'crosshair';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Draws position helper lines to move Ashita\'s font and UI elements.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local d3d8  = require('d3d8');
local imgui = require('imgui');

-- Addon variables..
local crosshair = T{
    enabled = true,
    mouse_pos = T{
        x = 0,
        y = 0,
    },
};

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/crosshair') then
        return;
    end

    e.blocked = true;

    crosshair.enabled = not crosshair.enabled;

    print(chat.header(addon.name):append(chat.message('Crosshair is now: ')):append(chat.success(crosshair.enabled and 'Enabled' or 'Disabled')));
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (crosshair.enabled == false) then return; end

    local res, vp = d3d8.get_device():GetViewport();
    if (res ~= 0) then
        return;
    end

    local fg = imgui.GetForegroundDrawList();
    local mx = crosshair.mouse_pos.x;
    local my = crosshair.mouse_pos.y;

    fg:AddLine({ 0, my }, { mx - 14, my }, 0xFFFFFFFF, 2);
    fg:AddLine({ mx + 14, my }, { vp.Width, my }, 0xFFFFFFFF, 2);
    fg:AddLine({ mx, 0 }, { mx, my - 14 }, 0xFFFFFFFF, 2);
    fg:AddLine({ mx, my + 14 }, { mx, vp.Height }, 0xFFFFFFFF, 2);
    fg:AddCircle({ mx, my }, 14, 0xFFFFFFFF);
end);

--[[
* event: mouse
* desc : Event called when the addon is processing mouse input. (WNDPROC)
--]]
ashita.events.register('mouse', 'mouse_cb', function (e)
    if (e.message ~= 512) then return; end

    crosshair.mouse_pos.x = e.x;
    crosshair.mouse_pos.y = e.y;
end);
