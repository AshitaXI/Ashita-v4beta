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

addon.name      = 'tokens';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Extends the parsable tokens in the chatlog.';
addon.link      = 'https://ashitaxi.com/';

require('common');

-- tokens Variables
local tokens = require('replacements');

--[[
* event: text_out
* desc : Event called when the addon is processing outgoing text.
--]]
ashita.events.register('text_out', 'text_out_cb', function (e)
    if (e.blocked) then
        return;
    end

    -- Replace found tokens..
    e.message_modified = e.message_modified:gsub('%%[^ ]+%%', function (m)
        local t = m:sub(2):sub(0, -2);
        local f = tokens[t];

        return f ~= nil and f() or m;
    end);
end);