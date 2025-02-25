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

addon.name      = 'paranormal';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Enables the use of [nearly] any game command while dead/unconscious.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- Paranormal Variables
local paranormal = T{
    cmds = T{ },
    ptr = 0,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the required pointer..
    paranormal.ptr = ashita.memory.find('FFXiMain.dll', 0, '88440C008A420141423C20????8D442400C6440C000050', 0x18, 0x00);
    if (paranormal.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end

    -- Read the command list..
    local start = ashita.memory.read_uint32(paranormal.ptr);
    local index = 1;
    while (true) do
        local cname = ashita.memory.read_string(start, 20);
        local cflag = ashita.memory.read_uint8(start + 0x16);

        -- Check for a forward-slash to ensure the command entry is valid..
        if (not cname:startswith('/')) then
            break;
        end

        -- Backup the command information..
        paranormal.cmds[index] = cflag;

        -- Modify the command flags to allow usage while dead..
        if (bit.band(cflag, 0x20) ~= 0x20) then
            ashita.memory.write_uint8(start + 0x16, bit.bor(cflag, 0x20));
        end

        -- Step to the next command..
        start = start + 0x18;
        index = index + 1;
    end

    print(chat.header(addon.name):append(chat.message('Functions patched; commands should be usable while dead/unconscious now.')));
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
paranormal.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (paranormal.ptr == 0) then
        return;
    end

    -- Restore the command flags..
    paranormal.cmds:each(function (v, k)
        local start = ashita.memory.read_uint32(paranormal.ptr);
        start = start + ((k - 1) * 0x18);
        ashita.memory.write_uint8(start + 0x16, v);
    end);

    paranormal.cmds:clear();
    paranormal.ptr = 0;
end);