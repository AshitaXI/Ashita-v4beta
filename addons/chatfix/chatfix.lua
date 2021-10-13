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

addon.name      = 'chatfix';
addon.author    = 'atom0s & Thorny';
addon.version   = '1.0';
addon.desc      = 'Fixes private server chat issues related to a client update.';
addon.link      = 'https://ashitaxi.com/';

-- Enable jitting..
local ffi = require('ffi');
local jit = require('jit');
jit.on();

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    if (e.id ~= 0x0017) then return; end

    -- Create a temp buffer and copy the packet into it..
    local buff = ffi.new('uint8_t[?]', 512);
    ffi.copy(buff, e.data_modified_raw, 512);

    -- Check for the packet alignment..
    local flag = false;
    if (buff[e.size - 3] == 0 and buff[e.size - 2] == 0 and buff[e.size - 1] == 0) then
        flag = true;
        buff[1] = (e.size - 4) / 2;
    end

    -- Shift the packet data..
    local ptr = ffi.cast('uint8_t*', e.data_modified_raw);
    ffi.copy(buff + 23, ptr + 24, e.size - 24);
    if (flag) then buff[e.size - 1] = 0; end
    ffi.copy(e.data_modified_raw, buff, 512);

    -- Cleanup..
    buff = nil;
end);

--[[
* event: packet_out
* desc : Event called when the addon is processing outgoing packets.
--]]
ashita.events.register('packet_out', 'packet_out_cb', function (e)
    if (e.id ~= 0x00B6) then return; end

    -- Create a temp buffer and copy the packet into it..
    local buff = ffi.new('uint8_t[?]', 512);
    ffi.copy(buff, e.data_modified_raw, 512);

    -- Shift the packet data..
    local ptr = ffi.cast('uint8_t*', e.data_modified_raw);
    ffi.copy(buff + 5, ptr + 6, e.size - 6);
    ffi.copy(e.data_modified_raw, buff, 512);

    -- Cleanup..
    buff = nil;
end);