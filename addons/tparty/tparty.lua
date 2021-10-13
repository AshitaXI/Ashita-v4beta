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

addon.name      = 'tparty';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Displays party member TP amounts and target health percent.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local fonts = require('fonts');
local scaling = require('scaling');
local settings = require('settings');

-- Default Settings
local default_settings = T{
    party = T{
        font = T{
            visible = true,
            locked = true,
            font_family = 'Arial',
            font_height = scaling.scale_f(8),
            bold = true,
            italic = true,
            right_justified = true,
            color = 0xFFFFFFFF,
        },
    },
    target = T{
        font = T{
            visible = true,
            locked = true,
            font_family = 'Arial',
            font_height = scaling.scale_f(10),
            bold = true,
            italic = true,
            right_justified = true,
            color = 0xFFFFFFFF,
        },
    },
};

-- TParty Variables
local tparty = T{
    font_target = nil,
    font_party = T{ },
    settings = settings.load(default_settings),
};

--[[
* Updates the font object settings and saves the current settings.
*
* @param {table} s - The new settings table to use for the addon settings. (Optional.)
--]]
local function update_settings(s)
    -- Update the settings table..
    if (s ~= nil) then
        tparty.settings = s;
    end

    -- Apply the font settings..
    if (tparty.font_target ~= nil) then
        tparty.font_target:apply(tparty.settings.target.font);
    end
    tparty.font_party:each(function (v, _)
        if (v ~= nil) then
            v:apply(tparty.settings.party.font);
        end
    end);

    -- Prepare the font defaults..
    for x = 1, 18 do
        if (x <= 6) then
            tparty.font_party[x].font_height    = scaling.scale_f(10);
            tparty.font_party[x].position_x     = scaling.scale_w(-95);
            tparty.font_party[x].position_y     = scaling.scale_h(-34 - 20 * (6 - x));
        elseif (x <= 12) then
            tparty.font_party[x].font_height    = scaling.scale_f(8);
            tparty.font_party[x].position_x     = scaling.scale_w(-100);
            tparty.font_party[x].position_y     = scaling.scale_h(-388 + 16 * ((x - 1) % 6));
        elseif (x <= 18) then
            tparty.font_party[x].font_height    = scaling.scale_f(8);
            tparty.font_party[x].position_x     = scaling.scale_w(-100);
            tparty.font_party[x].position_y     = scaling.scale_h(-287 + 16 * ((x - 1) % 6));
        end
    end

    -- Save the current settings..
    settings.save();
end

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', update_settings);

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/tparty help', 'Displays the addons help information.' },
        { '/tparty (reload | rl)', 'Reloads the addons settings from disk.' },
        { '/tparty reset', 'Resets the addons settings to default.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    tparty.font_target = fonts.new(tparty.settings.target.font);
    for x = 1, 18 do
        tparty.font_party[x] = fonts.new(tparty.settings.party.font);

        if (x <= 6) then
            tparty.font_party[x].font_height    = scaling.scale_f(10);
            tparty.font_party[x].position_x     = scaling.scale_w(-95);
            tparty.font_party[x].position_y     = scaling.scale_h(-34 - 20 * (6 - x));
        elseif (x <= 12) then
            tparty.font_party[x].font_height    = scaling.scale_f(8);
            tparty.font_party[x].position_x     = scaling.scale_w(-100);
            tparty.font_party[x].position_y     = scaling.scale_h(-388 + 16 * ((x - 1) % 6));
        elseif (x <= 18) then
            tparty.font_party[x].font_height    = scaling.scale_f(8);
            tparty.font_party[x].position_x     = scaling.scale_w(-100);
            tparty.font_party[x].position_y     = scaling.scale_h(-287 + 16 * ((x - 1) % 6));
        end
    end
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    if (tparty.font_target ~= nil) then
        tparty.font_target:destroy();
        tparty.font_target = nil;
    end

    if (tparty.font_party ~= nil) then
        tparty.font_party:each(function (v, _)
            v:destroy();
        end);
        tparty.font_party = T{ };
    end

    settings.save();
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/tparty') then
        return;
    end

    -- Block all tparty related commands..
    e.blocked = true;

    -- Handle: /tparty help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /tparty (reload|rl) - Reloads the addon settings from disk.
    if (#args == 2 and args[2]:any('reload', 'rl')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded from disk.')));
        return;
    end

    -- Handle: /tparty reset - Resets the addon settings to default.
    if (#args == 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    -- Update the target font..
    if (tparty.font_target ~= nil) then
        local target = GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(0));
        if (target ~= nil) then
            tparty.font_target.position_x = scaling.scale_w(-102);
            tparty.font_target.position_y = scaling.scale_h(-50 - 20 * AshitaCore:GetMemoryManager():GetParty():GetAlliancePartyMemberCount1());
            tparty.font_target.text = tostring(target.HPPercent);
        else
            tparty.font_target.text = '';
        end
    end

    -- Obtain the party and main players zone id..
    local party = AshitaCore:GetMemoryManager():GetParty();
    local zone = party:GetMemberZone(0);

    -- Update the party TP fonts..
    for x = 1, 18 do
        if (party:GetMemberIsActive(x - 1) == 0 or party:GetMemberZone(x - 1) ~= zone) then
            tparty.font_party[x].visible = false;
        else
            local tp = party:GetMemberTP(x - 1);
            tparty.font_party[x].visible = true;
            tparty.font_party[x].color = tp >= 1000 and 0xFF00FF00 or 0xFFFFFFFF;
            tparty.font_party[x].text = tostring(tp);

            if (x <= 6) then
                local pos = -34 - 20 * (6 - x);
                local cnt = (20 * (6 - party:GetAlliancePartyMemberCount1()));
                tparty.font_party[x].position_y = scaling.scale_h(pos + cnt);
            end
        end
    end
end);