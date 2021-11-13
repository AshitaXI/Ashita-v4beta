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
    name = 'incoming_chat',
    desc = 'Plays a sound file when the local player is mentioned in various chat channels.',
    event = 'text_in',

    -- Ruleset Settings
    settings = T{
        say = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        shout = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        yell = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        linkshell1 = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        linkshell2 = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        linkshell3 = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        party = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        unity = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        assist_jp = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
        assist_en = T{
            enabled = true,
            delay = 5,
            sound = 'talked_about.wav',
        },
    },

    -- Local Ruleset Variables
    map = T{
        [9]     = T{ name = 'say',          timeout = 0, },
        [10]    = T{ name = 'shout',        timeout = 0, },
        [11]    = T{ name = 'yell',         timeout = 0, },
        [14]    = T{ name = 'linkshell1',   timeout = 0, },
        [214]   = T{ name = 'linkshell2',   timeout = 0, },
        --[121]   = T{ name = 'linkshell3',   timeout = 0, },
        [13]    = T{ name = 'party',        timeout = 0, },
        [212]   = T{ name = 'unity',        timeout = 0, },
        [220]   = T{ name = 'assist_jp',    timeout = 0, },
        [222]   = T{ name = 'assist_en',    timeout = 0, },
    },
};

--[[
* Tries to play a sound file if the given chat mode meets specific requirements.
*
* @param {number} mode - The chat mode to try to play a sound for.
* @return {boolean} True if successful, false otherwise.
--]]
local function try_play_sound(mode)
    -- Obtain the map entry for the given type..
    local m = ruleset.map[mode];
    if (m == nil) then
        return false;
    end

    -- Ensure chat mode alerts are enabled..
    if (chatmon.settings.incoming_chat[m.name] == nil or not chatmon.settings.incoming_chat[m.name].enabled) then
        return false;
    end

    -- Ensure the repeat delay has passed..
    if ((os.time() - m.timeout) < chatmon.settings.incoming_chat[m.name].delay) then
        return false;
    end

    -- Update the delay time..
    m.timeout = os.time();

    -- Play the alert..
    ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.incoming_chat[m.name].sound));

    return true;
end

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ruleset.callback = function (e)
    -- Obtain the chat mode..
    local mid = bit.band(e.mode_modified,  0x000000FF);

    -- Tests if the current message contains the local players name..
    local function contains_name()
        local name = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
        return name ~= nil and e.message_modified:lower():contains(name:lower());
    end

    -- Test if the current mode is valid and the message contains the local player name..
    if (ruleset.map:haskey(mid) and contains_name()) then
        -- Try to play a sound for this mode..
        try_play_sound(mid);
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
        say = T{
            enabled = T{ chatmon.settings.incoming_chat.say.enabled, },
            delay = T{ chatmon.settings.incoming_chat.say.delay, },
            sound = T{ chatmon.settings.incoming_chat.say.sound, },
        },
        shout = T{
            enabled = T{ chatmon.settings.incoming_chat.shout.enabled, },
            delay = T{ chatmon.settings.incoming_chat.shout.delay, },
            sound = T{ chatmon.settings.incoming_chat.shout.sound, },
        },
        yell = T{
            enabled = T{ chatmon.settings.incoming_chat.yell.enabled, },
            delay = T{ chatmon.settings.incoming_chat.yell.delay, },
            sound = T{ chatmon.settings.incoming_chat.yell.sound, },
        },
        linkshell1 = T{
            enabled = T{ chatmon.settings.incoming_chat.linkshell1.enabled, },
            delay = T{ chatmon.settings.incoming_chat.linkshell1.delay, },
            sound = T{ chatmon.settings.incoming_chat.linkshell1.sound, },
        },
        linkshell2 = T{
            enabled = T{ chatmon.settings.incoming_chat.linkshell2.enabled, },
            delay = T{ chatmon.settings.incoming_chat.linkshell2.delay, },
            sound = T{ chatmon.settings.incoming_chat.linkshell2.sound, },
        },
        linkshell3 = T{
            enabled = T{ chatmon.settings.incoming_chat.linkshell3.enabled, },
            delay = T{ chatmon.settings.incoming_chat.linkshell3.delay, },
            sound = T{ chatmon.settings.incoming_chat.linkshell3.sound, },
        },
        party = T{
            enabled = T{ chatmon.settings.incoming_chat.party.enabled, },
            delay = T{ chatmon.settings.incoming_chat.party.delay, },
            sound = T{ chatmon.settings.incoming_chat.party.sound, },
        },
        unity = T{
            enabled = T{ chatmon.settings.incoming_chat.unity.enabled, },
            delay = T{ chatmon.settings.incoming_chat.unity.delay, },
            sound = T{ chatmon.settings.incoming_chat.unity.sound, },
        },
        assist_jp = T{
            enabled = T{ chatmon.settings.incoming_chat.assist_jp.enabled, },
            delay = T{ chatmon.settings.incoming_chat.assist_jp.delay, },
            sound = T{ chatmon.settings.incoming_chat.assist_jp.sound, },
        },
        assist_en = T{
            enabled = T{ chatmon.settings.incoming_chat.assist_en.enabled, },
            delay = T{ chatmon.settings.incoming_chat.assist_en.delay, },
            sound = T{ chatmon.settings.incoming_chat.assist_en.sound, },
        },
    };

    local function render_chat_settings(name)
        imgui.TextColored({ 1.0, 1.0, 0.0, 1.0, }, ('%s Settings'):fmt(name:proper()));
        if (imgui.Checkbox(('Enabled?##enabled_%s'):fmt(name), s[name].enabled)) then
            chatmon.settings.incoming_chat[name].enabled = s[name].enabled[1];
            updated = true;
        end
        if (imgui.InputInt(('Delay##delay_%s'):fmt(name), s[name].delay)) then
            chatmon.settings.incoming_chat[name].delay = s[name].delay[1];
            updated = true;
        end
        if (imgui.InputText(('Sound File##snd_%s'):fmt(name), s[name].sound, 256)) then
            chatmon.settings.incoming_chat[name].sound = s[name].sound[1];
            updated = true;
        end
        imgui.Separator();
        imgui.NewLine();
    end

    -- Render the ruleset editor..
    render_chat_settings('say');
    render_chat_settings('shout');
    render_chat_settings('yell');
    render_chat_settings('linkshell1');
    render_chat_settings('linkshell2');
    render_chat_settings('linkshell3');
    render_chat_settings('party');
    render_chat_settings('unity');
    render_chat_settings('assist_jp');
    render_chat_settings('assist_en');

    return updated;
end

-- Return the ruleset..
return ruleset;