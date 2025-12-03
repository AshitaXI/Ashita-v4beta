--[[
* Addons - Copyright (c) 2025 Ashita Development Team
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

---@meta

--[[
IGuiManager Interface
--]]

---@class IGuiManager
local IGuiManager = {};

---Returns the GuiManager visibility.
---@param self IGuiManager
---@return boolean
---@nodiscard
function IGuiManager:GetVisible() end

---Sets the GuiManager visibility.
---@param self IGuiManager
---@param visible boolean
function IGuiManager:SetVisible(visible) end

--[[
Note:   The below functions do not expect the IGuiManager as their first parameter. Instead, they
        are considered static functions and should be accessed with a dot (.) instead of a colon (:).

        Correct:    if (AshitaCore:GetGuiManager().Begin('TestWindow')) then
        Incorrect:  if (AshitaCore:GetGuiManager():Begin('TestWindow')) then
--]]

--[[
Context Creation and Access
--]]

---Creates a new ImGui context.
---
---**WARNING:** This function should not be used.
---@param shared_font_atlas? ImFontAtlas
---@return ImGuiContext
function IGuiManager.CreateContext(shared_font_atlas) end

---Destroys the current, or given, ImGui context.
---
---**WARNING:** This function should not be used.
---@param ctx? ImGuiContext
function IGuiManager.DestroyContext(ctx) end

---Returns the current ImGui context.
---@return ImGuiContext
---@nodiscard
function IGuiManager.GetCurrentContext() end

---Sets the current ImGui context.
---
---**WARNING:** This function should not be used.
---@param ctx ImGuiContext
function IGuiManager.SetCurrentContext(ctx) end

--[[
Main
--]]

---Returns the current ImGuiIO structure.
---@return ImGuiIO
---@nodiscard
function IGuiManager.GetIO() end

---Returns the current ImGuiPlatformIO structure.
---@return ImGuiPlatformIO
---@nodiscard
function IGuiManager.GetPlatformIO() end

---Returns the current ImGuiStyle structure.
---@return ImGuiStyle
---@nodiscard
function IGuiManager.GetStyle() end

---Begins a new ImGui frame.
function IGuiManager.NewFrame() end

---Ends the current ImGui frame.
function IGuiManager.EndFrame() end

---Renders the ImGui draw data.
function IGuiManager.Render() end

---Returns the current ImDrawData structure.
---@return ImDrawData
---@nodiscard
function IGuiManager.GetDrawData() end

--[[
Demo, Debug, Information
--]]

---Shows the ImGui demo window.
---@param is_open? table
function IGuiManager.ShowDemoWindow(is_open) end

---Shows the ImGui metrics window.
---@param is_open? table
function IGuiManager.ShowMetricsWindow(is_open) end

---Shows the ImGui demo log window.
---@param is_open? table
function IGuiManager.ShowDebugLogWindow(is_open) end

---Shows the ImGui ID stack tool window.
---@param is_open? table
function IGuiManager.ShowIDStackToolWindow(is_open) end

---Shows the ImGui about window.
---@param is_open? table
function IGuiManager.ShowAboutWindow(is_open) end

---Shows the ImGui style editor.
---@param ref? ImGuiStyle
function IGuiManager.ShowStyleEditor(ref) end

---Shows the ImGui style selector.
---@param label string
---@return boolean
function IGuiManager.ShowStyleSelector(label) end

---Shows the ImGui font selector.
---@param label string
function IGuiManager.ShowFontSelector(label) end

---Shows the ImGui user guide.
function IGuiManager.ShowUserGuide() end

---Returns the ImGui version.
---@return string
---@nodiscard
function IGuiManager.GetVersion() end

--[[
Styles
--]]

---Sets the ImGui color theme to dark. (Or clones its settings into the given `dst`.)
---@param dst? ImGuiStyle
function IGuiManager.StyleColorsDark(dst) end

---Sets the ImGui color theme to light. (Or clones its settings into the given `dst`.)
---@param dst? ImGuiStyle
function IGuiManager.StyleColorsLight(dst) end

---Sets the ImGui color theme to classic. (Or clones its settings into the given `dst`.)
---@param dst? ImGuiStyle
function IGuiManager.StyleColorsClassic(dst) end

--[[
Windows
--]]

---Begins a window.
---@param name string
---@param is_open? table
---@param flags? ImGuiWindowFlags
---@return boolean
function IGuiManager.Begin(name, is_open, flags) end

---Ends the current window.
function IGuiManager.End() end

--[[
Child Windows
--]]

---Begins a child.
---@param str_id string
---@param size? table
---@param child_flags? ImGuiChildFlags
---@param window_flags? ImGuiWindowFlags
---@return boolean
function IGuiManager.BeginChild(str_id, size, child_flags, window_flags) end

---Begins a child.
---@param id number
---@param size? table
---@param child_flags? ImGuiChildFlags
---@param window_flags? ImGuiWindowFlags
---@return boolean
function IGuiManager.BeginChild(id, size, child_flags, window_flags) end

---Ends the current child.
function IGuiManager.EndChild() end

--[[
Windows Utilities
--]]


---Returns if the current window is appearing.
---@return boolean
---@nodiscard
function IGuiManager.IsWindowAppearing() end

---Returns if the current window is collapsed.
---@return boolean
---@nodiscard
function IGuiManager.IsWindowCollapsed() end

---Returns if the current window is focused.
---@param flags? ImGuiFocusedFlags
---@return boolean
---@nodiscard
function IGuiManager.IsWindowFocused(flags) end

---Returns if the current window is hovered.
---@param flags? ImGuiHoveredFlags
---@return boolean
---@nodiscard
function IGuiManager.IsWindowHovered(flags) end

---Returns the current window draw list.
---@return ImDrawList
---@nodiscard
function IGuiManager.GetWindowDrawList() end

---Returns the current window DPI scale.
---@return number
---@nodiscard
function IGuiManager.GetWindowDpiScale() end

---Returns the current window position.
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetWindowPos() end

---Returns the current window size.
---@return number width
---@return number height
---@nodiscard
function IGuiManager.GetWindowSize() end

---Returns the current window width.
---@return number
---@nodiscard
function IGuiManager.GetWindowWidth() end

---Returns the current window height.
---@return number
---@nodiscard
function IGuiManager.GetWindowHeight() end

---Returns the current window viewport.
---@return ImGuiViewport
---@nodiscard
function IGuiManager.GetWindowViewport() end

--[[
Window Manipulation
--]]

---Sets the next window position.
---@param pos table
---@param cond? ImGuiCond
---@param pivot? table
function IGuiManager.SetNextWindowPos(pos, cond, pivot) end

---Sets the next window size.
---@param size table
---@param cond? ImGuiCond
function IGuiManager.SetNextWindowSize(size, cond) end

---Sets the next window size constraints.
---@param size_min table
---@param size_max table
---@param callback? function
function IGuiManager.SetNextWindowSizeConstraints(size_min, size_max, callback) end

---Sets the next window content size.
---@param size table
function IGuiManager.SetNextWindowContentSize(size) end

---Sets the next window collapsed flag.
---@param collapsed boolean
---@param cond? ImGuiCOnd
function IGuiManager.SetNextWindowCollapsed(collapsed, cond) end

---Sets the next window focus flag.
function IGuiManager.SetNextWindowFocus() end

---Sets the next window scroll.
---@param scroll table
function IGuiManager.SetNextWindowScroll(scroll) end

---Sets the next window bg alpha.
---@param alpha number
function IGuiManager.SetNextWindowBgAlpha(alpha) end

---Sets the next window viewport.
---@param viewport_id number
function IGuiManager.SetNextWindowViewport(viewport_id) end

---Sets the current window position.
---@param pos table
---@param cond? ImGuiCond
function IGuiManager.SetWindowPos(pos, cond) end

---Sets the given window position.
---@param name string
---@param pos table
---@param cond? ImGuiCond
function IGuiManager.SetWindowPos(name, pos, cond) end

---Sets the current window size.
---@param size table
---@param cond? ImGuiCond
function IGuiManager.SetWindowSize(size, cond) end

---Sets the given window size.
---@param name string
---@param size table
---@param cond? ImGuiCond
function IGuiManager.SetWindowSize(name, size, cond) end

---Sets the current window collapsed flag.
---@param collapsed boolean
---@param cond? ImGuiCond
function IGuiManager.SetWindowCollapsed(collapsed, cond) end

---Sets the given window collapsed flag.
---@param name string
---@param collapsed boolean
---@param cond? ImGuiCond
function IGuiManager.SetWindowCollapsed(name, collapsed, cond) end

---Sets the current window focus flag.
function IGuiManager.SetWindowFocus() end

---Sets the given window focus flag.
---@param name string
function IGuiManager.SetWindowFocus(name) end

--[[
Windows Scrolling
--]]

---Returns the current window scroll X.
---@return number
---@nodiscard
function IGuiManager.GetScrollX() end

---Returns the current window scroll Y.
---@return number
---@nodiscard
function IGuiManager.GetScrollY() end

---Sets the current window scroll X.
---@param scroll_x number
function IGuiManager.SetScrollX(scroll_x) end

---Sets the current window scroll Y.
---@param scroll_y number
function IGuiManager.SetScrollY(scroll_y) end

---Returns the current window scroll X max.
---@return number
---@nodiscard
function IGuiManager.GetScrollMaxX() end

---Returns the current window scroll Y max.
---@return number
---@nodiscard
function IGuiManager.GetScrollMaxY() end

---Sets the current window scroll here X.
---@param center_x_ratio? number
function IGuiManager.SetScrollHereX(center_x_ratio) end

---Sets the current window scroll here Y.
---@param center_y_ratio? number
function IGuiManager.SetScrollHereY(center_y_ratio) end

---Sets the current window scroll from pos X.
---@param local_x number
---@param center_x_ratio? number
function IGuiManager.SetScrollFromPosX(local_x, center_x_ratio) end

---Sets the current window scroll from pos Y.
---@param local_y number
---@param center_y_ratio? number
function IGuiManager.SetScrollFromPosY(local_y, center_y_ratio) end

--[[
Parameters Stacks (Font)
--]]

---Pushes a font onto the font stack, making it the currently used font.
---@param font ImFont
---@param font_size_base_unscaled number
function IGuiManager.PushFont(font, font_size_base_unscaled) end

---Pops a font from the font stack.
function IGuiManager.PopFont() end

---Returns the current font.
---@return ImFont
---@nodiscard
function IGuiManager.GetFont() end

---Returns the current font size.
---@return number
---@nodiscard
function IGuiManager.GetFontSize() end

---Returns the current baked font.
---@return ImFontBaked
---@nodiscard
function IGuiManager.GetFontBaked() end

--[[
Parameters Stacks (Shared)
--]]

---Pushes a style color.
---@param idx ImGuiCol
---@param col number
function IGuiManager.PushStyleColor(idx, col) end

---Pushes a style color.
---@param idx ImGuiCol
---@param col table
function IGuiManager.PushStyleColor(idx, col) end

---Pops one or more style colors.
---@param count? number
function IGuiManager.PopStyleColor(count) end

---Pushes a style variable.
---@param idx ImGuiStyleVar
---@param val number
function IGuiManager.PushStyleVar(idx, val) end

---Pushes a style variable.
---@param idx ImGuiStyleVar
---@param val table
function IGuiManager.PushStyleVar(idx, val) end

---Pushes a style X variable.
---@param idx ImGuiStyleVar
---@param val_x number
function IGuiManager.PushStyleVarX(idx, val_x) end

---Pushes a style Y variable.
---@param idx ImGuiStyleVar
---@param val_y number
function IGuiManager.PushStyleVarY(idx, val_y) end

---Pops one or more style variables.
---@param count? number
function IGuiManager.PopStyleVar(count) end

---Pushes an item flag.
---@param option ImGuiItemFlags
---@param enabled boolean
function IGuiManager.PushItemFlag(option, enabled) end

---Pops an item flag.
function IGuiManager.PopItemFlag() end

--[[
Parameters Stacks (Current Window)
--]]

---Pushes a new default item width onto the current windows parameters stack.
---@param item_width number
function IGuiManager.PushItemWidth(item_width) end

---Pops the item width from the current windows parameters stack.
function IGuiManager.PopItemWidth() end

---Sets the current windows next item width.
---@param item_width number
function IGuiManager.SetNextItemWidth(item_width) end

---Calculates the item width. (Based on pushed settings and cursor position.)
---@return number
---@nodiscard
function IGuiManager.CalcItemWidth() end

---Pushes a new text wrap position onto the current windows parameters stack.
---@param wrap_local_pos_x? number
function IGuiManager.PushTextWrapPos(wrap_local_pos_x) end

---Pops the text wrap position from the current windows parameters stack.
function IGuiManager.PopTextWrapPos() end

--[[
Style Read Access
--]]

---Returns the font tex uv white pixel.
---@return number tx
---@return number ty
---@nodiscard
function IGuiManager.GetFontTexUvWhitePixel() end

---Returns the color of the given color index.
---@param idx ImGuiCol
---@param alpha_mul? number
---@return number
---@nodiscard
function IGuiManager.GetColorU32(idx, alpha_mul) end

---Converts and returns a color.
---@param col table
---@return number
---@nodiscard
function IGuiManager.GetColorU32(col) end

---Converts and returns a color.
---@param col number
---@return number
---@nodiscard
function IGuiManager.GetColorU32(col) end

---Returns the color of the given color index.
---@param idx ImGuiCol
---@return number r
---@return number g
---@return number b
---@return number a
---@nodiscard
function IGuiManager.GetStyleColorVec4(idx) end

--[[
Layout Cursor Positioning
--]]

---Returns the layout cursor screen position.
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetCursorScreenPos() end

---Sets the layour cursor screen position.
---@param pos table
function IGuiManager.SetCursorScreenPos(pos) end

---Returns the content region available size.
---@return number width
---@return number height
---@nodiscard
function IGuiManager.GetContentRegionAvail() end

---Returns the layour cursor position. (Local Window)
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetCursorPos() end

---Returns the layour cursor X position. (Local Window)
---@return number
---@nodiscard
function IGuiManager.GetCursorPosX() end

---Returns the layout cursor Y position. (Local Window)
---@return number
---@nodiscard
function IGuiManager.GetCursorPosY() end

---Sets the layout cursor position. (Local Window)
---@param local_pos table
function IGuiManager.SetCursorPos(local_pos) end

---Sets the layout cursor X position. (Local Window)
---@param local_x number
function IGuiManager.SetCursorPosX(local_x) end

---Sets the layout cursor Y position. (Local Window)
---@param local_y number
function IGuiManager.SetCursorPosY(local_y) end

---Returns the layout cursor start position. (Local Window)
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetCursorStartPos() end

--[[
Other Layout Functions
--]]

---Renders a horizontal separator.
function IGuiManager.Separator() end

---Adjusts the layout cursor to stay on the same line as a previous element.
---@param offset_from_start_x? number
---@param spacing? number
function IGuiManager.SameLine(offset_from_start_x, spacing) end

---Force a new line (or undo a SameLine) in the horizontal-layout context.
function IGuiManager.NewLine() end

---Adds vertical spacing.
function IGuiManager.Spacing() end

---Renders an empty item of the given size.
---@param size table
function IGuiManager.Dummy(size) end

---Moves the layour cursor towards the right.
---@param indent_w? number
function IGuiManager.Indent(indent_w) end

---Moves the layour cursor towards the left.
---@param indent_w? number
function IGuiManager.Unindent(indent_w) end

---Begins a group.
function IGuiManager.BeginGroup() end

---Ends the current group.
function IGuiManager.EndGroup() end

---Vertically aligns upcoming text baseline.
function IGuiManager.AlignTextToFramePadding() end

---Returns the text line height.
---@return number
---@nodiscard
function IGuiManager.GetTextLineHeight() end

---Returns the text line height with spacing.
---@return number
---@nodiscard
function IGuiManager.GetTextLineHeightWithSpacing() end

---Returns the frame height.
---@return number
---@nodiscard
function IGuiManager.GetFrameHeight() end

---Returns the frame height with spacing.
---@return number
---@nodiscard
function IGuiManager.GetFrameHeightWithSpacing() end

--[[
ID Stack/Scopes
--]]

---Pushes an ID onto the stack.
---@param str_id string
function IGuiManager.PushID(str_id) end

---Pushes an ID onto the stack.
---@param str_id_begin string
---@param str_id_end string
function IGuiManager.PushID(str_id_begin, str_id_end) end

---Pushes an ID onto the stack.
---@param ptr_id userdata
function IGuiManager.PushID(ptr_id) end

---Pushes an ID onto the stack.
---@param int_id number
function IGuiManager.PushID(int_id) end

---Removes an ID from the stack.
function IGuiManager.PopID() end

---Returns a calculated ID.
---@param str_id string
---@return number
---@nodiscard
function IGuiManager.GetID(str_id) end

---Returns a calculated ID.
---@param str_id_begin string
---@param str_id_end string
---@return number
---@nodiscard
function IGuiManager.GetID(str_id_begin, str_id_end) end

---Returns a calculated ID.
---@param ptr_id userdata
---@return number
---@nodiscard
function IGuiManager.GetID(ptr_id) end

---Returns a calculated ID.
---@param int_id number
---@return number
---@nodiscard
function IGuiManager.GetID(int_id) end

--[[
Widgets: Text
--]]

---Renders an unformatted text string.
---@param text string
function IGuiManager.TextUnformatted(text) end

---Renders an unformatted text string.
---@param text string
function IGuiManager.Text(text) end

---Not implemented.
---@deprecated
function IGuiManager.TextV() end

---Renders an unformatted text string with color.
---@param color table
---@param text string
function IGuiManager.TextColored(color, text) end

---Not implemented.
---@deprecated
function IGuiManager.TextColoredV() end

---Renders a dimmed unformatted text string.
---@param text string
function IGuiManager.TextDisabled(text) end

---Not implemented.
---@deprecated
function IGuiManager.TextDisabledV() end

---Renders a wrapped text string.
---@param text string
function IGuiManager.TextWrapped(text) end

---Not implemented.
---@deprecated
function IGuiManager.TextWrappedV() end

---Returns a text string with a label.
---@param label string
---@param text string
function IGuiManager.LabelText(label, text) end

---Not implemented.
---@deprecated
function IGuiManager.LabelTextV() end

---Renders a text string with a prefixed bullet.
---@param text string
function IGuiManager.BulletText(text) end

---Not implemented.
---@deprecated
function IGuiManager.BulletTextV() end

---Renders a separator with a text string.
---@param label string
function IGuiManager.SeparatorText(label) end

--[[
Widgets: Main
--]]

---Renders a button.
---@param label string
---@param size? table
---@return boolean
function IGuiManager.Button(label, size) end

---Renders a small button.
---@param label string
---@return boolean
function IGuiManager.SmallButton(label) end

---Renders an invisible button.
---@param str_id string
---@param size table
---@param flags? ImGuiButtonFlags
---@return boolean
function IGuiManager.InvisibleButton(str_id, size, flags) end

---Renders a button with an arrow glyph.
---@param str_id string
---@param dir ImGuiDir
---@return boolean
function IGuiManager.ArrowButton(str_id, dir) end

---Renders a checkbox.
---@param label string
---@param val table
---@return boolean
function IGuiManager.Checkbox(label, val) end

---Renders a checkbox for flags.
---@param label string
---@param flags_and_data table
---@return boolean
function IGuiManager.CheckboxFlags(label, flags_and_data) end

---Renders a radio button.
---@param label string
---@param active boolean
---@return boolean
function IGuiManager.RadioButton(label, active) end

---Renders a radio button.
---@param label string
---@param val table
---@param v_button number
---@return boolean
function IGuiManager.RadioButton(label, val, v_button) end

---Renders a progress bar.
---@param fraction number
---@param size_arg? table
---@param overlay? string
function IGuiManager.ProgressBar(fraction, size_arg, overlay) end

---Renders a bullet.
function IGuiManager.Bullet() end

---Renders a text link.
---@param label string
---@return boolean
function IGuiManager.TextLink(label) end

---Renders a text link.
---@param label string
---@param url? string
---@return boolean
function IGuiManager.TextLinkOpenURL(label, url) end

--[[
Widgets: Images
--]]

---Renders an image.
---@param tex_ref number
---@param size table
---@param uv0? table
---@param uv1? table
function IGuiManager.Image(tex_ref, size, uv0, uv1) end

---Renders an image with a background.
---@param tex_ref number
---@param size table
---@param uv0? table
---@param uv1? table
---@param bg_color? table
---@param tint_color? table
function IGuiManager.ImageWithBg(tex_ref, size, uv0, uv1, bg_color, tint_color) end

---Renders an image button.
---@param str_id string
---@param tex_ref number
---@param image_size size
---@param uv0? table
---@param uv1? table
---@param bg_color? table
---@param tint_color? table
---@return boolean
function IGuiManager.ImageButton(str_id, tex_ref, size, uv0, uv1, bg_color, tint_color) end

--[[
Widgets: Combo Box (Dropdown)
--]]

---Begins a combo.
---@param label string
---@param preview_value string
---@param flags? ImGuiComboFlags
---@return boolean
function IGuiManager.BeginCombo(label, preview_value, flags) end

---Ends the current combo.
function IGuiManager.EndCombo() end

---Renders a combo.
---@param label string
---@param current_item table
---@param items table
---@param items_count number
---@param popup_max_height_in_items? number
---@return boolean
function IGuiManager.Combo(label, current_item, items, items_count, popup_max_height_in_items) end

---Renders a combo.
---@param label string
---@param current_item table
---@param items_separated_by_zeros string
---@param popup_max_height_in_items? number
---@return boolean
function IGuiManager.Combo(label, current_item, items_separated_by_zeros, popup_max_height_in_items) end

--[[
Widgets: Drag Sliders
--]]

---Renders a dragger. (float)
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragFloat(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a dragger. (float)
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragFloat2(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a dragger. (float)
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragFloat3(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a dragger (float).
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragFloat4(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a ranged dragger. (float)
---@param label string
---@param v_current_min table
---@param v_current_max table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param format_max? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags) end

---Renders a dragger. (int)
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragInt(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a dragger. (int)
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragInt2(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a dragger. (int)
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragInt3(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a dragger. (int)
---@param label string
---@param val table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragInt4(label, val, v_speed, v_min, v_max, format, flags) end

---Renders a ranged dragger. (int)
---@param label string
---@param v_current_min table
---@param v_current_max table
---@param v_speed? number
---@param v_min? number
---@param v_max? number
---@param format? string
---@param format_max? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags) end

---Renders a dragger. (Scalar)
---@param label string
---@param data_type ImGuiDataType
---@param p_data table
---@param v_speed? number
---@param p_min? table
---@param p_max? table
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragScalar(label, data_type, p_data, v_speed, p_min, p_max, format, flags) end

---Renders a dragger. (ScalarN)
---@param label string
---@param data_type ImGuiDataType
---@param p_data table
---@param components number
---@param v_speed? number
---@param p_min? table
---@param p_max? table
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.DragScalarN(label, data_type, p_data, components, v_speed, p_min, p_max, format, flags) end

--[[
Widgets: Regular Sliders
--]]

---Renders a slider. (float)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderFloat(label, val, v_min, v_max, format, flags) end

---Renders a slider. (float)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderFloat2(label, val, v_min, v_max, format, flags) end

---Renders a slider. (float)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderFloat3(label, val, v_min, v_max, format, flags) end

---Renders a slider. (float)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderFloat4(label, val, v_min, v_max, format, flags) end

---Renders an angle slider.
---@param label string
---@param v_rad table
---@param v_degrees_min? number
---@param v_degrees_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderAngle(label, v_rad, v_degrees_min, v_degrees_max, format, flags) end

---Renders a slider. (int)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderInt(label, val, v_min, v_max, format, flags) end

---Renders a slider. (int)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderInt2(label, val, v_min, v_max, format, flags) end

---Renders a slider. (int)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderInt3(label, val, v_min, v_max, format, flags) end

---Renders a slider. (int)
---@param label string
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderInt4(label, val, v_min, v_max, format, flags) end

---Renders a slider. (Scalar)
---@param label string
---@param data_type ImGuiDataType
---@param p_data table
---@param p_min? table
---@param p_max? table
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderScalar(label, data_type, p_data, p_min, p_max, format, flags) end

---Renders a slider. (ScalarN)
---@param label string
---@param data_type ImGuiDataType
---@param p_data table
---@param components number
---@param p_min? table
---@param p_max? table
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.SliderScalarN(label, data_type, p_data, components, p_min, p_max, format, flags) end

---Renders a vertical slider. (float)
---@param label string
---@param size table
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.VSliderFloat(label, size, val, v_min, v_max, format, flags) end

---Renders a vertical slider. (int)
---@param label string
---@param size table
---@param val table
---@param v_min? number
---@param v_max? number
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.VSliderInt(label, size, val, v_min, v_max, format, flags) end

---Renders a vertical slider. (Scalar)
---@param label string
---@param size table
---@param data_type ImGuiDataType
---@param p_data table
---@param p_min? table
---@param p_max? table
---@param format? string
---@param flags? ImGuiSliderFlags
---@return boolean
function IGuiManager.VSliderScalar(label, size, data_type, p_data, p_min, p_max, format, flags) end

--[[
Widgets: Input With Keyboard
--]]

---Renders an input text editor.
---@param label string
---@param buffer table
---@param buffer_size number
---@param flags? ImGuiInputTextFlags
---@param callback? function
---@return boolean
function IGuiManager.InputText(label, buffer, buffer_size, flags, callback) end

---Renders an input text editor. (Multiline)
---@param label string
---@param buffer buffer
---@param buffer_size number
---@param size? table
---@param flags? ImGuiInputTextFlags
---@param callback? function
---@return boolean
function IGuiManager.InputTextMultiline(label, buffer, buffer_size, size, flags, callback) end

---Renders an input text editor with hint.
---@param label string
---@param hint string
---@param buffer table
---@param buffer_size number
---@param flags? ImGuiInputTextFlags
---@param callback? function
---@return boolean
function IGuiManager.InputTextWithHint(label, hint, buffer, buffer_size, flags, callback) end

---Renders an input editor. (float)
---@param label string
---@param val table
---@param step? number
---@param step_fast? number
---@param format? string
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputFloat(label, val, step, step_fast, format, flags) end

---Renders an input editor. (float)
---@param label string
---@param val table
---@param format? string
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputFloat2(label, val, format, flags) end

---Renders an input editor. (float)
---@param label string
---@param val table
---@param format? string
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputFloat3(label, val, format, flags) end

---Renders an input editor. (float)
---@param label string
---@param val table
---@param format? string
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputFloat4(label, val, format, flags) end

---Renders an input editor. (int)
---@param label string
---@param val table
---@param step? number
---@param step_fast? number
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputInt(label, val, step, step_fast, flags) end

---Renders an input editor. (int)
---@param label string
---@param val table
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputInt2(label, val, flags) end

---Renders an input editor. (int)
---@param label string
---@param val table
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputInt3(label, val, flags) end

---Renders an input editor. (int)
---@param label string
---@param val table
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputInt4(label, val, flags) end

---Renders an input editor. (double)
---@param label string
---@param val table
---@param step? number
---@param step_fast? number
---@param format? string
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputDouble(label, val, step, step_fast, format, flags) end

---Renders an input editor. (Scalar)
---@param label string
---@param data_type ImGuiDataType
---@param p_data table
---@param p_step? table
---@param p_step_fast? table
---@param format? string
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputScalar(label, data_type, p_data, p_step, p_step_fast, format, flags) end

---Renders an input editor. (ScalarN)
---@param label string
---@param data_type ImGuiDataType
---@param p_data table
---@param components number
---@param p_step? table
---@param p_step_fast? table
---@param format? string
---@param flags? ImGuiInputTextFlags
---@return boolean
function IGuiManager.InputScalarN(label, data_type, p_data, components, p_step, p_step_fast, format, flags) end

--[[
Widgets: Color Editor/Picker
--]]

---Renders a color editor.
---@param label string
---@param color table
---@param flags? ImGuiColorEditFlags
---@return boolean
function IGuiManager.ColorEdit3(label, color, flags) end

---Renders a color editor.
---@param label string
---@param color table
---@param flags? ImGuiColorEditFlags
---@return boolean
function IGuiManager.ColorEdit4(label, color, flags) end

---Renders a color editor.
---@param label string
---@param color table
---@param flags? ImGuiColorEditFlags
---@return boolean
function IGuiManager.ColorPicker3(label, color, flags) end

---Renders a color editor.
---@param label string
---@param color table
---@param flags? ImGuiColorEditFlags
---@param ref_color? table
---@return boolean
function IGuiManager.ColorPicker4(label, color, flags, ref_color) end

---Renders a color editor button.
---@param desc_id string
---@param color table
---@param flags? ImGuiColorEditFlags
---@param size? table
---@return boolean
function IGuiManager.ColorButton(desc_id, color, flags, size) end

---Sets the color editor options.
---@param flags ImGuiColorEditFlags
function IGuiManager.SetColorEditOptions(flags) end

--[[
Widgets: Trees
--]]

---Renders a tree node.
---@param label string
---@return boolean
function IGuiManager.TreeNode(label) end

---Renders a tree node.
---@param str_id string
---@param text string
---@return boolean
function IGuiManager.TreeNode(str_id, text) end

---Renders a tree node.
---@param ptr_id userdata
---@param text string
---@return boolean
function IGuiManager.TreeNode(ptr_id, text) end

---Not implemented.
---@deprecated
function IGuiManager.TreeNodeV() end

---Renders a tree node.
---@param label string
---@param flags? ImGuiTreeNodeFlags
---@return boolean
function IGuiManager.TreeNodeEx(label, flags) end

---Renders a tree node.
---@param str_id string
---@param flags ImGuiTreeNodeFlags
---@param text string
---@return boolean
function IGuiManager.TreeNodeEx(str_id, flags, text) end

---Renders a tree node.
---@param ptr_id userdata
---@param flags ImGuiTreeNodeFlags
---@param text string
---@return boolean
function IGuiManager.TreeNodeEx(ptr_id, flags, text) end

---Not implemented.
---@deprecated
function IGuiManager.TreeNodeExV() end

---Pushes a tree to the stack.
---@param str_id string
function IGuiManager.TreePush(str_id) end

---Pushes a tree to the stack.
---@param ptr_id userdata
function IGuiManager.TreePush(ptr_id) end

---Pops a tree from the stack.
function IGuiManager.TreePop() end

---Returns the tree node label spacing.
---@return number
---@nodiscard
function IGuiManager.GetTreeNodeToLabelSpacing() end

---Renders a collapsing header.
---@param label string
---@param flags? ImGuiTreeNodeFlags
---@return boolean
function IGuiManager.CollapsingHeader(label, flags) end

---Renders a collapsing header.
---@param label string
---@param is_visible table
---@param flags? ImGuiTreeNodeFlags
---@return boolean
function IGuiManager.CollapsingHeader(label, is_visible, flags) end

---Sets the next item open flag.
---@param is_open boolean
---@param cond? ImGuiCond
function IGuiManager.SetNextItemOpen(is_open, cond) end

---Sets the next item storage id.
---@param storage_id number
function IGuiManager.SetNextItemStorageID(storage_id) end

--[[
Widgets: Selectables
--]]

---Renders a selectable.
---@param label string
---@param selected? boolean
---@param flags? ImGuiSelectableFlags
---@param size? table
---@return boolean
function IGuiManager.Selectable(label, selected, flags, size) end

---Renders a selectable.
---@param label string
---@param p_selected table
---@param flags? ImGuiSelectableFlags
---@param size? table
---@return boolean
function IGuiManager.Selectable(label, p_selected, flags, size) end

--[[
Multi-selection System for Selectable(), Checkbox(), TreeNode() Functions [BETA]
--]]

---Begins a multi-select.
---@param flags ImGuiMultiSelectFlags
---@param selection_size? number
---@param items_count? number
---@return ImGuiMultiSelectIO
function IGuiManager.BeginMultiSelect(flags, selection_size, items_count) end

---Ends the current multi-select.
---@return ImGuiMultiSelectIO
function IGuiManager.EndMultiSelect() end

---Sets the next item selection user data.
---@param selection_user_data ImGuiSelectionUserData
function IGuiManager.SetNextItemSelectionUserData(selection_user_data) end

---Returns if the last items selection state was toggled.
---@return boolean
function IGuiManager.IsItemToggledSelection() end

--[[
Widgets: List Boxes
--]]

---Begins a list box.
---@param label string
---@param size? table
---@return boolean
function IGuiManager.BeginListBox(label, size) end

---Ends the current list box.
function IGuiManager.EndListBox() end

---Renders a list box.
---@param label string
---@param current_item table
---@param items tables
---@param items_count number
---@param height_in_items? number
---@return boolean
function IGuiManager.ListBox(label, current_item, items, items_count, height_in_items) end

--[[
Widgets: Data Plotting
--]]

---Renders a line plot.
---@param label string
---@param values table
---@param values_count number
---@param values_offset? number
---@param overlay_text? string
---@param scale_min? number
---@param scale_max? number
---@param graph_size? table
---@param stride? number
function IGuiManager.PlotLines(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride) end

---Renders a histogram plot.
---@param label string
---@param values table
---@param values_count number
---@param values_offset? number
---@param overlay_text? string
---@param scale_min? number
---@param scale_max? number
---@param graph_size? table
---@param stride? number
function IGuiManager.PlotHistogram(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride) end

--[[
Widgets: Value() Helpers.
--]]

---Renders a value. (boolean)
---@param prefix string
---@param val boolean
function IGuiManager.Value(prefix, val) end

---Renders a value. (int)
---@param prefix string
---@param val table
function IGuiManager.Value(prefix, val) end

---Renders a value. (float)
---@param prefix string
---@param val number
---@param format? string
function IGuiManager.Value(prefix, val, format) end

--[[
Widgets: Menus
--]]

---Begins a menu bar.
---@return boolean
function IGuiManager.BeginMenuBar() end

---Ends the current menu bar.
function IGuiManager.EndMenuBar() end

---Begins a main menu bar.
---@return boolean
function IGuiManager.BeginMainMenuBar() end

---Ends the current main menu bar.
function IGuiManager.EndMainMenuBar() end

---Begins a menu.
---@param label string
---@param enabled? boolean
---@return boolean
function IGuiManager.BeginMenu(label, enabled) end

---Ends the current menu.
function IGuiManager.EndMenu() end

---Renders a menu item.
---@param label string
---@param shortcut? string
---@param selected? boolean
---@param enabled? boolean
---@return boolean
function IGuiManager.MenuItem(label, shortcut, selected, enabled) end

---Renders a menu item.
---@param label string
---@param shortcut string
---@param p_selected? table
---@param enabled? boolean
---@return boolean
function IGuiManager.MenuItem(label, shortcut, p_selected, enabled) end

--[[
Tooltips
--]]

---Begins a tooltip.
---@return boolean
function IGuiManager.BeginTooltip() end

---Ends the current tooltip.
function IGuiManager.EndTooltip() end

---Sets the current tooltip.
---@param text string
function IGuiManager.SetTooltip(text) end

---Not implemented.
---@deprecated
function IGuiManager.SetTooltipV() end

--[[
Tooltips: Helpers
--]]

---Begins an item tooltip.
---@return boolean
function IGuiManager.BeginItemTooltip() end

---Sets an item tooltip.
---@param text string
function IGuiManager.SetItemTooltip(text) end

---Not implemented.
---@deprecated
function IGuiManager.SetItemTooltipV() end

--[[
Popups, Modals
--]]

---Begins a popup.
---@param str_id string
---@param flags? ImGuiWindowFlags
---@return boolean
function IGuiManager.BeginPopup(str_id, flags) end

---Begins a modal popup.
---@param str_id string
---@param p_open? table
---@param flags? ImGuiWindowFlags
---@return boolean
function IGuiManager.BeginPopupModal(str_id, p_open, flags) end

---Ends the current popup.
function IGuiManager.EndPopup() end

--[[
Popups: Open/Close Functions
--]]

---Opens a popup.
---@param str_id string
---@param popup_flags? ImGuiPopupFlags
function IGuiManager.OpenPopup(str_id, popup_flags) end

---Opens a popup.
---@param id number
---@param popup_flags? ImGuiPopupFlags
function IGuiManager.OpenPopup(id, popup_flags) end

---Opens a popup on item click.
---@param str_id? string
---@param popup_flags? ImGuiPopupFlags
function IGuiManager.OpenPopupOnItemClick(str_id, popup_flags) end

---Closes the current popup.
function IGuiManager.CloseCurrentPopup() end

--[[
Popups: Open/Begin Functions
--]]

---Begins a popup context item.
---@param str_id? string
---@param popup_flags? ImGuiPopupFlags
---@return boolean
function IGuiManager.BeginPopupContextItem(str_id, popup_flags) end

---Begins a popup context window.
---@param str_id? string
---@param popup_flags? ImGuiPopupFlags
---@return boolean
function IGuiManager.BeginPopupContextWindow(str_id, popup_flags) end

---Begins a popup context void.
---@param str_id? string
---@param popup_flags? ImGuiPopupFlags
---@return boolean
function IGuiManager.BeginPopupContextVoid(str_id, popup_flags) end

--[[
Popups: Query Functions
--]]

---Returns if a popup is open.
---@param str_id string
---@param popup_flags? ImGuiPopupFlags
---@return boolean
function IGuiManager.IsPopupOpen(str_id, popup_flags) end

--[[
Tables
--]]

---Begins a table.
---@param str_id string
---@param columns number
---@param flags? ImGuiTableFlags
---@param outer_size? table
---@param inner_width? number
---@return boolean
function IGuiManager.BeginTable(str_id, columns, flags, outer_size, inner_width) end

---Ends the current table.
function IGuiManager.EndTable() end

---Begins the next table row.
---@param row_flags? ImGuiTableRowFlags
---@param min_row_height? number
function IGuiManager.TableNextRow(row_flags, min_row_height) end

---Begins the next table column.
---@return boolean
function IGuiManager.TableNextColumn() end

---Sets the next table column index.
---@param column_n number
---@return boolean
function IGuiManager.TableSetColumnIndex(column_n) end

--[[
Tables: Headers & Columns Declaration
--]]

---Sets up a table column.
---@param label string
---@param flags? ImGuiTableColumnFlags
---@param init_width_or_height? number
---@param user_id? number
function IGuiManager.TableSetupColumn(label, flags, init_width_or_height, user_id) end

---Sets the table scroll freeze.
---@param cols number
---@param rows number
function IGuiManager.TableSetupScrollFreeze(cols, rows) end

---Submits a table header manually.
---@param label string
function IGuiManager.TableHeader(label) end

---Renders the table headers row.
function IGuiManager.TableHeadersRow() end

---Renders the table headers row. (Angled)
function IGuiManager.TableAngledHeadersRow() end

--[[
Tables: Sorting & Miscellaneous Functions
--]]

---Returns the tables sort specs.
---@return ImGuiTableSortSpecs
---@nodiscard
function IGuiManager.TableGetSortSpecs() end

---Returns the tables column count.
---@return number
---@nodiscard
function IGuiManager.TableGetColumnCount() end

---Returns the tables column index.
---@return number
---@nodiscard
function IGuiManager.TableGetColumnIndex() end

---Returns the tables row index.
---@return number
---@nodiscard
function IGuiManager.TableGetRowIndex() end

---Returns the current, or requested, table column name.
---@param column_n? number
---@return string
---@nodiscard
function IGuiManager.TableGetColumnName(column_n) end

---Returns the current, or requested, table column flags.
---@param column_n? number
---@return ImGuiTableColumnFlags
---@nodiscard
function IGuiManager.TableGetColumnFlags(column_n) end

---Sets the table column enabled flag.
---@param column_n number
---@param val boolean
function IGuiManager.TableSetColumnEnabled(column_n, val) end

---Returns the current hovered table column index.
---@return number
---@nodiscard
function IGuiManager.TableGetHoveredColumn() end

---Sets the table background color.
---@param target ImGuiTableBgTarget
---@param color number
---@param column_n? number
function IGuiManager.TableSetBgColor(target, color, column_n) end

--[[
Legacy Columns API
--]]

---Prepares column space for usage.
---@param count? number
---@param id? string
---@param border? boolean
function IGuiManager.Columns(count, id, border) end

---Begins the next column.
function IGuiManager.NextColumn() end

---Returns the current column index.
---@return number
---@nodiscard
function IGuiManager.GetColumnIndex() end

---Returns the current, or requested, column width.
---@param column_index? number
---@return number
---@nodiscard
function IGuiManager.GetColumnWidth(column_index) end

---Sets the column width.
---@param column_index number
---@param width number
function IGuiManager.SetColumnWidth(column_index, width) end

---Returns the current, or requested, column offset.
---@param column_index? number
---@return number
---@nodiscard
function IGuiManager.GetColumnOffset(column_index) end

---Sets the column offset.
---@param column_index number
---@param offset_x number
function IGuiManager.SetColumnOffset(column_index, offset_x) end

---Returns the columns count.
---@return number
---@nodiscard
function IGuiManager.GetColumnsCount() end

--[[
Tab Bars, Tabs
--]]

---Begins a tab bar.
---@param str_id string
---@param flags? ImGuiTabBarFlags
---@return boolean
function IGuiManager.BeginTabBar(str_id, flags) end

---Ends the current tab bar.
function IGuiManager.EndTabBar() end

---Begins a tab item.
---@param str_id string
---@param p_open? table
---@param flags? ImGuiTabItemFlags
---@return boolean
function IGuiManager.BeginTabItem(str_id, p_open, flags) end

---Ends the current tab item.
function IGuiManager.EndTabItem() end

---Renders a tab item. (Behaves like a button.)
---@param label string
---@param flags? ImGuiTabItemFlags
---@return boolean
function IGuiManager.TabItemButton(label, flags) end

---Notifies the tab bar (or docking system) of a closed tab.
---@param tab_or_docked_window_label string
function IGuiManager.SetTabItemClosed(tab_or_docked_window_label) end

--[[
Docking
--]]

---Creates a dockspace.
---@param dockspace_id number
---@param size? table
---@param flags? ImGuiDockNodeFlags
---@param window_class? IGuiWindowClass
---@return number
function IGuiManager.DockSpace(dockspace_id, size, flags, window_class) end

---Creates a dockspace over a specific viewport.
---@param dockspace_id? number
---@param viewport? ImGuiViewport
---@param flags? ImGuiDockNodeFlags
---@param window_class? ImGuiWindowClass
---@return number
function IGuiManager.DockSpaceOverViewport(dockspace_id, viewport, flags, window_class) end

---Sets the next window dock id.
---@param dock_id number
---@param cond? ImGuiCond
function IGuiManager.SetNextWindowDockID(dock_id, cond) end

---Sets the next window class.
---@param window_class ImGuiWindowClass
function IGuiManager.SetNextWindowClass(window_class) end

---Returns the window dock id.
---@return number
---@nodiscard
function IGuiManager.GetWindowDockID() end

---Returns if the current window is docked.
---@return boolean
---@nodiscard
function IGuiManager.IsWindowDocked() end

--[[
Logging/Capture
--]]

---Starts logging to TTY.
---@param auto_open_depth? number
function IGuiManager.LogToTTY(auto_open_depth) end

---Starts logging to file.
---@param auto_open_depth? number
---@param filename? string
function IGuiManager.LogToFile(auto_open_depth, filename) end

---Starts logging to clipboard.
---@param auto_open_depth? number
function IGuiManager.LogToClipboard(auto_open_depth) end

---Finishes the current logging.
function IGuiManager.LogFinish() end

---Renders helper buttons to start logging.
function IGuiManager.LogButtons() end

---Logs the given text.
---@param text string
function IGuiManager.LogText(text) end

---Not implemented.
---@deprecated
function IGuiManager.LogTextV() end

--[[
Drag and Drop
--]]

---Begins new drag and drop source.
---@param flags? ImGuiDragDropFlags
---@return boolean
function IGuiManager.BeginDragDropSource(flags) end

---Sets the drag and drop payload.
---@param type string
---@param data userdata
---@param sz number
---@param cond? ImGuiCond
---@return boolean
function IGuiManager.SetDragDropPayload(type, data, sz, cond) end

---Ends the current drag and drop source.
function IGuiManager.EndDragDropSource() end

---Begins new drag and drop target.
---@return boolean
function IGuiManager.BeginDragDropTarget() end

---Accepts the drag and drop payload.
---@param type string
---@param flags? ImGuiDragDropFlags
---@return ImGuiPayload
function IGuiManager.AcceptDragDropPayload(type, flags) end

---Ends the current drag and drop target.
function IGuiManager.EndDragDropTarget() end

---Returns the drag and drop payload.
---@return ImGuiPayload
---@nodiscard
function IGuiManager.GetDragDropPayload() end

--[[
Disabling [BETA API]
--]]

---Begins a disabled block.
---@param disabled? boolean
function IGuiManager.BeginDisabled(disabled) end

---Ends a disabled block.
function IGuiManager.EndDisabled() end

--[[
Clipping
--]]

---Pushes a clip rect onto the stack.
---@param clip_rect_min table
---@param clip_rect_max table
---@param intersect_with_current_clip_rect boolean
function IGuiManager.PushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect) end

---Pops a clip rect from the stack.
function IGuiManager.PopClipRect() end

--[[
Focus, Activation
--]]

---Sets the default item focus.
function IGuiManager.SetItemDefaultFocus() end

---Sets the keyboard focus.
---@param offset? number
function IGuiManager.SetKeyboardFocusHere(offset) end

--[[
Keyboard/Gamepad Navigation
--]]

---Sets the nav cursor visible flag.
---@param visible boolean
function IGuiManager.SetNavCursorVisible(visible) end

--[[
Overlapping Mode
--]]

---Sets the next item allow overlap flag.
function IGuiManager.SetNextItemAllowOverlap() end

--[[
Item/Widgets Utilities and Query Functions
--]]

---Returns if the last item is hovered.
---@param flags? ImGuiHoveredFlags
---@return boolean
---@nodiscard
function IGuiManager.IsItemHovered(flags) end

---Returns if the last item is active.
---@return boolean
---@nodiscard
function IGuiManager.IsItemActive() end

---Returns if the last item is focused.
---@return boolean
---@nodiscard
function IGuiManager.IsItemFocused() end

---Returns if the last item is clicked.
---@param mouse_button? ImGuiMouseButton
---@return boolean
---@nodiscard
function IGuiManager.IsItemClicked(mouse_button) end

---Returns if the last item is visible.
---@return boolean
---@nodiscard
function IGuiManager.IsItemVisible() end

---Returns if the last item is edited.
---@return boolean
---@nodiscard
function IGuiManager.IsItemEdited() end

---Returns if the last item is activated.
---@return boolean
---@nodiscard
function IGuiManager.IsItemActivated() end

---Returns if the last item is deactivated.
---@return boolean
---@nodiscard
function IGuiManager.IsItemDeactivated() end

---Returns if the last item is deactivated after edit.
---@return boolean
---@nodiscard
function IGuiManager.IsItemDeactivatedAfterEdit() end

---Returns if the last item is toggled open.
---@return boolean
---@nodiscard
function IGuiManager.IsItemToggledOpen() end

---Returns if the any item is hovered.
---@return boolean
---@nodiscard
function IGuiManager.IsAnyItemHovered() end

---Returns if the any item is active.
---@return boolean
---@nodiscard
function IGuiManager.IsAnyItemActive() end

---Returns if the any item is focused.
---@return boolean
---@nodiscard
function IGuiManager.IsAnyItemFocused() end

---Returns the current item id.
---@return number
---@nodiscard
function IGuiManager.GetItemID() end

---Returns the upper-left bounding rect of the last item.
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetItemRectMin() end

---Returns the lower-right bounding rect of the last item.
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetItemRectMax() end

---Returns the size of the last item.
---@return number width
---@return number height
---@nodiscard
function IGuiManager.GetItemRectSize() end

--[[
Viewports
--]]

---Returns the main viewport.
---@return ImGuiViewport
---@nodiscard
function IGuiManager.GetMainViewport() end

--[[
Background/Foreground Draw Lists
--]]

---Returns the background draw list.
---@param viewport? ImGuiViewport
---@return ImDrawList
---@nodiscard
function IGuiManager.GetBackgroundDrawList(viewport) end

---Returns the foreground draw list.
---@param viewport? ImGuiViewport
---@return ImDrawList
---@nodiscard
function IGuiManager.GetForegroundDrawList(viewport) end

--[[
Miscellaneous Utilities
--]]

---Returns if the given rect is visible.
---@param size table
---@return boolean
---@nodiscard
function IGuiManager.IsRectVisible(size) end

---Returns if the given rect is visible.
---@param rect_min table
---@param rect_max table
---@return boolean
---@nodiscard
function IGuiManager.IsRectVisible(rect_min, rect_max) end

---Returns the global ImGui time.
---@return number
---@nodiscard
function IGuiManager.GetTime() end

---Returns the global ImGui frame count.
---@return number
---@nodiscard
function IGuiManager.GetFrameCount() end

---Returns the draw list shared data.
---@return ImDrawListSharedData
---@nodiscard
function IGuiManager.GetDrawListSharedData() end

---Returns the color name by its index.
---@param idx ImGuiCol
---@return string
---@nodiscard
function IGuiManager.GetStyleColorName(idx) end

---Sets the state storage.
---@param storage ImGuiStorage
function IGuiManager.SetStateStorage(storage) end

---Returns the state storage.
---@return ImGuiStorage
---@nodiscard
function IGuiManager.GetStateStorage() end

--[[
Text Utilities
--]]

---Returns the calculated text size.
---@param text string
---@param hide_text_after_double_hash? boolean
---@param wrap_width? number
---@return number width
---@return number height
---@nodiscard
function IGuiManager.CalcTextSize(text, hide_text_after_double_hash, wrap_width) end

--[[
Color Utilities
--]]

---Converts a color.
---@param color number
---@return number r
---@return number g
---@return number b
---@return number a
---@nodiscard
function IGuiManager.ColorConvertU32ToFloat4(color) end

---Converts a color.
---@param color table
---@return number
---@nodiscard
function IGuiManager.ColorConvertFloat4ToU32(color) end

---Converts a color.
---@param r number
---@param g number
---@param b number
---@return number h
---@return number s
---@return number v
---@nodiscard
function IGuiManager.ColorConvertRGBtoHSV(r, g, b) end

---Converts a color.
---@param h number
---@param s number
---@param v number
---@return number r
---@return number g
---@return number b
---@nodiscard
function IGuiManager.ColorConvertHSVtoRGB(h, s, v) end

--[[
Inputs Utilities: Keyboard/Mouse/Gamepad
--]]

---Returns if a key is currently down.
---@param key ImGuiKey
---@return boolean
---@nodiscard
function IGuiManager.IsKeyDown(key) end

---Returns if a key is currently pressed.
---@param key ImGuiKey
---@param repeat? boolean
---@return boolean
---@nodiscard
function IGuiManager.IsKeyPressed(key, repeat) end

---Returns if a key is released.
---@param key ImGuiKey
---@return boolean
---@nodiscard
function IGuiManager.IsKeyReleased(key) end

---Returns if a key chord is currently pressed.
---@param key_chord ImGuiKeyChord
---@return boolean
---@nodiscard
function IGuiManager.IsKeyChordPressed(key_chord) end

---Returns the key pressed amount.
---@param key ImGuiKey
---@param repeat_delay number
---@param rate number
---@return number
---@nodiscard
function IGuiManager.GetKeyPressedAmount(key, repeat_delay, rate) end

---Returns the key name.
---@param key ImGuiKey
---@return string
---@nodiscard
function IGuiManager.GetKeyName(key) end

---Sets the WantCaptureKeyboard flag for the next frame.
---@param want_capture_keyboard boolean
function IGuiManager.SetNextFrameWantCaptureKeyboard(want_capture_keyboard) end

--[[
Inputs Utilities: Shortcut Testing & Routing [BETA]
--]]

---Returns if the given shortcut is active.
---@param key_chord ImGuiKeyChord
---@param flags? ImGuiInputFlags
---@return boolean
---@nodiscard
function IGuiManager.Shortcut(key_chord, flags) end

---Sets the next item shortcut.
---@param key_chord ImGuiKeyChord
---@param flags? ImGuiInputFlags
function IGuiManager.SetNextItemShortcut(key_chord, flags) end

--[[
Inputs Utilities: Key/Input Ownership [BETA]
--]]

---Sets a key item owner.
---@param key ImGuiKey
function IGuiManager.SetItemKeyOwner(key) end

--[[
Inputs Utilities: Mouse
--]]

---Returns if the given mouse button is down.
---@param button ImGuiMouseButton
---@return boolean
---@nodiscard
function IGuiManager.IsMouseDown(button) end

---Returns if the given mouse button is clicked.
---@param button ImGuiMouseButton
---@param repeat? boolean
---@return boolean
---@nodiscard
function IGuiManager.IsMouseClicked(button, repeat) end

---Returns if the given mouse button is released.
---@param button ImGuiMouseButton
---@return boolean
---@nodiscard
function IGuiManager.IsMouseReleased(button) end

---Returns if the given mouse button is double clicked.
---@param button ImGuiMouseButton
---@return boolean
---@nodiscard
function IGuiManager.IsMouseDoubleClicked(button) end

---Returns if the given mouse button is released (with delay).
---@param button ImGuiMouseButton
---@param delay number
---@return boolean
---@nodiscard
function IGuiManager.IsMouseReleasedWithDelay(button, delay) end

---Returns the given mouse buttons click count.
---@param button ImGuiMouseButton
---@return number
---@nodiscard
function IGuiManager.GetMouseClickedCount(button) end

---Returns if the mouse is hovering over the given rect.
---@param r_min table
---@param r_max table
---@param clip? boolean
---@return boolean
---@nodiscard
function IGuiManager.IsMouseHoveringRect(r_min, r_max, clip) end

---Returns if the current, or given, mouse position is valid.
---@param mouse_pos? table
---@return boolean
---@nodiscard
function IGuiManager.IsMousePosValid(mouse_pos) end

---Returns if any mouse button is down.
---@return boolean
---@nodiscard
function IGuiManager.IsAnyMouseDown() end

---Returns the current mouse position.
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetMousePos() end

---Returns the current mouse position upon opening the current popup.
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetMousePosOnOpeningCurrentPopup() end

---Returns if the mouse is currently dragging.
---@param button ImGuiMouseButton
---@param lock_threshold? number
---@return boolean
---@nodiscard
function IGuiManager.IsMouseDragging(button, lock_threshold) end

---Returns the mouse drag delta.
---@param button ImGuiMouseButton
---@param lock_threshold? number
---@return number x
---@return number y
---@nodiscard
function IGuiManager.GetMouseDragDelta(button, lock_threshold) end

---Resets the mouse drag delta.
---@param button? ImGuiMouseButton
function IGuiManager.ResetMouseDragDelta(button) end

---Returns the current mouse cursor.
---@return ImGuiMouseCursor
---@nodiscard
function IGuiManager.GetMouseCursor() end

---Sets the current mouse cursor.
---@param cursor_type ImGuiMouseCursor
function IGuiManager.SetMouseCursor(cursor_type) end

---Sets the WantCaptureMouse flag for the next frame.
---@param want_capture_mouse boolean
function IGuiManager.SetNextFrameWantCaptureMouse(want_capture_mouse) end

--[[
Clipboard Utilities
--]]

---Returns the current clipboard text.
---@return string
---@nodiscard
function IGuiManager.GetClipboardText() end

---Sets the current clipboard text.
---@param text string
function IGuiManager.SetClipboardText(text) end

--[[
Settings/.Ini Utilities
--]]

---Loads ImGui settings from a file on disk.
---@param ini_filename string
function IGuiManager.LoadIniSettingsFromDisk(ini_filename) end

---Loads ImGui settings from memory.
---@param ini_data string
---@param ini_size? number
function IGuiManager.LoadIniSettingsFromMemory(ini_data, ini_size) end

---Saves ImGui settings to a file on disk.
---@param ini_filename string
function IGuiManager.SaveIniSettingsToDisk(ini_filename) end

---Saves ImGui settings to memory.
---@param out_ini_size? table
---@return string
---@nodiscard
function IGuiManager.SaveIniSettingsToMemory(out_ini_size) end

--[[
Debug Utilities
--]]

---Debugs text encoding.
---@param text string
function IGuiManager.DebugTextEncoding(text) end

---Debugs style color by flashing all usages.
---@param idx ImGuiCol
function IGuiManager.DebugFlashStyleColor(idx) end

---Debugs item selection. (Warning: Do not use this, it will crash the game!)
function IGuiManager.DebugStartItemPicker() end

---Debugs version and data layout information.
---@param version_str string
---@param sz_io number
---@param sz_style number
---@param sz_vec2 number
---@param sz_vec4 number
---@param sz_drawvert number
---@param sz_drawidx number
---@return boolean
---@nodiscard
function IGuiManager.DebugCheckVersionAndDataLayout(version_str, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx) end

---Writes the given text to the debug log.
---@param text string
function IGuiManager.DebugLog(text) end

---Not implemented.
---@deprecated
function IGuiManager.DebugLogV() end

--[[
Memory Allocators
--]]

---Not implemented.
---@deprecated
function IGuiManager.SetAllocatorFunctions() end

---Not implemented.
---@deprecated
function IGuiManager.GetAllocatorFunctions() end

---Allocates a block of memory.
---
---**WARNING:** This function should not be used unless you know what you are doing!
---You are responsible for cleaning up the memory you allocate with **MemFree**.
---@param size number
---@return number
---@nodiscard
function IGuiManager.MemAlloc(size) end

---Deallocates a previously allocated block of memory via **MemAlloc**.
---
---**WARNING:** This function should not be used unless you know what you are doing!
---@param ptr number
function IGuiManager.MemFree(ptr) end

--[[
(Optional) Platform/OS Interface for Multi-viewport Support
--]]

---Updates platform windows.
function IGuiManager.UpdatePlatformWindows() end

---Renders platform windows default.
function IGuiManager.RenderPlatformWindowsDefault() end

---Destroys platform windows.
function IGuiManager.DestroyPlatformWindows() end

---Returns a viewport by its id.
---@param id number
---@return ImGuiViewport
---@nodiscard
function IGuiManager.FindViewportByID(id) end

---Returns a viewport by its platform handle.
---@param platform_handle userdata
---@return ImGuiViewport
---@nodiscard
function IGuiManager.FindViewportByPlatformHandle(platform_handle) end

--[[
Ashita Custom Helpers
--]]

---Loads and returns a font.
---@param filename string
---@param size_pixels number
---@return ImFont
function IGuiManager.AddFontFromFileTTF(filename, size_pixels) end

---Loads and returns a font.
---@param compressed_font_data userdata
---@param compressed_font_size number
---@param size_pixels number
---@return ImFont
function IGuiManager.AddFontFromMemoryCompressedTTF(compressed_font_data, compressed_font_size, size_pixels) end

---Loads and returns a font.
---@param compressed_font_data_base85 string
---@param size_pixels number
---@return ImFont
function IGuiManager.AddFontFromMemoryCompressedBase85TTF(compressed_font_data_base85, size_pixels) end

--[[
ImGui Internal Forwards
--]]

---Begins a menu.
---@param label string
---@param icon? string
---@param enabled? boolean
---@return boolean
function IGuiManager.BeginMenuEx(label, icon, enabled) end

---Begins a menu item.
---@param label string
---@param icon? string
---@param shortcut? string
---@param selected? boolean
---@param enabled? boolean
---@return boolean
function IGuiManager.MenuItemEx(label, icon, shortcut, selected, enabled) end

--[[
ImGui Custom Helpers

Note: These require the use of the main imgui library!
--]]

---Convert the given ARGB values into a 32bit color.
---@param a number The alpha color code.
---@param r number The red color code.
---@param g number The green color code.
---@param b number The blue color code.
---@return number
function IGuiManager.col32(a, r, g, b) end

---Draws an help marker with ImGui that will display some text when hovered over with the mouse.
---@param text string
---@param sameLine boolean
function IGuiManager.ShowHelp(text, sameLine) end

---Helper function that displays a popup if it is currently enabled to be displayed.
---@param title string The title text of the popup.
---@param name string The internal ImGui hashtag name of the popup.
---@param cb function The callback function to call to render the popups contents.
---@param buttons number The type of buttons to show on the popup. (See PopupButtons.)
---@return number The popup result. (See PopupResult.)
function IGuiManager.DisplayPopup(title, name, cb, buttons) end