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
IFontObject Interface
--]]

---@class IFontObject
local IFontObject = {};

---Renders the font object. (Used when ManualRendering mode is enabled.)
---@param self IFontObject
function IFontObject:Render() end

---Returns the size of the font objects text.
---@param self IFontObject
---@param size SIZE
function IFontObject:GetTextSize(size) end

---Tests if the given point is within the font objects bounds.
---@param self IFontObject
---@param x number
---@param y number
---@return boolean
---@nodiscard
function IFontObject:HitTest(x, y) end

---Returns the font objects parent.
---@param self IFontObject
---@return IFontObject?
---@nodiscard
function IFontObject:GetParent() end

---Returns the font objects background primitive.
---@param self IFontObject
---@return IPrimitiveObject?
---@nodiscard
function IFontObject:GetBackground() end

---Returns the font objects real X position.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetRealPositionX() end

---Returns the font objects real Y position.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetRealPositionY() end

---Returns the font objects alias.
---@param self IFontObject
---@return string
---@nodiscard
function IFontObject:GetAlias() end

---Returns the font objects visibility.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetVisible() end

---Returns if the font object can be focused.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetCanFocus() end

---Returns if the font object is locked.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetLocked() end

---Returns if the font object is Z locked.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetLockedZ() end

---Returns if the font object is dirty.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetIsDirty() end

---Returns the window width.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetWindowWidth() end

---Returns the window height.
---@param self IFontObject
---@return number.
---@nodiscard
function IFontObject:GetWindowHeight() end

---Returns the font file.
---@param self IFontObject
---@return string
---@nodiscard
function IFontObject:GetFontFile() end

---Returns the font family.
---@param self IFontObject
---@return string
---@nodiscard
function IFontObject:GetFontFamily() end

---Returns the font height.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetFontHeight() end

---Returns the font create flags.
---@param self IFontObject
---@return FontCreateFlags
---@nodiscard
function IFontObject:GetCreateFlags() end

---Returns the font draw flags.
---@param self IFontObject
---@return FontDrawFlags
---@nodiscard
function IFontObject:GetDrawFlags() end

---Returns the font bold flag.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetBold() end

---Returns the font italic flag.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetItalic() end

---Returns the font right-justified flag.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetRightJustified() end

---Returns the font strike-through flag.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetStrikeThrough() end

---Returns the font underlined flag.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetUnderlined() end

---Returns the font color.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetColor() end

---Returns the font outline color.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetColorOutline() end

---Returns the font padding.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetPadding() end

---Returns the font X position.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetPositionX() end

---Returns the font Y position.
---@param self IFontObject
---@return number
---@nodiscard
function IFontObject:GetPositionY() end

---Returns the font auto-resize flag.
---@param self IFontObject
---@return boolean
---@nodiscard
function IFontObject:GetAutoResize() end

---Returns the font anchor flags.
---@param self IFontObject
---@return FrameAnchor
---@nodiscard
function IFontObject:GetAnchor() end

---Returns the font anchor parent flags.
---@param self IFontObject
---@return FrameAnchor
---@nodiscard
function IFontObject:GetAnchorParent() end

---Returns the font text.
---@param self IFontObject
---@return string
---@nodiscard
function IFontObject:GetText() end

---Sets the font alias.
---@param self IFontObject
---@param alias string
function IFontObject:SetAlias(alias) end

---Sets the font visibility.
---@param self IFontObject
---@param visible boolean
function IFontObject:SetVisible(visible) end

---Sets the font focus flag.
---@param self IFontObject
---@param focus boolean
function IFontObject:SetCanFocus(focus) end

---Sets the font locked flag.
---@param self IFontObject
---@param locked boolean
function IFontObject:SetLocked(locked) end

---Sets the font locked Z flag.
---@param self IFontObject
---@param locked boolean
function IFontObject:SetLockedZ(locked) end

