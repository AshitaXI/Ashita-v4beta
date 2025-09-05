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

addon.name      = 'quicksets';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Removes the delay between equipping different equipment sets.';
addon.link      = 'https://ashitaxi.com/';

require 'common';
local chat  = require 'chat';
local ffi   = require 'ffi';

local quicksets = T{
    ptrs = T{
        ptr1 = ashita.memory.find('FFXiMain.dll', 0, '75??5E5B81C448010000C3', 0x00, 0x00),
        ptr2 = ashita.memory.find('FFXiMain.dll', 0, '75??8B4424145BF7D859C38B4424145B59C3', 0x00, 0x00),
        ptr3 = ashita.memory.find('FFXiMain.dll', 0, '6A006A006A51E8????????8BF883C40C', 0x03, 0x00),
    },
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    if (not quicksets.ptrs:all(function (v) return v ~= 0 and v ~= nil; end)) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer(s).')));
        return;
    end

    ashita.memory.write_array(quicksets.ptrs.ptr1, T{ 0xEB });
    ashita.memory.write_array(quicksets.ptrs.ptr2, T{ 0xEB });
    ashita.memory.write_array(quicksets.ptrs.ptr3, T{ 0x01 });

    print(chat.header(addon.name):append(chat.message('Function patched; equipset usage should now be instant.')));
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
quicksets.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (quicksets.ptrs.ptr1 ~= 0) then
        ashita.memory.write_array(quicksets.ptrs.ptr1, T{ 0x75 });
    end
    if (quicksets.ptrs.ptr2 ~= 0) then
        ashita.memory.write_array(quicksets.ptrs.ptr2, T{ 0x75 });
    end
    if (quicksets.ptrs.ptr3 ~= 0) then
        ashita.memory.write_array(quicksets.ptrs.ptr3, T{ 0x00 });
    end
    quicksets.ptrs.ptr1 = 0;
    quicksets.ptrs.ptr2 = 0;
    quicksets.ptrs.ptr3 = 0;
end);