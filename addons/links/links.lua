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

addon.name      = 'links';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Captures urls from the various text of the game and adds them to a ui window.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local imgui = require('imgui');

-- Links Variables
local links = {
    urls = T{ },
    is_open = { true, },
};

--[[
* Parses a string for urls.
*
* @param {string} msg - The message to look for urls within.
--]]
local function parse_urls(msg)
    if (msg == nil) then
        return;
    end

    -- Parse the message for urls via regular expressions..
    local m = ashita.regex.search(msg, '((http(s)?:\\/\\/.)?(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&\\/\\/=]*))');
    if (m ~= nil) then
        T(m):each(function (v)
            if (not links.urls:hasval(v[1])) then
                links.urls:append(v[1]);
            end
        end);
    end
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/links')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Toggle the links window..
    links.is_open[1] = not links.is_open[1];
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    local msg = nil;

    -- Packet: Chat
    if (e.id == 0x0017) then
        msg, _ = struct.unpack('s', e.data_modified, 0x17 + 0x01);
    end

    -- Packet: Server Message
    if (e.id == 0x004D) then
        local s = math.clamp(struct.unpack('L', e.data_modified, 0x14 + 0x01), 1, e.size - 0x18);
        msg, _ = struct.unpack('c' .. s, e.data_modified, 0x18 + 0x01);
    end

    -- Packet: Bazaar Message
    if (e.id == 0x00CA) then
        msg, _ = struct.unpack('s', e.data_modified, 0x04 + 0x01);
    end

    -- Packet: Linkshell Message
    if (e.id == 0x00CC) then
        msg, _ = struct.unpack('s', e.data_modified, 0x08 + 0x01);
    end

    -- Parse any urls if a message was found..
    if (msg ~= nil) then
        parse_urls(msg);
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (links.is_open[1]) then
        imgui.SetNextWindowSize({ 400, 200, }, ImGuiCond_FirstUseEver);
        if (imgui.Begin('Links', links.is_open)) then
            if (imgui.Button('Clear List')) then
                links.urls:clear();
            end
            imgui.Separator();
            links.urls:each(function (v, k)
                if (imgui.Button(('%s##%s'):fmt(v, k))) then
                    ashita.misc.open_url(v);
                end
            end);
        end
        imgui.End();
    end
end);