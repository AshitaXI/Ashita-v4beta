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
Ashita Table -> Events ('ashita.events')
--]]

---@class ashita.events
ashita.events = {};

---Registers an event handler for the given event.
---@param event_name string
---@param event_alias string
---@param callback function
---@return boolean
function ashita.events.register(event_name, event_alias, callback) end

---Unregisters an existing event handler.
---@param event_name string
---@param event_alias string
---@return boolean
function ashita.events.unregister(event_name, event_alias) end