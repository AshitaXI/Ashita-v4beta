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

addon.name      = 'renamer';
addon.author    = 'atom0s & Teotwawki';
addon.version   = '1.0';
addon.desc      = 'Renames entities with overrides.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local editor = require('editor');

--[[
* Conditional printer. Prints the 'tmsg' message on true conditions, or 'fmsg' otherwise.
*
* @param {table} t - Table that contains the condition and a message on error.
* @param {string} tmsg - The message to print if the condition is true.
* @param {string} fmsg - The message to print if the condition is false.
--]]
local function iifp(t, tmsg, fmsg)
    local cond, m = unpack(t);
    if (cond) then
        print(chat.header(addon.name):append(tmsg));
    else
        print(chat.header(addon.name):append(fmsg:fmt(m)));
    end
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', editor.load);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', editor.unload);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', editor.packet_in);

--[[
* event: d3d_beginscene
* desc : Event called when the Direct3D device is beginning a scene.
--]]
ashita.events.register('d3d_beginscene', 'beginscene_cb', editor.beginscene);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', editor.render);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/renamer')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /renamer
    -- Handle: /renamer editor
    if (#args == 1 or (#args >= 2 and args[2]:any('editor'))) then
        editor.is_open[1] = not editor.is_open[1];
        return;
    end

    -- Handle: /renamer load <name>
    if (#args >= 3 and args[2]:ieq('load')) then
        editor.lstMgr.refresh_saved_lists();

        -- Find the index of the list..
        local lst = editor.lstMgr.saved_lists;
        for x = 1, #lst do
            if (lst[x]:ieq(args:concat(' ', 3):lower():append('.lua'))) then
                iifp(editor.lstMgr.load_list:packed()(x - 1, false),
                    chat.message('Loaded renamer list.'),
                    chat.error('Failed to load renamer list; \'%s\''));
                return;
            end
        end

        print(chat.header(addon.name):append(chat.error('Failed to load renamer list; invalid list file name.')));
        return;
    end

    -- Handle: /renamer merge <name>
    if (#args >= 3 and args[2]:ieq('merge')) then
        editor.lstMgr.refresh_saved_lists();

        -- Find the index of the list..
        local lst = editor.lstMgr.saved_lists;
        for x = 1, #lst do
            if (lst[x]:ieq(args:concat(' ', 3):lower():append('.lua'))) then
                iifp(editor.lstMgr.load_list:packed()(x - 1, true),
                    chat.message('Loaded renamer list.'),
                    chat.error('Failed to load renamer list; \'%s\''));
            return;
            end
        end

        print(chat.header(addon.name):append(chat.error('Failed to load renamer list; invalid list file name.')));
        return;
    end
end);