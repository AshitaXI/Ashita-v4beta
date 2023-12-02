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
    name = 'incoming_trade',
    desc = 'Plays a sound file when the local player is traded.',
    event = 'packet_in',

    -- Ruleset Settings
    settings = T{
        incoming_trade = T{
            enabled = true,
            delay = 5,
            sound = 'incoming_trade.wav',
        },
    },

    -- Local Ruleset Variables
    timeout_traded = 0,
};

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ruleset.callback = function (e)
    -- Packet: Trade Request
    if (e.id == 0x0021) then

        -- Ensure alerts are enabled..
        if (not chatmon.settings.incoming_trade.incoming_trade.enabled) then
            return;
        end

        -- Ensure the repeat delay has passed..
        if ((os.time() - ruleset.timeout_traded) < chatmon.settings.incoming_trade.incoming_trade.delay) then
            return;
        end

        -- Update the delay time..
        ruleset.timeout_traded = os.time();

        -- Play the alert..
        ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.incoming_trade.incoming_trade.sound));
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
        enabled = T{ chatmon.settings.incoming_trade.incoming_trade.enabled, },
        delay = T{ chatmon.settings.incoming_trade.incoming_trade.delay, },
        sound = T{ chatmon.settings.incoming_trade.incoming_trade.sound, },
    };

    -- Render the ruleset editor..
    if (imgui.Checkbox('Enabled?', s.enabled)) then
        chatmon.settings.incoming_trade.incoming_trade.enabled = s.enabled[1];
        updated = true;
    end
    if (imgui.InputInt('Delay', s.delay)) then
        chatmon.settings.incoming_trade.incoming_trade.delay = s.delay[1];
        updated = true;
    end
    if (imgui.InputText('Sound File', s.sound, 256)) then
        chatmon.settings.incoming_trade.incoming_trade.sound = s.sound[1];
        updated = true;
    end

    return updated;
end

-- Return the ruleset..
return ruleset;
