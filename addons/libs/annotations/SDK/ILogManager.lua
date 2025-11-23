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
ILogManager Interface
--]]

---@class ILogManager
local ILogManager = {};

---Logs a message to the log file.
---@param self ILogManager
---@param level number
---@param source string
---@param message string
---@return boolean
function ILogManager:Log(level, source, message) end

---Returns the current log level.
---@param self ILogManager
---@return number
---@nodiscard
function ILogManager:GetLogLevel() end

---Sets the current log level.
---@param self ILogManager
---@param level number
function ILogManager:SetLogLevel(level) end

---Returns the current LogManager pointer.
---@param self ILogManager
---@return number
---@nodiscard
function ILogManager:GetPointer() end

---@type ILogManager
LogManager = {};