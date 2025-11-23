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
castbar_t Structure
--]]

---@class castbar_t
---@field VTablePointer number
---@field m_BaseObj number
---@field m_pParentMCD number
---@field m_InputEnable number
---@field unknown000D number
---@field m_SaveCursol number
---@field m_Reposition number
---@field unknown0011 table
---@field Max number
---@field Count number
---@field Percent number
---@field CastType number
local castbar_t = {};

--[[
ICastBar Interface
--]]

---@class ICastBar
local ICastBar = {};

---Returns the raw castbar structure.
---@param self ICastBar
---@return castbar_t
---@nodiscard
function ICastBar:GetRawStructure() end

---Returns the castbar max.
---@param self ICastBar
---@return number
---@nodiscard
function ICastBar:GetMax() end

---Returns the castbar count.
---@param self ICastBar
---@return number
---@nodiscard
function ICastBar:GetCount() end

---Returns the castbar percent.
---@param self ICastBar
---@return number
---@nodiscard
function ICastBar:GetPercent() end

---Returns the castbar type.
---@param self ICastBar
---@return number
---@nodiscard
function ICastBar:GetCastType() end

---Sets the castbar max.
---@param self ICastBar
---@param val number
function ICastBar:SetMax(val) end

---Sets the castbar count.
---@param self ICastBar
---@param val number
function ICastBar:SetCount(val) end

---Sets the castbar percent.
---@param self ICastBar
---@param val number
function ICastBar:SetPercent(val) end

---Sets the castbar type.
---@param self ICastBar
---@param val number
function ICastBar:SetCastType(val) end