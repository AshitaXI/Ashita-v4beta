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
local settings = require('settings');

-- ListManager Variables
local listmanager = T{
    watched_items       = T{ },
    watched_keyitems    = T{ },
    saved_lists         = T{ },
};

--[[
* Returns the number of currently watched items.
*
* @return {number} The number of watched items.
--]]
function listmanager.watched_items_count()
    return #listmanager.watched_items;
end

--[[
* Returns the number of currently watched key items.
*
* @return {number} The number of watched key items.
--]]
function listmanager.watched_keyitems_count()
    return #listmanager.watched_keyitems;
end

--[[
* Returns the number of currently watched items and key items combined.
*
* @return {number} The number of total watched items.
--]]
function listmanager.watched_count()
    return #listmanager.watched_items + #listmanager.watched_keyitems;
end

--[[
* Adds an item to the watch list.
*
* @param {number} id - The item id to add to the watch list.
* @return {boolean, string} True on success, false otherwise. Error message on false returns.
--]]
function listmanager.add_watched_item(id)
    if (id == nil) then
        return false, 'Invalid item id.';
    end

    if (listmanager.watched_items:any(function (v) return v[1] == id; end)) then
        return false, 'Item is already being watched.';
    end

    local item = AshitaCore:GetResourceManager():GetItemById(id);
    if (item == nil or item.Name[1] == nil or item.Name[1]:len() < 2) then
        return false, 'Invalid item id; item not found.';
    end

    listmanager.watched_items:append({ id, item.Name[1] });
    return true;
end

--[[
* Removes an item from the watch list.
*
* @param {number} id - The item id to remove from the watch list.
* @return {boolean, string} True on success, false otherwise. Error message on false returns.
--]]
function listmanager.delete_watched_item(id)
    if (id == nil) then
        return false, 'Invalid item id.';
    end

    for x = #listmanager.watched_items, 1, -1 do
        if (listmanager.watched_items[x][1] == id) then
            table.remove(listmanager.watched_items, x);
            return true;
        end
    end
    return false, 'Item is not being watched.';
end

--[[
* Clears the watched item list.
--]]
function listmanager.clear_watched_items()
    listmanager.watched_items = T{ };
end

--[[
* Adds a key item to the watch list.
*
* @param {number} id - The key item id to add to the watch list.
* @return {boolean, string} True on success, false otherwise. Error message on false returns.
--]]
function listmanager.add_watched_keyitem(id)
    if (id == nil) then
        return false, 'Invalid key item id.';
    end

    if (listmanager.watched_keyitems:any(function (v) return v[1] == id; end)) then
        return false, 'Key item is already being watched.';
    end

    local name = AshitaCore:GetResourceManager():GetString('keyitems.names', id);
    if (name == nil or name:len() < 2) then
        return false, 'Invalid key item id; key item not found.';
    end

    listmanager.watched_keyitems:append({ id, name });
    return true;
end

--[[
* Removes a key item from the watch list.
*
* @param {number} id - The key item id to remove from the watch list.
* @return {boolean, string} True on success, false otherwise. Error message on false returns.
--]]
function listmanager.delete_watched_keyitem(id)
    if (id == nil) then
        return false, 'Invalid key item id.';
    end

    for x = #listmanager.watched_keyitems, 1, -1 do
        if (listmanager.watched_keyitems[x][1] == id) then
            table.remove(listmanager.watched_keyitems, x);
            return true;
        end
    end
    return false, 'Key item is not being watched.';
end

--[[
* Clears the watched key item list.
--]]
function listmanager.clear_watched_keyitems()
    listmanager.watched_keyitems = T{ };
end

--[[
* Returns a list of items that contain the given partial name.
*
* @param {string} name - The partial item name to look for.
* @return {T} Table containing any found matches.
--]]
function listmanager.find_items(name)
    local items = T{ };

    for x = 0, 65535 do
        local item = AshitaCore:GetResourceManager():GetItemById(x);
        if (item ~= nil and item.Name[1] ~= nil and item.Name[1]:len() > 1) then
            if (item.Name[1]:lower():contains(name:lower())) then
                items:append({ x, item.Name[1] });
            end
        end
    end

    return items;
end

--[[
* Returns a list of key items that contain the given partial name.
*
* @param {string} name - The partial key item name to look for.
* @return {T} Table containing any found matches.
--]]
function listmanager.find_keyitems(name)
    local items = T{ };

    for x = 0, 65535 do
        local n = AshitaCore:GetResourceManager():GetString('keyitems.names', x);
        if (n ~= nil and n:len() > 1) then
            if (n:lower():contains(name:lower())) then
                items:append({ x, n });
            end
        end
    end

    return items;
end

--[[
* Refreshes the saved lists table.
--]]
function listmanager.refresh_saved_lists()
    listmanager.saved_lists = T{ };

    local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'itemwatch');
    if (not ashita.fs.exists(path)) then
        ashita.fs.create_dir(path);
        return;
    end

    local files = ashita.fs.get_dir(path, '.*.lst', true);
    if (files == nil) then
        return;
    end

    T(files):each(function (v) listmanager.saved_lists:append(v); end);
