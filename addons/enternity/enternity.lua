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

addon.name      = 'enternity';
addon.author    = 'Hypnotoad & atom0s';
addon.version   = '1.1';
addon.desc      = 'Removes the need to press enter through npc dialog and cutscenes.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- Enternity Variables
local enternity = T{
    ignored = T{
        -- Causes dialog freezes..
        'Geomantic Reservoir',

        -- Requires specific timing..
        'Paintbrush of Souls',
        'Stone Picture Frame',
    },
    skip = false,
};

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/enternity help', 'Displays the addons help information.' },
        { '/enternity skip', 'Toggles automatically skipping lines with items.' },
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
    if (#args == 0 or args[1] ~= '/enternity') then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /enternity help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /enternity skip - Toggles skipping lines with items automatically.
    if (#args == 2 and args[2]:any('skip')) then
        enternity.skip = not enternity.skip;
        print(chat.header(addon.name):append(chat.message('Skip status is now: ')):append(chat.success(enternity.skip and 'Enabled' or 'Disabled')));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ashita.events.register('text_in', 'text_in_cb', function (e)
    if (e.blocked) then
        return;
    end
    -- Obtain the message mode..
    local mid = bit.band(e.mode_modified, 0x000000FF);

    -- Look for messages to modify..
    if ((mid == 150 or mid == 151) and not (not enternity.skip and e.message_modified:match(string.char(0x1E, 0x02)))) then
        local target = GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(0));
        if not (target ~= nil and enternity.ignored:hasval(target.Name)) then
            e.message_modified = e.message_modified:gsub(string.char(0x7F, 0x31), '');
        end
    end
end);
