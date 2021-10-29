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

addon.name      = 'imguistyle';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Allows per-character customizations to the ImGui style settings.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat      = require('chat');
local imgui     = require('imgui');
local settings  = require('settings');
local style     = imgui.GetStyle();

-- ImGui Style Property Names
local properties = T{
    -- Properties that are accessed as a boolean.
    b = T{
        'AntiAliasedLines',
        'AntiAliasedLinesUseTex',
        'AntiAliasedFill',
    },

    -- Properties that are accessed as a number.
    n = T{
        'Alpha',
        'WindowRounding',
        'WindowBorderSize',
        'WindowMenuButtonPosition',
        'ChildRounding',
        'ChildBorderSize',
        'PopupRounding',
        'PopupBorderSize',
        'FrameRounding',
        'FrameBorderSize',
        'IndentSpacing',
        'ColumnsMinSpacing',
        'ScrollbarSize',
        'ScrollbarRounding',
        'GrabMinSize',
        'GrabRounding',
        'LogSliderDeadzone',
        'TabRounding',
        'TabBorderSize',
        'TabMinWidthForCloseButton',
        'ColorButtonPosition',
        'MouseCursorScale',
        'CurveTessellationTol',
        'CircleSegmentMaxError',
    },

    -- Properties that are accessed as a ImVec2.
    v = T{
        'WindowPadding',
        'WindowMinSize',
        'WindowTitleAlign',
        'FramePadding',
        'ItemSpacing',
        'ItemInnerSpacing',
        'CellPadding',
        'TouchExtraPadding',
        'ButtonTextAlign',
        'SelectableTextAlign',
        'DisplayWindowPadding',
        'DisplaySafeAreaPadding',
    },
};

-- Default Settings
local default_settings = T{
    b = T{ },
    n = T{ },
    v = T{ },
    c = T{ },
};

-- ImGuiStyle Settings
local imguistyle = T{
    is_open = T{ false, },
    settings = nil,
};

--[[
* Populates the given table with the current ImGui style properties.
*
* @param {table} t - The table to populate.
--]]
local function populate(t)
    -- Process the various properties..
    properties.b:each(function (v)
        t.b[v] = style[v];
    end);
    properties.n:each(function (v)
        t.n[v] = style[v];
    end);
    properties.v:each(function (v)
        local val = style[v];
        t.v[v] = T{ val.x, val.y, };
    end);

    -- Process the colors array..
    for x = ImGuiCol_Text, ImGuiCol_COUNT - 1 do
        local val = style.Colors[x + 1];
        t.c[x] = T{ val.x, val.y, val.z, val.w, };
    end
end

--[[
* Applies the given style to ImGui.
*
* @param {table} s - The style table to apply.
--]]
local function apply(s)
    s.b:each(function (v, k)
        style[k] = v;
    end);
    s.n:each(function (v, k)
        style[k] = v;
    end);
    s.v:each(function (v, k)
        style[k].x = v[1];
        style[k].y = v[2];
    end);
    s.c:each(function (v, k)
        style.Colors[k + 1].x = v[1];
        style.Colors[k + 1].y = v[2];
        style.Colors[k + 1].z = v[3];
        style.Colors[k + 1].w = v[4];
    end);
end

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/imguistyle', 'Toggle the style editor window.', },
        { '/imguistyle help', 'Shows the addon help.', },
        { '/imguistyle (hide | show)', 'Sets the style editor visibility.', },
        { '/imguistyle save', 'Saves the style settings to disk.', },
        { '/imguistyle (reload | rl)', 'Reloads the style settings from disk.', },
        { '/imguistyle reset', 'Resets the style settings to default.', },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', function (s)
    if (s ~= nil) then
        imguistyle.settings = s;
        apply(s);
    end

    settings.save();
end);

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    populate(default_settings);

    imguistyle.settings = settings.load(default_settings);

    apply(imguistyle.settings);
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/imguistyle') then
        return;
    end

    -- Block all imguistyle related commands..
    e.blocked = true;

    -- Handle: /imguistyle - Toggle the style editor window.
    if (#args == 1) then
        imguistyle.is_open[1] = not imguistyle.is_open[1];
        return;
    end

    -- Handle: /imguistyle help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /imguistyle (hide | show) - Sets the style editor visibility.
    if (#args == 2 and args[2]:any('hide', 'show')) then
        imguistyle.is_open[1] = args[2]:lower() == 'show' and true or false;
        return;
    end

    -- Handle: /imguistyle save - Saves the style settings to disk.
    if (#args == 2 and args[2]:any('save')) then
        settings.save();
        print(chat.header(addon.name):append(chat.message('Settings saved to disk.')));
        return;
    end

    -- Handle: /imguistyle (reload | rl) - Reloads the style settings from disk.
    if (#args == 2 and args[2]:any('reload', 'rl')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded from disk.')));
        return;
    end

    -- Handle: /imguistyle reset - Resets the style settings to default.
    if (#args == 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        return;
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (not imguistyle.is_open[1]) then
        return;
    end

    imgui.SetNextWindowSize({ 500, 600, });
    imgui.SetNextWindowSizeConstraints({ 500, 600, }, { FLT_MAX, FLT_MAX, });
    imgui.Begin('Style Editor (ImGuiStyle)');
    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0, }, 'Please Note: ');
    imgui.ShowHelp([[
The below editor is built into ImGui. However, saving settings requires manual usage due to how Ashita is setup.

Because of this, the below editors buttons such as:
  - Save Ref
  - Export

Do nothing. You need to be sure to use the buttons below to save, reload, or reset your settings as desired.

If you wish to revert changes, you can use the 'Revert Ref' button, but be sure to click 'Save Settings' afterward!]]);

    imgui.TextWrapped('After making any changes, be sure to use the \'Save Settings\' button below. Do not use the \'Save Ref\' or \'Export\' buttons as they WILL NOT save your changes!');
    imgui.NewLine();
    if (imgui.Button('Save Settings')) then
        populate(imguistyle.settings);
        settings.save();

        print(chat.header(addon.name):append(chat.message('Settings saved.')));
    end
    imgui.SameLine();
    if (imgui.Button('Reload Settings')) then
        settings.reload();

        print(chat.header(addon.name):append(chat.message('Settings reloaded from disk.')));
    end
    imgui.SameLine();
    if (imgui.Button('Reset Settings To Default')) then
        settings.reset();

        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
    end
    imgui.Separator();
    imgui.ShowStyleEditor();
    imgui.End();
end);