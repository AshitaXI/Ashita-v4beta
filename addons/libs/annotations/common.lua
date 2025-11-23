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
Win32: RECT
--]]

---@class RECT
---@field left number
---@field top number
---@field right number
---@field bottom number
RECT = {};

---Creates and returns a new RECT object.
---@return RECT
---@nodiscard
function RECT.new() end

--[[
Win32: SIZE
--]]

---@class SIZE
---@field x number
---@field y number
SIZE = {};

---Creates and returns a new SIZE object.
---@return SIZE
---@nodiscard
function SIZE.new() end