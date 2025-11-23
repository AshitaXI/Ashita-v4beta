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
IRecast Interface
--]]

---@class IRecast
local IRecast = {};

---Returns the requested ability recast.
---@param self IRecast
---@param index number
---@return number
---@nodiscard
function IRecast:GetAbilityRecast(index) end

---Returns the requested ability calc 1.
---@param self IRecast
---@param index number
---@return number
---@nodiscard
function IRecast:GetAbilityCalc1(index) end

---Returns the requested ability timer id.
---@param self IRecast
---@param index number
---@return number
---@nodiscard
function IRecast:GetAbilityTimerId(index) end

---Returns the requested ability calc 2.
---@param self IRecast
---@param index number
---@return number
---@nodiscard
function IRecast:GetAbilityCalc2(index) end

---Returns the requested ability timer.
---@param self IRecast
---@param index number
---@return number
---@nodiscard
function IRecast:GetAbilityTimer(index) end

---Returns the requested spell timer.
---@param self IRecast
---@param index number
---@return number
---@nodiscard
function IRecast:GetSpellTimer(index) end