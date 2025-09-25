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

addon.name      = 'ahcolors';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Changes the auction house listing colors to be easier to see.';
addon.link      = 'https://ashitaxi.com/';

require 'common';

local chat  = require 'chat';
local ffi   = require 'ffi';

local ahcolors = T{
    gc = nil,
    ptrs = T{
        [1] = T{ n = 'learned',     color = 0xFF00FF00, backup = 0, ptr = 0, off = 0x01, pattern = 'BD509050808B96????????8B8C24????????5552' },
        [2] = T{ n = 'learnable',   color = 0xFFFFFF00, backup = 0, ptr = 0, off = 0x01, pattern = 'BD40909080EB??8B86????????85C074' },
        [3] = T{ n = 'unlearnable', color = 0xFF333333, backup = 0, ptr = 0, off = 0x07, pattern = '8B86????????BD8080808085C074??6683380074' },
    },
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    ahcolors.ptrs:ieach(function (v)
        local ptr = ashita.memory.find(0, 0, v.pattern, v.off, 0);
        if (ptr == 0) then
            error(chat.header(addon.name):append(chat.error('Error: Failed to locate a required pointer.')));
        end

        -- Backup the pointer and current value..
        v.ptr = ptr;
        v.backup = ashita.memory.read_uint32(v.ptr);

        -- Update the color..
        ashita.memory.write_uint32(v.ptr, v.color);
    end);
end);

-- Cleanup the memory edits when addon is unloaded..
ahcolors.gc = ffi.new('uint8_t*');
ffi.gc(ahcolors.gc, function ()
    ahcolors.ptrs:ieach(function (v)
        if (v.ptr ~= 0 and v.backup ~= nil) then
            ashita.memory.write_uint32(v.ptr, v.backup);
        end
        v.ptr = 0;
        v.backup = nil;
    end);
end);