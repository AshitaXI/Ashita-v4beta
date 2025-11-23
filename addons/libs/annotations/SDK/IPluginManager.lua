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
IPlugin Interface
--]]

---@class IPlugin
local IPlugin = {};

---Returns the plugin name.
---@param self IPlugin
---@return string
---@nodiscard
function IPlugin:GetName() end

---Returns the plugin author.
---@param self IPlugin
---@return string
---@nodiscard
function IPlugin:GetAuthor() end

---Returns the plugin description.
---@param self IPlugin
---@return string
---@nodiscard
function IPlugin:GetDescription() end

---Returns the plugin link.
---@param self IPlugin
---@return string
---@nodiscard
function IPlugin:GetLink() end

---Returns the plugin version.
---@param self IPlugin
---@return number
---@nodiscard
function IPlugin:GetVersion() end

---Returns the plugin interface version.
---@param self IPlugin
---@return number
---@nodiscard
function IPlugin:GetInterfaceVersion() end

---Returns the plugin priority.
---@param self IPlugin
---@return number
---@nodiscard
function IPlugin:GetPriority() end

---Returns the plugin flags.
---@param self IPlugin
---@return number
---@nodiscard
function IPlugin:GetFlags() end

--[[
IPluginManager Interface
--]]

---@class IPluginManager
local IPluginManager = {};

---Returns if the given plugin is currently loaded.
---@param self IPluginManager
---@param name string
---@return boolean
---@nodiscard
function IPluginManager:IsLoaded(name) end

---Returns the plugin instance by name.
---@param self IPluginManager
---@param name string
---@return IPlugin|nil
---@nodiscard
function IPluginManager:Get(name) end

---Returns the plugin instance by index.
---@param self IPluginManager
---@param index number
---@return IPlugin|nil
---@nodiscard
function IPluginManager:Get(index) end

---Returns the number of currently loaded plugins.
---@param self IPluginManager
---@return number
---@nodiscard
function IPluginManager:Count() end

---Raises an event to be seen by all plugins.
---@param self IPluginManager
---@param event_name string
---@param event_data table
function IPluginManager:RaiseEvent(event_name, event_data) end

---Returns the silent plugins flag.
---@param self IPluginManager
---@return boolean
---@nodiscard
function IPluginManager:GetSilentPlugins() end

---Sets the silent plugins flag.
---@param self IPluginManager
---@param flag boolean
function IPluginManager:SetSilentPlugins(flag) end