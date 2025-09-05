--[[
* Addons - Copyright (c) 2023 Ashita Development Team
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
local parser = require('parser');

-- actionparse ui variables..
local ui = T{
    is_open = T{ true, },
    capture_injected = T{ false, },
    selected = T{ -1, },
    packets = T{ },
    packet = T{
        selected_target = T{ -1, },
        selected_result = T{ -1, },
    },
};

--[[
* Resets the ui.
--]]
function ui.reset()
    ui.selected = T{ -1, };
    ui.packets = T{};
    ui.packet.selected_target = T{ -1, };
    ui.packet.selected_result = T{ -1, };
end

--[[
* Handles incoming packets to update the ui accordingly.
*
* @param {userdata} e - The packet object.
--]]
function ui.packet_in(e)
    if (e.injected == true and ui.capture_injected[1] == false) then
        return;
    end

    -- Packet: Action
    if (e.id == 0x0028) then
        local action = parser.parse(e.data);
        action.packet = e.data:tohex():sub(1, e.size * 3);
        ui.packets:append(action);
    end
end

--[[
* Renders the left hand side recorded action packet list.
--]]
function ui.render_action_list()
    local index = 1;
    ui.packets:each(function (v)
        if (imgui.Selectable(('Action [%02X][%s]##action_%d'):fmt(v.cmd_no, v.caster_name, index), ui.selected[1] == index)) then
            ui.selected[1] = index;
        end
        if (imgui.IsItemHovered()) then
            imgui.BeginTooltip();
            imgui.Text(('Action: %d - %s'):fmt(v.cmd_no, parser.get_action_name(v.cmd_no)));
            imgui.NewLine();
            imgui.Text(('Caster: %08X - %s'):fmt(v.m_uID, v.caster_name));
            imgui.Text(('Targets: %d'):fmt(v.trg_sum));
            imgui.EndTooltip();
        end
        index = index + 1;
    end);
end

--[[
* Renders the right-hand side action packet information.
--]]
function ui.render_action_info()
    if (ui.selected[1] <= 0) then
        imgui.TextColored(T{ 1.0, 1.0, 0.0, 1.0, }, '<< Select an action packet.');
        return;
    end

    local action = ui.packets[ui.selected[1]];
    if (not action) then
        imgui.TextColored(T{ 1.0, 1.0, 0.0, 1.0, }, '<< Select an action packet.');
        return;
    end

    -- Caster Information
    imgui.TextColored(T{ 1.0, 1.0, 0.0, 1.0, }, 'Caster Information');
    imgui.Separator();
    if (imgui.BeginTable('##tbl_caster', 6, bit.bor(ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersH, ImGuiTableFlags_BordersV, ImGuiTableFlags_ContextMenuInBody, ImGuiTableFlags_ScrollX, ImGuiTableFlags_ScrollY, ImGuiTableFlags_SizingFixedFit), { -1, 50 })) then
        imgui.TableSetupColumn('Caster Actor', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('Action', ImGuiTableColumnFlags_WidthFixed, 250, 0);
        imgui.TableSetupColumn('Action Arg', ImGuiTableColumnFlags_WidthFixed, 200, 0);
        imgui.TableSetupColumn('Targets', ImGuiTableColumnFlags_WidthFixed, 80, 0);
        imgui.TableSetupColumn('Info', ImGuiTableColumnFlags_WidthFixed, 80, 0);
        imgui.TableSetupColumn('Other', ImGuiTableColumnFlags_WidthFixed, 120, 0);
        imgui.TableSetupScrollFreeze(0, 1);
        imgui.TableHeadersRow();
        imgui.PushID(1);
        imgui.TableNextRow();
        imgui.TableSetColumnIndex(0);
        imgui.Text(('%08X [%s]'):fmt(action.m_uID, action.caster_name));
        imgui.TableNextColumn();
        imgui.Text(('%d [%s]'):fmt(action.cmd_no, parser.get_action_name(action.cmd_no)));
        imgui.TableNextColumn();
        imgui.Text(('%d'):fmt(action.cmd_arg));
        imgui.TableNextColumn();
        imgui.Text(('%d'):fmt(action.trg_sum));
        imgui.TableNextColumn();
        imgui.Text(('%d'):fmt(action.info));
        imgui.TableNextColumn();
        imgui.Text(('res_sum: %d'):fmt(action.res_sum));
        imgui.PopID();
        imgui.EndTable();
    end

    -- Targets Information
    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, 'Targets');
    imgui.Separator();
    if (imgui.BeginTable('##tbl_targets', 2, bit.bor(ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersH, ImGuiTableFlags_BordersV, ImGuiTableFlags_ContextMenuInBody, ImGuiTableFlags_ScrollX, ImGuiTableFlags_ScrollY, ImGuiTableFlags_SizingFixedFit), { -1, 200 })) then
        imgui.TableSetupColumn('Target Actor', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('Results', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupScrollFreeze(0, 1);
        imgui.TableHeadersRow();

        local idx = 1;
        action.target:each(function (v, k)
            imgui.PushID(idx);
            imgui.TableNextRow();
            imgui.TableSetColumnIndex(0);
            if (imgui.Selectable(('%08X [%s]'):fmt(v.m_uID, v.target_name), idx == ui.packet.selected_target[1], bit.bor(ImGuiSelectableFlags_SpanAllColumns, ImGuiSelectableFlags_AllowOverlap), { 0, 0 })) then
                ui.packet.selected_target[1] = idx;
            end
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.result_sum));
            imgui.PopID();
            idx = idx + 1;
        end);

        imgui.EndTable();
    end

    -- Hide result information if no target is selected..
    if (ui.packet.selected_target[1] <= 0) then
        return;
    end

    local target = action.target[ui.packet.selected_target[1]];
    if (target == nil) then
        return;
    end

    -- Results Information
    imgui.TextColored({ 1.0, 1.0, 0.0, 1.0 }, 'Results');
    imgui.Separator();
    if (imgui.BeginTable('##tbl_results', 16, bit.bor(ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersH, ImGuiTableFlags_BordersV, ImGuiTableFlags_ContextMenuInBody, ImGuiTableFlags_ScrollX, ImGuiTableFlags_ScrollY, ImGuiTableFlags_SizingFixedFit), { -1, 200 })) then
        imgui.TableSetupColumn('miss', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('kind', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('sub_kind', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('info', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('scale', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('value', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('message', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('bit', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('proc_kind', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('proc_info', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('proc_value', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('proc_message', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('react_kind', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('react_info', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('react_value', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupColumn('react_message', ImGuiTableColumnFlags_WidthStretch, 0, 0);
        imgui.TableSetupScrollFreeze(0, 1);
        imgui.TableHeadersRow();

        local idx = 1;
        target.result:each(function (v, k)
            imgui.PushID(idx);
            imgui.TableNextRow();
            imgui.TableSetColumnIndex(0);
            imgui.Text(('%d - %s'):fmt(v.miss, parser.get_miss_name(v.miss):proper()));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.kind));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.sub_kind));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.info));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.scale));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.value));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.message));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.bit));
            imgui.TableNextColumn();
            if (v.has_proc) then
                imgui.PushStyleColor(ImGuiCol_Text, { 0.0, 1.0, 0.0, 1.0 });
            else
                imgui.PushStyleColor(ImGuiCol_Text, { 1.0, 0.3, 0.3, 1.0 });
            end
            imgui.Text(('%d'):fmt(v.proc_kind));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.proc_info));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.proc_value));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.proc_message));
            imgui.PopStyleColor();
            imgui.TableNextColumn();
            if (v.has_react) then
                imgui.PushStyleColor(ImGuiCol_Text, { 0.0, 1.0, 0.0, 1.0 });
            else
                imgui.PushStyleColor(ImGuiCol_Text, { 1.0, 0.3, 0.3, 1.0 });
            end
            imgui.Text(('%d'):fmt(v.react_kind));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.react_info));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.react_value));
            imgui.TableNextColumn();
            imgui.Text(('%d'):fmt(v.react_message));
            imgui.PopStyleColor();
            imgui.PopID();
            idx = idx + 1;
        end);

        imgui.EndTable();
    end
