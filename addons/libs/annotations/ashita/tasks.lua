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
Ashita Table -> Tasks ('ashita.tasks')
--]]

---@class ashita.tasks
ashita.tasks = {};

---Creates a new task to be executed once, immediately.
---@param func function
---@return thread
function ashita.tasks.once(func) end

---Creates a new task to be executed once, after a time-based delay.
---@param delay number
---@param func function
---@return thread
function ashita.tasks.once(delay, func) end

---Creates a new task to be executed once, after a frame-based delay.
---@param delay number
---@param func function
---@return thread
function ashita.tasks.oncef(delay, func) end

---Creates a new task to be executed repeatedly, after a time-based delay.
---@param delay number
---@param repeats number
---@param repeat_delay number
---@param func function
---@return thread
function ashita.tasks.repeating(delay, repeats, repeat_delay, func) end

---Creates a new task to be executed repeatedly, after a frame-based delay.
---@param delay number
---@param repeats number
---@param repeat_delay number
---@param func function
---@return thread
function ashita.tasks.repeatingf(delay, repeats, repeat_delay, func) end