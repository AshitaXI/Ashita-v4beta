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
local chat = require('chat');
local dats = require('ffxi.dats');
local imgui = require('imgui');

-- Renamer Editor Variables
local editor = T{
    lstMgr = require('listmanager'),
    npcs = T{ },

    -- Main Window
    is_open = { false, },

    -- Tabs
    tab_zone = T{
        renames_selected = { -1, },
        name_buffer = { '' },
        name_buffer_size = 28,
        popup_name_buffer = { '' },
        popup_name_buffer_size = 28,
        npcs_selected = { -1, },
        scroll_to_npc = false,
    },
    tab_renames = T{
        selected = { -1, },
        name_buffer = { '' },
        name_buffer_size = 28,
    },
    tab_lists = T{
        list_selected = { -1, },
        name_buffer = { '' },
        name_buffer_size = 256,
    },
};

-- Color Variables
local colors = {
    error = { 1.0, 0.4, 0.4, 1.0 },
    header = { 1.0, 0.65, 0.26, 1.0 },
    warn = { 0.9, 0.9, 0.0, 1.0 },
};

--[[
* Updates the npc list with the current zones information.
*
* @param {number} zid - The zone id to load the npcs of.
* @param {number} zsubid - The zone sub id to load the npcs of.
* @return {boolean} True on success, false otherwise.
--]]
function editor.update_zone_npcs(zid, zsubid)
    -- Clear the previous npc information..
    editor.npcs = T{ };

    -- Obtain the npc list dat for the given zone..
    local file = dats.get_zone_npclist(zid, zsubid);
    if (file == nil or file:len() == 0) then
        return false;
    end

    -- Open the DAT for reading..
    local f = io.open(file, 'rb');
    if (f == nil) then
        return false;
    end

    -- Obtain the file size..
    local size = f:seek('end');
    f:seek('set', 0);

    -- Validate the file by its size and expected entry count alignment..
    if (size == 0 or ((size - math.floor(size / 0x20) * 0x20) ~= 0)) then
        f:close();
        return false;
    end

    -- Parse the file for npc entries..
    for x = 0, ((size / 0x20) - 0x01) do
        local data = f:read(0x20);
        local name, id = struct.unpack('c28L', data);
        table.insert(editor.npcs, { id, bit.band(id, 0x0FFF), name });
    end

    f:close();
    return true;
end

--[[
* Loads the editor, preparing it for usage.
--]]
function editor.load()
    -- Update the zone npc list..
    editor.update_zone_npcs(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0), 0);
end

--[[
* Unloads the editor, cleaning up any of its resources.
--]]
function editor.unload()

end

