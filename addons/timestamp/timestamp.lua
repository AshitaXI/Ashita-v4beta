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

addon.name      = 'timestamp';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Adds a timestamp to chat messages.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local settings = require('settings');

-- Default Settings
local default_settings = T{
    format = '\30\81[%H:%M:%S]\30\01';
};

-- Timestamp Variables
local timestamp = T{
    ignored = T {
        -- NPC Chat Reinjections
        190,

        -- Synergy Messages
        600, 702, 909, 919,
    },

    settings = settings.load(default_settings),
};

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', function (s)
    if (s ~= nil) then
        timestamp.settings = s;
    end

    settings.save();
end);

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/ts')));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/ts help', 'Displays the addons help information.' },
        { '/ts (format | fmt) <fmt>', 'Sets the timestamp format.' },
        { '/ts (reload | rl)', 'Reloads the addons settings from disk.' },
        { '/ts reset', 'Resets the addons settings to default.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ashita.events.register('text_in', 'text_in_cb', function (e)
    -- Obtain the mode information..
    local mex = bit.band(e.mode_modified,  0xFFFFFF00);
    local mid = bit.band(e.mode_modified,  0x000000FF);

    -- Skip ignored modes..
    if (timestamp.ignored:hasval(mid)) then
        return;
    end

    -- Prevent mode indents on npc chat..
    if (mid == 150) then
        e.mode_modified = bit.bor(mex, 151);
    end

    -- Prepare needed variables..
    local fmt = timestamp.settings.format;

    -- Manually handle line indents..
    if (e.indent) then
        e.indent_modified = false;
        fmt = fmt:append('  ');
    end

    -- Parse the message for auto-translate tags to prevent collisions with linebreak matching..
    local msg = AshitaCore:GetChatManager():ParseAutoTranslate(e.message_modified, true);

    -- Find all locations were the chat should be split by newlines..
    local indices = T{ };
    local pattern = '[\x0A\x0D]';
    local pos = msg:find(pattern, 1);

    while (pos) do
        local prev = msg:sub(pos - 1, pos - 1);
        if (prev ~= string.char(0x1E) and prev ~= string.char(0x1F)) then
            indices:append(pos);
        end
        pos = msg:find(pattern, pos + 1);
    end
    indices:append(#msg + 1);

    -- Split the line into parts based on the found indices..
    local parts = T{ };
    local start = 1;

    for _, v in pairs(indices) do
        local part = msg:sub(start, v - 1);
        if (#part > 0) then
            parts:append(part);
        end
        start = v + 1;
    end

    -- Rebuild the message with injected timestamps..
    msg = parts:map(function (v)
        return os.date(fmt, os.time()):append(' ' .. v);
    end):concat('\n');

    -- Inject stamps into linebreaks via the bell character.. (npc chat lines use this)
    msg = msg:gsub('[^\x1E\x1F][\x07]', function (s)
        local spacing = mid == 150 and '   ' or ' ';
        return s:sub(1, 1):append('\n' + os.date(fmt, os.time()) + spacing);
    end);

    e.message_modified = msg;
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/ts')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /ts help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /ts (format | fmt) <fmt> - Sets the timestamp format.
    if (#args == 3 and args[2]:any('format', 'fmt')) then
        timestamp.settings.format = args[3];
        return;
    end

    -- Handle: /ts (reload | rl) - Reloads the addon settings from disk.
    if (#args == 2 and args[2]:any('reload', 'rl')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded from disk.')));
        return;
    end

    -- Handle: /ts reset - Resets the addon settings to default.
    if (#args == 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);