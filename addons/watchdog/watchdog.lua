--[[
* Addons - Copyright (c) 2023 Ashita Development Team
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

addon.name      = 'watchdog';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables widescan tracking [nearly] anything with a command.';
addon.link      = 'https://ashitaxi.com/';

require('common');
require('win32types');
local chat  = require('chat');
local dats  = require('ffxi.dats');
local ffi   = require('ffi');

ffi.cdef[[
    typedef bool (__cdecl* gcTrackingStartSet_f)(uint32_t);
]];

-- Addon variables..
local watchdog = T{
    entities = T{ },
    pointers = T{
        func = 0,
        zone = 0,
    },
};

--[[
* Prints the addon help information.
*
* @param {boolean} is_err - Flag if this function was invoked due to an error.
--]]
local function print_help(is_err)
    -- Print the help header..
    if (is_err) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/watchdog help', 'Displays the addons help information.' },
        { '/watchdog refresh', 'Refreshes the current zone entity list.' },
        { '/watchdog find <name>', 'Lists all entities matching the given name (or partial name).' },
        { '/watchdog track <id>', 'Tracks the given entity.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Returns the current zones id and sub id.
*
* @return {number, number} The current zones id and sub id.
--]]
local function get_zone_ids()
    if (watchdog.pointers.zone == 0) then
        return 0, 0;
    end

    local pointer = ashita.memory.read_uint32(watchdog.pointers.zone);
    if (pointer == 0) then return 0, 0; end
    pointer = ashita.memory.read_uint32(pointer + 0x04);
    if (pointer == 0) then return 0, 0; end

    return ashita.memory.read_uint32(pointer + 0x3C2E0), ashita.memory.read_uint16(pointer + 0x3C2EA);
end

--[[
* Loads the current zones static entities from disk.
*
* @param {number} zid - The zone id.
* @param {number} sid - The zone sub id.
* @return {boolean} True on success, false otherwise.
--]]
local function load_zone_entities(zid, sid)
    watchdog.entities = T{ };

    local file = dats.get_zone_npclist(zid, sid);
    if (file == nil or file:len() == 0) then
        print(chat.header(addon.name):append(chat.error('Failed to determine zone entity DAT file for current zone. [zid: %d, sid: %d]'):fmt(zid, sid)));
        return false;
    end

    local f = io.open(file, 'rb');
    if (f == nil) then
        print(chat.header(addon.name):append(chat.error('Failed to access zone entity DAT file for current zone. [zid: %d, sid: %d]'):fmt(zid, sid)));
        return false;
    end

    local size = f:seek('end');
    f:seek('set', 0);

    if (size == 0 or ((size - math.floor(size / 0x20) * 0x20) ~= 0)) then
        f:close();
        print(chat.header(addon.name):append(chat.error('Failed to validate zone entity DAT file for current zone. [zid: %d, sid: %d]'):fmt(zid, sid)));
        return false;
    end

    for _ = 0, ((size / 0x20) - 0x01) do
        local data = f:read(0x20);
        local name, id = struct.unpack('c28L', data);
        table.insert(watchdog.entities, T{ ['id'] = bit.band(id, 0x0FFF), ['name'] = name:trim('\0') });
    end

    f:close();

    print(chat.header(addon.name):append(chat.message('Loaded zone entity list!')));

    return true;
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    watchdog.pointers.func = ashita.memory.find('FFXiMain.dll', 0, '66837C240405568BF10F85????????0FBF44240C480F84????????48', 0xD7, 0x00);
    watchdog.pointers.zone = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8B44240425FFFF00003B', 0x02, 0x00);

    if (watchdog.pointers.func == 0 or watchdog.pointers.zone == 0) then
        error(chat.header(addon.name):append(chat.error('Failed to locate required pointer(s); cannot continue!')));
        return;
    end

    load_zone_entities(get_zone_ids());
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/watchdog') then
        return;
    end

    e.blocked = true;

    -- Handle: /watchdog help
    if (args:len() == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /watchdog refresh
    if (args:len() == 2 and args[2]:any('refresh')) then
        load_zone_entities(get_zone_ids());
        return;
    end

    -- Handle: /watchdog find <name>
    if (args:len() >= 3 and args[2]:any('find')) then
        if (watchdog.entities:len() == 0) then
            print(chat.header(addon.name):append(chat.error('No entities loaded for the current zone; cannot search.')));
            print(chat.header(addon.name):append(chat.error('Try manually refreshing via: ')):append(chat.message('/watchdog refresh')));
            return;
        end

        local name = args:slice(3, args:len()):join(' '):lower();
        if (name == nil or name:len() == 0) then
            print(chat.header(addon.name):append(chat.error('Invalid search name provided; cannot search.')));
            return;
        end

        local matches = T{ };
        watchdog.entities:each(function (v)
            if (v.name:lower():contains(name)) then
                matches:append(v);
            end
        end);

        if (matches:len() == 0) then
            print(chat.header(addon.name):append(chat.message('No matching entities found.')));
            return;
        end

        matches:ieach(function(v)
            print(chat.header(addon.name):append(chat.message('Found partial match: ')):append(chat.success(v.id)):append(chat.message(' - ' .. v.name)));
        end);

        return;
    end

    -- Handle: /watchdog track <id>
    if (args:len() == 3 and args[2]:any('track')) then
        local off = ashita.memory.read_uint32(watchdog.pointers.func + 0x01);
        local ptr = (watchdog.pointers.func + 0x05) + off;
        local mid = args[3]:num_or(0);

        (ffi.cast('gcTrackingStartSet_f', ptr))(mid);

        print(chat.header(addon.name):append(chat.message('Attempting to track entity id: ')):append(chat.success(mid)));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: RecvLogIn
    if (e.id == 0x000A) then
        if (struct.unpack('b', e.data_modified, 0x80 + 0x01) == 1) then
            watchdog.entities = T{ };
            return;
        end

        local zid = struct.unpack('L', e.data_modified, 0x30 + 0x01);
        local sid = struct.unpack('H', e.data_modified, 0x9E + 0x01);

        load_zone_entities(zid, sid);
        return;
    end
end);