end

--[[
* Saves the current watched items and key items to a new list file.
*
* @param {string} name - The name of the new list file to save.
* @return {boolean} True on success, false otherwise.
--]]
function listmanager.save_list_new(name)
    -- Validate and update the file name..
    if (name == nil or name:len() < 2) then
        return false;
    end
    name = name .. '.lst';

    -- Build a path to the file and ensure it does not exist already..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'itemwatch', name);
    if (ashita.fs.exists(path)) then
        return false;
    end

    -- Create the new settings object to be saved..
    local t = T{ i = listmanager.watched_items, k = listmanager.watched_keyitems, };

    -- Serialize the settings table for saving..
    local p, s = settings.process(t, 'settings');

    -- Open and save the new list..
    local f = io.open(path, 'w+');
    if (f == nil) then
        return false;
    end

    f:write('require(\'common\');\n\n');
    f:write('local settings = T{ };\n');
    p:each(function (v) f:write(('%s = T{ };\n'):fmt(v)); end);
    f:write(s);
    f:write('\nreturn settings;\n');
    f:close();

    -- Update the saved lists..
    listmanager.refresh_saved_lists();

    return true;
end

--[[
* Saves the current watched items and key items to an existing list file.
*
* @param {number} The index of the existing list to overwrite.
* @return {boolean} True on success, false otherwise.
--]]
function listmanager.save_list_existing(index)
    if (index < 0 or #listmanager.saved_lists == 0) then
        return false;
    end

    local name = listmanager.saved_lists[index + 1];
    if (name == nil or name:len() < 1) then
        return false;
    end

    -- Build a path to the file..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'itemwatch', name);

    -- Create the new settings object to be saved..
    local t = T{ i = listmanager.watched_items, k = listmanager.watched_keyitems, };

    -- Serialize the settings table for saving..
    local p, s = settings.process(t, 'settings');

    -- Open and save the new list..
    local f = io.open(path, 'w+');
    if (f == nil) then
        return false;
    end

    f:write('require(\'common\');\n\n');
    f:write('local settings = T{ };\n');
    p:each(function (v) f:write(('%s = T{ };\n'):fmt(v)); end);
    f:write(s);
    f:write('\nreturn settings;\n');
    f:close();

    -- Update the saved lists..
    listmanager.refresh_saved_lists();

    return true;
end

--[[
* Loads the given selected saved lists contents.
*
* @param {number} index - The index of the list to load.
* @param {boolean} merged - Flag if the list should be merged into the already loaded data.
* @return {boolean, string} True on success, false otherwise. Error message on false returns.
--]]
function listmanager.load_list(index, merged)
    if (index < 0 or #listmanager.saved_lists == 0) then
        return false, 'Invalid index.';
    end

    merged = merged or false;

    local name = listmanager.saved_lists[index + 1];
    if (name == nil or name:len() < 2) then
        return false, 'Invalid list selected.';
    end

    -- Build a path to the file and ensure it exists..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'itemwatch', name);
    if (not ashita.fs.exists(path)) then
        return false, 'Invalid list selected; list file is missing.';
    end

    -- Load the list settings..
    local t = T{ };
    local status, err = pcall(function ()
        t = loadfile(path)();
    end);

    -- Ensure the list settings are valid..
    if (not status or err or t['i'] == nil or t['k'] == nil) then
        return false, 'Invalid list file format.';
    end

    -- Update the lists..
    if (merged) then
        t['i']:each(function (v) listmanager.add_watched_item(v[1]); end);
        t['k']:each(function (v) listmanager.add_watched_keyitem(v[1]); end);
    else
        listmanager.watched_items = t['i'];
        listmanager.watched_keyitems = t['k'];
    end

    return true;
end

--[[
* Deletes the given selected saved list.
*
* @param {number} index - The index of the list to delete.
* @return {boolean} True on success, false otherwise.
--]]
function listmanager.delete_list(index)
    if (index < 0 or #listmanager.saved_lists == 0) then
        return false;
    end

    local name = listmanager.saved_lists[index + 1];
    if (name == nil) then
        return false;
    end

    -- Build a path to the file and ensure it exists..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'itemwatch', name);
    if (not ashita.fs.exists(path)) then
        return false;
    end

    -- Delete the list..
    ashita.fs.remove(path);

    -- Update the saved lists..
    listmanager.refresh_saved_lists();
    return true;
end

--[[
* Deletes all saved lists.
--]]
function listmanager.delete_all_lists()
    -- Build a path to the lists folder..
    local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'itemwatch');
    if (not ashita.fs.exists(path)) then
        ashita.fs.create_dir(path);
        return;
    end

    local files = ashita.fs.get_dir(path, '.*.lst', true);
    if (files == nil) then
        return;
    end

    T(files):each(function (v)
        path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'itemwatch', v);
        if (ashita.fs.exists(path)) then
            ashita.fs.remove(path);
        end
    end);

    -- Update the saved lists..
    listmanager.refresh_saved_lists();
    return true;
end

-- Return the ListManager object..
return listmanager;
