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
    name = 'incoming_tell',
    desc = 'Plays a sound file when the player receives an incoming tell.',
    event = 'packet_in',

    -- Ruleset Settings
    settings = T{
        gm = T{
            enabled = true,
            delay = 5,
            sound = 'incoming_tell_gm.wav',
        },
        player = T{
            enabled = true,
            delay = 15,
            sound = 'incoming_tell_player.wav',
        },
    },

    -- Local Ruleset Variables
    timeout_gm = 0,
    timeout_player = 0,
};

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ruleset.callback = function (e)
    -- Packet: Chat
    if (e.id == 0x0017 and struct.unpack('b', e.data_modified, 0x04 + 1) == 0x03) then
        if (struct.unpack('b', e.data_modified, 0x05 + 1) == 0) then
            -- Ensure player tell alerts are enabled..
            if (not chatmon.settings.incoming_tell.player.enabled) then
                return;
            end

            -- Ensure the repeat delay has passed..
            if ((os.time() - ruleset.timeout_player) < chatmon.settings.incoming_tell.player.delay) then
                return;
            end

            -- Update the delay time..
            ruleset.timeout_player = os.time();

            -- Play the alert..
            ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.incoming_tell.player.sound));
        else
            -- Ensure GM tell alerts are enabled..
            if (not chatmon.settings.incoming_tell.gm.enabled) then
                return;
            end

            -- Ensure the repeat delay has passed..
            if ((os.time() - ruleset.timeout_gm) < chatmon.settings.incoming_tell.gm.delay) then
                return;
            end

            -- Update the delay time..
            ruleset.timeout_gm = os.time();

            -- Play the alert..
            ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.incoming_tell.gm.sound));
        end
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
        gm = T{
            enabled = T{ chatmon.settings.incoming_tell.gm.enabled, },
            delay = T{ chatmon.settings.incoming_tell.gm.delay, },
            sound = T{ chatmon.settings.incoming_tell.gm.sound, },
        },
        player = T{
            enabled = T{ chatmon.settings.incoming_tell.player.enabled, },
            delay = T{ chatmon.settings.incoming_tell.player.delay, },
            sound = T{ chatmon.settings.incoming_tell.player.sound, },
        },
    };

    local function render_chat_settings(name)
        imgui.TextColored({ 1.0, 1.0, 0.0, 1.0, }, ('%s Tell Settings'):fmt(name:proper()));
        if (imgui.Checkbox(('Enabled?##enabled_%s'):fmt(name), s[name].enabled)) then
            chatmon.settings.incoming_tell[name].enabled = s[name].enabled[1];
            updated = true;
        end
        if (imgui.InputInt(('Delay##delay_%s'):fmt(name), s[name].delay)) then
            chatmon.settings.incoming_tell[name].delay = s[name].delay[1];
            updated = true;
        end
        if (imgui.InputText(('Sound File##snd_%s'):fmt(name), s[name].sound, 256)) then
            chatmon.settings.incoming_tell[name].sound = s[name].sound[1];
            updated = true;
        end
        imgui.Separator();
        imgui.NewLine();
    end

    -- Render the ruleset editor..
    render_chat_settings('gm');
    render_chat_settings('player');

    return updated;
end

-- Return the ruleset..
return ruleset;