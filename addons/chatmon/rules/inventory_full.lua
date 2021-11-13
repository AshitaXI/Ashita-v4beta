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
    name = 'inventory_full',
    desc = 'Plays a sound file when the local players inventory is full.',
    event = 'packet_in',

    -- Ruleset Settings
    settings = T{
        inventory = T{
            enabled = true,
            delay = 30,
            frequency = 10,
            sound = 'inventory_full.wav',
        },
    },

    -- Local Ruleset Variables
    timeout = T{
        inventory_alert = 0,
        inventory_check = 0,
    },
};

--[[
* Checks if the players inventory is full. If true, will play the inventory full sound notification.
--]]
local function check_inventory_full()
    -- Ensure the repeat delay has passed..
    if ((os.time() - ruleset.timeout.inventory_alert) < chatmon.settings.inventory_full.inventory.delay) then
        return;
    end

    -- Determine if the players inventory is full..
    local inv = AshitaCore:GetMemoryManager():GetInventory();
    if (inv == nil) then
        return;
    end

    local cnt = inv:GetContainerCount(0);
    if (cnt == 0 or cnt < inv:GetContainerCountMax(0)) then
        return;
    end

    -- Update the delay time..
    ruleset.timeout.inventory_alert = os.time();

    -- Play the alert..
    ashita.misc.play_sound(addon.path:append('\\sounds\\'):append(chatmon.settings.inventory_full.inventory.sound));
end

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ruleset.callback = function (e)
    -- Ensure inventory full alerts are enabled..
    if (not chatmon.settings.inventory_full.inventory.enabled) then
        return;
    end

    -- Ensure the frequency delay has passed..
    if ((os.time() - ruleset.timeout.inventory_check) < chatmon.settings.inventory_full.inventory.frequency) then
        return;
    end

    -- Update the frequency delay..
    ruleset.timeout.inventory_check = os.time();

    -- Check the players inventory..
    check_inventory_full();
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
        enabled = T{ chatmon.settings.inventory_full.inventory.enabled, },
        delay = T{ chatmon.settings.inventory_full.inventory.delay, },
        frequency = T{ chatmon.settings.inventory_full.inventory.frequency, },
        sound = T{ chatmon.settings.inventory_full.inventory.sound, },
    };

    -- Render the ruleset editor..
    if (imgui.Checkbox('Enabled?', s.enabled)) then
        chatmon.settings.inventory_full.inventory.enabled = s.enabled[1];
        updated = true;
    end
    if (imgui.InputInt('Delay', s.delay)) then
        chatmon.settings.inventory_full.inventory.delay = s.delay[1];
        updated = true;
    end
    if (imgui.InputInt('Check Frequency', s.frequency)) then
        chatmon.settings.inventory_full.inventory.frequency = s.frequency[1];
        updated = true;
    end
    if (imgui.InputText('Sound File', s.sound, 256)) then
        chatmon.settings.inventory_full.inventory.sound = s.sound[1];
        updated = true;
    end

    return updated;
end

-- Return the ruleset..
return ruleset;