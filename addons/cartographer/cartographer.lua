--[[
* Addons - Copyright (c) 2024 Ashita Development Team
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

addon.name      = 'cartographer';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables the ability to see every map in the map menus when trying to view non-current zone maps.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat  = require('chat');
local ffi   = require('ffi');

local cartographer = T{
    patch1 = { ptr = 0, backup = nil, },
    patch2 = { ptr = 0, backup = nil, },
    patch3 = { ptr = 0, backup = nil, },
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    local ptr1 = ashita.memory.find('FFXiMain.dll', 0, '74??576A14E8????????83C40885C074??FF44240C83C302', 0, 0);
    if (ptr1 == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required map function pointer. (1)')));
        return;
    end
    local ptr2 = ashita.memory.find('FFXiMain.dll', 0, '0F??????????576A14E8????????83C4088944242885C00F', 0, 0);
    if (ptr2 == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required map function pointer. (2)')));
        return;
    end
    local ptr3 = ashita.memory.find('FFXiMain.dll', 0, '0F??????????556A14E8????????83C40885C00F', 0, 0);
    if (ptr3 == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required map function pointer. (3)')));
        return;
    end

    cartographer.patch1.ptr = ptr1;
    cartographer.patch2.ptr = ptr2;
    cartographer.patch3.ptr = ptr3;

    cartographer.patch1.backup = ashita.memory.read_array(ptr1, 2);
    cartographer.patch2.backup = ashita.memory.read_array(ptr2, 6);
    cartographer.patch3.backup = ashita.memory.read_array(ptr3, 6);

    ashita.memory.write_array(ptr1, { 0x90, 0x90 });
    ashita.memory.write_array(ptr2, { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 });
    ashita.memory.write_array(ptr3, { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 });
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
cartographer.gc = ffi.new('uint8_t*');
ffi.gc(cartographer.gc, function ()
    if (cartographer.patch1.ptr ~= 0) then
        ashita.memory.write_array(cartographer.patch1.ptr, cartographer.patch1.backup);
    end
    if (cartographer.patch2.ptr ~= 0) then
        ashita.memory.write_array(cartographer.patch2.ptr, cartographer.patch2.backup);
    end
    if (cartographer.patch3.ptr ~= 0) then
        ashita.memory.write_array(cartographer.patch3.ptr, cartographer.patch3.backup);
    end

    cartographer.patch1.ptr = 0;
    cartographer.patch2.ptr = 0;
    cartographer.patch3.ptr = 0;
end);