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

addon.name      = 'chatmon';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Plays sounds as a reaction to certain events in chat. (And some other helpful events.)';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local settings = require('settings');
imgui = require('imgui');

-- Default Settings
local default_settings = T{ };

-- ChatMon Variables
chatmon = T{
    rules = T{ },
    settings = nil,

    -- Editor variables..
    editor = T{
        is_open = T{ false, },
        selected = { -1, },
    }
};

--[[
* Loads the ruleset files located in the /rules/ folder.
--]]
local function load_rules()
    -- Find all .lua files inside of the rules folder..
    T(ashita.fs.get_dir(addon.path:append('\\rules\\'), '.*.lua', true)):each(function (v)
        -- Attempt to load the ruleset file..
        local ruleset = T{ };
        local s, e = pcall(function ()
            ruleset = loadfile(addon.path:append('\\rules\\'):append(v))();
        end);

        -- Validate the ruleset loaded..
        if (s == false or e ~= nil) then
            print(chat.header(addon.name)
                :append(chat.error('Failed to load ruleset file due to error: '))
                :append(chat.warning(v)));
            print(chat.header(addon.name):append(chat.error(e or 'Unknown Error')));
            return;
        end

        -- Validate the ruleset returned properly..
        if (type(ruleset) ~= 'table') then
            print(chat.header(addon.name):append(chat.error('Failed to load ruleset file. Expected a table return: ')):append(chat.warning(v)));
            return;
        end

        -- Validate the ruleset table..
        if (ruleset.name == nil or type(ruleset.name) ~= 'string') then
            print(chat.header(addon.name):append(chat.error('Invalid ruleset file. \'name\' field expected to be a string: ')):append(chat.warning(v)));
            return;
        end
        if (ruleset.desc == nil or type(ruleset.desc) ~= 'string') then
            print(chat.header(addon.name):append(chat.error('Invalid ruleset file. \'desc\' field expected to be a string: ')):append(chat.warning(v)));
            return;
        end
        if (ruleset.event == nil or type(ruleset.event) ~= 'string') then
            print(chat.header(addon.name):append(chat.error('Invalid ruleset file. \'event\' field expected to be a string: ')):append(chat.warning(v)));
            return;
        end
        if (ruleset.callback == nil or type(ruleset.callback) ~= 'function') then
            print(chat.header(addon.name):append(chat.error('Invalid ruleset file. \'callback\' field expected to be a function: ')):append(chat.warning(v)));
            return;
        end
        if (ruleset.settings ~= nil and type(ruleset.settings) ~= 'table') then
            print(chat.header(addon.name):append(chat.error('Invalid ruleset file. \'settings\' field expected to be a table: ')):append(chat.warning(v)));
            return;
        end

        -- Store the ruleset settings into the defaults..
        if (ruleset.settings ~= nil) then
            default_settings[ruleset.name:lower()] = T(ruleset.settings);
        end

        -- Store the ruleset..
        local k = chatmon.rules:find_if(function (vv)
            return (vv.name:lower() == ruleset.name:lower());
        end);
        if (k ~= nil) then
            chatmon.rules[k] = ruleset;
        else
            chatmon.rules:append(ruleset);
        end
    end);
end

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', function (s)
    if (s ~= nil) then
        chatmon.settings = s;
    end

    -- Save the current settings..
    settings.save();
end);

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Load the chatmon rulesets..
    load_rules();

    -- Load the chatmon settings..
    chatmon.settings = settings.load(default_settings);
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/chatmon')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /chatmon
    if (#args >= 1) then
        chatmon.editor.is_open[1] = not chatmon.editor.is_open[1];
        return;
    end
end);

--[[
* Raises evens of a given type from the current loaded rulesets.
*
* @param {string} n - The name of the event to invoke the callbacks for.
* @param {userdata} e - The event args to pass to the callbacks.
--]]
local function raise_events(n, e)
    chatmon.rules:each(function (v)
        if (v.event:any(n)) then
            v.callback(e);
        end
    end);
end

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ashita.events.register('text_in', 'text_in_cb', function (e)
    raise_events('text_in', e);
end);

--[[
* event: text_out
* desc : Event called when the addon is processing outgoing text.
--]]
ashita.events.register('text_out', 'text_out_cb', function (e)
    raise_events('text_out', e);
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    raise_events('packet_in', e);
end);

--[[
* event: packet_out
* desc : Event called when the addon is processing outgoing packets.
--]]
ashita.events.register('packet_out', 'packet_out_cb', function (e)
    raise_events('packet_out', e);
end);

--[[
* Renders information and configuration options for the given ruleset.
*
* @param {table} rule - The ruleset to display info and configurations for.
--]]
local function render_ruleset(rule)
    imgui.PushTextWrapPos(imgui.GetFontSize() * 23.0);
    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, 'Ruleset:');
    imgui.SameLine();
    imgui.TextColored({ 1.0, 0.2, 0.5, 1.0 }, rule.name);
    imgui.TextColored({ 1.0, 0.5, 0.2, 1.0 }, rule.desc);
    imgui.PopTextWrapPos();
    imgui.Separator();

    -- Display a warning if the ruleset does not offer a UI..
    if (rule.ui == nil or type(rule.ui) ~= 'function') then
        imgui.PushTextWrapPos(imgui.GetFontSize() * 23.0);
        imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, 'This ruleset does not offer the ability to edit its configuration settings in-game. (Or does not include any configurable settings.)');
        imgui.PopTextWrapPos();
        return;
    end

    -- Render the ruleset configurations editor..
    if (rule.ui()) then
        settings.save();
    end
end

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    if (not chatmon.editor.is_open[1]) then
        return;
    end

    -- Render the ChatMon editor..
    imgui.SetNextWindowSize({ 600, 400, });
    imgui.SetNextWindowSizeConstraints({ 600, 400, }, { FLT_MAX, FLT_MAX, });
    if (imgui.Begin('ChatMon', chatmon.editor.is_open, ImGuiWindowFlags_NoResize)) then
        -- Left Side (Many whelps, handle it!!)
        imgui.BeginGroup();
            imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'ChatMon Rulesets');
            imgui.BeginChild('leftpane', { 200, -imgui.GetFrameHeightWithSpacing(), }, true);
                local index = 1;
                chatmon.rules:each(function (v)
                    if (imgui.Selectable(v.name, chatmon.editor.selected[1] == index)) then
                        chatmon.editor.selected[1] = index;
                    end
                    index = index + 1;
                end);
            imgui.EndChild();
        imgui.EndGroup();
        imgui.SameLine();

        -- Right Side (Key Item Lookup Editor)
        imgui.BeginGroup();
            imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Ruleset Configurations');
            imgui.BeginChild('rightpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, true);
                if (chatmon.editor.selected[1] == -1) then
                    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, '<< Select a ruleset from the left.');
                else
                    local ruleset = chatmon.rules[chatmon.editor.selected[1]];
                    if (ruleset == nil) then
                        imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, '<< Select a ruleset from the left.');
                    else
                        render_ruleset(ruleset);
                    end
                end
            imgui.EndChild();
        imgui.EndGroup();

        -- Settings Buttons..
        if (imgui.Button('Save Settings')) then
            settings.save();
            print(chat.header(addon.name):append(chat.message('Settings saved.')));
        end
        imgui.SameLine();
        if (imgui.Button('Reload Settings')) then
            settings.reload();
            print(chat.header(addon.name):append(chat.message('Settings reloaded.')));
        end
        imgui.SameLine();
        if (imgui.Button('Reset To Defaults')) then
            settings.reset();
            print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        end
    end
    imgui.End();
end);