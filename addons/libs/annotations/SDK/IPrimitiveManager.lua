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
IPrimitiveObject Interface
--]]

---@class IPrimitiveObject
local IPrimitiveObject = {};

---Renders the primitive object. (Used when ManualRendering mode is enabled.)
---@param self IPrimitiveObject
function IPrimitiveObject:Render() end

---Sets the primitive texture from a file.
---@param self IPrimitiveObject
---@param file string
---@return boolean
function IPrimitiveObject:SetTextureFromFile(file) end

---Sets the primitive texture from a file in memory.
---@param self IPrimitiveObject
---@param data string
---@param size number
---@param color_key number
---@return boolean
function IPrimitiveObject:SetTextureFromMemory(data, size, color_key) end

---Sets the primitive texture from a file in a module resource.
---@param self IPrimitiveObject
---@param module_name string
---@param res_name string
---@return boolean
function IPrimitiveObject:SetTextureFromResource(module_name, res_name) end

---Sets the primitive texture from a cached resource.
---@param self IPrimitiveObject
---@param name string
---@return boolean
function IPrimitiveObject:SetTextureFromResourceCache(name) end

---Sets the primitive texture from another texture.
---@param self IPrimitiveObject
---@param texture userdata
---@param width number
---@param height number
---@return boolean
function IPrimitiveObject:SetTextureFromTexture(texture, width, height) end

---Tests if the given point is within the primitive objects bounds.
---@param self IPrimitiveObject
---@param x number
---@param y number
---@return boolean
---@nodiscard
function IPrimitiveObject:HitTest(x, y) end

---Returns the primitive objects alias.
---@param self IPrimitiveObject
---@return string
---@nodiscard
function IPrimitiveObject:GetAlias() end

---Returns the primitive objects texture X offset.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetTextureOffsetX() end

---Returns the primitive objects texture Y offset.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetTextureOffsetY() end

---Returns the primitive objects border visible flag.
---@param self IPrimitiveObject
---@return boolean
---@nodiscard
function IPrimitiveObject:GetBorderVisible() end

---Returns the primitive objects border color.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetBorderColor() end

---Returns the primitive objects border flags.
---@param self IPrimitiveObject
---@return FontBorderFlags
---@nodiscard
function IPrimitiveObject:GetBorderFlags() end

---Returns the primitive objects border sizes.
---@param self IPrimitiveObject
---@return RECT
---@nodiscard
function IPrimitiveObject:GetBorderSizes() end

---Returns the primitive objects visible flag.
---@param self IPrimitiveObject
---@return boolean
---@nodiscard
function IPrimitiveObject:GetVisible() end

---Returns the primitive objects X position.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetPositionX() end

---Returns the primitive objects Y position.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetPositionY() end

---Returns the primitive objects focus flag.
---@param self IPrimitiveObject
---@return boolean
---@nodiscard
function IPrimitiveObject:GetCanFocus() end

---Returns the primitive objects locked flag.
---@param self IPrimitiveObject
---@return boolean
---@nodiscard
function IPrimitiveObject:GetLocked() end

---Returns the primitive objects locked Z flag.
---@param self IPrimitiveObject
---@return boolean
---@nodiscard
function IPrimitiveObject:GetLockedZ() end

---Returns the primitive objects X scale.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetScaleX() end

---Returns the primitive objects Y scale.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetScaleY() end

---Returns the primitive objects width.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetWidth() end

---Returns the primitive objects height.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetHeight() end

---Returns the primitive objects draw flags.
---@param self IPrimitiveObject
---@return PrimitiveDrawFlags
---@nodiscard
function IPrimitiveObject:GetDrawFlags() end

---Returns the primitive objects color.
---@param self IPrimitiveObject
---@return number
---@nodiscard
function IPrimitiveObject:GetColor() end

---Sets the primitive objects alias.
---@param self IPrimitiveObject
---@param alias string
function IPrimitiveObject:SetAlias(alias) end

