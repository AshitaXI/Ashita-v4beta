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
local imgui = require('imgui');
local json = require('json');

-- blucheck UI Variables
local ui = {
    counts = T{
        known   = 0,
        missing = 0,
        total   = 0,
    },
    data = T{},     -- Raw data loaded from /data/spells.json..
    spells = T{},   -- List of spells with proper data from resources..
    zone = T{},     -- List of spells available in the current zone..

    -- Main Window
    is_open = { false, },

    -- Spells Tab
    tab_spells = {
        selected = { -1, },
    },

    -- Zone Helper Tab
    tab_zonehelper = {
        selected = { -1, },
    },
};

--[[
* Returns the string representation of the given spell type id.
*
* @param {number} t - The spell element type.
* @return {string} The element string.
--]]
function ui.get_spell_element(t)
    return switch(t, {
        [0] = function () return 'Fire'; end,
        [1] = function () return 'Ice'; end,
        [2] = function () return 'Wind'; end,
        [3] = function () return 'Earth'; end,
        [4] = function () return 'Lightning'; end,
        [5] = function () return 'Water'; end,
        [6] = function () return 'Light'; end,
        [7] = function () return 'Dark'; end,
        [15] = function () return '(None)'; end,
        [switch.default] = function () return tostring(t); end
    });
end

--[[
* Returns the spell information block for the given spell. (Learned from which mobs.)
*
* @param {number} id - The spell id to lookup.
* @return {table} The table of data on success, empty table otherwise.
--]]
function ui.get_spell_data(id)
    local _, v = ui.data:findkey(tostring(id));
    return v or T{};
end

--[[
* Updates the list of Blue Mage spell information.
--]]
function ui.get_spells()
    ui.spells = T{};

    -- Build the list of BLU spells..
    for x = 0, 2048 do
        local spell = AshitaCore:GetResourceManager():GetSpellById(x);
        if (spell ~= nil and spell.Skill == 43 and spell.LevelRequired[16 + 1] > 0) then
            ui.spells:append(T{
                index   = x,
                name    = spell.Name[1],
                level   = spell.LevelRequired[16 + 1],
                element = spell.Element,
                known   = AshitaCore:GetMemoryManager():GetPlayer():HasSpell(x),
                zones   = ui.get_spell_data(x),
            });
        end
    end

    -- Sort the spell list..
    ui.spells:sort(function (a, b)
        return (a.level < b.level) or (a.level == b.level and a.name < b.name);
    end);
end

--[[
* Updates the list of Blue Mage spell information for spells learnable in the current zone.
*
* @param {number} id - The zone id to find spells for.
--]]
function ui.get_zone_spells(id)
    ui.zone = T{};

    -- Skip invalid zones..
    if (id == 0) then
        return;
    end

    -- Find all valid spell ids for this zone from the raw data..
    local spellids = T{};
    ui.data:each(function (v, k)
        v:each(function (_, kk)
            if (kk == tostring(id)) then
                spellids:append(k);
            end
        end);
    end);

    -- Obtain the spells..
    spellids:each(function (v, _)
        ui.spells:each(function (vv, _)
            if (tostring(vv.index) == v) then
                ui.zone:append(vv);
            end
        end);
    end);

    -- Sort the zone spell list..
    ui.zone:sort(function(a, b)
        return (a.level < b.level) or (a.level == b.level and a.name < b.name);
    end);
end

--[[
* Updates the current counts for spells. (Known, missing, and total.)
--]]
function ui.get_spell_counts()
    local counts = T{
        known   = 0,
        missing = 0,
        total   = 0,
    };

    ui.spells:each(function (v, k)
        counts.total = counts.total + 1;

        if (v.known) then
            counts.known = counts.known + 1;
        else
            counts.missing = counts.missing + 1;
        end
    end);

    ui.counts = counts;
end

--[[
* Loads the ui, preparing it for usage.
--]]
function ui.load()
    -- Load the BLU spell list..
    local f = io.open(addon.path .. '/data/spells.json', 'rb');
    if (f == nil) then
        error('Failed to load spell list file. (/data/spells.json)');
    end

    -- Read the full file contents..
    local c = f:read("*all");
    f:close();

    -- Parse the spell json data..
    ui.data = T(json.decode(c) or {});

    -- Load the spell information..
    ui.get_spells();
    ui.get_spell_counts();
    ui.get_zone_spells(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0));
end

