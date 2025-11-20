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

addon.name      = 'namecolors';
addon.author    = 'atom0s';
addon.version   = '1.2';
addon.desc      = 'Enables editing the games name color table.';
addon.link      = 'https://ashitaxi.com/';

require 'common';
require 'win32types';

local chat      = require 'chat';
local imgui     = require 'imgui';
local settings  = require 'settings';

local default_settings = T{
    colors = T{
        ['0']   = 0xC0808080,
        ['1']   = 0xC0618080,
        ['2']   = 0xC0616180,
        ['3']   = 0xC0416180,
        ['4']   = 0xC0618061,
        ['5']   = 0xC0808061,
        ['6']   = 0xC0804141,
        ['7']   = 0xC0804180,
        ['8']   = 0xC0806141,
        ['9']   = 0xC0414141,
        ['10']  = 0xC0808080,
        ['11']  = 0xC0808080,
        ['12']  = 0xC0617180,
        ['13']  = 0xC0592121,
        ['14']  = 0xC0592121,
        ['15']  = 0xC0592121,
        ['16']  = 0xC0806169,
        ['17']  = 0xC0494980,
        ['18']  = 0xC0802141,
        ['19']  = 0xC0214180,
        ['20']  = 0xC0616121,
        ['21']  = 0xC0013D5A,
        ['22']  = 0xC02E4D20,
    },
};

local namecolors = T{
    ptr = 0,
    settings = settings.load(default_settings),
    window = T{
        is_open = T{ false, },
    },
};

--[[
* Reads the address to the name color table.
--]]
local function get_addr()
    if (namecolors.ptr == 0) then
        return 0;
    end
    return ashita.memory.read_uint32(namecolors.ptr);
end

--[[
* Flips a color tables red and blue channels.
*
* @param {table} The color table to flip.
* @return {table} The flipped color table.
--]]
local function cflip(c)
    local r, b = c[3], c[1];
    c[1] = r;
    c[3] = b;
    return c;
end

--[[
* Converts a Direct3D color to an ImGui color.
*
* @param {number} color - The color to convert.
* @return {table} The converted color.
--]]
local function u32_to_hsv(color)
    return cflip({ imgui.ColorConvertU32ToFloat4(color) });
end

--[[
* Updates the current name colors table in memory.
--]]
local function update_name_colors()
    local addr = get_addr();
    if (addr == 0) then
        return;
    end
    for x = 0, 22 do
        ashita.memory.write_uint32(addr + (x * 4), namecolors.settings.colors[x:str()]);
    end
end

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/namecolors',        'Toggles the NameColors editor.' },
        { '/namecolors save',   'Saves the current settings.' },
        { '/namecolors reload', 'Reloads the current settings from disk.' },
        { '/namecolors reset',  'Resets the current settings.' },
    };

    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', function (s)
    if (s ~= nil) then
        namecolors.settings = s;
    end
    update_name_colors();
    settings.save();
end);

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    namecolors.ptr = ashita.memory.find(0, 0, 'B917000000B880808080BF', 0x0B, 0);
    if (namecolors.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end

    update_name_colors();
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    settings.save();
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/namecolors')) then
        return;
    end

    e.blocked = true;

    -- Handle: /namecolors          - Toggles the NameColors editor.
    -- Handle: /namecolors editor   - Toggles the NameColors editor.
    if (#args == 1 or (#args >= 2 and args[2]:any('editor'))) then
        namecolors.window.is_open[1] = not namecolors.window.is_open[1];
        return;
    end

    -- Handle: /namecolors save - Saves the current settings.
    if (#args >= 2 and args[2]:any('save')) then
        settings.save();
        print(chat.header(addon.name):append(chat.message('Settings saved.')));
        return;
    end

    -- Handle: /namecolors reload - Reloads the current settings from disk.
    if (#args >= 2 and args[2]:any('reload')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded.')));
        return;
    end

    -- Handle: /namecolors reset - Resets the current settings.
    if (#args >= 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
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
    if (not namecolors.window.is_open[1]) then return; end
    if (imgui.Begin('NameColors - by atom0s', namecolors.window.is_open)) then
        local addr = get_addr();
        if (addr == 0) then
            imgui.TextColored(T{ 1.0, 0.4, 0.4, 1.0, }, 'Name color pointer is invalid!');
        end
        for x = 0, 22 do
            local c = u32_to_hsv(ashita.memory.read_uint32(addr + (x * 4)));
            if (imgui.ColorEdit4(('Color: '):append(x), c)) then
                c = cflip(c);
                local col = imgui.ColorConvertFloat4ToU32(c);
                ashita.memory.write_uint32(addr + (x * 4), col);
                namecolors.settings.colors[x:str()] = col;
                settings.save();
            end
        end
    end
    imgui.End();
end);
