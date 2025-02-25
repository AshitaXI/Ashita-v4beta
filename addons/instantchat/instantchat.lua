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

addon.name      = 'instantchat';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Removes the delay from adding messages to the chat windows.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- instantchat Variables
local instantchat = {
    ptr = 0,
    gc = nil,
};

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Find the required pointer..
    instantchat.ptr = ashita.memory.find('FFXiMain.dll', 0, '8BF174??8B46340FBF4E5485C07D??894E34', 0x00, 0x00);
    if (instantchat.ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointer.')));
        return;
    end

    -- Patch the function..
    ashita.memory.write_array(instantchat.ptr + 0x1F, { 0x90, 0x90, 0x90 });
    print(chat.header(addon.name):append(chat.message('Function patched; new messages logged to chat should be instant.')));
end);

-- Create a cleanup object to restore the pointers when the addon is unloaded..
instantchat.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (instantchat.ptr ~= 0) then
        ashita.memory.write_array(instantchat.ptr + 0x1F, { 0x83, 0xC0, 0x14 });
    end
    instantchat.ptr = 0;
end);