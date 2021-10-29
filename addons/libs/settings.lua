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

--[[
* Settings Library
*
* Implements a library that will manage and automatically handle loading/saving character-specific settings.
* Once a settings block is loaded; the library will monitor for character changes and automatically update
* accordingly. Addons can register to a callback event to monitor for when these switches happen.
*
* Addon settings loaded/saved through this library are located within:
*       <AshitaPath>/config/<addon_name>/
*
* Addons can maintain multiple settings files at once via passing an alias to the settings functions accordingly.
* If no settings alias is provided, it is always defaulted to 'settings'.
*
* Addon settings are saved under the following paths:
*       Defaults : <AshitaPath>/config/<addon_name>/defaults/<alias>.lua
*       Character: <AshitaPath>/config/<addon_name>/<charname>_<serverid>/<alias>.lua
*
* For example, here are two paths for the FPS addon:
*       Defaults : <AshitaPath>/config/fps/defaults/settings.lua
*       Character: <AshitaPath>/config/fps/Atomos_1337/settings.lua
--]]

require('common');
local chat = require('chat');

-- Settings library table..
local settingslib       = T{ };
settingslib.cache       = T{ };
settingslib.logged_in   = false;
settingslib.server_id   = 0;
settingslib.name        = '';

-- Function forwards..
local process_settings  = nil;
local load_settings     = nil;
local save_settings     = nil;

