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
IConfigurationManager Interface
--]]

---@class IConfigurationManager
local IConfigurationManager = {};

---Loads a configuration file into the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param file string
---@return boolean
function IConfigurationManager:Load(alias, file) end

---Saves a configuration file from the configuration cache to a file.
---@param self IConfigurationManager
---@param alias string
---@param file string
---@return boolean
function IConfigurationManager:Save(alias, file) end

---Deletes a configuration files entries from the configuration cache.
---@param self IConfigurationManager
---@param alias string
function IConfigurationManager:Delete(alias) end

---Returns a new-line (\n) seperated buffer of section names from the given configuration.
---@param self IConfigurationManager
---@param alias string
---@return string
function IConfigurationManager:GetSections(alias) end

---Returns a new-line (\n) seperated buffer of a sections keys from the given configuration.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@return string
function IConfigurationManager:GetSectionKeys(alias, section) end

---Returns a string value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@return string
function IConfigurationManager:GetString(alias, section, key) end

---Sets a value in the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param value string
function IConfigurationManager:SetValue(alias, section, key, value) end

---Returns an boolean value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value boolean
---@return boolean
function IConfigurationManager:GetBool(alias, section, key, default_value) end

---Returns an uint8 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetUInt8(alias, section, key, default_value) end

---Returns an uint16 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetUInt16(alias, section, key, default_value) end

---Returns an uint32 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetUInt32(alias, section, key, default_value) end

---Returns an uint64 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetUInt64(alias, section, key, default_value) end

---Returns an int8 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetInt8(alias, section, key, default_value) end

---Returns an int16 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetInt16(alias, section, key, default_value) end

---Returns an int32 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetInt32(alias, section, key, default_value) end

---Returns an int64 value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetInt64(alias, section, key, default_value) end

---Returns a float value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetFloat(alias, section, key, default_value) end

---Returns a double value from the configuration cache.
---@param self IConfigurationManager
---@param alias string
---@param section string
---@param key string
---@param default_value number
---@return number
function IConfigurationManager:GetDouble(alias, section, key, default_value) end