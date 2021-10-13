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

addon.name      = 'logincmd';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Executes a per-character script when logging in, or switching characters.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- LoginCmd Variables
local logincmd = T{
    name = nil,
};

--[[
* Executes a Lua file, but in a protected environment.
*
* @param {string} path - The file path to execute.
--]]
local function protected_dofile(path)
    local status, err = pcall(function ()
        local func = loadfile(path);
        if (func) then
            func();
        else
            error('Loaded file failed to return an executable function.');
        end
    end);

    if (not status) then
        print(chat.header(addon.name):append(chat.message('Failed to execute current player profile due to error:')));
        print(chat.header(addon.name):append(chat.error(err)));
    end
end

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Zone Enter
    if (e.id == 0x000A) then
        -- Obtain the character name from the packet..
        local name = struct.unpack('s', e.data_modified, 0x84 + 0x01);
        if (logincmd.name ~= name) then
            logincmd.name = name;
            local path = ('%s\\profiles\\%s.lua'):fmt(addon.path, name);
            if (ashita.fs.exists(path)) then
                protected_dofile(path);
            end
        end
        return;
    end

    -- Packet: Zone Exit
    if (e.id == 0x000B) then
        if (struct.unpack('b', e.data_modified, 0x04 + 0x01) == 1) then
            logincmd.name = nil;
        end
        return;
    end
end);