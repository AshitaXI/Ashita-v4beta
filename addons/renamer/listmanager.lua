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

-- ListManager Variables
local ListManager = T{
    renames = T{ },
    saved_lists = T{ },
};

--[[
* Adds an entry to the current renamer list.
*
* @param {number} zoneid - The zone id of the entity being renamed.
* @param {number} id - The server id of the entity.
* @param {string} name - The new name to use for the entity.
--]]
function ListManager.add_rename(zoneid, id, name)
    if (ListManager.renames[zoneid] == nil) then
        ListManager.renames[zoneid] = T{ };
    end

    for _, v in pairs(ListManager.renames[zoneid]) do
        if (v[1] == id) then
            v[2] = name;
            return;
        end
    end

    ListManager.renames[zoneid]:append({ id, name });
end

--[[
* Deletes an entry from the current renamer list.
*
* @param {number} zoneid - The zone id of the entity.
* @param {number} id - The server id of the entity.
--]]
function ListManager.delete_rename(zoneid, id)
    local renames = ListManager.renames[zoneid];
    if (renames == nil) then
        return;
    end

    for _, v in pairs(ListManager.renames[zoneid]) do
        if (v[1] == id) then
            ListManager.renames[zoneid]:delete(v);
            return;
        end
    end
end

--[[
* Deletes all rename entries for the given zone.
*
* @param {number} zoneid - The zone id of the renames to remove.
--]]
function ListManager.clear_renames(zoneid)
    ListManager.renames[zoneid] = nil;
end

--[[
* Refreshes the available lists.
*
* Note: This does not validate the file is usable with this addon.
*       It simply lists all found .lua files in the renamer config folder.
--]]
function ListManager.refresh_saved_lists()
    ListManager.saved_lists = T{ };

    local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'renamer');
    if (not ashita.fs.exists(path)) then
        ashita.fs.create_dir(path);
        return;
    end

    local files = ashita.fs.get_dir(path, '.*.lua', true);
    if (files == nil) then
        return;
    end

    T(files):each(function (v) ListManager.saved_lists:append(v); end);
end

--[[
* Saves the current renamer data to a new renamer list file.
*
* @param {string} name - The name of the new renamer list file to save.
* @return {boolean} True on success, false otherwise.
--]]
function ListManager.save_list_new(name)
    -- Validate and update the file name..
    if (name == nil or name:len() < 2) then
        return false;
    end
    name = name .. '.lua';

    -- Build a path to the file and ensure it does not exist already..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'renamer', name);
    if (ashita.fs.exists(path)) then
        return false;
    end

    -- Open and save the new list..
    local f = io.open(path, 'w+');
    if (f == nil) then
        return false;
    end

    -- Save the file with a newer format than the previous renamer addon..
    f:write('require(\'common\');\n\n');
    f:write('return T{\n');
    T(ListManager.renames):each(function (v, k)
        f:write(('    [%d] = T{\n'):fmt(k));
        T(v):each(function (vv, _)
            f:write(('        T{ %s, %s },\n'):fmt(vv[1], ('%q'):fmt(vv[2]):gsub('\010', 'n'):gsub('\026', '\\026')));
        end);
        f:write('    },\n');
    end);
    f:write('};\n');
    f:close();

    -- Update the saved lists..
    ListManager.refresh_saved_lists();

    return true;
end

--[[
* Saves the current renamer data an existing renamer list file.
*
* @param {number} The index of the existing renamer list to overwrite.
* @return {boolean} True on success, false otherwise.
--]]
function ListManager.save_list_existing(index)
    if (index < 0 or #ListManager.saved_lists == 0) then
        return false;
    end

    local name = ListManager.saved_lists[index + 1];
    if (name == nil or name:len() < 1) then
        return false;
    end

    -- Build a path to the file..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'renamer', name);

    -- Open and save the new list..
    local f = io.open(path, 'w+');
    if (f == nil) then
        return false;
    end

    -- Save the file with a newer format than the previous renamer addon..
    f:write('require(\'common\');\n\n');
    f:write('return T{\n');
    T(ListManager.renames):each(function (v, k)
        f:write(('    [%d] = T{\n'):fmt(k));
        T(v):each(function (vv, _)
            f:write(('        T{ %s, %s },\n'):fmt(vv[1], ('%q'):fmt(vv[2]):gsub('\010', 'n'):gsub('\026', '\\026')));
        end);
        f:write('    },\n');
    end);
    f:write('};\n');
    f:close();

    -- Update the saved lists..
    ListManager.refresh_saved_lists();

    return true;
