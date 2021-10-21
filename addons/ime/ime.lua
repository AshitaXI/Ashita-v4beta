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

addon.name      = 'ime';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Allows non-Japanese clients to talk using the Japanese IME and character sets.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- IME Variables
local ime = T{
    -- Pointers
    ptr_check   = nil,
    ptr_input   = nil,
    ptr_lang    = nil,

    -- Offsets
    off_input_1 = 0xF0EC,
    off_input_2 = 0xF10C,
    off_langid  = 0x0008,

    -- Language id backup..
    langid      = 1,
};

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
        { '/ime help', 'Displays the addons help information.' },
        { '/ime setlang <id>', 'Sets the client language. (0 = JP, 1 = NA, 2 = EU, 3 = EU)' },
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
    -- Create a pointer to the IME language check..
    ime.ptr_check = ffi.gc(ffi.cast('uint8_t*', ashita.memory.find('FFXiMain.dll', 0, '83EC08A1????????5333DB56', 0x2F, 0)), function ()
        ime.ptr_check[0] = 0x74;
    end);

    if (ime.ptr_check == nil) then
        error(chat.header('ime'):append(chat.error('Error: Failed to locate IME language check function pointer.')));
    end

    -- Create a pointer to the IME language object..
    ime.ptr_input = ffi.gc(ffi.cast('uint8_t*', (ffi.cast('uint32_t**', ashita.memory.find('FFXiMain.dll', 0, '8B0D????????81EC0401000053568B', 2, 0))[0])[0]), function ()
        ime.ptr_input[ime.off_input_1] = 0x01;
        ime.ptr_input[ime.off_input_2] = 0x01;
    end);

    if (ime.ptr_input == nil) then
        error(chat.header('ime'):append(chat.error('Error: Failed to locate IME language object pointer.')));
    end

    -- Create a pointer to the client language id..
    ime.ptr_lang = ffi.gc(ffi.cast('uint8_t*', (ffi.cast('uint32_t**', ashita.memory.find('FFXiMain.dll', 0, '8B0D????????83EC0C8A51188B410884D256', 2, 0))[0])[0]), function ()
        ime.ptr_lang[ime.off_langid] = ime.langid;
    end);

    if (ime.ptr_lang == 0) then
        error(chat.header('ime'):append(chat.error('Error: Failed to locate game language pointer.')));
    end

    -- Backup the current client language id..
    ime.langid = ime.ptr_lang[ime.off_langid];
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/ime')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /ime help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /ime setlang <id> - Sets the client language id. (0 = JP, 1 = NA, 2 = EU, 3 = EU)
    if (#args >= 3 and args[2]:any('setlang')) then
        if (ime.ptr_lang == nil) then
            return;
        end

        local id = args[3]:num() or 1;
        ime.ptr_lang[ime.off_langid] = id:within(0, 3) and id or 1;

        print(chat.header('ime'):append(chat.message('Set the client language to: '))
                                :append(chat.success(T{'JP', 'NA', 'EU', 'EU'}[(id:within(0, 3) and id or 1) + 1])));
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
    -- Enforce the IME patches..
    if (ime.ptr_check ~= nil) then
        ime.ptr_check[0] = 0xEB;
    end
    if (ime.ptr_input ~= nil) then
        ime.ptr_input[ime.off_input_1] = 0x00;
        ime.ptr_input[ime.off_input_2] = 0x00;
    end
end);