end

--[[
* Renders the ui.
--]]
function ui.render()
    if (not ui.is_open[1]) then
        return;
    end
    if (imgui.Begin('Action Parser - by atom0s', ui.is_open)) then
        imgui.BeginGroup();
            imgui.TextColored(T{ 1.0, 1.0, 1.0, 1.0, }, 'Recorded Actions');
            imgui.BeginChild('leftpane', T{ 230, -imgui.GetFrameHeightWithSpacing(), }, ImGuiChildFlags_Borders);
                ui.render_action_list();
            imgui.EndChild();
            if (imgui.Button('Clear')) then
                ui.reset();
            end
            imgui.SameLine();
            if (imgui.Button('Copy')) then
                if (ui.selected[1] > 0) then
                    local action = ui.packets[ui.selected[1]];
                    if (action) then
                        ashita.misc.set_clipboard(action.packet);
                    end
                end
            end
            imgui.SameLine();
            if (imgui.Button('Resend')) then
                if (ui.selected[1] > 0) then
                    local action = ui.packets[ui.selected[1]];
                    if (action) then
                        local packet = T{};
                        local packet_str = action.packet;
                        packet_str:strip(' \r\n'):gsub('(%x%x)', function (x)
                            return table.insert(packet, tonumber(x, 16));
                        end);
                        AshitaCore:GetPacketManager():AddIncomingPacket(packet[1], packet);
                    end
                end
            end
        imgui.EndGroup();
        imgui.SameLine();
        imgui.BeginGroup();
            imgui.TextColored(T{ 1.0, 1.0, 1.0, 1.0, }, 'Action Information');
            imgui.BeginChild('rightpane', T{ 0, -imgui.GetFrameHeightWithSpacing(), }, ImGuiChildFlags_Borders);
                ui.render_action_info();
            imgui.EndChild();
            imgui.Checkbox('Capture Injected Actions', ui.capture_injected);
        imgui.EndGroup();
    end
    imgui.End();
end

-- Return the ui table..
return ui;