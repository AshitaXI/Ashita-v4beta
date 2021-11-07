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

addon.name      = 'filters';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Allows for saving/loading chat filter sets with ease. (Useful for private servers.)';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');
local settings = require('settings');

-- Filters Variables
local filters = T{
    ptr     = nil,
    offset  = nil,
    current = nil,
};

-- FFI Prototypes
ffi.cdef[[
    // Packet: 0x00DB - Char Config (Client To Server)
    typedef struct packet_charconfig_c2s_t {
        uint32_t Header;            // 0x00
        uint8_t Unknown0000;        // 0x04
        uint8_t Unknown0001;        // 0x05
        uint8_t Mode;               // 0x06
        uint8_t Unknown0002;        // 0x07
        uint32_t NameConfigMask;    // 0x08
        uint32_t ChatFilterMask1;   // 0x0C
        uint32_t ChatFilterMask2;   // 0x10
        uint8_t Unknown0003[16];    // 0x14
        uint32_t Param;             // 0x24
    } packet_charconfig_c2s_t;

    // Packet: 0x00B4 - Char Config (Server To Client)
    typedef struct packet_charconfig_s2c_t {
        uint32_t Header;            // 0x00
        uint32_t NameConfigMask;    // 0x04
        uint32_t ChatFilterMask1;   // 0x08
        uint32_t ChatFilterMask2;   // 0x0C
        uint16_t LinkshellFlag;     // 0x10
        uint8_t AreaCode;           // 0x12
    } packet_charconfig_s2c_t;
]];

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
        { '/filters help', 'Displays the addons help information.' },
        { '/filters load <name>', 'Loads a set of previously saved filters.' },
        { '/filters save <name>', 'Saves the current set of filters to a file.' },
        { '/filters clear', 'Clears the current set filters to keep enforcing.' },
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
    -- Find the needed mask information for the character config packets..
    filters.ptr = ffi.cast('uint32_t**', ashita.memory.find('FFXiMain.dll', 0, 'C3C74004000000008B0D????????81C1', 0x0A, 0));
    if (filters.ptr == nil) then
        error(chat.header('filters'):append(chat.error('Error: Failed to locate required data pointer.')));
    end
    filters.offset = ffi.cast('uint32_t*', ffi.cast('uint8_t*', filters.ptr) + 0x06);
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/filters')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /filters help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /filters load <name> - Loads a set of previously saved filters.
    if (#args >= 3 and args[2]:any('load')) then
        local name = args:concat(' ', 3);
        if (not name:endswith('.txt')) then
            name = name:append('.txt');
        end

        -- Build a path to the file and ensure it exists..
        local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'filters', name);
        if (not ashita.fs.exists(path)) then
            print(chat.header('filters'):append(chat.error('Failed to load filters file; file does not exist.')));
            return;
        end

        -- Load the filter settings..
        local t = T{ };
        local status, err = pcall(function ()
            t = loadfile(path)();
        end);

        -- Ensure the file is valid..
        if (not status or err or t['n'] == nil or t['c1'] == nil or t['c2'] == nil) then
            print(chat.header('filters'):append(chat.error('Failed to load filters file; file is not a valid format.')));
            return;
        end

        -- Store these values for later use..
        filters.current = t;

        -- Ensure the needed data pointer is loaded..
        if (filters.ptr[0][0] ~= 0) then
            -- Update the memory data..
            local data = ffi.cast('uint32_t*', filters.ptr[0][0] + filters.offset[0]);
            data[0] = t['n'];
            data[1] = t['c1'];
            data[2] = t['c2'];

            -- Build and inject an incoming config packet..
            local cfg = ffi.new('packet_charconfig_s2c_t', { 0x00000CB4, t['n'], t['c1'], t['c2'], 0, 2, });
            local packet = ffi.string(cfg, ffi.sizeof('packet_charconfig_s2c_t')):totable();
            AshitaCore:GetPacketManager():AddIncomingPacket(0xB4, packet);
        end

        print(chat.header('filters'):append(chat.message('Loaded filter set: ')):append(chat.success(name)));
        return;
    end

    -- Handle: /filters save <name> - Saves the current set of filters to a file.
    if (#args >= 3 and args[2]:any('save')) then
        -- Ensure the needed data pointer is loaded..
        if (filters.ptr[0][0] == 0) then
            print(chat.header('filters'):append(chat.error('Failed to save filters file; data pointer is invalid')));
            return;
        end

        local name = args:concat(' ', 3);
        if (not name:endswith('.txt')) then
            name = name:append('.txt');
        end

        -- Build a path to the file..
        local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'filters', name);

        -- Serialize the filter data..
        local data = ffi.cast('uint32_t*', filters.ptr[0][0] + filters.offset[0]);
        local t = T{ n = data[0], c1 = data[1], c2 = data[2], };
        local p, s = settings.process(t, 'settings');

        -- Open and save the new list..
        local f = io.open(path, 'w+');
        if (f == nil) then
            return false;
        end

        f:write('require(\'common\');\n\n');
        f:write('local settings = T{ };\n');
        p:each(function (v) f:write(('%s = T{ };\n'):fmt(v)); end);
        f:write(s);
        f:write('\nreturn settings;\n');
        f:close();

        print(chat.header('filters'):append(chat.message('Saved filter set: ')):append(chat.success(name)));
        return;
    end

    -- Handle: /filters clear - Clears the current set filters to keep enforcing.
    if (#args >= 2 and args[2]:any('clear')) then
        print(chat.header('filters'):append(chat.message('Cleared current filter set.')));
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
    if (e.blocked) then return; end
    if (filters.current == nil) then return; end;

    -- Packet: Char Config
    if (e.id == 0x00B4 and not e.injected) then
        local packet = ffi.cast('packet_charconfig_s2c_t*', e.data_modified_raw);
        packet.NameConfigMask   = filters.current['n'];
        packet.ChatFilterMask1  = filters.current['c1'];
        packet.ChatFilterMask2  = filters.current['c2'];
    end
end);

--[[
* event: packet_out
* desc : Event called when the addon is processing outgoing packets.
--]]
ashita.events.register('packet_out', 'packet_out_cb', function (e)
    if (e.blocked) then return; end
    if (filters.current == nil) then return; end;

    -- Packet: Char Config
    if (e.id == 0x00DB and not e.injected) then
        local packet = ffi.cast('packet_charconfig_c2s_t*', e.data_modified_raw);
        packet.NameConfigMask   = filters.current['n'];
        packet.ChatFilterMask1  = filters.current['c1'];
        packet.ChatFilterMask2  = filters.current['c2'];
    end
end);