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

addon.name      = 'noname';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Removes the local player name.';
addon.link      = 'https://ashitaxi.com/';

require 'common';

local chat = require 'chat';

-- noname Variables
local noname = T{
    ptr = 0,
    cave = 0,
    backup = nil,
};

--[[
* Returns the rel32 bytes for a jump or call ending at 'from' to 'to'.
--]]
local function rel32(from, to)
    local v = bit.tobit(to - from);
    return { bit.band(v, 0xFF), bit.band(bit.rshift(v, 8), 0xFF), bit.band(bit.rshift(v, 16), 0xFF), bit.band(bit.rshift(v, 24), 0xFF) };
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Locate the needed patterns..
    local ptr = ashita.memory.find(0, 0, 'A0????????84C0747A8B7E7033C0A0????????83F804776BFF2485????????F74778000000FF755B8B168BCEFF92CC0000005F5E81C418010000C3', 0, 0);
    local player = ashita.memory.find(0, 0, '66A1????????6685C0740E0FBFC08B0485????????85C0750233C0C3', 0, 0);
    if (ptr == 0 or player == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate a required pointer.')));
        return;
    end

    -- Backup the patch data..
    local backup = ashita.memory.read_array(ptr, 9);

    -- Create the cave..
    local cave = ashita.memory.alloc(64);
    ashita.memory.unprotect(cave, 64);

    local a = rel32(cave + 0x06, player);
    local b = rel32(cave + 0x15, ptr + 0x28);
    local c = rel32(cave + 0x23, ptr + 0x83);
    local d = rel32(cave + 0x28, ptr + 0x09);
    ashita.memory.write_array(cave, {
        0x50,                                   -- push eax
        0xE8, a[1], a[2], a[3], a[4],           -- call GetPlayerEntity
        0x85, 0xC0,                             -- test eax, eax
        0x74, 0x0B,                             -- je original
        0x3B, 0x46, 0x70,                       -- cmp eax, [esi+0x70]
        0x75, 0x06,                             -- jne original
        0x58,                                   -- pop eax
        0xE9, b[1], b[2], b[3], b[4],           -- jmp hide name
        0x58,                                   -- original: pop eax
        backup[1], backup[2], backup[3], backup[4], backup[5], backup[6], backup[7],
        0x0F, 0x84, c[1], c[2], c[3], c[4],     -- je show name
        0xE9, d[1], d[2], d[3], d[4],           -- jmp back
    });

    -- Store the pointers..
    noname.ptr = ptr;
    noname.cave = cave;
    noname.backup = backup;

    -- Patch the name check to hide the local player name..
    local e = rel32(ptr + 0x05, cave);
    ashita.memory.write_array(ptr, { 0xE9, e[1], e[2], e[3], e[4], 0x90, 0x90, 0x90, 0x90, });
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    -- Restore the name check..
    if (noname.ptr ~= 0) then
        ashita.memory.write_array(noname.ptr, noname.backup);
        ashita.memory.dealloc(noname.cave);
    end
end);
