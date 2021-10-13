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

addon.name      = 'autojoin';
addon.author    = 'atom0s & Thorny';
addon.version   = '1.0';
addon.desc      = 'Automatically handles party invite related interactions.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local settings = require('settings');

-- Default Settings
local default_settings = T{
    mode = 2, -- 0 = Decline, 1 = Join (Accept), 2 = Ignore
    decline = T{ },
    join = T{ },
    ignore = T{ },
};

-- AutoJoin Variables
local autojoin = T{
    settings = settings.load(default_settings),
    users = T{ },
};

--[[
* Builds the list of users to react to.
--]]
local function build_users()
    -- Clear the user list..
    autojoin.users:clear();

    -- Rebuild the user list..
    if (autojoin.settings.decline ~= nil) then
        T(autojoin.settings.decline):each(function (v)
            autojoin.users:insert({ v:lower(), 0 });
        end);
    end
    if (autojoin.settings.join ~= nil) then
        T(autojoin.settings.join):each(function (v)
            autojoin.users:insert({ v:lower(), 1 });
        end);
    end
    if (autojoin.settings.ignore ~= nil) then
        T(autojoin.settings.ignore):each(function (v)
            autojoin.users:insert({ v:lower(), 2 });
        end);
    end
end

--[[
* Returns a user entry from the known list of users to react to.
*
* @param {string} n - The name of the player to look up.
* @return {table|nil} The entry if exists, nil otherwise.
--]]
local function get_user_entry(n)
    for _, v in pairs(autojoin.users) do
        if (v[1] == n:lower()) then
            return v;
        end
    end
    return nil;
end