---Sets the font dirty flag.
---@param self IFontObject
---@param dirty boolean
function IFontObject:SetIsDirty(dirty) end

---Sets the font window width.
---@param self IFontObject
---@param width number
function IFontObject:SetWindowWidth(width) end

---Sets the font window height.
---@param self IFontObject
---@param height number
function IFontObject:SetWindowHeight(height) end

---Sets the font file.
---@param self IFontObject
---@param file string
function IFontObject:SetFontFile(file) end

---Sets the font family.
---@param self IFontObject
---@param family string
function IFontObject:SetFontFamily(family) end

---Sets the font height.
---@param self IFontObject
---@param height number
function IFontObject:SetFontHeight(height) end

---Sets the font create flags.
---@param self IFontObject
---@param flags FontCreateFlags
function IFontObject:SetCreateFlags(flags) end

---Sets the font draw flags.
---@param self IFontObject
---@param flags FontDrawFlags
function IFontObject:SetDrawFlags(flags) end

---Sets the font bold flag.
---@param self IFontObject
---@param flag boolean
function IFontObject:SetBold(flag) end

---Sets the font italic flag.
---@param self IFontObject
---@param flag boolean
function IFontObject:SetItalic(flag) end

---Sets the font right-justified flag.
---@param self IFontObject
---@param flag boolean
function IFontObject:SetRightJustified(flag) end

---Sets the font strike-through flag.
---@param self IFontObject
---@param flag boolean
function IFontObject:SetStrikeThrough(flag) end

---Sets the font underlined flag.
---@param self IFontObject
---@param flag boolean
function IFontObject:SetUnderlined(flag) end

---Sets the font color.
---@param self IFontObject
---@param color number
function IFontObject:SetColor(color) end

---Sets the font outline color.
---@param self IFontObject
---@param color number
function IFontObject:SetColorOutline(color) end

---Sets the font padding.
---@param self IFontObject
---@param padding number
function IFontObject:SetPadding(padding) end

---Sets the font X position.
---@param self IFontObject
---@param x number
function IFontObject:SetPositionX(x) end

---Sets the font Y position.
---@param self IFontObject
---@param y number
function IFontObject:SetPositionY(y) end

---Sets the font auto-resize flag.
---@param self IFontObject
---@param flag boolean
function IFontObject:SetAutoResize(flag) end

---Sets the font anchor.
---@param self IFontObject
---@param anchor FrameAnchor
function IFontObject:SetAnchor(anchor) end

---Sets the font anchor parent.
---@param self IFontObject
---@param anchor FrameAnchor
function IFontObject:SetAnchorParent(anchor) end

---Sets the font text.
---@param self IFontObject
---@param str? string
function IFontObject:SetText(str) end

---Sets the font parent.
---@param self IFontObject
---@param parent? IFontObject
function IFontObject:SetParent(parent) end

--[[
IFontManager Interface
--]]

---@class IFontManager
local IFontManager = {};

---Creates a new, or returns an existing, font object.
---@param self IFontManager
---@param alias string
---@return IFontObject?
function IFontManager:Create(alias) end

---Returns an existing font object.
---@param self IFontManager
---@param alias string
---@return IFontObject?
---@nodiscard
function IFontManager:Get(alias) end

---Deletes an existing font object.
---@param self IFontManager
---@param alias string
function IFontManager:Delete(alias) end

---Returns the currently focused font object.
---@param self IFontManager
---@return IFontObject?
---@nodiscard
function IFontManager:GetFocusedObject() end

---Sets the current focused font object.
---@param self IFontManager
---@param alias string
---@return boolean
function IFontManager:SetFocusedObject(alias) end

---Returns the FontManager visibility.
---@param self IFontManager
---@return boolean
---@nodiscard
function IFontManager:GetVisible() end

---Sets the FontManager visibility.
---@param self IFontManager
---@param visible boolean
function IFontManager:SetVisible(visible) end