---Sets the primitive objects texture X offset.
---@param self IPrimitiveObject
---@param x number
function IPrimitiveObject:SetTextureOffsetX(x) end

---Sets the primitive objects texture Y offset.
---@param self IPrimitiveObject
---@param y number
function IPrimitiveObject:SetTextureOffsetY(y) end

---Sets the primitive objects border visible flag.
---@param self IPrimitiveObject
---@param visible boolean
function IPrimitiveObject:SetBorderVisible(visible) end

---Sets the primitive objects border color.
---@param self IPrimitiveObject
---@param color number
function IPrimitiveObject:SetBorderColor(color) end

---Sets the primitive objects border flags.
---@param self IPrimitiveObject
---@param flags FontBorderFlags
function IPrimitiveObject:SetBorderFlags(flags) end

---Sets the primitive objects border sizes.
---@param self IPrimitiveObject
---@param sizes RECT
function IPrimitiveObject:SetBorderSizes(sizes) end

---Sets the primitive objects visibility.
---@param self IPrimitiveObject
---@param visible boolean
function IPrimitiveObject:SetVisible(visible) end

---Sets the primitive objects X position.
---@param self IPrimitiveObject
---@param x number
function IPrimitiveObject:SetPositionX(x) end

---Sets the primitive objects Y position.
---@param self IPrimitiveObject
---@param y number
function IPrimitiveObject:SetPositionY(y) end

---Sets the primitive objects focus flag.
---@param self IPrimitiveObject
---@param focus boolean
function IPrimitiveObject:SetCanFocus(focus) end

---Sets the primitive objects locked flag.
---@param self IPrimitiveObject
---@param locked boolean
function IPrimitiveObject:SetLocked(locked) end

---Sets the primitive objects locked Z flag.
---@param self IPrimitiveObject
---@param locked boolean
function IPrimitiveObject:SetLockedZ(locked) end

---Sets the primitive objects X scale.
---@param self IPrimitiveObject
---@param x number
function IPrimitiveObject:SetScaleX(x) end

---Sets the primitive objects Y scale.
---@param self IPrimitiveObject
---@param y number
function IPrimitiveObject:SetScaleY(y) end

---Sets the primitive objects width.
---@param self IPrimitiveObject
---@param width number
function IPrimitiveObject:SetWidth(width) end

---Sets the primitive objects height.
---@param self IPrimitiveObject
---@param height number
function IPrimitiveObject:SetHeight(height) end

---Sets the primitive objects draw flags.
---@param self IPrimitiveObject
---@param flags PrimitiveDrawFlags
function IPrimitiveObject:SetDrawFlags(flags) end

---Sets the primitive objects color.
---@param self IPrimitiveObject
---@param color number
function IPrimitiveObject:SetColor(color) end

--[[
IPrimitiveManager Interface
--]]

---@class IPrimitiveManager
local IPrimitiveManager = {};

---Creates a new, or returns an existing, primitive object.
---@param self IPrimitiveManager
---@param alias string
---@return IPrimitiveObject|nil
function IPrimitiveManager:Create(alias) end

---Returns an existing primitive object.
---@param self IPrimitiveManager
---@param alias string
---@return IPrimitiveObject|nil
---@nodiscard
function IPrimitiveManager:Get(alias) end

---Deletes an existing primitive object.
---@param self IPrimitiveManager
---@param alias string
function IPrimitiveManager:Delete(alias) end

---Returns the currently focused primitive object.
---@param self IPrimitiveManager
---@return IPrimitiveObject|nil
---@nodiscard
function IPrimitiveManager:GetFocusedObject() end

---Sets the current focused primitive object.
---@param self IPrimitiveManager
---@param alias string
---@return boolean
function IPrimitiveManager:SetFocusedObject(alias) end

---Returns the PrimitiveManager visibility.
---@param self IPrimitiveManager
---@return boolean
---@nodiscard
function IPrimitiveManager:GetVisible() end

---Sets the PrimitiveManager visibility.
---@param self IPrimitiveManager
---@param visible boolean
function IPrimitiveManager:SetVisible(visible) end