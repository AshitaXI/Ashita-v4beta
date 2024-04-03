--[[
* Addons - Copyright (c) 2024 Ashita Development Team
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

addon.name      = 'casper';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Remove collision with other players; walk through them like a ghost.';
addon.link      = 'https://ashitaxi.com/';

require 'common';

ashita.events.register('packet_in', 'packet_in', function (e)
    if (e.id ~= 0x000D) then return; end
    local ent = GetEntity(struct.unpack('H', e.data_modified, 0x08 + 1));
    if (ent ~= nil) then
        ent.Render.Flags0 = bit.bor(ent.Render.Flags0, 0x40);
    end
end);