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
local imgui = require('imgui');

-- ItemWatch Editor Variables
local editor = {
    lstMgr = require('listmanager'),
    settings = require('settings'),

    -- Main Window
    is_open = { false, },

    -- Tabs
    tab_items = T{
        search_buffer = { '' },
        search_buffer_size = 256,
        search_items = T{ },
        search_selected = { -1, },
        watched_selected = { -1, },
    },
    tab_keyitems = T{
        search_buffer = { '' },
        search_buffer_size = 256,
        search_keyitems = T{ },
        search_selected = { -1, },
        watched_selected = { -1, },
    },
    tab_lists = T{
        list_selected = { -1, },
        name_buffer = { '' },
        name_buffer_size = 256,
    },

    -- Overlay (Defaults)
    overlay_defaults = T{
        is_open = { true, },
        docking = { 0, },
        padding = { 130.0, 152.0, },
        opacity = { 0.6, },
        show_border = { true, },
        override_background_color = { false, },
        color_background = { 0.0, 0.0, 0.0, 0.0, },
        color_keyitem_missing = { 1.0, 0.3, 0.3, 1.0, },
        color_keyitem_have = { 0.0, 1.0, 0.10, 1.0, },
    },
};

-- Color Variables
local colors = {
    error = { 1.0, 0.4, 0.4, 1.0 },
    header = { 1.0, 0.65, 0.26, 1.0 },
    warn = { 0.9, 0.9, 0.0, 1.0 },
};

--[[
* Loads the editor, preparing it for usage.
--]]
function editor.load()
    -- Load the overlay settings..
    editor.overlay = editor.settings.load(editor.overlay_defaults);

    -- Register to the settings update event..
    editor.settings.register('settings', 'settings_update', function (s)
        if(s ~= nil) then
            editor.overlay = s;
        end
        editor.settings.save();
    end);
end

--[[
* Unloads the editor, cleaning up any of its resources.
--]]
function editor.unload()
    -- Save the current settings..
    editor.settings.save();
end

