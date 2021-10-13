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
addon.version   = '1.0';
addon.desc      = 'Removes the need to press enter through npc dialog and cutscenes.';
addon.link      = 'https://ashitaxi.com/';

require('common');

-- Enternity Variables
local enternity = T{
    ignored = T{
        -- Causes dialog freezes..
        'Geomantic Reservoir',

        -- Requires specific timing..
        'Paintbrush of Souls',
        'Stone Picture Frame',
    }
};

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
    if ((mid == 150 or mid == 151) and not e.message_modified:match(string.char(0x1E, 0x02))) then
        local target = GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(0));
        if not (target ~= nil and enternity.ignored:hasval(target.Name)) then
            e.message_modified = e.message_modified:gsub(string.char(0x7F, 0x31), '');
        end
    end
end);