--[[
* Handles incoming packets to update the ui accordingly.
*
* @param {userdata} e - The packet object.
--]]
function ui.packet_in(e)
    -- Packet: Zone Enter
    if (e.id == 0x000A) then
        ui.tab_zonehelper.selected[1] = -1;
        ui.zone = T{};

        -- Ignore mog house zoning..
        if (struct.unpack('b', e.data_modified, 0x80 + 0x01) == 1) then
            return;
        end

        -- Obtain the zone id..
        local zone = struct.unpack('H', e.data_modified, 0x30 + 1);
        if (zone == 0) then
            zone = struct.unpack('H', e.data_modified, 0x42 + 1);
        end

        -- Update the spell information..
        ui.get_zone_spells(zone);
        ui.get_spell_counts();

        return;
    end

    -- Packet: Zone Leave
    if (e.id == 0x000B) then
        ui.tab_zonehelper.selected[1] = -1;
        ui.zone = T{};

        return;
    end

    -- Packet: Message Basic
    if (e.id == 0x0029) then
        -- Obtain the message id..
        local msg = struct.unpack('H', e.data_modified, 0x18 + 0x01);
        if (msg == 419) then
            -- Obtain the message information..
            local spellId   = struct.unpack('L', e.data_modified, 0x0C + 0x01);
            local sender    = struct.unpack('H', e.data_modified, 0x14 + 0x01);
            local target    = struct.unpack('H', e.data_modified, 0x16 + 0x01);

            -- Obtain the player entity..
            local player = GetPlayerEntity();
            if (sender == player.TargetIndex and target == player.TargetIndex) then
                -- Mark the spell as known..
                ui.spells:each(function (v, k)
                    if (v.index == spellId) then
                        v.known = true;
                    end
                end);

                -- Update the spell information..
                ui.get_spell_counts();
                ui.get_zone_spells(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0));
            end
        end

        return;
    end

    -- Packet: Spells Information
    if (e.id == 0x00AA) then
        ashita.tasks.oncef(1, function ()
            -- Reload the spell information..
            ui.get_spells();
            ui.get_spell_counts();
            ui.get_zone_spells(AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0));
        end);
        return;
    end
end

--[[
* Renders the right-hand side spell information.
*
* @param {table} lst - The list of data to pull the spell from.
* @param {number} index - The index in the list of data to read the spell from.
--]]
function ui.render_spell_info(lst, index)
    if (index == -1) then
        imgui.TextColored({ 1.0, 1.0, 1.0, 1.0 }, '<< Select a spell for more info.');
    else
        local spell = lst[index];
        local res   = AshitaCore:GetResourceManager():GetSpellById(spell.index);

        if (res == nil) then
            imgui.TextColored({ 1.0, 0.0, 0.0, 1.0 }, 'Failed to obtain spell information.');
        else
            -- Displays a stat value with some color.
            local function showStat(header, value)
                imgui.TextColored({ 1.0, 1.0, 1.0, 1.0 }, header);
                imgui.SameLine();
                imgui.TextColored({ 0.2, 0.7, 1.0, 1.0 }, tostring(value));
            end

            if (imgui.Button('Show Spell On BgWiki')) then
                ashita.misc.open_url(('https://www.bg-wiki.com/ffxi/%s'):fmt(res.Name[1]));
            end

            imgui.PushTextWrapPos(imgui.GetFontSize() * 23.0);
            imgui.TextColored({ 1.0, 0.2, 0.5, 1.0 }, res.Name[1]);
            imgui.TextColored({ 1.0, 0.5, 0.2, 1.0 }, res.Description[1]);
            imgui.PopTextWrapPos();
            imgui.Separator();

            showStat('Index        :', res.Index);
            showStat('Element      :', ui.get_spell_element(res.Element));
            showStat('Mana Cost    :', res.ManaCost);
            showStat('Cast Time    :', ('%.2f sec'):fmt(res.CastTime / 4.0));
            showStat('Recast Delay :', ('%.2f sec'):fmt(res.RecastDelay / 4.0));
            showStat('Level Needed :', res.LevelRequired[16 + 1]);
            showStat('Range        :', ('%d yalms'):fmt(AshitaCore:GetResourceManager():GetSpellRange(res.Index, false)));
            showStat('Area Range   :', ('%d yalms'):fmt(AshitaCore:GetResourceManager():GetSpellRange(res.Index, true)));

            imgui.TextColored({ 1.0, 1.0, 1.0, 1.0 }, 'Known        :');
            imgui.SameLine();
            if (spell.known) then
                imgui.TextColored({ 0.0, 1.0, 0.0, 1.0 }, 'Yes');
            else
                imgui.TextColored({ 1.0, 0.0, 0.0, 1.0 }, 'No');
            end

            imgui.Separator();
            imgui.TextColored({ 1.0, 1.0, 0.4, 1.0 }, 'Learned From The Following');
            imgui.Separator();

            if (spell.zones:len() > 0) then
                spell.zones:each(function (v, k)
                    imgui.TextColored({ 1.0, 0.0, 1.0, 1.0 }, AshitaCore:GetResourceManager():GetString('zones.names', tonumber(k)));
                    imgui.Indent();
                    for _, vv in pairs(v) do
                        imgui.TextColored({ 1.0, 1.0, 1.0, 1.0 }, tostring(vv));
                    end
                    imgui.Unindent();
                end);
            else
                imgui.TextColored({ 1.0, 0.0, 1.0, 1.0 }, 'No data available.');
            end
        end
    end
end

