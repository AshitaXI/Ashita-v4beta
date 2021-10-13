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

addon.name      = 'logs';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Logs all text that goes through the chat log to a file.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- Logs Variables
local logs = T{
    name = nil,
};

--[[
* Returns a string cleaned from FFXI specific tags and special characters.
*
* @param {string} str - The string to clean.
* @return {string} The cleaned string.
--]]
local function clean_str(str)
    -- Parse the strings auto-translate tags..
    str = AshitaCore:GetChatManager():ParseAutoTranslate(str, true);

    -- Strip FFXI-specific color and translate tags..
    str = str:strip_colors();
    str = str:strip_translate(true);

    -- Strip line breaks..
    while (true) do
        local hasN = str:endswith('\n');
        local hasR = str:endswith('\r');

        if (not hasN and not hasR) then
            break;
        end

        if (hasN) then str = str:trimend('\n'); end
        if (hasR) then str = str:trimend('\r'); end
    end

    -- Replace mid-linebreaks..
    return (str:gsub(string.char(0x07), '\n'));
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    local name = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    if (name ~= nil and name:len() > 0) then
        logs.name = name;
    end
end);

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ashita.events.register('text_in', 'text_in_cb', function (e)
    -- Validate if the message can be logged..
    if (logs.name == nil or e.message_modified:len() == 0) then
        return;
    end

    -- Prepare the file path..
    local d = os.date('*t');
    local n = ('%s_%.4u.%.2u.%.2u.log'):fmt(logs.name, d.year, d.month, d.day);
    local p = ('%s/%s/'):fmt(AshitaCore:GetInstallPath(), 'chatlogs');

    -- Create the chatlogs folder if required..
    if (not ashita.fs.exists(p)) then
        ashita.fs.create_dir(p);
    end

    -- Append the chat line to the file..
    local f = io.open(('%s/%s'):fmt(p, n), 'a');
    if (f ~= nil) then
        local t = os.date('[%H:%M:%S]', os.time());
        f:write(t .. ' ' .. clean_str(e.message_modified) .. '\n');
        f:close();
    end
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Zone Enter
    if (e.id == 0x000A) then
        local name = struct.unpack('s', e.data_modified, 0x84 + 0x01);
        if (logs.name ~= name) then
            logs.name = name;
        end
        return;
    end

    -- Packet: Zone Exit
    if (e.id == 0x000B) then
        if (struct.unpack('b', e.data_modified, 0x04 + 0x01) == 1) then
            logs.name = nil;
        end
        return;
    end
end);