--[[
* Updates the addon settings.
*
* @param {table} s - The new settings table to use for the addon settings. (Optional.)
--]]
local function update_settings(s)
    -- Update the settings table..
    if (s ~= nil) then
        autojoin.settings = s;
    end

    -- Save the current settings..
    settings.save();

    -- Rebuild the user list..
    build_users();
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
        { '/autojoin help', 'Displays the addons help information.' },
        { '/autojoin (reload | rl)', 'Reloads the addons settings from disk.' },
        { '/autojoin reset', 'Resets the addons settings to default.' },
        { '/autojoin mode <m>', 'Sets the default mode. (0 = Decline, 1 = Join (Accept), 2 = Ignore)' },
        { '/autojoin list', 'Lists the players currently registered to each autojoin list.' },
        { '/autojoin add (decline | join | ignore) <name>', 'Adds a player name to the given list.' },
        { '/autojoin (del | delete | remove) (decline | join | ignore) <name>', 'Removes a player name from the given list.' },
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
    -- Rebuild the user list..
    build_users();
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/autojoin') then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /autojoin help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /autojoin (reload | rl) - Reloads the settings from disk.
    if (#args == 2 and args[2]:any('reload', 'rl')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded from disk.')));
        return;
    end

    -- Handle: /autojoin reset - Resets the settings to defaults.
    if (#args == 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        return;
    end

    -- Handle: /autojoin mode <m> - Sets the autojoin mode.
    if (#args == 3 and args[2]:any('mode')) then
        local m = args[3]:number_or(2);
        if (m > 2 or m < 0) then
            m = 2;
        end

        local names = T{ 'Decline', 'Join', 'Ignore', };

        autojoin.settings.mode = m;
        settings.save();

        print(chat.header(addon.name):append(chat.message('Default mode set to: ')):append(chat.success(names[m + 1] or '(Unknown)')));
        return;
    end

    -- Handle: /autojoin list - Lists users registered to each autojoin list.
    if (#args == 2 and args[2]:any('list')) then
        local d, j, i = T{ }, T{ }, T{ };
        for _, v in pairs(autojoin.users) do
            if (v[2] == 0) then
                d:append(v[1]);
            elseif (v[2] == 1) then
                j:append(v[1]);
            elseif (v[2] == 2) then
                i:append(v[1]);
            end
        end

        print(chat.header(addon.name):append(chat.message('Auto-join will decline invites from the following players:')));
        print(chat.header(addon.name):append(chat.color1(5, d:join(', '))));
        print(chat.header(addon.name):append(chat.message('Auto-join will accept invites from the following players:')));
        print(chat.header(addon.name):append(chat.color1(5, j:join(', '))));
        print(chat.header(addon.name):append(chat.message('Auto-join will ignore invites from the following players:')));
        print(chat.header(addon.name):append(chat.color1(5, i:join(', '))));
        return;
    end

    -- Handle: /autojoin add (decline|join|ignore) <name> - Adds a player name to the given list.
    if (#args == 4 and args[2]:any('add')) then
        if (not args[3]:any('decline', 'join', 'ignore')) then
            print_help(true);
            return;
        end

        -- Checks if a given autojoin user list contains a given player name..
        local function has_user(n, m)
            for _, v in pairs(autojoin.users) do
                if (v[1]:lower() == n:lower() and v[2] == m) then
                    return true;
                end
            end
            return false;
        end

        local m = -1;
        local n = T{ 'decline', 'join', 'ignore', };

        switch(args[3], {
            ['decline'] = function () m = 0; end,
            ['join'] = function () m = 1; end,
            ['ignore'] = function () m = 2; end,
        });

        if (m == -1) then
            print(chat.header(addon.name):append(chat.error('Invalid add table given. Expected one of: ')):append(chat.message('decline, join, ignore')));
            return;
        end

        -- Check if the user is already being handled..
        if (has_user(args[4], m)) then
            print(chat.header(addon.name):append(chat.message(('Player already exists in the %s list.'):fmt(n[m + 1]))));
            return;
        end

        -- Update the settings and rebuild the user list..
        autojoin.settings[n[m + 1]]:append(args[4]);
        settings.save();
        build_users();

        print(chat.header(addon.name) + chat.message('Added \'') + chat.success(args[4]) + chat.message('\' ') + chat.message(('to the %s list.'):fmt(n[m + 1])));
        return;
    end

    -- Handle: /autojoin (del|delete|remove) (decline|join|ignore) <name> - Removes a player name from the given list.
    if (#args == 4 and args[2]:any('del', 'delete', 'remove')) then
        if (not args[3]:any('decline', 'join', 'ignore')) then
            print_help(true);
            return;
        end

        -- Checks if a given autojoin user list contains a given player name..
        local function has_user(n, m)
            for _, v in pairs(autojoin.users) do
                if (v[1]:lower() == n:lower() and v[2] == m) then
                    return true;
                end
            end
            return false;
        end

        local m = -1;
        local n = T{ 'decline', 'join', 'ignore', };

        switch(args[3], {
            ['decline'] = function () m = 0; end,
            ['join'] = function () m = 1; end,
            ['ignore'] = function () m = 2; end,
        });

        if (m == -1) then
            print(chat.header(addon.name):append(chat.error('Invalid add table given. Expected one of: ')):append(chat.message('decline, join, ignore')));
            return;
        end

        -- Check if the user is already being handled..
        if (not has_user(args[4], m)) then
            print(chat.header(addon.name):append(chat.message(('Player does not exist in the %s list.'):fmt(n[m + 1]))));
            return;
        end

        -- Update the settings and rebuild the user list..
        local k, _ = autojoin.settings[n[m + 1]]:find_if(function (v, _)
            return v:lower() == args[4]:lower();
        end);
        if (k ~= nil) then
            autojoin.settings[n[m + 1]]:remove(k);
            settings.save();
            build_users();

            print(chat.header(addon.name) + chat.message('Removed \'') + chat.success(args[4]) + chat.message('\' ') + chat.message(('from the %s list.'):fmt(n[m + 1])));
        end

        print(chat.header(addon.name):append(chat.error('Unexpected error happened trying to remove player.')));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Packet: Party Request
    if (e.id == 0x00DC) then
        e.blocked = true;

        local n = struct.unpack('c16', e.data_modified, 0x0C + 0x01);
        local a = autojoin.settings.mode;
        local u = get_user_entry(n:trim('\0'));

        if (u ~= nil) then
            a = u[2];
        end

        -- Handle the action for the user..
        if (a ~= 2) then
            local packet = { 0x74, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, };
            packet[5] = a;
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x74, packet);

            if (a == 1) then
                print(chat.header(addon.name):append(chat.message('Accepted invite from: ')):append(chat.success(n)));
            else
                print(chat.header(addon.name):append(chat.message('Declined invite from: ')):append(chat.success(n)));
            end

            return;
        end

        print(chat.header(addon.name):append(chat.message('Ignoring invite from: ')):append(chat.success(n)));
    end
end);