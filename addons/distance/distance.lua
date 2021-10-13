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

addon.name      = 'distance';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Displays the distance between you and your target.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local fonts = require('fonts');
local scaling = require('scaling');
local settings = require('settings');

-- Default Settings
local default_settings = T{
    font = T{
        visible = true,
        font_family = 'Arial',
        font_height = scaling.scale_f(16),
        color = 0xFFFFFFFF,
        bold = true,
        position_x = scaling.scale_w(-180),
        position_y = scaling.scale_h(20),
    },
};

-- Distance Variables
local distance = T{
    font = nil,
    settings = settings.load(default_settings),
};

--[[
* Updates the addon settings.
*
* @param {table} s - The new settings table to use for the addon settings. (Optional.)
--]]
local function update_settings(s)
    -- Update the settings table..
    if (s ~= nil) then
        distance.settings = s;
    end

    -- Apply the font settings..
    if (distance.font ~= nil) then
        distance.font:apply(distance.settings.font);
    end

    -- Save the current settings..
    settings.save();
end

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', update_settings);

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
        { '/distance help', 'Displays the addons help information.' },
        { '/distance (reload | rl)', 'Reloads the addons settings from disk.' },
        { '/distance reset', 'Resets the addons settings to default.' },
        { '/distance font <family> <height>', 'Sets the font family and height.' },
        { '/distance (position | pos) <x> <y>', 'Sets the font position.' },
        { '/distance (color | col) <a> <r> <g> <b>', 'Sets the font color.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    distance.font = fonts.new(distance.settings.font);
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    if (distance.font ~= nil) then
        distance.font:destroy();
        distance.font = nil;
    end

    settings.save();
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/distance') then
        return;
    end

    -- Block all distance related commands..
    e.blocked = true;

    -- Handle: /distance help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /distance (reload | rl) - Reloads the addon settings from disk.
    if (#args == 2 and args[2]:any('reload', 'rl')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded from disk.')));
        return;
    end

    -- Handle: /distance reset - Resets the addon settings to default.
    if (#args == 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        return;
    end

    -- Handle: /distance font <family> <height> - Sets the font family and height.
    if (#args == 4 and args[2]:any('font')) then
        distance.settings.font.font_family = args[3];
        distance.settings.font.font_height = args[4]:number_or(12);
        update_settings();
        return;
    end

    -- Handle: /distance (position | pos) <x> <y> - Sets the font position.
    if (#args == 4 and args[2]:any('position', 'pos')) then
        distance.settings.font.position_x = args[3]:number_or(1);
        distance.settings.font.position_y = args[4]:number_or(1);
        update_settings();
        return;
    end

    -- Handle: /distance (color | col) <a> <r> <g> <b> - Sets the font color.
    if (#args == 6 and args[2]:any('color', 'col')) then
        local c = math.d3dcolor(args[3]:number_or(0), args[4]:number_or(0), args[5]:number_or(0), args[6]:number_or(0));
        distance.settings.font.color = c;
        update_settings();
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (distance.font == nil) then
        return;
    end

    -- Update the current settings font position..
    distance.settings.font.position_x = distance.font.position_x;
    distance.settings.font.position_y = distance.font.position_y;

    -- Ensure there is a player..
    local party = AshitaCore:GetMemoryManager():GetParty();
    if (party:GetMemberIsActive(0) == 0 or party:GetMemberServerId(0) == 0) then
        distance.font.text = '';
        return;
    end

    -- Ensure there is a target..
    local target = GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(0));
    if (target ~= nil) then
        distance.font.text = ('%.1f'):fmt(math.sqrt(target.Distance));
    else
        distance.font.text = '';
    end
end);