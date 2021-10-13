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

addon.name      = 'singlerace';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables changing all player and npc models to a single race/hair style. (One of us....)';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- SingleRace Variables
local singlerace = T{
    npc = false,
    pc = false,
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
        { '/singlerace help', 'Displays the addons help information.' },
        { '/singlerace npc', 'Toggles npc overriding.' },
        { '/singlerace npc (disable | off)', 'Disables npc overriding.' },
        { '/singlerace npc (enable | on)', 'Enables npc overriding.' },
        { '/singlerace pc', 'Toggles pc overriding.' },
        { '/singlerace pc (disable | off)', 'Disables pc overriding.' },
        { '/singlerace pc (enable | on)', 'Enables pc overriding.' },
        { '/singlerace hair <id>', 'Sets the hair type to apply.' },
        { '/singlerace race <id>', 'Sets the race type to apply.' },
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
    if (#args == 0 or args[1] ~= '/singlerace') then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /singlerace help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /singlerace npc - Toggles npc overriding.
    if (#args == 2 and args[2]:any('npc')) then
        singlerace.npc = not singlerace.npc;
        print(chat.header(addon.name):append(chat.message('NPC overriding is now: ')):append(chat.success(singlerace.npc and 'Enabled' or 'Disabled')));
        return;
    end

    -- Handle: /singlerace npc (disable | off) - Disables npc overriding.
    if (#args == 3 and args[2] == 'npc' and args[3]:any('disable', 'off')) then
        singlerace.npc = false;
        print(chat.header(addon.name):append(chat.message('NPC overriding is now: ')):append(chat.success('Disabled')));
        return;
    end

    -- Handle: /singlerace npc (enable | on) - Enables npc overriding.
    if (#args == 3 and args[2] == 'npc' and args[3]:any('enable', 'on')) then
        singlerace.npc = true;
        print(chat.header(addon.name):append(chat.message('NPC overriding is now: ')):append(chat.success('Enabled')));
        return;
    end

    -- Handle: /singlerace pc - Toggles pc overriding.
    if (#args == 2 and args[2]:any('pc')) then
        singlerace.pc = not singlerace.pc;
        print(chat.header(addon.name):append(chat.message('PC overriding is now: ')):append(chat.success(singlerace.pc and 'Enabled' or 'Disabled')));
        return;
    end

    -- Handle: /singlerace pc (disable | off) - Disables pc overriding.
    if (#args == 3 and args[2] == 'pc' and args[3]:any('disable', 'off')) then
        singlerace.pc = false;
        print(chat.header(addon.name):append(chat.message('PC overriding is now: ')):append(chat.success('Disabled')));
        return;
    end

    -- Handle: /singlerace pc (enable | on) - Enables pc overriding.
    if (#args == 3 and args[2] == 'pc' and args[3]:any('enable', 'on')) then
        singlerace.pc = true;
        print(chat.header(addon.name):append(chat.message('PC overriding is now: ')):append(chat.success('Enabled')));
        return;
    end

    -- Handle: /singlerace hair <id> - Sets the override hair type.
    if (#args == 3 and args[2]:any('hair')) then
        singlerace.hair = args[3]:number_or(2);
        print(chat.header(addon.name):append(chat.message('Hair override set to: '):append(chat.success('%d'):fmt(singlerace.hair))));
        return;
    end

    -- Handle: /singlerace race <id> - Sets the override race type.
    if (#args == 3 and args[2]:any('race')) then
        singlerace.race = args[3]:number_or(5);
        print(chat.header(addon.name):append(chat.message('Race override set to: '):append(chat.success('%d'):fmt(singlerace.race))));
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
    if (e.blocked) then
        return;
    end

    -- Packet: Player Update
    if (e.id == 0x000D and singlerace.pc) then
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        if (p[0x0A] == 0x1F) then
            p[0x48] = singlerace.hair;
            p[0x49] = singlerace.race;
        end
    end

    -- Packet: Entity Update
    if (e.id == 0x000E and singlerace.npc) then
        --[[
        * Note: This does not work on all NPCs. Some are specifically modeled and will break if you change their information and cause them
        *       to not spawn. To avoid potentially causing NPCs to be missing; we ignore those specifically.
        --]]
        local p = ffi.cast('uint8_t*', e.data_modified_raw);
        if ((p[0x0A] == 0x0F or p[0x0A] == 0x57) and p[0x1F] ~= 0x09 and p[0x30] == 1) then
            p[0x32] = singlerace.hair;
            p[0x33] = singlerace.race;
        end
    end
end);