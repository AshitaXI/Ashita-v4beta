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

addon.name      = 'hideui';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Adds slash commands to hide, show, or toggle Ashita\'s custom drawn elements.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- HideUI Variables
local hideui = {
    show = true
};

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
        { '/hideui', 'Toggles the Ashita elements visibility.' },
        { '/hideui help', 'Displays the addons help information.' },
        { '/hideui (hide | h)', 'Sets the Ashita elements to be hidden.' },
        { '/hideui (show | s)', 'Sets the Ashita elements to be visible.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Sets the various Ashita rendered elements visibility.
*
* @param {boolean} visible - The visibility to set.
--]]
local function set_visibility(visible)
    AshitaCore:GetFontManager():SetVisible(visible);
    AshitaCore:GetPrimitiveManager():SetVisible(visible);
    AshitaCore:GetGuiManager():SetVisible(visible);
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/hideui')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /hideui - Toggles the elements.
    if (#args == 1) then
        hideui.show = not hideui.show;
        set_visibility(hideui.show);
        return;
    end

    -- Handle: /hideui help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /hideui hide - Hides the elements.
    if (#args == 2 and args[2]:any('hide', 'h')) then
        hideui.show = false;
        set_visibility(hideui.show);
        return;
    end

    -- Handle: /hideui show - Shows the elements.
    if (#args == 2 and args[2]:any('show', 's')) then
        hideui.show = true;
        set_visibility(hideui.show);
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);