--[[
* Renders the current zone rename editor tab elements.
--]]
function editor.render_tab_zonerenames()
    -- Obtain the current zone rename list..
    local zid = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
    local renames = editor.lstMgr.renames[zid] or T{ };

    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Current Zone Renames');
        imgui.BeginChild('leftpane', { 275, -imgui.GetFrameHeightWithSpacing(), }, true);
            for x = 0, #renames - 1 do
                if (x < #renames) then
                    imgui.PushID(x);
                    local name = ('[%04d] %s##%d'):fmt(bit.band(renames[x + 1][1], 0x0FFF), renames[x + 1][2], renames[x + 1][1]);
                    if (imgui.Selectable(name, editor.tab_zone.renames_selected[1] == x)) then
                        editor.tab_zone.renames_selected[1] = x;
                    end
                    if (imgui.IsItemHovered()) then
                        imgui.BeginTooltip();
                        imgui.Text(('Server Id: %d'):fmt(renames[x + 1][1]));
                        imgui.EndTooltip();
                    end

                    -- Handle item double-click.. (delete)
                    if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                        if (editor.tab_zone.renames_selected[1] >= 0) then
                            local r = renames[editor.tab_zone.renames_selected[1] + 1];
                            if (r ~= nil) then
                                editor.tab_zone.renames_selected[1] = -1;
                                editor.lstMgr.delete_rename(zid, r[1]);
                            end
                        end
                    end

                    -- Handle item right-click.. (editor)
                    if (imgui.BeginPopupContextItem('')) then
                        editor.tab_zone.popup_name_buffer[1] = renames[x + 1][2];
                        if (imgui.InputText('Name', editor.tab_zone.popup_name_buffer, editor.tab_zone.popup_name_buffer_size)) then
                            renames[x + 1][2] = editor.tab_zone.popup_name_buffer[1];
                        end
                        if (imgui.Button('Delete')) then
                            imgui.CloseCurrentPopup();

                            editor.lstMgr.delete_rename(zid, renames[x + 1][1]);
                            editor.tab_zone.popup_name_buffer[1] = '';
                        end
                        imgui.EndPopup();
                    end

                    imgui.PopID(x);
                end
            end
        imgui.EndChild();

        if (imgui.Button('Remove Selected')) then
            if (editor.tab_zone.renames_selected[1] >= 0) then
                local r = renames[editor.tab_zone.renames_selected[1] + 1];
                if (r ~= nil) then
                    editor.tab_zone.renames_selected[1] = -1;
                    editor.lstMgr.delete_rename(zid, r[1]);
                end
            end
        end
        imgui.SameLine();
        if (imgui.Button('Remove All')) then
            editor.tab_zone.renames_selected[1] = -1;
            editor.lstMgr.clear_renames(zid);
        end
    imgui.EndGroup();
    imgui.SameLine();

    -- Right Side (Zone Entity List)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Zone Entities List');
        imgui.BeginChild('rightpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, true);
            imgui.InputText('New Name', editor.tab_zone.name_buffer, editor.tab_zone.name_buffer_size, ImGuiInputTextFlags_EnterReturnsTrue);
            imgui.ShowHelp('Used to set the new name of the selected entity.\nAlso updates the existing name if the npc is being renamed already.');
            if (imgui.Button('Add / Update Selected', { -1, 0 })) then
                if (editor.tab_zone.npcs_selected[1] >= 0) then
                    local r = editor.npcs[editor.tab_zone.npcs_selected[1] + 1];
                    if (r ~= nil) then
                        editor.lstMgr.add_rename(zid, r[1], editor.tab_zone.name_buffer[1]:trim('\0'));
                    end
                end
            end
            imgui.Separator();
            imgui.BeginChild('rightpane_npcs');
                for x = 0, #editor.npcs - 1 do
                    if (editor.npcs[x + 1][2] ~= 0) then
                        local name = ('[%04d] %s##npc_%d'):fmt(editor.npcs[x + 1][2], editor.npcs[x + 1][3], editor.npcs[x + 1][1]);
                        if (imgui.Selectable(name, editor.tab_zone.npcs_selected[1] == x)) then
                            editor.tab_zone.npcs_selected[1] = x;
                        end
                        if (editor.tab_zone.npcs_selected[1] == x and editor.tab_zone.scroll_to_npc == true) then
                            imgui.SetScrollHereY(0.5);
                            editor.tab_zone.scroll_to_npc = false;
                        end
                        if (imgui.IsItemHovered()) then
                            imgui.BeginTooltip();
                            imgui.Text(('Server Id: %d'):fmt(editor.npcs[x + 1][1]));
                            imgui.EndTooltip();
                        end
                    end
                end
            imgui.EndChild();
        imgui.EndChild();

        if (imgui.Button('Refresh Entities')) then
            editor.update_zone_npcs(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0), 0);
        end
        imgui.SameLine();
        if (imgui.Button('Find Current Target')) then
            -- Obtain and validate the players current target is an npc..
            local target = AshitaCore:GetMemoryManager():GetTarget():GetServerId(0);
            if (target == 0 or target == 0x4000000 or bit.band(target, 0x0FFF) >= 1024) then
                print(chat.header(addon.name):append(chat.error('Invalid target; ensure you are targeting a non-player entity!')));
                return;
            end

            -- Find the entity in the zone list..
            local idx = 0;
            editor.npcs:each(function (v, _)
                if (v[1] == target) then
                    editor.tab_zone.npcs_selected[1] = idx;
                    editor.tab_zone.scroll_to_npc = true;
                end
                idx = idx + 1;
            end);
        end
    imgui.EndGroup();
end

--[[
* Renders the current renames list editor tab elements.
--]]
function editor.render_tab_renames()
    imgui.TextColored(colors.header, 'Current List Renames');
    imgui.BeginChild('leftpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, false);
        if (imgui.BeginTable('##renamer_list', 4, bit.bor(ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersH, ImGuiTableFlags_BordersV, ImGuiTableFlags_ContextMenuInBody, ImGuiTableFlags_ScrollX, ImGuiTableFlags_ScrollY, ImGuiTableFlags_SizingFixedFit))) then
            imgui.TableSetupColumn('Zone Id', ImGuiTableColumnFlags_WidthFixed, 50.0, 0);
            imgui.TableSetupColumn('Target Index', ImGuiTableColumnFlags_WidthFixed, 90.0, 0);
            imgui.TableSetupColumn('Server Id', ImGuiTableColumnFlags_WidthFixed, 70.0, 0);
            imgui.TableSetupColumn('Rename', ImGuiTableColumnFlags_WidthStretch, 0, 0);
            imgui.TableSetupScrollFreeze(0, 1);
            imgui.TableHeadersRow();

            local idx = 0;
            editor.lstMgr.renames:sortkeys():each(function (v, _)
                local npcs = T(editor.lstMgr.renames[v]);
                npcs:each(function (vv, _)
                    imgui.PushID(idx);
                    imgui.TableNextRow();
                    imgui.TableSetColumnIndex(0);

                    -- Setup the whole row as selectable..
                    if (imgui.Selectable(('%d##%d'):fmt(v, vv[1]), vv[1] == editor.tab_renames.selected[1], bit.bor(ImGuiSelectableFlags_SpanAllColumns, ImGuiSelectableFlags_AllowItemOverlap), { 0, 0 })) then
                        editor.tab_renames.selected[1] = vv[1];
                    end

                    -- Handle item hover..
                    if (imgui.IsItemHovered()) then
                        local zname = AshitaCore:GetResourceManager():GetString('zones.names', v);
                        imgui.SetTooltip(('Zone: %s'):fmt(zname or '(Unknown Zone)'));
                    end

                    -- Handle item right-click.. (editor)
                    if (imgui.BeginPopupContextItem('')) then
                        editor.tab_renames.name_buffer[1] = vv[2];
                        if (imgui.InputText('Name', editor.tab_renames.name_buffer, editor.tab_renames.name_buffer_size)) then
                            vv[2] = editor.tab_renames.name_buffer[1];
                        end
                        if (imgui.Button('Delete')) then
                            imgui.CloseCurrentPopup();

                            editor.lstMgr.delete_rename(v, vv[1]);
                            editor.tab_renames.name_buffer[1] = '';
                        end
                        imgui.EndPopup();
                    end

                    imgui.TableNextColumn();
                    imgui.Text(('%d'):fmt(bit.band(vv[1], 0x0FFF)));
                    imgui.TableNextColumn();
                    imgui.Text(('%d'):fmt(vv[1]));
                    imgui.TableNextColumn();
                    imgui.Text(vv[2]);

                    imgui.PopID();
                    idx = idx + 1;
                end);
            end);
            imgui.EndTable();
        end
    imgui.EndChild();

    if (imgui.Button('Delete All Renames')) then
        imgui.OpenPopup('###DeleteAllRenames');
    end

    -- Popups..
    switch(imgui.DisplayPopup('Are you sure?', 'DeleteAllRenames', function ()
        imgui.Text('This will delete all current renames for every zone listed above.\nAre you sure?');
        imgui.NewLine();
        imgui.TextColored(colors.warn, 'This cannot be undone! Use with caution!');
    end, PopupButtonsOkCancel), {
        [PopupResultOk] = function ()
            editor.lstMgr.renames = T{ };
        end
    });
end

--[[
* Renders the lists editor tab elements.
--]]
function editor.render_tab_lists()
    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Saved Renamer Lists');
        imgui.BeginChild('leftpane', { 230, -imgui.GetFrameHeightWithSpacing(), }, true);
            local lists = editor.lstMgr.saved_lists;
            for x = 0, #lists - 1 do
                if (x < #lists) then
                    local name = ('%s##%d'):fmt(lists[x + 1], x);
                    if (imgui.Selectable(name, editor.tab_lists.list_selected[1] == x)) then
                        editor.tab_lists.list_selected[1] = x;
                    end
                end

                -- Handle item double-click.. (load)
                if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                    if (editor.tab_lists.list_selected[1] >= 0) then
                        local ret = editor.lstMgr.load_list:packed()(editor.tab_lists.list_selected[1], false);
                        if (not ret[1]) then
                            print(chat.header(addon.name):append(chat.error('Failed to load renamer list; \'%s\'')):fmt(ret[2]));
                        end
                    end
                end
            end

            -- Display no lists loaded message..
            if (#lists <= 0) then
                imgui.PushTextWrapPos();
                imgui.TextColored(colors.error, 'No lists loaded or found!');
                imgui.TextColored(colors.warn, 'Click the \'Refresh\' button below to try and update this list.');
                imgui.PopTextWrapPos();
            end
        imgui.EndChild();

        -- Left side buttons..
        if (imgui.Button('Refresh Saved Lists')) then
            editor.lstMgr.refresh_saved_lists();
        end
        imgui.ShowHelp('Refreshes the saved list shown above.');
    imgui.EndGroup();
    imgui.SameLine();

    -- Right Side (Saved Lists Manager)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Saved Lists Manager');
        imgui.BeginChild('rightpane', { -1, -imgui.GetFrameHeightWithSpacing() }, true);
            imgui.PushItemWidth(225);
            imgui.InputText('Name', editor.tab_lists.name_buffer, editor.tab_lists.name_buffer_size);
            imgui.PopItemWidth();
            imgui.ShowHelp('The name of the renamer file to save.\n(Only used when saving to new file!)\n\nDo not include the file extension, it will be added automatically.');
            if (imgui.Button('Save To New File', { 225, 0 })) then
                editor.lstMgr.save_list_new(editor.tab_lists.name_buffer[1]:trim('\0'));
            end
            imgui.ShowHelp('Saves the current renames to a new renamer list using the name given above. If the list already exists, it will not be overwritten.');
            if (imgui.Button('Save To Existing File', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    editor.lstMgr.save_list_existing(editor.tab_lists.list_selected[1]);
                end
            end
            imgui.ShowHelp('Saves the current renames to an existing file; selected on the left. (Does not use the name above!)');
            imgui.NewLine();
            imgui.Separator();
            if (imgui.Button('Load Selected List', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    local ret = editor.lstMgr.load_list:packed()(editor.tab_lists.list_selected[1], false);
                    if (not ret[1]) then
                        print(chat.header(addon.name):append(chat.error('Failed to load renamer list; \'%s\'')):fmt(ret[2]));
                    end
                end
            end
            imgui.ShowHelp('Loads the selected renamer list on the left. (Overwrites any currently set renames.)');
            if (imgui.Button('Load Selected List (Merged)', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    local ret = editor.lstMgr.load_list:packed()(editor.tab_lists.list_selected[1], true);
                    if (not ret[1]) then
                        print(chat.header(addon.name):append(chat.error('Failed to load renamer list; \'%s\'')):fmt(ret[2]));
                    end
                end
            end
            imgui.ShowHelp('Loads the selected renamer list on the left. (Merges the lists contents with the currently set renames.)');
            imgui.NewLine();
            imgui.Separator();
            if (imgui.Button('Delete Selected File', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    editor.lstMgr.delete_list(editor.tab_lists.list_selected[1]);
                    editor.tab_lists.list_selected[1] = -1;
                end
            end
            imgui.ShowHelp('Deletes the selected renamer list on the left.\n\n(Warning: This deletes the file on disk! This cannot be undone!)');
            if (imgui.Button('Delete All Renamer Files', { 225, 0 })) then
                imgui.OpenPopup('###DeleteAllSavedLists');
            end
            switch(imgui.DisplayPopup('Are you sure?', 'DeleteAllSavedLists', function ()
                imgui.Text('This will delete all currently saved renamer lists on disk.\nAre you sure?');
                imgui.NewLine();
                imgui.TextColored(colors.warn, 'This cannot be undone! Use with caution!');
            end, PopupButtonsOkCancel), {
                [PopupResultOk] = function ()
                    editor.lstMgr.delete_all_lists();
                    editor.tab_lists.list_selected[1] = -1;
                end
            });
            imgui.ShowHelp('Deletes all saved renamer list files.\n\n(Warning: This deletes all saved renamer list files on disk! This cannot be undone!)');
        imgui.EndChild();
    imgui.EndGroup();
end

--[[
* Event called when the addon is processing incoming packets.
--]]
function editor.packet_in(e)
    -- Packet: Zone Enter
    if (e.id == 0x000A) then
        -- Ignore mog house zoning..
        if (struct.unpack('b', e.data_modified, 0x80 + 0x01) == 1) then
            return;
        end

        -- Obtain the zone id from the packet..
        local zid = struct.unpack('H', e.data_modified, 0x30 + 0x01);
        local zsubid = struct.unpack('H', e.data_modified, 0x9E + 0x01);

        -- Update the zone npc list..
        editor.update_zone_npcs(zid, zsubid);
        return;
    end

    -- Packet: Zone Leave
    if (e.id == 0x000B) then
        editor.npcs:clear();
        return;
    end
end

--[[
* Event called when the Direct3D device is beginning a scene.
--]]
function editor.beginscene()
    -- Obtain the players current zone rename list..
    local renames = editor.lstMgr.renames[AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)];
    if (renames == nil) then
        return;
    end

    -- Rename entities..
    T(renames):each(function (v, k)
        local idx = bit.band(v[1], 0x0FFF);
        AshitaCore:GetMemoryManager():GetEntity():SetName(idx, v[2]);
    end);
end

--[[
* Event called when the Direct3D device is presenting a scene.
--]]
function editor.render()
    if (not editor.is_open[1]) then
        return;
    end

    -- Render the Renamer editor..
    imgui.SetNextWindowSize({ 600, 400, });
    imgui.SetNextWindowSizeConstraints({ 600, 400, }, { FLT_MAX, FLT_MAX, });
    if (imgui.Begin('Renamer', editor.is_open, ImGuiWindowFlags_NoResize)) then
        if (imgui.BeginTabBar('##renamer_tabbar', ImGuiTabBarFlags_NoCloseWithMiddleMouseButton)) then
            if (imgui.BeginTabItem('Current Zone Editor', nil)) then
                editor.render_tab_zonerenames();
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Renames Editor', nil)) then
                editor.render_tab_renames();
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Lists', nil)) then
                editor.render_tab_lists();
                imgui.EndTabItem();
            end
            imgui.EndTabBar();
        end
    end
    imgui.End();
end

-- Return the editor table..
return editor;