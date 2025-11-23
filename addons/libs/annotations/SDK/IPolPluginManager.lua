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
IPolPlugin Interface
--]]

---@class IPolPlugin
local IPolPlugin = {};

---Returns the plugin name.
---@param self IPolPlugin
---@return string
---@nodiscard
function IPolPlugin:GetName() end

---Returns the plugin author.
---@param self IPolPlugin
---@return string
---@nodiscard
function IPolPlugin:GetAuthor() end

---Returns the plugin description.
---@param self IPolPlugin
---@return string
---@nodiscard
function IPolPlugin:GetDescription() end

---Returns the plugin link.
---@param self IPolPlugin
---@return string
---@nodiscard
function IPolPlugin:GetLink() end

---Returns the plugin version.
---@param self IPolPlugin
---@return number
---@nodiscard
function IPolPlugin:GetVersion() end

---Returns the plugin interface version.
---@param self IPolPlugin
---@return number
---@nodiscard
function IPolPlugin:GetInterfaceVersion() end

---Returns the plugin flags.
---@param self IPolPlugin
---@return number
---@nodiscard
function IPolPlugin:GetFlags() end

--[[
IPolPluginManager Interface
--]]

---@class IPolPluginManager
local IPolPluginManager = {};

---Returns if the given plugin is currently loaded.
---@param self IPolPluginManager
---@param name string
---@return boolean
---@nodiscard
function IPolPluginManager:IsLoaded(name) end

---Returns the plugin instance by name.
---@param self IPolPluginManager
---@param name string
---@return IPolPlugin?
---@nodiscard
function IPolPluginManager:Get(name) end

---Returns the plugin instance by index.
---@param self IPolPluginManager
---@param index number
---@return IPolPlugin?
---@nodiscard
function IPolPluginManager:Get(index) end

---Returns the number of currently loaded plugins.
---@param self IPolPluginManager
---@return number
---@nodiscard
function IPolPluginManager:Count() end

---Raises an event to be seen by all plugins.
---@param self IPolPluginManager
---@param event_name string
---@param event_data table
function IPolPluginManager:RaiseEvent(event_name, event_data) end