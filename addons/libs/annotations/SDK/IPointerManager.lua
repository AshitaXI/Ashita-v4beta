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
IPointerManager Interface
--]]

---@class IPointerManager
local IPointerManager = {};

---Adds (or updates) a pointer to the pointer cache.
---@param self IPointerManager
---@param name string
---@param pointer number
function IPointerManager:Add(name, pointer) end

---Adds (or updates) a pointer to the pointer cache.
---@param self IPointerManager
---@param name string
---@param module_name string
---@param pattern string
---@param offset number
---@param count number
---@return number
function IPointerManager:Add(name, module_name, pattern, offset, count) end

---Returns a pointer from the pointer cache.
---@param self IPointerManager
---@param name string
---@return number
---@nodiscard
function IPointerManager:Get(name) end

---Deletes a registered pointer from the pointer cache.
---@param self IPointerManager
---@param name string
function IPointerManager:Delete(name) end