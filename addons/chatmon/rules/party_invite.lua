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
    name = 'party_invite',
    desc = 'Plays a sound file when the player receives a party invite.',
    event = 'packet_in',

    -- Ruleset Settings
    settings = T{
        party = T{
            enabled = true,
            delay = 5,
            sound = 'incoming_party_invite.wav',
        },
        alliance = T{
            enabled = true,
            delay = 5,
            sound = 'incoming_party_invite.wav',
        },
    },

    -- Local Ruleset Variables
    timeout_invite_party = 0,
    timeout_invite_alliance = 0,
};

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ruleset.callback = function (e)
    -- Packet: Party Invite
    if (e.id == 0x00DC) then
        switch(struct.unpack('b', e.data_modified, 0x0B + 1), {
            -- Party
            [0] = function ()
                -- Ensure party invite alerts are enabled..
                if (not chatmon.settings.party_invite.party.enabled) then
                    return;
                end

                -- Ensure the repeat delay has passed..
                if ((os.time() - ruleset.timeout_invite_party) < chatmon.settings.party_invite.party.delay) then
                    return;
                end

                -- Update the delay time..
                ruleset.timeout_invite_party = os.time();

                -- Play the alert..
                ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.party_invite.party.sound));
            end,

            -- Alliance
            [5] = function ()
                -- Ensure alliance invite alerts are enabled..
                if (not chatmon.settings.party_invite.alliance.enabled) then
                    return;
                end

                -- Ensure the repeat delay has passed..
                if ((os.time() - ruleset.timeout_invite_alliance) < chatmon.settings.party_invite.alliance.delay) then
                    return;
                end

                -- Update the delay time..
                ruleset.timeout_invite_alliance = os.time();

                -- Play the alert..
                ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.party_invite.alliance.sound));
            end,
        });
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
        party = T{
            enabled = T{ chatmon.settings.party_invite.party.enabled, },
            delay = T{ chatmon.settings.party_invite.party.delay, },
            sound = T{ chatmon.settings.party_invite.party.sound, },
        },
        alliance = T{
            enabled = T{ chatmon.settings.party_invite.alliance.enabled, },
            delay = T{ chatmon.settings.party_invite.alliance.delay, },
            sound = T{ chatmon.settings.party_invite.alliance.sound, },
        },
    };

    local function render_settings(name)
        imgui.TextColored({ 1.0, 1.0, 0.0, 1.0, }, ('%s Invite Settings'):fmt(name:proper()));
        if (imgui.Checkbox(('Enabled?##enabled_%s'):fmt(name), s[name].enabled)) then
            chatmon.settings.party_invite[name].enabled = s[name].enabled[1];
            updated = true;
        end
        if (imgui.InputInt(('Delay##delay_%s'):fmt(name), s[name].delay)) then
            chatmon.settings.party_invite[name].delay = s[name].delay[1];
            updated = true;
        end
        if (imgui.InputText(('Sound File##snd_%s'):fmt(name), s[name].sound, 256)) then
            chatmon.settings.party_invite[name].sound = s[name].sound[1];
            updated = true;
        end
        imgui.Separator();
        imgui.NewLine();
    end

    -- Render the ruleset editor..
    render_settings('party');
    render_settings('alliance');

    return updated;
end

-- Return the ruleset..
return ruleset;