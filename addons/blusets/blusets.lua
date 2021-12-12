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

addon.name      = 'blusets';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Manage blue magic spells easily with slash commands.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local blu = require('blu');
local chat = require('chat');

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
        { '/blusets help', 'Shows the addon help.' },
        { '/blusets list', 'Lists all available spell list files.' },
        { '/blusets load <file>', 'Loads the BLU spells from the given spell list file.' },
        { '/blusets save <file>', 'Saves the current set BLU spells to the given spell list file.' },
        { '/blusets delete <file>', 'Deletes the given spell list file.' },
        { '/blusets (clear | reset | unset)', 'Unsets all currently set BLU spells.' },
        { '/blusets set <slot> <spell>', 'Sets the given slot to the given BLU spell by its id.' },
        { '/blusets setn <slot> <spell>', 'Sets the given slot to the given BLU spell by its name.' },
        { '/blusets mode [safe | fast]', 'Sets mode BluSets will use to send packets. (safe is default.)' },
        { '/blusets delay <amount>', 'Sets the delay, in seconds, between packets that BluSets will use when loading sets. (If safe mode is on, minimum is 1 second.)' },
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
    -- Ensure the configuration folder exists..
    local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'blusets');
    if (not ashita.fs.exists(path)) then
        ashita.fs.create_dir(path);
    end
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/blusets', '/bluesets', '/bluset', '/blueset', '/bs')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /blusets help - Shows the addon help.
    if (#args >= 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /blusets list - Lists all available spell list files.
    if (#args >= 2 and args[2]:any('list')) then
        local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'blusets');
        local files = ashita.fs.get_dir(path, '.*.txt', true);
        if (files ~= nil and #files > 0) then
            T(files):each(function (v)
                print(chat.header(addon.name):append(chat.message('Found spell set file: ')):append(chat.success(v:gsub('.txt', ''))));
            end);
            return;
        end

        print(chat.header(addon.name):append(chat.message('No saved spell lists found.')));
        return;
    end

    -- Handle: /blusets load <file> - Loads the BLU spells from the given spell list file.
    if (#args >= 3 and args[2]:any('load')) then
        local name = args:concat(' ', 3):gsub('.txt', ''):trim();
        local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'blusets');

        -- Check if the file exists..
        if (not ashita.fs.exists(path:append(name:append('.txt')))) then
            print(chat.header(addon.name):append(chat.error('Failed to load spell list; file does not exist: ')):append(chat.warning(name)));
            return;
        end

        -- Load the spell file for reading..
        local f = io.open(path:append(name:append('.txt')), 'r');
        if (f == nil) then
            print(chat.header(addon.name):append(chat.error('Failed to open spell list file for reading: ')):append(chat.warning(name)));
            return;
        end

        -- Read the spell file lines..
        local spells = T{ };
        for line in f:lines() do
            spells:append(line);
        end

        f:close();

        -- Determine the delay to be used while setting spells..
        local delay = blu.delay;
        if (delay < 1 and blu.mode == 'safe') then
            delay = 1;
        end

        -- Apply the spell list..
        ashita.tasks.once(1, (function (d, lst)
            -- Reset the current spells first..
            blu.reset_all_spells();
            coroutine.sleep(d);

            -- Set each spell in the spell list..
            lst:each(function (v, k)
                blu.set_spell_by_name(k, v);
                coroutine.sleep(d);
            end);

            print(chat.header(addon.name):append(chat.message('Finished setting blue magic spells set.')));
        end):bindn(delay, spells));

        print(chat.header(addon.name):append(chat.message('Setting blue magic from spell set; please wait..')));
        return;
    end

    -- Handle: /blusets save <file> - Saves the current set BLU spells to the given spell list file.
    if (#args >= 3 and args[2]:any('save')) then
        local spells = blu.get_spells_names();

        local name = args:concat(' ', 3):gsub('.txt', ''):trim();
        local path = ('%s\\config\\addons\\%s\\%s.txt'):fmt(AshitaCore:GetInstallPath(), 'blusets', name);
        local f = io.open(path, 'w+');
        if (f == nil) then
            print(chat.header(addon.name):append(chat.error('Failed to open spell list file for writing.')));
            return;
        end
        f:write(spells:concat('\n'));
        f:close();

        print(chat.header(addon.name):append(chat.message('Saved spell list to: ')):append(chat.success(name)));
        return;
    end

    -- Handle: /blusets delete <file> - Deletes the given spell list file.
    if (#args >= 3 and args[2]:any('delete')) then
        local name = args:concat(' ', 3):gsub('.txt', ''):trim();
        local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'blusets');

        if (not ashita.fs.exists(path:append(name:append('.txt')))) then
            print(chat.header(addon.name):append(chat.error('Failed to delete spell list; file does not exist: ')):append(chat.warning(name)));
            return;
        end

        ashita.fs.remove(path:append(name:append('.txt')));

        print(chat.header(addon.name):append(chat.message('Deleted spell list file: ')):append(chat.success(name)));
        return;
    end

    -- Handle: /blusets (clear | reset | unset) - Unsets all currently set BLU spells.
    if (#args >= 2 and args[2]:any('clear', 'reset', 'unset')) then
        blu.reset_all_spells();

        print(chat.header(addon.name):append(chat.message('Blue magic spells reset.')));
        return;
    end

    -- Handle: /blusets set <slot> <spell> - Sets the given slot to the given BLU spell by its id.
    if (#args >= 4 and args[2]:any('set')) then
        blu.set_spell(args[3]:num(), args[4]:num_or(0));
        return;
    end

    -- Handle: /blusets setn <slot> <spell> - Sets the given slot to the given BLU spell by its name.
    if (#args >= 4 and args[2]:any('setn')) then
        blu.set_spell_by_name(args[3]:num(), args:concat(' ', 4));
        return;
    end

    -- Handle: /blusets mode [safe | fast] - Sets mode BluSets will use to send packets. (safe is default.)
    if (#args >= 2 and args[2]:any('mode')) then
        if (#args >= 3) then
            if (args[3]:any('fast')) then
                blu.mode = 'fast';
            else
                blu.mode = 'safe';
            end
        end

        print(chat.header(addon.name):append(chat.message('BluSets packet mode is set to: ')):append(chat.success(blu.mode)));
        return;
    end

    -- Handle: /blusets delay <amount> - Sets the delay, in seconds, between packets that BluSets will use when loading sets. (If safe mode is on, minimum is 1 second.)
    if (#args >= 3 and args[2]:any('delay')) then
        blu.delay = args[3]:num_or(1);
        if (blu.delay <= 0) then
            blu.delay = 1;
        end

        print(chat.header(addon.name):append(chat.message('BluSets packet delay set to: ')):append(chat.success(blu.delay)));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);