--[[
* Renders the items editor tab elements.
--]]
function editor.render_tab_items()
    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Current Tracked Items');
        imgui.BeginChild('leftpane', { 230, -imgui.GetFrameHeightWithSpacing(), }, true);
            -- Display watched items..
            local watched = editor.lstMgr.watched_items;
            for x = 0, #watched - 1 do
                if (x < #watched) then
                    local name = ('%s##%d'):fmt(watched[x + 1][2], watched[x + 1][1]);
                    if (imgui.Selectable(name, editor.tab_items.watched_selected[1] == x)) then
                        editor.tab_items.watched_selected[1] = x;
                    end
                end

                -- Handle watched item double-click..
                if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                    if (editor.tab_items.watched_selected[1] >= 0) then
                        local item = watched[editor.tab_items.watched_selected[1] + 1];
                        if (item ~= nil) then
                            editor.tab_items.watched_selected[1] = -1;
                            editor.lstMgr.delete_watched_item(item[1]);
                        end
                    end
                end
            end
        imgui.EndChild();

        -- Left side buttons..
        if (imgui.Button('Remove Selected')) then
            if (editor.tab_items.watched_selected[1] >= 0) then
                local item = watched[editor.tab_items.watched_selected[1] + 1];
                if (item ~= nil) then
                    editor.tab_items.watched_selected[1] = -1;
                    editor.lstMgr.delete_watched_item(item[1]);
                end
            end
        end
        imgui.SameLine();
        if (imgui.Button('Remove All')) then
            editor.tab_items.watched_selected[1] = -1;
            editor.lstMgr.clear_watched_items();
        end
    imgui.EndGroup();
    imgui.SameLine();

    -- Right Side (Item Lookup Editor)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Item Lookup Tool');
        imgui.BeginChild('rightpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, true);
            -- Item search..
            if (imgui.InputText('Item Name', editor.tab_items.search_buffer, editor.tab_items.search_buffer_size, ImGuiInputTextFlags_EnterReturnsTrue)) then
                editor.tab_items.search_selected[1] = -1;
                editor.tab_items.search_items = editor.lstMgr.find_items(editor.tab_items.search_buffer[1]:trim('\0'));
            end
            if (imgui.Button('Search', { -1, 0 })) then
                editor.tab_items.search_selected[1] = -1;
                editor.tab_items.search_items = editor.lstMgr.find_items(editor.tab_items.search_buffer[1]:trim('\0'));
            end
            imgui.Separator();
            imgui.BeginChild('rightpane_items');
                -- Display the found items from search..
                for x = 0, #editor.tab_items.search_items - 1 do
                    local name = ('[%d] %s##sitem_%d'):fmt(editor.tab_items.search_items[x + 1][1], editor.tab_items.search_items[x + 1][2], editor.tab_items.search_items[x + 1][1]);
                    if (imgui.Selectable(name, editor.tab_items.search_selected[1] == x)) then
                        editor.tab_items.search_selected[1] = x;
                    end

                    -- Handle found item double-click..
                    if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                        if (editor.tab_items.search_selected[1] >= 0) then
                            local item = editor.tab_items.search_items[editor.tab_items.search_selected[1] + 1];
                            if (item ~= nil) then
                                editor.lstMgr.add_watched_item(item[1]);
                            end
                        end
                    end
                end
            imgui.EndChild();
        imgui.EndChild();
    imgui.EndGroup();
end

--[[
* Renders the key items editor tab elements.
--]]
function editor.render_tab_keyitems()
    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Current Tracked Key Items');
        imgui.BeginChild('leftpane', { 230, -imgui.GetFrameHeightWithSpacing(), }, true);
            -- Display watched key items..
            local watched = editor.lstMgr.watched_keyitems;
            for x = 0, #watched - 1 do
                if (x < #watched) then
                    local name = ('%s##%d'):fmt(watched[x + 1][2], watched[x + 1][1]);
                    if (imgui.Selectable(name, editor.tab_keyitems.watched_selected[1] == x)) then
                        editor.tab_keyitems.watched_selected[1] = x;
                    end
                end

                -- Handle watched key item double-click..
                if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                    if (editor.tab_keyitems.watched_selected[1] >= 0) then
                        local item = watched[editor.tab_keyitems.watched_selected[1] + 1];
                        if (item ~= nil) then
                            editor.tab_keyitems.watched_selected[1] = -1;
                            editor.lstMgr.delete_watched_keyitem(item[1]);
                        end
                    end
                end
            end
        imgui.EndChild();

        -- Left side buttons..
        if (imgui.Button('Remove Selected')) then
            if (editor.tab_keyitems.watched_selected[1] >= 0) then
                local item = watched[editor.tab_keyitems.watched_selected[1] + 1];
                if (item ~= nil) then
                    editor.tab_keyitems.watched_selected[1] = -1;
                    editor.lstMgr.delete_watched_keyitem(item[1]);
                end
            end
        end
        imgui.SameLine();
        if (imgui.Button('Remove All')) then
            editor.tab_keyitems.watched_selected[1] = -1;
            editor.lstMgr.clear_watched_keyitems();
        end
    imgui.EndGroup();
    imgui.SameLine();

    -- Right Side (Key Item Lookup Editor)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Key Item Lookup Tool');
        imgui.BeginChild('rightpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, true);
            -- Key Item search..
            if (imgui.InputText('Key Item Name', editor.tab_keyitems.search_buffer, editor.tab_keyitems.search_buffer_size, ImGuiInputTextFlags_EnterReturnsTrue)) then
                editor.tab_keyitems.search_selected[1] = -1;
                editor.tab_keyitems.search_keyitems = editor.lstMgr.find_keyitems(editor.tab_keyitems.search_buffer[1]:trim('\0'));
            end
            if (imgui.Button('Search', { -1, 0 })) then
                editor.tab_keyitems.search_selected[1] = -1;
                editor.tab_keyitems.search_keyitems = editor.lstMgr.find_keyitems(editor.tab_keyitems.search_buffer[1]:trim('\0'));
            end
            imgui.Separator();
            imgui.BeginChild('rightpane_items');
                -- Display the found key items from search..
                for x = 0, #editor.tab_keyitems.search_keyitems - 1 do
                    local name = ('[%d] %s##sitem_%d'):fmt(editor.tab_keyitems.search_keyitems[x + 1][1], editor.tab_keyitems.search_keyitems[x + 1][2], editor.tab_keyitems.search_keyitems[x + 1][1]);
                    if (imgui.Selectable(name, editor.tab_keyitems.search_selected[1] == x)) then
                        editor.tab_keyitems.search_selected[1] = x;
                    end

                    -- Handle found key item double-click..
                    if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                        if (editor.tab_keyitems.search_selected[1] >= 0) then
                            local item = editor.tab_keyitems.search_keyitems[editor.tab_keyitems.search_selected[1] + 1];
                            if (item ~= nil) then
                                editor.lstMgr.add_watched_keyitem(item[1]);
                            end
                        end
                    end
                end
            imgui.EndChild();
        imgui.EndChild();
    imgui.EndGroup();
end

--[[
* Renders the lists editor tab elements.
--]]
function editor.render_tab_lists()
    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Saved Lists');
        imgui.BeginChild('leftpane', { 230, -imgui.GetFrameHeightWithSpacing(), }, true);
            -- Display saved lists..
            local lists = editor.lstMgr.saved_lists;
            for x = 0, #lists - 1 do
                if (x < #lists) then
                    local name = ('%s##%d'):fmt(lists[x + 1], x);
                    if (imgui.Selectable(name, editor.tab_lists.list_selected[1] == x)) then
                        editor.tab_lists.list_selected[1] = x;
                    end

                    -- Handle saved list double-click..
                    if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                        if (editor.tab_lists.list_selected[1] >= 0) then
                            local ret = editor.lstMgr.load_list:packed()(editor.tab_lists.list_selected[1], false);
                            if (not ret[1]) then
                                print(chat.header(addon.name):append(chat.error('Failed to load watch list; \'%s\'')):fmt(ret[2]));
                            end
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
            imgui.ShowHelp('The name of the list file to save.\n(Only used when saving to new file!)\n\nDo not include the file extension, it will be added automatically.');
            if (imgui.Button('Save To New List File', { 225, 0 })) then
                editor.lstMgr.save_list_new(editor.tab_lists.name_buffer[1]:trim('\0'));
            end
            imgui.ShowHelp('Saves the current watched items to a new list using the name given above. If the list already exists, it will not be overwritten.');
            if (imgui.Button('Save To Existing List File', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    editor.lstMgr.save_list_existing(editor.tab_lists.list_selected[1]);
                end
            end
            imgui.ShowHelp('Saves the current watched items to an existing list; selected on the left. (Does not use the name above!)');

            imgui.NewLine();
            imgui.Separator();

            if (imgui.Button('Load Selected List', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    local ret = editor.lstMgr.load_list:packed()(editor.tab_lists.list_selected[1], false);
                    if (not ret[1]) then
                        print(chat.header(addon.name):append(chat.error('Failed to load watch list; \'%s\'')):fmt(ret[2]));
                    end
                end
            end
            imgui.ShowHelp('Loads the selected list on the left. (Overwrites any currently watched items.)');
            if (imgui.Button('Load Selected List (Merged)', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    local ret = editor.lstMgr.load_list:packed()(editor.tab_lists.list_selected[1], true);
                    if (not ret[1]) then
                        print(chat.header(addon.name):append(chat.error('Failed to load watch list; \'%s\'')):fmt(ret[2]));
                    end
                end
            end
            imgui.ShowHelp('Loads the selected list on the left. (Merges the lists contents with the currently watched items.)');

            imgui.NewLine();
            imgui.Separator();

            if (imgui.Button('Delete Selected List', { 225, 0 })) then
                if (editor.tab_lists.list_selected[1] >= 0) then
                    editor.lstMgr.delete_list(editor.tab_lists.list_selected[1]);
                end
            end
            imgui.ShowHelp('Deletes the selected list on the left.\n\n(Warning: This deletes the file on disk! This cannot be undone!)');

            if (imgui.Button('Delete All Lists', { 225, 0 })) then
                imgui.OpenPopup('###DeleteAllSavedLists');
            end
            switch(imgui.DisplayPopup('Are you sure?', 'DeleteAllSavedLists', function ()
                imgui.Text('This will delete all currently saved lists on disk.\nAre you sure?');
                imgui.NewLine();
                imgui.TextColored(colors.warn, 'This cannot be undone! Use with caution!');
            end, PopupButtonsOkCancel), {
                [PopupResultOk] = function ()
                    editor.lstMgr.delete_all_lists();
                end
            });
            imgui.ShowHelp('Deletes all saved list files.\n\n(Warning: This deletes all saved list files on disk! This cannot be undone!)');
        imgui.EndChild();
    imgui.EndGroup();
end

--[[
* Renders the settings tab elements.
--]]
function editor.render_tab_settings()
    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored(colors.header, 'Overlay Settings');
        imgui.BeginChild('leftpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, true);
            imgui.Checkbox('Show Overlay', editor.overlay.is_open);
            imgui.ShowHelp('Toggles if the overlay is visible or not.');
            imgui.Checkbox('Show Border', editor.overlay.show_border);
            imgui.ShowHelp('Toggles if the overlay border is visible or not.');

            local overlay_pos = { editor.overlay.docking[1] + 1 };
            if (imgui.Combo('Overlay Position', overlay_pos, 'Unlocked\0Top-Left\0Top-Right\0Bottom-Left\0Bottom-Right\0\0')) then
                editor.overlay.docking[1] = overlay_pos[1] - 1;
            end
            imgui.ShowHelp([[The location where the overlay should be displayed.

Unlocked - The position is not fixed and the overlay can be dragged around with the mouse.

Top-Left - The overlay is locked to the top-left of the screen.

Top-Right - The overlay is locked to the top-right of the screen.

Bottom-Left - The overlay is locked to the bottom-left of the screen.

Bottom-Right - The overlay is locked to the bottom-right of the screen.]]);

            imgui.InputInt2('Padding', editor.overlay.padding);
            imgui.ShowHelp('The padding to apply to the overlay when it\'s docked.\n(Not used when overlay position is set to \'Unlocked\')');
            imgui.SliderFloat('Opacity', editor.overlay.opacity, 0.0, 1.0, '%.2f');
            imgui.ShowHelp('The opacity of the overlay background.');

            imgui.Separator();
            imgui.Checkbox('Override Background Color?', editor.overlay.override_background_color);
            imgui.ShowHelp('Allows overriding the background color of the overlay.');
            imgui.ColorEdit4('Background Color', editor.overlay.color_background);
            imgui.ShowHelp('The color to use for the overlay background.');

            imgui.Separator();
            imgui.ColorEdit4('Key Item Color (Missing)', editor.overlay.color_keyitem_missing);
            imgui.ColorEdit4('Key Item Color (Have)', editor.overlay.color_keyitem_have);
            imgui.ShowHelp('The colors used when displaying the status of a key item.', false);
        imgui.EndChild();

        -- Settings Buttons..
        if (imgui.Button('Save Settings')) then
            editor.settings.save();
            print(chat.header(addon.name):append(chat.message('Settings saved.')));
        end
        imgui.SameLine();
        if (imgui.Button('Reload Settings')) then
            editor.settings.reload();
            print(chat.header(addon.name):append(chat.message('Settings reloaded.')));
        end
        imgui.SameLine();
        if (imgui.Button('Reset To Defaults')) then
            editor.settings.reset();
            print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        end
    imgui.EndGroup();
end

--[[
* Renders the ItemWatch overlay.
--]]
function editor.render_watchlist_overlay()
    if (not editor.overlay.is_open[1]) then
        return;
    end

    -- Prepare the default window flags..
    local flags = bit.bor(ImGuiWindowFlags_NoDecoration, ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoSavedSettings, ImGuiWindowFlags_NoFocusOnAppearing, ImGuiWindowFlags_NoNav);

    -- Adjust the layout specific to a docking location..
    if (editor.overlay.docking[1] ~= -1) then
        local work_size = imgui.GetIO().DisplaySize;
        local pos = { 0, 0, };
        local pivot = { 0, 0, };

        pos[1] = bit.band(editor.overlay.docking[1], 1) == 1 and work_size.x - editor.overlay.padding[1] or editor.overlay.padding[1];
        pos[2] = bit.band(editor.overlay.docking[1], 2) == 2 and work_size.y - editor.overlay.padding[2] or editor.overlay.padding[2];
        pivot[1] = bit.band(editor.overlay.docking[1], 1) == 1 and 1.0 or 0.0;
        pivot[2] = bit.band(editor.overlay.docking[1], 2) == 2 and 1.0 or 0.0;

        -- Update the window flags to not allow movement of the overlay..
        flags = bit.bor(flags, ImGuiWindowFlags_NoMove);

        -- Set the overlay windows position..
        imgui.SetNextWindowPos(pos, ImGuiCond_Always, pivot);
    end

    -- Alter the background color..
    if (editor.overlay.override_background_color[1] == true) then
        imgui.PushStyleColor(ImGuiCol_WindowBg, editor.overlay.color_background);
    end

    -- Adjust the border size..
    local border_size = imgui.GetStyle().WindowBorderSize;
    imgui.GetStyle().WindowBorderSize = editor.overlay.show_border[1] == true and 1.0 or 0.0;

    -- Display the overlay window..
    imgui.SetNextWindowBgAlpha(editor.overlay.opacity[1]);
    if (imgui.Begin('itemwatch_overlay', editor.overlay.is_open, flags)) then

        local inv = AshitaCore:GetMemoryManager():GetInventory();
        local ply = AshitaCore:GetMemoryManager():GetPlayer();

        -- Display the watched items..
        if (editor.lstMgr.watched_items_count() > 0) then
            editor.lstMgr.watched_items:each(function (v)
                local total = 0;
                for x = 0, 16 do
                    for y = 0, 80 do
                        local item = inv:GetContainerItem(x, y);
                        if (item ~= nil and item.Id == v[1]) then
                            total = total + item.Count;
                        end
                    end
                end
                imgui.Text(('%4d %s'):fmt(total, v[2]));
            end);
        end

        -- Display the watched items..
        if (editor.lstMgr.watched_keyitems_count() > 0) then
            editor.lstMgr.watched_keyitems:each(function (v)
                local has = ply:HasKeyItem(v[1]);
                imgui.TextColored(has and editor.overlay.color_keyitem_have or editor.overlay.color_keyitem_missing, v[2]);
            end);
        end

        if (imgui.BeginPopupContextWindow()) then
            if (imgui.MenuItem('Unlocked', nil, editor.overlay.docking[1] == -1)) then editor.overlay.docking[1] = -1; end
            if (imgui.MenuItem('Top-Left', nil, editor.overlay.docking[1] == 0)) then editor.overlay.docking[1] = 0; end
            if (imgui.MenuItem('Top-Right', nil, editor.overlay.docking[1] == 1)) then editor.overlay.docking[1] = 1; end
            if (imgui.MenuItem('Bottom-Left', nil, editor.overlay.docking[1] == 2)) then editor.overlay.docking[1] = 2; end
            if (imgui.MenuItem('Bottom-Right', nil, editor.overlay.docking[1] == 3)) then editor.overlay.docking[1] = 3; end
            if (editor.overlay.is_open[1] and imgui.MenuItem('Close')) then
                editor.overlay.is_open[1] = false;
            end
            imgui.EndPopup();
        end

        imgui.End();
    end

    -- Restore the border size..
    imgui.GetStyle().WindowBorderSize = border_size;

    -- Restore the background color..
    if (editor.overlay.override_background_color[1] == true) then
        imgui.PopStyleColor();
    end
end

--[[
* Renders ItemWatches various elements.
--]]
function editor.render()
    -- Render the watch lists..
    if (editor.lstMgr.watched_count() > 0) then
        editor.render_watchlist_overlay();
    end

    -- Skip rendering the editor if it's not open..
    if (not editor.is_open[1]) then
        return;
    end

    -- Render the ItemWatch editor..
    imgui.SetNextWindowSize({ 600, 400, });
    imgui.SetNextWindowSizeConstraints({ 600, 400, }, { FLT_MAX, FLT_MAX, });
    if (imgui.Begin('ItemWatch', editor.is_open, ImGuiWindowFlags_NoResize)) then
        if (imgui.BeginTabBar('##itemwatch_tabbar', ImGuiTabBarFlags_NoCloseWithMiddleMouseButton)) then
            if (imgui.BeginTabItem('Items Editor', nil)) then
                editor.render_tab_items();
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Key Items Editor', nil)) then
                editor.render_tab_keyitems();
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Lists Editor', nil)) then
                editor.render_tab_lists();
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Settings', nil)) then
                editor.render_tab_settings();
                imgui.EndTabItem();
            end
            imgui.EndTabBar();
        end
    end
    imgui.End();
end

-- Return the editor table..
return editor;