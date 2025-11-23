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
Coroutine Extensions
--]]

---Kills a coroutine task.
---@param thread? thread
function coroutine.kill(thread) end

---Sleeps a coroutine for a given amount of time, in seconds.
---@param delay number
function coroutine.sleep(delay) end

---Sleeps a coroutine for a given amount of time, in frames.
---@param delay number
function coroutine.sleepf(delay) end

--[[
Table Extensions
--]]

---Converts a table of bytes into a string literal.
---@param val table
---@return string
function table.make_literal(val) end