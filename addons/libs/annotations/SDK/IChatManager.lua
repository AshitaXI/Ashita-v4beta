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
IChatManager Interface
--]]

---@class IChatManager
local IChatManager = {};

---Queues a command to be handled.
---@param self IChatManager
---@param mode number
---@param command string
function IChatManager:QueueCommand(mode, command) end

---Writes a message to the chat log.
---@param self IChatManager
---@param mode number
---@param indent boolean
---@param msg string
function IChatManager:Write(mode, indent, msg) end

---Writes a message to the chat log.
---@param self IChatManager
---@param mode number
---@param indent boolean
---@param msg string
function IChatManager:AddChatMessage(mode, indent, msg) end

---Parses and replaces auto-translate tags from a string.
---@param self IChatManager
---@param msg string
---@param use_brackets boolean
---@return string
function IChatManager:ParseAutoTranslate(msg, use_brackets) end

---Executes a script file.
---@param self IChatManager
---@param file string
---@param args string
---@param threaded boolean
function IChatManager:ExecuteScript(file, args, threaded) end

---Executes a script string.
---@param self IChatManager
---@param str string
---@param args string
---@param threaded boolean
function IChatManager:ExecuteScriptString(str, args, threaded) end

---Returns the current raw input text.
---@param self IChatManager
---@return string?
function IChatManager:GetInputTextRaw() end

---Sets the current raw input text.
---@param self IChatManager
---@param msg string
---@param size number
function IChatManager:SetInputTextRaw(msg, size) end

---Returns the raw input text length.
---@param self IChatManager
---@return number
function IChatManager:GetInputTextRawLength() end

---Returns the raw input text caret position.
---@param self IChatManager
---@return number
function IChatManager:GetInputTextRawCaretPosition() end

---Returns the current parsed input text.
---@param self IChatManager
---@return string?
function IChatManager:GetInputTextParsed() end

---Sets the current parsed input text.
---@param self IChatManager
---@param msg string
function IChatManager:SetInputTextParsed(msg) end

---Returns the parsed input text length.
---@param self IChatManager
---@return number
function IChatManager:GetInputTextParsedLength() end

---Returns the parsed input text max length.
---@param self IChatManager
---@return number
function IChatManager:GetInputTextParsedLengthMax() end

---Returns the current display input text.
---@param self IChatManager
---@return string?
function IChatManager:GetInputTextDisplay() end

---Sets the current display input text.
---@param self IChatManager
---@param msg string
function IChatManager:SetInputTextDisplay(msg) end

---Sets the current input text.
---@param self IChatManager
---@param msg string
function IChatManager:SetInputText(msg) end

---Returns if the game input is currently open.
---@param self IChatManager
---@return ChatInputOpenStatus
---@nodiscard
function IChatManager:IsInputOpen() end

---Returns the silent aliases flag.
---@param self IChatManager
---@return boolean
---@nodiscard
function IChatManager:GetSilentAliases() end

---Sets the silent aliases flag.
---@param self IChatManager
---@param silent boolean
function IChatManager:SetSilentAliases(silent) end