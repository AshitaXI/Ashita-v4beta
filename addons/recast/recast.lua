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

addon.name      = 'recast';
addon.author    = 'atom0s, Thorny, RZN';
addon.version   = '1.0';
addon.desc      = 'Displays ability and spell recast times.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local fonts = require('fonts');
local scaling = require('scaling');
local settings = require('settings');

-- Default Settings
local default_settings = T{
    font = T{
        visible = true,
        font_family = 'Arial',
        font_height = scaling.scale_f(10),
        color = 0xFFFF0000,
        position_x = 100,
        position_y = 100,
        background = T{
            visible = true,
            color = 0x80000000,
        }
    },
};

-- Recast Variables
local recast = T{
    font = nil,
    sch_jp = 0,
    settings = settings.load(default_settings),
};

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', function (s)
    if (s ~= nil) then
        recast.settings = s;
    end

    -- Apply the font settings..
    if (recast.font ~= nil) then
        recast.font:apply(recast.settings.font);
    end

    settings.save();
end);

--[[
* Colorizes a recast timer string.
*
* @param {string} s - The recast string to be colorized.
* @param {number} t - The recast timer.
* @return {string} The colorized recast string.
--]]
local function colorize(s, t)
    if (t >= 1200) then
        return s;
    elseif (t < 1200 and t > 300) then
        return ('|cFFFFFF00|%s|r'):fmt(s);
    else
        return ('|cFF00FF00|%s|r'):fmt(s);
    end
end

--[[
* Returns a formatted recast timestamp.
*
* @param {number} timer - The recast timestamp to format.
* @return {string} The formatted timestamp.
--]]
local function format_timestamp(timer)
    local t = timer / 60;
    local h = math.floor(t / (60 * 60));
    local m = math.floor(t / 60 - h * 60);
    local s = math.floor(t - (m + h * 60) * 60);
    return ('%02i:%02i:%02i'):fmt(h, m, s);
end

--[[
* Returns an abilities name as a fallback if the ability is not known to the player.
*
* @param {number} id - The recast timer id of the ability to obtain.
* @return {object} The ability if found, nil otherwise.
* @note
*
* This is not guaranteed to get the desired ability as the game shares recast timer ids based on the players
* job combo. Because of this, another ability may be returned instead of what was expected if it was found first.
--]]
local function get_ability_fallback(id)
    local resMgr = AshitaCore:GetResourceManager();
    for x = 0, 2048 do
        local ability = resMgr:GetAbilityById(x);
        if (ability ~= nil and ability.RecastTimerId == id) then
            return ability;
        end
    end
    return nil;
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    recast.font = fonts.new(recast.settings.font);
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    -- Cleanup the font object..
    if (recast.font ~= nil) then
        recast.font:destroy();
        recast.font = nil;
    end

    settings.save();
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (recast.font == nil or recast.font.visible == false) then
        return;
    end

    -- Update the current settings font position..
    recast.settings.font.position_x = recast.font.position_x;
    recast.settings.font.position_y = recast.font.position_y;

    local resMgr    = AshitaCore:GetResourceManager();
    local mmRecast  = AshitaCore:GetMemoryManager():GetRecast();
    local timers    = T{};

    -- Obtain the players ability recasts..
    for x = 0, 31 do
        local id = mmRecast:GetAbilityTimerId(x);
        local timer = mmRecast:GetAbilityTimer(x);

        -- Ensure the ability is valid and has a current recast timer..
        if ((id ~= 0 or x == 0) and timer > 0) then
            -- Obtain the resource entry for the ability..
            local ability = resMgr:GetAbilityByTimerId(id);
            local name = ('(Unknown: %d)'):fmt(id);

            -- Determine the name to be displayed..
            if (x == 0) then
                -- TODO: Update this to the actual name per-job?
                name = '(Job One Hour)';
            elseif (id == 231) then
                -- Determine the players SCH level..
                local player = AshitaCore:GetMemoryManager():GetPlayer();
                local lvl = (player:GetMainJob() == 20) and player:GetMainJobLevel() or player:GetSubJobLevel();

                -- Adjust the timer offset by the players level..
                local val = 48;
                if (lvl < 30) then
                    val = 240;
                elseif (lvl < 50) then
                    val = 120;
                elseif (lvl < 70)then
                    val = 80;
                elseif (lvl < 90) then
                    val = 60;
                end

                -- Calculate the stratagems amount..
                local stratagems = 0;
                if (lvl == 99 and recast.sch_jp >= 550) then
                    val = 33;
                    stratagems = math.floor((165 - (timer / 60)) / val);
                else
                    stratagems = math.floor((240 - (timer / 60)) / val);
                end

                -- Update the name and timer..
                name = ('Stratagems[%d]'):fmt(stratagems);
                timer = math.fmod(timer, val * 60);
            elseif (ability ~= nil) then
                name = ability.Name[1];
            elseif (ability == nil) then
                ability = get_ability_fallback(id);
                if (ability ~= nil) then
                    name = ability.Name[1];
                end
            end

            -- Append the timer to the table..
            timers:insert(colorize(('%s : %s'):fmt(format_timestamp(timer), name), timer));
        end
    end

    -- Obtain the players spell recasts..
    for x = 0, 1024 do
        local id = x;
        local timer = mmRecast:GetSpellTimer(x);

        -- Ensure the spell has a current recast timer..
        if (timer > 0) then
            local spell = resMgr:GetSpellById(id);
            local name = '(Unknown Spell)';

            -- Determine the name to be displayed..
            if (spell ~= nil) then
                name = spell.Name[1];
            end
            if (spell == nil or name:len() == 0) then
                name = ('Unknown Spell: %d'):fmt(id);
            end

            -- Append the timer to the table..
            timers:insert(colorize(('%s : %s'):fmt(format_timestamp(timer), name), timer));
        end
    end

    -- Update the recast font object text..
    recast.font.text = timers:join('\n');
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Job Points
    if (e.id == 0x0063) then
        if (struct.unpack('B', e.data_modified, 0x04 + 0x01) == 5) then
            recast.sch_jp = struct.unpack('H', e.data_modified, 0x88 + 0x01);
        end
    end
end);