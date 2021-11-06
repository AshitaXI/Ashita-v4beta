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

require('common');

-- Ruleset Variables
local ruleset = T{
    name = 'skillup',
    desc = 'Plays a sound file when the local player gets a skillup.',
    event = 'packet_in',

    -- Ruleset Settings
    settings = T{
        skillup = T{
            enabled = true,
            delay = 10,
            sound = 'skillup.wav',
        },
    },

    -- Local Ruleset Variables
    timeout_skillup = 0,
};

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ruleset.callback = function (e)
    -- Packet: Message (Basic)
    if (e.id == 0x0029) then
        -- Ensure the packet contains a skillup message id..
        local mid = struct.unpack('H', e.data_modified, 0x18 + 1);
        if (not T{ 38, 53, }:contains(mid)) then
            return;
        end

        -- Ensure skillup alerts are enabled..
        if (not chatmon.settings.skillup.skillup.enabled) then
            return;
        end

        -- Ensure the repeat delay has passed..
        if ((os.time() - ruleset.timeout_skillup) < chatmon.settings.skillup.skillup.delay) then
            return;
        end

        -- Update the delay time..
        ruleset.timeout_skillup = os.time();

        -- Play the alert..
        ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.skillup.skillup.sound));
    end
end

--[[
* Renders the elements to allow this rulesets configurations to be edited inside of ChatMon's UI.
*
* @return {boolean} True if a setting was changed, false otherwise.
--]]
ruleset.ui = function ()
    local updated = false;

    -- Create a temp copy of the settings usable with ImGui..
    local s = T{
        enabled = T{ chatmon.settings.skillup.skillup.enabled, },
        delay = T{ chatmon.settings.skillup.skillup.delay, },
        sound = T{ chatmon.settings.skillup.skillup.sound, },
    };

    -- Render the ruleset editor..
    if (imgui.Checkbox('Enabled?', s.enabled)) then
        chatmon.settings.skillup.skillup.enabled = s.enabled[1];
        updated = true;
    end
    if (imgui.InputInt('Delay', s.delay)) then
        chatmon.settings.skillup.skillup.delay = s.delay[1];
        updated = true;
    end
    if (imgui.InputText('Sound File', s.sound, 256)) then
        chatmon.settings.skillup.skillup.sound = s.sound[1];
        updated = true;
    end

    return updated;
end

-- Return the ruleset..
return ruleset;