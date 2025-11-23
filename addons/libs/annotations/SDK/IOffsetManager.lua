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
IOffsetManager Interface
--]]

---@class IOffsetManager
local IOffsetManager = {};

---Adds (or updates) an offset to the offset cache.
---@param self IOffsetManager
---@param section string
---@param key string
---@param offset number
function IOffsetManager:Add(section, key, offset) end

---Returns an offset from the offset cache.
---@param self IOffsetManager
---@param section string
---@param key string
---@return number
---@nodiscard
function IOffsetManager:Get(section, key) end

---Deletes a registered offset from the offset cache.
---@param self IOffsetManager
---@param section string
function IOffsetManager:Delete(section) end

---Deletes a registered offset from the offset cache.
---@param self IOffsetManager
---@param section string
---@param key string
function IOffsetManager:Delete(section, key) end