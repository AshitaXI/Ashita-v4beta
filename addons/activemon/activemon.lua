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

addon.name      = 'activemon';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Displays an image on screen showing if the current client is focused.';
addon.link      = 'https://ashitaxi.com/';

require 'common';
require 'win32types';

local ffi   = require 'ffi';
local prims = require 'primitives';

ffi.cdef[[
    HWND GetFocus();
    HWND GetForegroundWindow();
]];

local default_settings = T{
    visible     = true,
    position_x  = 25,
    position_y  = 25,
    can_focus   = false,
    locked      = false,
    lockedz     = false,
    scale_x     = 0.5,
    scale_y     = 0.5,
    width       = 64.0,
    height      = 64.0,
    color       = 0xFFFFFFFF,
};

local activemon = T{
    img = prims.new(default_settings),
    status = false,
};

activemon.img:SetTextureFromFile(('%s/inactive.png'):fmt(addon.path));

ashita.events.register('d3d_present', 'd3d_present_cb', function ()
    local has_focus         = false;
    local hwnd_focus        = ffi.cast('uint32_t', ffi.C.GetFocus());
    local hwnd_foreground   = ffi.cast('uint32_t', ffi.C.GetFocus());
    local hwnd_game         = AshitaCore:GetProperties():GetFinalFantasyHwnd();
    if (hwnd_focus == 0 or hwnd_foreground == 0 or hwnd_game == 0) then
        has_focus = false;
    else
        if (hwnd_focus == hwnd_game and hwnd_foreground == hwnd_game) then
            has_focus = true;
        end
    end
    if (activemon.status ~= has_focus) then
        activemon.status = has_focus;
        if (has_focus) then
            activemon.img:SetTextureFromFile(('%s/active.png'):fmt(addon.path));
        else
            activemon.img:SetTextureFromFile(('%s/inactive.png'):fmt(addon.path));
        end
    end
end);