--[[
* Renders the spell counts.
--]]
function ui.render_spell_counts()
    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, 'Total Spells:');
    imgui.SameLine();
    imgui.TextColored({ 1.0, 0.5, 0.2, 1.0 }, ('%d'):fmt(ui.counts.total));
    imgui.SameLine();
    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, '| Known:');
    imgui.SameLine();
    imgui.TextColored({ 0.2, 1.0, 0.2, 1.0 }, ('%d'):fmt(ui.counts.known));
    imgui.SameLine();
    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, '| Missing:');
    imgui.SameLine();
    imgui.TextColored({ 1.0, 0.2, 0.2, 1.0 }, ('%d'):fmt(ui.counts.missing));
end

--[[
* Renders the spells ui tab.
--]]
function ui.render_tab_spells()
    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Blue Mage Spells');
        imgui.BeginChild('leftpane', { 230, -imgui.GetFrameHeightWithSpacing(), }, true);
            local index = 1;
            ui.spells:each(function (v, k)
                if (v.known) then
                    imgui.PushStyleColor(ImGuiCol_Text, { 0.0, 1.0, 0.0, 1.0 });
                else
                    imgui.PushStyleColor(ImGuiCol_Text, { 1.0, 0.0, 0.0, 1.0 });
                end
                if (imgui.Selectable(('[%02d] %s##%d'):fmt(v.level, v.name, v.index), ui.tab_spells.selected[1] == index)) then
                    ui.tab_spells.selected[1] = index;
                end
                imgui.PopStyleColor();

                index = index + 1;
            end);
        imgui.EndChild();

        -- Left side buttons..
        if (imgui.Button('Sort By Level')) then
            ui.spells:sort(function(a, b)
                return (a.level < b.level) or (a.level == b.level and a.name < b.name);
            end);
        end
        imgui.SameLine();
        if (imgui.Button('Sort By Name')) then
            ui.spells:sort(function(a, b)
                return a.name < b.name;
            end);
        end
    imgui.EndGroup();
    imgui.SameLine();

    -- Right Side (Key Item Lookup Editor)
    imgui.BeginGroup();
        imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Spell Information');
        imgui.BeginChild('rightpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, true);
            ui.render_spell_info(ui.spells, ui.tab_spells.selected[1]);
        imgui.EndChild();
    imgui.EndGroup();
end

--[[
* Renders the zone helper ui tab.
--]]
function ui.render_tab_zonehelper()
    -- Left Side (Many whelps, handle it!!)
    imgui.BeginGroup();
        imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Zone Spells');
        imgui.BeginChild('leftpane', { 230, -imgui.GetFrameHeightWithSpacing(), }, true);
            local index = 1;
            ui.zone:each(function (v, k)
                if (v.known) then
                    imgui.PushStyleColor(ImGuiCol_Text, { 0.0, 1.0, 0.0, 1.0 });
                else
                    imgui.PushStyleColor(ImGuiCol_Text, { 1.0, 0.0, 0.0, 1.0 });
                end
                if (imgui.Selectable(('[%02d] %s##%d'):fmt(v.level, v.name, v.index), ui.tab_zonehelper.selected[1] == index)) then
                    ui.tab_zonehelper.selected[1] = index;
                end
                imgui.PopStyleColor();

                index = index + 1;
            end);
        imgui.EndChild();

        -- Left side buttons..
        if (imgui.Button('Sort By Level')) then
            ui.zone:sort(function(a, b)
                return (a.level < b.level) or (a.level == b.level and a.name < b.name);
            end);
        end
        imgui.SameLine();
        if (imgui.Button('Sort By Name')) then
            ui.zone:sort(function(a, b)
                return a.name < b.name;
            end);
        end
    imgui.EndGroup();
    imgui.SameLine();

    -- Right Side (Key Item Lookup Editor)
    imgui.BeginGroup();
        imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Spell Information');
        imgui.BeginChild('rightpane', { 0, -imgui.GetFrameHeightWithSpacing(), }, true);
            ui.render_spell_info(ui.zone, ui.tab_zonehelper.selected[1]);
        imgui.EndChild();
    imgui.EndGroup();
end

--[[
* Renders the ui.
--]]
function ui.render()
    -- Skip rendering the ui if it's not open..
    if (not ui.is_open[1]) then
        return;
    end

    -- Render the editor..
    imgui.SetNextWindowSize({ 600, 400, });
    imgui.SetNextWindowSizeConstraints({ 600, 400, }, { FLT_MAX, FLT_MAX, });
    if (imgui.Begin('BluCheck', ui.is_open, ImGuiWindowFlags_NoResize)) then
        ui.render_spell_counts();
        if (imgui.BeginTabBar('##blucheck_tabbar', ImGuiTabBarFlags_NoCloseWithMiddleMouseButton)) then
            if (imgui.BeginTabItem('Spell List', nil)) then
                ui.render_tab_spells();
                imgui.EndTabItem();
            end
            if (imgui.BeginTabItem('Zone Helper', nil)) then
                ui.render_tab_zonehelper();
                imgui.EndTabItem();
            end
            imgui.EndTabBar();
        end
    end
    imgui.End();
end

-- Return the ui table..
return ui;