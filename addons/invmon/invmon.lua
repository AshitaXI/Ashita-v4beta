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

addon.name      = 'invmon';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Displays current inventory container space information.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat      = require('chat');
local fonts     = require('fonts');
local imgui     = require('imgui');
local scale     = require('scaling');
local settings  = require('settings');

local default_settings = T{
    colors = T{
        default     = T{ 1.0, 1.0, 1.0, 1.0 },
        warning     = T{ 1.0, 1.0, 0.0, 1.0 },
        full        = T{ 1.0, 0.0, 0.0, 1.0 },
    },
    colorize = true,
    containers = T{
        [0x01] = true,  -- Inventory
        [0x02] = false, -- Safe
        [0x03] = false, -- Storage
        [0x04] = false, -- Temporary
        [0x05] = false, -- Locker
        [0x06] = false, -- Satchel
        [0x07] = false, -- Sack
        [0x08] = false, -- Case
        [0x09] = false, -- Wardrobe 1
        [0x0A] = false, -- Safe 2
        [0x0B] = false, -- Wardrobe 2
        [0x0C] = false, -- Wardrobe 3
        [0x0D] = false, -- Wardrobe 4
        [0x0E] = false, -- Wardrobe 5
        [0x0F] = false, -- Wardrobe 6
        [0x10] = false, -- Wardrobe 7
        [0x11] = false, -- Wardrobe 8
        [0x12] = false, -- Recycle
    },
    font = T{
        color = 0xFFFFFFFF,
        font_family = 'Arial',
        font_height = scale.scale_font(12),
        padding = 1,
        position_x = 100,
        position_y = 100,
        visible = true,
        background = T{
            color = 0x80000000,
            visible = true,
        },
    },
    warning_count = 5,
};

local invmon = T{
    editor = T{
        is_open = T{ false, },
    },
    font = nil,
    settings = settings.load(default_settings),
};

local container_names = T{
    'Inventory', 'Safe', 'Storage', 'Temporary', 'Locker',
    'Satchel', 'Sack', 'Case', 'Wardrobe', 'Safe 2',
    'Wardrobe 2', 'Wardrobe 3', 'Wardrobe 4', 'Wardrobe 5',
    'Wardrobe 6', 'Wardrobe 7', 'Wardrobe 8', 'Recycle',
};

--[[
* Updates the addon settings.
*
* @param {table} s - The new settings table to use for the addon settings. (Optional.)
--]]
local function update_settings(s)
    if (s ~= nil) then
        invmon.settings = s;
    end
    if (invmon.font ~= nil) then
        invmon.font:apply(invmon.settings.font);
    end
    settings.save();
end
settings.register('settings', 'settings_update', update_settings);

--[[
* Converts an HSV color code to a uint32_t.
*
* @param {table} c - The HSV color to be converted.
* @return {number} The converted color code.
--]]
local function hsv_to_u32(c)
    return math.d3dcolor(c[4] * 255, c[1] * 255, c[2] * 255, c[3] * 255);
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    invmon.font = fonts.new(invmon.settings.font);
    invmon.font.color = hsv_to_u32(invmon.settings.colors.default);
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    if (invmon.font ~= nil) then
        invmon.font:destroy();
        invmon.font = nil;
    end

    settings.save();
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/invmon') then
        return;
    end

    e.blocked = true;

    invmon.editor.is_open[1] = not invmon.editor.is_open[1];
end);

--[[
* Renders the inventory monitor settings editor.
--]]
local function render_editor()
    if (not invmon.editor.is_open[1]) then
        return;
    end
    if (imgui.Begin('InvMon Settings Editor', invmon.editor.is_open)) then
        if (imgui.BeginTabBar('##invmon_tabbar', ImGuiTabBarFlags_NoCloseWithMiddleMouseButton)) then
            if (imgui.BeginTabItem('General', nil)) then
                local colorize      = T{ invmon.settings.colorize, };
                local background    = T{ invmon.font.background.visible, };
                local warncount     = T{ invmon.settings.warning_count, };

                if (imgui.Checkbox('Colorize?', colorize)) then
                    invmon.settings.colorize = colorize[1];
                    settings.save();
                end
                if (imgui.Checkbox('Show Background?', background)) then
                    invmon.settings.font.background.visible = background[1];
                    invmon.font.background.visible = background[1];
                    settings.save();
                end
                imgui.ShowHelp('Color container entries based on remaining storage space.');
                if (imgui.SliderInt('Warning Count', warncount, 1, 15)) then
                    invmon.settings.warning_count = warncount[1];
                end
                imgui.ShowHelp('The amount of items remaining in the container until the warning color is used.');
                imgui.NewLine();
                if (imgui.ColorEdit4('Default', invmon.settings.colors.default)) then
                    invmon.font.color = hsv_to_u32(invmon.settings.colors.default);
                end
                imgui.ShowHelp('The default color to show inventory containers that have available space.');
                imgui.ColorEdit4('Warning', invmon.settings.colors.warning);
                imgui.ShowHelp('The color to use when the inventory container is almost full.');
                imgui.ColorEdit4('Full', invmon.settings.colors.full);
                imgui.ShowHelp('The color to use whe nthe inventory container is full.');
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Containers', nil)) then
                imgui.Columns(2, nil, false);
                for x = 1, 18 do
                    local checked = T{ invmon.settings.containers[x], };
                    if (imgui.Checkbox(container_names[x], checked)) then
                        invmon.settings.containers[x] = checked[1];
                    end
                    if (x == 9) then
                        imgui.NextColumn();
                    end
                end
                imgui.NextColumn();
                imgui.EndTabItem();
            end
            imgui.EndTabBar();
        end
    end
    imgui.End();
end

--[[
* Renders the inventory monitor display.
--]]
local function render_display()
    if (invmon.font == nil) then
        return;
    end

    if (invmon.settings.containers:all(function (v) return v == false; end)) then
        invmon.font.text = '';
        return;
    end

    local entries = T{ };
    invmon.settings.containers:filter(function (v) return v; end):sortkeys():each(function (v)
        local n = container_names[v];
        local c = AshitaCore:GetMemoryManager():GetInventory():GetContainerCount(v - 1);
        local m = AshitaCore:GetMemoryManager():GetInventory():GetContainerCountMax(v - 1);
        if (invmon.settings.colorize and c >= m) then
            local col = invmon.settings.colors.full;
            entries:append(('|c%02X%02X%02X%02X|%02d/%02d - %s|r'):fmt(
                col[4] * 255, col[1] * 255, col[2] * 255, col[3] * 255,
                c, m, n));
        elseif (invmon.settings.colorize and m - c <= invmon.settings.warning_count) then
            local col = invmon.settings.colors.warning;
            entries:append(('|c%02X%02X%02X%02X|%02d/%02d - %s|r'):fmt(
                col[4] * 255, col[1] * 255, col[2] * 255, col[3] * 255,
                c, m, n));
        else
            entries:append(('%02d/%02d - %s'):fmt(c, m, n));
        end
    end);

    invmon.font.text = entries:join('\n');
end

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    render_editor();
    render_display();
end);