end

--[[
* Loads the given selected saved lists contents.
*
* @param {number} index - The index of the renamer list to load.
* @param {boolean} merged - Flag if the renamer list should be merged into the already loaded data.
* @return {boolean, string} True on success, false otherwise. Error message on false returns.
--]]
function ListManager.load_list(index, merged)
    -- Ensure the previous v3 renamer list global is not valid before trying to load..
    ObjectList = nil;

    if (index < 0 or #ListManager.saved_lists == 0) then
        return false, 'Invalid index.';
    end

    merged = merged or false;

    local name = ListManager.saved_lists[index + 1];
    if (name == nil or name:len() < 1) then
        return false, 'Invalid list selected.';
    end

    -- Build a path to the file and ensure it exists..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'renamer', name);
    if (not ashita.fs.exists(path)) then
        return false, 'Invalid renamer list file selected; file is missing.';
    end

    -- Load the renamer list file..
    local ret = T{ };
    local status, err = pcall(function ()
        ret = loadfile(path)();
    end);

    if (not status or err) then
        return false, 'Invalid renamer list file format.';
    end

    -- Handle reading older v3 renamer list files..
    if (ret == nil and ObjectList ~= nil) then
        ret = ObjectList;
        ObjectList = nil;
    end

    -- Ensure a valid table was returned..
    if (type(ret) ~= 'table') then
        return false, 'Invalid renamer list file.';
    end

    -- Validate the table data..
    T(ret):each(function (v, k)
        -- Check the key and value are the proper types..
        if (type(k) ~= 'number' or type(v) ~= 'table') then
            return false, 'Invalid renamer list file data detected.';
        end

        -- Check the value data..
        T(v):each(function (vv, _)
            if (type(vv) ~= 'table') then
                return false, 'Invalid renamer list file data detected.';
            end
            if (#vv ~= 2 or type(vv[1]) ~= 'number' or type(vv[2]) ~= 'string') then
                return false, 'Invalid renamer list file data detected.';
            end
        end);
    end);

    -- Update the renamer data..
    if (merged) then
        T(ret):each(function (v, k)
            T(v):each(function (vv, _)
                ListManager.add_rename(k, vv[1], vv[2]);
            end);
        end);
    else
        ListManager.renames = T(ret);
    end

    return true;
end

--[[
* Deletes the given selected saved list.
*
* @param {number} index - The index of the renamer list to delete.
* @return {boolean} True on success, false otherwise.
--]]
function ListManager.delete_list(index)
    if (index < 0 or #ListManager.saved_lists == 0) then
        return false;
    end

    local name = ListManager.saved_lists[index + 1];
    if (name == nil) then
        return false;
    end

    -- Build a path to the file and ensure it exists..
    local path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'renamer', name);
    if (not ashita.fs.exists(path)) then
        return false;
    end

    -- Delete the list..
    ashita.fs.remove(path);

    -- Update the saved lists..
    ListManager.refresh_saved_lists();
    return true;
end

--[[
* Deletes all saved renamer lists.
--]]
function ListManager.delete_all_lists()
    -- Build a path to the lists folder..
    local path = ('%s\\config\\addons\\%s\\'):fmt(AshitaCore:GetInstallPath(), 'renamer');
    if (not ashita.fs.exists(path)) then
        ashita.fs.create_dir(path);
        return;
    end

    local files = ashita.fs.get_dir(path, '.*.lua', true);
    if (files == nil) then
        return;
    end

    T(files):each(function (v)
        path = ('%s\\config\\addons\\%s\\%s'):fmt(AshitaCore:GetInstallPath(), 'renamer', v);
        if (ashita.fs.exists(path)) then
            ashita.fs.remove(path);
        end
    end);

    -- Update the saved lists..
    ListManager.refresh_saved_lists();
    return true;
end

-- Return the ListManager table..
return ListManager;