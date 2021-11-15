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

addon.name      = 'debuff';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables cancelling status effects via a command.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError, cmd)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success(cmd)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { cmd:append(' help'), 'Displays the addons help information.' },
        { cmd:append(' <id>'), 'Cancels a status effect via the command.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/cancel', '/debuff')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle invalid input..
    if (#args ~= 2) then
        print_help(true, args[1]);
        return;
    end

    -- Obtain the status id..
    local id = tonumber(args[2]);

    -- Handle name based attempts..
    if (id == nil) then
        local name = e.command:gsub('([/%w]+) ', '', 1):trim();

        for x = 0, 640 do
            local n = AshitaCore:GetResourceManager():GetString('buffs.names', x);
            if (n ~= nil and #n > 0) then
                if (n:icmp(name)) then
                    id = x;
                    break;
                end
            end
        end
    end

    -- Handle invalid status id/name..
    if (id == nil or id <= 0) then
        print(chat.header(addon.name):append(chat.error('Invalid id/status name given; cannot continue.')));
        return;
    end

    -- Inject the status cancel packet..
    local p = struct.pack("bbbbhbb", 0xF1, 0x04, 0x00, 0x00, id, 0x00, 0x00):totable();
    AshitaCore:GetPacketManager():AddOutgoingPacket(0xF1, p);
end);