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

addon.name      = 'skeletonkey';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Enables the ability to force closed doors open.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- Skeletonkey Variables
local skeletonkey = {
    enabled = false,
};

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/skeletonkey', '/sk')) then
        return;
    end

    -- Block all distance related commands..
    e.blocked = true;

    -- Toggle the skeletonkey feature..
    skeletonkey.enabled = not skeletonkey.enabled;
    print(chat.header(addon.name):append(chat.message('Skeleton key mode is now: ')):append(chat.success(skeletonkey.enabled and 'Enabled' or 'Disabled')));
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (not skeletonkey.enabled) then return; end

    local target = GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(0));
    if (target ~= nil) then
        if (bit.band(target.SpawnFlags, 0x20) == 0x20) then
            target.StatusServer = 0x08;
        end
    end
end);