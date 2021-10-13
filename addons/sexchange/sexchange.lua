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

addon.name      = 'sexchange';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Allows changing the players race and hair style with commands.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- SexChange Variables
local sexchange = T{
    enabled = false,
    hair = 2,
    race = 5,
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
        { '/sexchange', 'Toggles sexchange on and off.' },
        { '/sexchange help', 'Displays the addons help information.' },
        { '/sexchange (disable | off)', 'Turns sexchange off.' },
        { '/sexchange (enable | on)', 'Turns sexchange on.' },
        { '/sexchange hair <id>', 'Sets the hair type to apply to the player.' },
        { '/sexchange race <id>', 'Sets the race type to apply to the player.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/sexchange') then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /sexchange - Toggle sexchange on and off.
    if (#args == 1) then
        sexchange.enabled = not sexchange.enabled;
        print(chat.header(addon.name):append(chat.message('Sexchange is now: ')):append(chat.success(sexchange.enabled and 'Enabled' or 'Disabled')));
        return;
    end

    -- Handle: /sexchange help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /sexchange (disable | off) - Turns off sexchange.
    if (#args == 2 and args[2]:any('disable', 'off')) then
        sexchange.enabled = false;
        print(chat.header(addon.name):append(chat.message('Sexchange is now: ')):append(chat.success('Disabled')));
        return;
    end

    -- Handle: /sexchange (enable | on) - Turns on sexchange.
    if (#args == 2 and args[2]:any('enable', 'on')) then
        sexchange.enabled = true;
        print(chat.header(addon.name):append(chat.message('Sexchange is now: ')):append(chat.success('Enabled')));
        return;
    end

    -- Handle: /sexchange hair <id> - Sets the players hair type.
    if (#args == 3 and args[2]:any('hair')) then
        sexchange.hair = args[3]:number_or(2);
        print(chat.header(addon.name):append(chat.message('Sexchange hair override set to: '):append(chat.success('%d'):fmt(sexchange.hair))));

        -- Force-update the player model..
        if (sexchange.enabled) then
            local player = GetPlayerEntity();
            if (player ~= nil) then
                player.Look.Hair = sexchange.hair;
                player.ModelUpdateFlags = 0x10;
            end
        end

        return;
    end

    -- Handle: /sexchange race <id> - Sets the players race type.
    if (#args == 3 and args[2]:any('race')) then
        sexchange.race = args[3]:number_or(5);
        print(chat.header(addon.name):append(chat.message('Sexchange race override set to: '):append(chat.success('%d'):fmt(sexchange.race))));

        -- Force-update the player model..
        if (sexchange.enabled) then
            local player = GetPlayerEntity();
            if (player ~= nil) then
                player.Race = sexchange.race;
                player.ModelUpdateFlags = 0x10;
            end
        end

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
    if (e.blocked or not sexchange.enabled) then
        return;
    end

    -- Packet: Zone Enter
    if (e.id == 0x000A) then
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        p[0x44] = sexchange.hair;
        p[0x45] = sexchange.race;
    end

    -- Packet: Character Update
    if (e.id == 0x000D) then
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        local i = struct.unpack('L', e.data_modified, 0x04 + 0x1);
        if (i == AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0) and p[0x0A] == 0x1F) then
            p[0x48] = sexchange.hair;
            p[0x49] = sexchange.race;
        end
    end

    -- Packet: Character Jobs
    if (e.id == 0x001B) then
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        p[0x04] = sexchange.race;
    end

    -- Packet: Character Appearance
    if (e.id == 0x0051) then
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        p[0x04] = sexchange.hair;
        p[0x05] = sexchange.race;
    end
end);