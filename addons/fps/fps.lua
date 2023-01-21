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

addon.name      = 'fps';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Displays and manipulates the games framerate handling.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local fonts = require('fonts');
local settings = require('settings');

-- Default Settings
local default_settings = T{
    font = T{
        visible = true,
        font_family = 'Arial',
        font_height = 12,
        color = 0xFFFF0000,
        position_x = 1,
        position_y = 1,
    },
    fps = T{
        format = '%d',
    },
};

-- FPS Variables
local fps = T{
    count = 0,
    timer = 0,
    frame = 0,
    font = nil,
    show = true,
    settings = settings.load(default_settings)
};

--[[
* Updates the addon settings.
*
* @param {table} s - The new settings table to use for the addon settings. (Optional.)
--]]
local function update_settings(s)
    -- Update the settings table..
    if (s ~= nil) then
        fps.settings = s;
    end

    -- Apply the font settings..
    if (fps.font ~= nil) then
        fps.font:apply(fps.settings.font);
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
        { '/fps', 'Toggles the fps font visibility.' },
        { '/fps help', 'Displays the addons help information.' },
        { '/fps (hide | show)', 'Sets the fps font visibility.' },
        { '/fps (reload | rl)', 'Reloads the addons settings from disk.' },
        { '/fps reset', 'Resets the addons settings to default.' },
        { '/fps font <family> <height>', 'Sets the fps font family and height.' },
        { '/fps (position | pos) <x> <y>', 'Sets the fps font position.' },
        { '/fps (color | col) <a> <r> <g> <b>', 'Sets the fps font color.' },
        { '/fps <divisor>', 'Sets the fps divisor. (1 = 60fps, 2 = 30fps, etc.)' },
        { '/fps sample <time>', 'Samples the games current frame rate for the given number of seconds to get an estimate of performance.' },
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
    fps.font = fonts.new(fps.settings.font);
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    if (fps.font ~= nil) then
        fps.font:destroy();
        fps.font = nil;
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
    if (#args == 0 or args[1] ~= '/fps') then
        return;
    end

    -- Block all fps related commands..
    e.blocked = true;

    -- Handle: /fps - Toggle the font visibility.
    if (#args == 1) then
        fps.show = not fps.show;
        fps.settings.font.visible = fps.show;
        update_settings();
        return;
    end

    -- Handle: /fps help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /fps (hide | show) - Sets the font visibility.
    if (#args == 2 and args[2]:any('hide', 'show')) then
        fps.show = args[2] == 'show' and true or false;
        fps.settings.font.visible = fps.show;
        update_settings();
        return;
    end

    -- Handle: /fps (reload | rl) - Reloads the FPS settings from disk.
    if (#args == 2 and args[2]:any('reload', 'rl')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded from disk.')));
        return;
    end

    -- Handle: /fps reset - Resets the FPS settings to default.
    if (#args == 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        return;
    end

    -- Handle: /fps font <family> <height> - Sets the font family and height.
    if (#args == 4 and args[2]:any('font')) then
        fps.settings.font.font_family = args[3];
        fps.settings.font.font_height = args[4]:number_or(12);
        update_settings();
        return;
    end

    -- Handle: /fps (position | pos) <x> <y> - Sets the font position.
    if (#args == 4 and args[2]:any('position', 'pos')) then
        fps.settings.font.position_x = args[3]:number_or(1);
        fps.settings.font.position_y = args[4]:number_or(1);
        update_settings();
        return;
    end

    -- Handle: /fps (color | col) <a> <r> <g> <b> - Sets the font color.
    if (#args == 6 and args[2]:any('color', 'col')) then
        local c = math.d3dcolor(args[3]:number_or(0), args[4]:number_or(0), args[5]:number_or(0), args[6]:number_or(0));
        fps.settings.font.color = c;
        update_settings();
        return;
    end

    -- Handle: /fps <divisor> - Sets the fps divisor.
    if (#args == 2) then
        -- Find the FPS divisor pointer..
        local pointer = ashita.memory.find('FFXiMain.dll', 0, '81EC000100003BC174218B0D', 0, 0);
        if (pointer == 0) then
            print(chat.header(addon.name):append(chat.error('Error: Failed to locate FPS divisor pointer; cannot adjust framerate!')));
            return;
        end

        -- Read the pointer..
        pointer = ashita.memory.read_uint32(pointer + 0x0C);
        pointer = ashita.memory.read_uint32(pointer);

        -- Write the new divisor..
        local divisor = args[2]:number_or(2);
        ashita.memory.write_uint32(pointer + 0x30, math.round(divisor));

        print(chat.header(addon.name):append(chat.message('Set the FPS divisor to: ')):append(chat.success(math.round(divisor))));
        return;
    end

    -- Handle: /fps sample <time> - Samples the current frame rate.
    if (#args >= 3 and args[2]:any('sample')) then
        local len = args[3]:number_or(60);
        fps.sample  = T{
            cnt     = 0,
            len     = len,
            fin     = os.clock() + len,
        };
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
    -- Handle sampling if enabled..
    if (fps.sample ~= nil) then
        if (os.clock() > fps.sample.fin) then
            print(chat.header(addon.name)
                :append(chat.message('Sample results: '))
                :append(chat.success(tostring(fps.sample.len)))
                :append(chat.message(' second(s) yielded '))
                :append(chat.success(tostring(fps.sample.cnt)))
                :append(chat.message(' frames. (Avg. '))
                :append(chat.success(tostring(fps.sample.cnt / fps.sample.len)))
                :append(chat.message(' frames per second.)')));
            fps.sample = nil;
        else
            fps.sample.cnt = fps.sample.cnt + 1;
        end
    end

    if (not fps.show) then
        return;
    end

    -- Calculate the current frames per second..
    fps.count = fps.count + 1;
    if (os.time() >= fps.timer + 1) then
        fps.frame = fps.count;
        fps.count = 0;
        fps.timer = os.time();
    end

    -- Update the FPS font object..
    if (fps.font ~= nil and fps.font.visible == true) then
        -- Update the current settings font position..
        fps.settings.font.position_x = fps.font.position_x;
        fps.settings.font.position_y = fps.font.position_y;

        -- Update the font text..
        fps.font.text = (fps.settings.fps.format or '%d'):fmt(fps.frame);
    end
end);