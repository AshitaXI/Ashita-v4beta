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

addon.name      = 'trimspells';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Changes the CTRL+M shortcut spell list to be trimmed to known spells.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat  = require('chat');
local ffi   = require('ffi');

local trimspells = T{
    patch   = { ptr = 0, backup = nil, },
    gc      = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    local ptr = ashita.memory.find('FFXiMain.dll', 0, '68000100006A016A00E8????????83C40CB801000000C3', 0, 0);
    if (ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required function pointer.')));
        return;
    end

    trimspells.patch.ptr    = ptr;
    trimspells.patch.backup = ashita.memory.read_array(ptr, 9);

    ashita.memory.write_array(ptr, { 0x68, 0x00, 0x01, 0x00, 0x00, 0x6A, 0x00, });
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
trimspells.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (trimspells.patch.ptr ~= 0) then
        ashita.memory.write_array(trimspells.patch.ptr, trimspells.patch.backup);
        trimspells.patch.ptr = 0;
    end
end);