do
    --[[
    * Returns true if the given key is considered valid based on its type.
    *
    * @param {any} k - The key to check.
    * @return {boolean} True if valid, false otherwise.
    --]]
    local function is_valid_key(k)
        return switch(type(k), {
            ['boolean'] = function () return true; end,
            ['number'] = function () return true; end,
            ['string'] = function () return true; end,
            [switch.default] = function () return false; end,
        });
    end

    --[[
    * Serializes a key to a clean value that is save-safe.
    *
    * @param {any} k - The key to check.
    * @return {string} The prepared key for serialization.
    --]]
    local function serialize_key(k)
        return switch(type(k), {
            ['boolean'] = function ()
                return tostring(k);
            end,
            ['number'] = function ()
                -- Handle infinite number conditions..
                local snum = { [tostring(1/0)] = '1/0', [tostring(-1/0)] = '-1/0', [tostring(0/0)] = '0/0', };
                return snum[tostring(k)] or ("%.17g"):format(k);
            end,
            ['string'] = function ()
                return ('%q'):fmt(k):gsub('\010', 'n'):gsub('\026', '\\026');
            end,
            [switch.default] = function ()
                error('Invalid key type being serialized.');
            end,
        });
    end

    --[[
    * Processes a settings table, converting it to a string to be written to disk. (Recursive!)
    *
    * @param {table} s - The settings table to process.
    * @param {string} p - The parent level string to prepend to any configurations to be saved.
    * @return {table, string} A table containing all found parent strings to be used to initialize sub-tables. The configuration data converted to a string.
    --]]
    process_settings = function (s, p)
        local parents = T{ };
        local ret = '';

        -- Process the table converting values to a valid string representation..
        for k, v in pairs(s) do
            -- Recursively handle tables..
            if (type(v) == 'table') then
                -- Prepare the key..
                local key = '[' + serialize_key(k) + ']';

                -- Store the table path as a parent..
                local parent = (p or ''):append(key);
                parents:insert(#parents + 1, parent);

                -- Process the table..
                local ip, is = process_settings(v, parent);
                if (#ip > 0) then
                    ip:each(function (pv)
                        parents:insert(#parents + 1, pv);
                    end);
                end

                -- Append the processed values..
                ret = ret:append(is);
            else
                if (is_valid_key(k)) then
                    -- Prepare the key..
                    local key = '[' + serialize_key(k) + ']';

                    -- Process valid non-table values..
                    switch(type(v), {
                        ['boolean'] = function ()
                            ret = ret:append(('%s = %s;\n'):fmt((p or ''):append(key), tostring(v)));
                        end,
                        ['number'] = function ()
                            -- Handle infinite number conditions..
                            local snum = { [tostring(1/0)] = '1/0', [tostring(-1/0)] = '-1/0', [tostring(0/0)] = '0/0', };
                            ret = ret:append(('%s = %s;\n'):fmt((p or ''):append(key), snum[tostring(v)] or ("%.17g"):format(v)));
                        end,
                        ['string'] = function ()
                            ret = ret:append(('%s = %s;\n'):fmt((p or ''):append(key), ('%q'):fmt(v):gsub('\010', 'n'):gsub('\026', '\\026')));
                        end,

                        -- Consider all other Lua types as non-valid settings data..
                        [switch.default] = function ()
                            error(('[%s] Unsupported settings type detected while parsing settings file: %s -- %s'):fmt(addon.name, (p or ''):append(key), type(v)));
                        end
                    });
                end
            end
        end

        return parents, ret;
    end

    --[[
    * Loads a settings file from disk.
    *
    * @param {table} defaults - The default settings table to be used if the file fails to load or does not exist.
    * @param {string} alias - The settings file alias to use for the file name.
    * @return {table} The loaded settings.
    --]]
    load_settings = function (defaults, alias)
        local file = ('%s\\%s.lua'):fmt(settingslib.settings_path(), alias);

        -- If no settings file exists; create a new default file..
        if (not ashita.fs.exists(file)) then
            -- Save the defaults to the file..
            save_settings(defaults, alias);

            -- Create and return a copy of the defaults as the new settings table..
            return defaults:copy(true);
        end

        -- Load the settings file..
        local settings = nil;
        local status, err = pcall(function ()
            settings = loadfile(file)();
        end);

        -- Ensure the settings were loaded..
        if (status == false or type(settings) ~= 'table') then
            print(chat.header(addon.name):append(chat.warning('Failed to load a settings file: ')):append(chat.message(file)));
            if (status == false) then
                print(chat.header(addon.name):append(chat.error('Error: ' .. err)));
            elseif (type(settings) ~= 'table') then
                print(chat.header(addon.name):append(chat.error('Error: ')):append(chat.error('Settings file did not return a table.')));
            end
            print(chat.header(addon.name):append(chat.warning('Settings have been reverted to default values.')));

            -- Save the defaults to the file..
            save_settings(defaults, alias);

            -- Create and return a copy of the defaults as the new settings table..
            return defaults:copy(true);
        end

        return T(settings);
    end

    --[[
    * Saves the settings table to disk.
    *
    * @param {table} settings - The settings table to process.
    * @param {string} alias - The settings file alias to use for the file name.
    * @return {boolean} True on success, false otherwise.
    --]]
    save_settings = function (settings, alias)
        -- Create paths to the settings folder..
        ashita.fs.create_dir(settingslib.settings_path());

        -- Create path to the settings file..
        local file = ('%s\\%s.lua'):fmt(settingslib.settings_path(), alias);

        -- Process the settings table for storage on disk..
        local p, s = process_settings(settings, 'settings');

        -- Open the settings file for writing..
        local f = io.open(file, 'w+');
        if (f == nil) then
            return false;
        end

        -- Write the settings information..
        f:write('require(\'common\');\n\n');
        f:write('local settings = T{ };\n');
        p:each(function (v) f:write(('%s = T{ };\n'):fmt(v)); end);
        f:write(s);
        f:write('\nreturn settings;\n');
        f:close();

        return true;
    end
end

-- Function forwards..
local raise_events              = nil;
local process_character_switch  = nil;

do
    --[[
    * Invokes the settings registered callbacks to inform them of a settings block change.
    *
    * @param {string} alias - The alias of the settings to raise the events of.
    * @param {table} settings - The new settings table to pass to the event callbacks.
    --]]
    raise_events = function (alias, settings)
        if (settingslib.cache[alias] == nil) then
            return;
        end

        if (settingslib.cache[alias].events ~= nil) then
            settingslib.cache[alias].events:each(function (v)
                v(settings);
            end);
        end
    end

    --[[
    * Callback to process a login or logout event to handle character switching.
    *
    * @param {number} id - The characters server id. (Or 0 if logout.)
    * @param {string} name - The characters name. (Or empty of logout.)
    --]]
    process_character_switch = function (id, name)
        -- Save all current settings back to disk..
        for _, v in settingslib.cache:it() do
            save_settings(v.settings, v.alias);
        end

        -- Update the current login information..
        settingslib.logged_in   = id ~= 0;
        settingslib.server_id   = id;
        settingslib.name        = name;

        -- Reload all settings that are currently loaded for the new player..
        for _, v in settingslib.cache:it() do
            local settings = load_settings(v.defaults, v.alias);
            settings = settings:merge(v.defaults);

            -- Save the updated settings to ensure the data on disk matches the merged information..
            save_settings(settings, v.alias);

            -- Update the settings table..
            settingslib.cache[v.alias].settings = settings;

            -- Invoke callbacks registered for the settings changes..
            raise_events(v.alias, settings);
        end
    end
end

--[[
* Returns the current settings file path. (Returns the parent folder where settings would be located.)
--]]
settingslib.settings_path = function ()
    local name = 'defaults';

    if (settingslib.logged_in and #settingslib.name > 0 and settingslib.server_id > 0) then
        name = ('%s_%d'):fmt(settingslib.name, settingslib.server_id);
    end

    return ('%s\\config\\addons\\%s\\%s\\'):fmt(AshitaCore:GetInstallPath(), addon.name, name);
end

--[[
* Loads and returns a settings table.
*
* @param {table} defaults - The default settings table to be used if no settings are loaded from disk.
* @param {string} alias - The alias to store the settings within. (Optional.)
* @return {table} The settings table.
*
* @note
*   The settings alias is optional for the main settings block being loaded. If it is not given, then the alias is
*   defaulted to 'settings'. If the requested file does not exist, then the defaults passed are saved to disk for
*   that file and then returned as the settings to be used.
*
*   It is important to make use of the table returned here and to not overwrite the returned object afterward. This
*   class keeps track of the same table to be used for saving settings back to disk.
*
*   Register to the settings block events if you need to monitor for character switches and reloads of the settings.
--]]
settingslib.load = function (defaults, alias)
    -- Prepare the arguments..
    defaults = defaults or T{ };
    alias = alias or 'settings';

    -- Load the settings and merge the defaults together ensuring the block has all expected information..
    local settings = load_settings(defaults, alias);
    settings = settings:merge(defaults);

    -- Save the updated settings to ensure the data on disk matches the merged information..
    save_settings(settings, alias);

    -- Cache the settings information..
    settingslib.cache[alias] = settingslib.cache[alias] or T{ };
    settingslib.cache[alias].alias = alias;
    settingslib.cache[alias].defaults = defaults;
    settingslib.cache[alias].events = settingslib.cache[alias].events or T{ };
    settingslib.cache[alias].settings = settings;

    -- Invoke callbacks registered for the settings changes..
    raise_events(alias, settings);

    return settings;
end

--[[
* Saves a settings table to disk.
*
* @param {string} alias - The alias of the settings to save. (Optional.)
* @return {boolean} True on success, false otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.save = function (alias)
    -- Prepare the arguments..
    alias = alias or 'settings';

    -- Find the cached settings table..
    local settings = settingslib.cache[alias];
    if (settings == nil) then
        return false;
    end

    -- Save the settings..
    save_settings(settings.settings, alias);

    return true;
end

--[[
* Reloads a settings table from disk.
*
* @param {string} alias - The alias of the settings to reload. (Optional.)
* @return {boolean} True on success, false otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.reload = function (alias)
    alias = alias or 'settings';

    -- Ensure the settings entry exists..
    if (settingslib.cache[alias] == nil) then
        return false;
    end

    -- Load the settings and merge the defaults together ensuring the block has all expected information..
    local settings = load_settings(settingslib.cache[alias].defaults, alias);
    settings = settings:merge(settingslib.cache[alias].defaults);

    -- Save the updated settings to ensure the data on disk matches the merged information..
    save_settings(settings, alias);

    --- Update the settings cache..
    settingslib.cache[alias].settings = settings;

    -- Invoke callbacks registered for the settings changes..
    raise_events(alias, settings);

    return true;
end

--[[
* Resets a settings table to its defaults.
*
* @param {string} alias - The alias of the settings to reload. (Optional.)
* @return {boolean} True on success, false otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.reset = function (alias)
    alias = alias or 'settings';

    -- Ensure the settings entry exists..
    if (settingslib.cache[alias] == nil) then
        return false;
    end

    -- Default the settings..
    local settings = T{ };
    settings = settings:merge(settingslib.cache[alias].defaults:copy(true));

    -- Save the updated settings to ensure the data on disk matches the merged information..
    save_settings(settings, alias);

    --- Update the settings cache..
    settingslib.cache[alias].settings = settings;

    -- Invoke callbacks registered for the settings changes..
    raise_events(alias, settings);

    return true;
end

--[[
* Returns the settings table for the given alias.
*
* @param {string} alias - The alias of the settings to reload. (Optional.)
* @return {table} The settings table on success, nil otherwise.
*
* @note
*   The settings alias is optional. If it is not given, then the alias is defaulted to 'settings'.
--]]
settingslib.get = function (alias)
    alias = alias or 'settings';

    -- Ensure the settings entry exists..
    if (settingslib.cache[alias] == nil) then
        return nil;
    end

    return settingslib.cache[alias].settings;
end

--[[
* Registers an event callback to a settings block.
*
* @param {string} settingsAlias - The alias of the settings block to register the event for.
* @param {string} eventAlias - The alias of the event callback.
* @param {function} callback - The callback function to invoke when an event is raised.
* @return {boolean} True on success, false otherwise.
--]]
settingslib.register = function (settingsAlias, eventAlias, callback)
    assert(type(settingsAlias) == 'string', 'Invalid event settings alias; expected a string.');
    assert(type(eventAlias) == 'string', 'Invalid event alias; expected a string.');
    assert(type(callback) == 'function', 'Invalid event callback; expected a function.');

    local s = settingsAlias:lower();
    local a = eventAlias:lower();

    -- Ensure the settings entry exists..
    if (settingslib.cache[s] == nil) then
        settingslib.cache[s] = T{ };
    end

    -- Create the event table if it doesn't exist..
    if (settingslib.cache[s].events == nil) then
        settingslib.cache[s].events = T{ };
    end

    -- Store the event callback..
    settingslib.cache[s].events[a] = callback;

    return true;
end

--[[
* Unregisters an event callback from a settings block.
*
* @param {string} settingsAlias - The alias of the settings block to register the event for.
* @param {string} eventAlias - The alias of the event callback.
* @return {boolean} True on success, false otherwise.
--]]
settingslib.unregister = function (settingsAlias, eventAlias)
    assert(type(settingsAlias) == 'string', 'Invalid event settings alias; expected a string.');
    assert(type(eventAlias) == 'string', 'Invalid event alias; expected a string.');

    local s = settingsAlias:lower();
    local a = eventAlias:lower();

    -- Ensure the settings entry exists..
    if (settingslib.cache[s] == nil) then
        return false;
    end

    -- Unset the event callback..
    if (settingslib.cache[s].events ~= nil) then
        settingslib.cache[s].events[a] = nil;
    end

    return true;
end

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', '__settings_packet_in_cb', function (e)
    -- Packet: Zone Enter
    if (e.id == 0x000A) then
        if (not settingslib.logged_in or settingslib.server_id == 0 or settingslib.name:empty()) then
            local serverId = struct.unpack('L', e.data, 0x04 + 0x01);
            local name = struct.unpack('c16', e.data, 0x84 + 0x01);

            -- Update the settings for the login event..
            process_character_switch(serverId, name:trim('\0'));
        end
        return;
    end

    -- Packet: Zone Exit
    if (e.id == 0x000B) then
        if (struct.unpack('b', e.data, 0x04 + 0x01) == 1 and settingslib.logged_in) then
            -- Update the settings for the logout event..
            process_character_switch(0, '');
        end
        return;
    end
end);

--[[
* Settings library preparations.
*
* Ensures the settings folder for addons is created and checks for an already logged in state when loaded.
* If logged in, will update the library with the current players information.
--]]
do
    -- Create the parent addons settings folder if it does not already exist..
    local path = ('%s\\config\\addons\\'):fmt(AshitaCore:GetInstallPath());
    if (not ashita.fs.exists(path)) then
        ashita.fs.create_dir(path);
    end

    -- Check if the player is logged in already..
    local loginStatus = AshitaCore:GetMemoryManager():GetPlayer():GetLoginStatus();
    if (loginStatus == 2) then
        -- Get the player entity..
        local player = GetPlayerEntity();
        if (player ~= nil) then
            process_character_switch(player.ServerId, player.Name);
        end
    end
end

--[[
* Settings library forwards.
*
* Allows other addons and libraries to make use of functions this library implements.
--]]
settingslib.process = process_settings;

-- Return the library table..
return settingslib;