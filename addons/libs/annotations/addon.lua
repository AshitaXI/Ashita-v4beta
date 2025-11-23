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
Addon (Internal)
--]]

---@class Addon
---@field current_frame number
---@field state number
local Addon = {};

---Returns the addons current memory usage.
---@param self Addon
---@return number
---@nodiscard
function Addon:get_memory_usage() end

--[[
Addon Table ('addon')
--]]

---@class addon
---@field author string The addon author.
---@field desc? string The addon description.
---@field instance Addon The addon instance.
---@field link? string The addon website url.
---@field name string The addon name.
---@field path string The addon path.
---@field version string The addon version.
addon = {};