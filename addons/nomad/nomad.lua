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

addon.name      = 'nomad';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables mog house functionality in any zone.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- Nomad Variables
local nomad = T{
    ptr_1 = 0, -- Mog House Check
    ptr_2 = 0, -- Zone Flag Function
    ptr_3 = 0, -- Zone Information Base
    off_1 = 0, -- Zone Flags
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Obtain the required pointers..
    nomad.ptr_1 = ashita.memory.find('FFXiMain.dll', 0, '0544FE00000FBF2925FFFF00003BC5????4283C10283FA04', 0x00, 0x00);
    nomad.ptr_2 = ashita.memory.find('FFXiMain.dll', 0, '8B8C24040100008B90????????0BD18990????????8B15????????8B82', 0x00, 0x00);

    -- Validate the base pointers were found..
    if (nomad.ptr_1 == 0 or nomad.ptr_2 == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer(s).')));
        return;
    end

    -- Obtain the required values from the second pointer..
    nomad.ptr_3 = ashita.memory.read_uint32(nomad.ptr_2 + 0x17);
    nomad.off_1 = ashita.memory.read_uint32(nomad.ptr_2 + 0x09);

    -- Validate the offsets were found..
    if (nomad.ptr_3 == 0 or nomad.off_1 == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to read required values(s).')));
        return;
    end
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command args..
    local args = e.command:args();

    -- Handle: /nomad
    if (#args >= 1 and args[1]:ieq('/nomad')) then
        e.blocked = true;

        -- Handle: /nomad on
        if (#args >= 2 and args[2]:ieq('on')) then
            -- Read the zone information pointer..
            local pointer = ashita.memory.read_uint32(nomad.ptr_3);
            if (pointer == 0 or nomad.ptr_1 == 0) then
                error(chat.header(addon.name):append(chat.error('Error: Invalid pointer information; cannot set nomad mode.')));
                return;
            end

            -- Alter the zone flags for mog house usage..
            local flags = ashita.memory.read_uint32(pointer + nomad.off_1);
            if (bit.band(flags, 0x0100) == 0) then
                ashita.memory.write_uint32(pointer + nomad.off_1, bit.bor(flags, 0x0100));
            end

            -- Alter the mog house check..
            ashita.memory.write_uint8(nomad.ptr_1 + 0x0F, 0xEB);

            print(chat.header(addon.name):append(chat.message('Nomad mode has been: ') + chat.success('Enabled')));
            print(chat.header(addon.name):append(chat.message('You can now access your mog house via the main menu.')));
            return;
        end

        -- Handle: /nomad off
        if (#args >= 2 and args[2]:ieq('off')) then
            -- Read the zone information pointer..
            local pointer = ashita.memory.read_uint32(nomad.ptr_3);
            if (pointer == 0 or nomad.ptr_1 == 0) then
                error(chat.header(addon.name):append(chat.error('Error: Invalid pointer information; cannot set nomad mode.')));
                return;
            end

            -- Alter the zone flags for mog house usage..
            local flags = ashita.memory.read_uint32(pointer + nomad.off_1);
            if (bit.band(flags, 0x0100) == 0x0100) then
                ashita.memory.write_uint32(pointer + nomad.off_1, bit.band(flags, bit.bnot(0x0100)));
            end

            -- Alter the mog house check..
            ashita.memory.write_uint8(nomad.ptr_1 + 0x0F, 0x74);

            print(chat.header(addon.name):append(chat.message('Nomad mode has been: ') + chat.success('Disabled')));
            return;
        end

        return;
    end
end);

-- Memory patching cleanup when addon is unloaded..
nomad.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    -- Validate a pointer was found..
    if (nomad.ptr_1 == 0) then
        return;
    end

    -- Check if the patch is currently applied..
    local jmp = ashita.memory.read_uint8(nomad.ptr_1 + 0x0F);
    if (jmp == 0xEB) then
        ashita.memory.write_uint8(nomad.ptr_1 + 0x0F, 0x74);

        -- Unset the zone flags..
        local ptr = ashita.memory.read_uint32(nomad.ptr_3);
        if (ptr ~= 0) then
            local flags = ashita.memory.read_uint32(ptr + nomad.off_1);
            if (bit.band(flags, 0x0100) == 0x0100) then
                ashita.memory.write_uint32(ptr + nomad.off_1, bit.band(flags, bit.bnot(0x0100)));
            end
        end
    end
end);