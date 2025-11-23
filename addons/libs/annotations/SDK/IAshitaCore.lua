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
IAshitaCore Interface
--]]

---@class IAshitaCore
local IAshitaCore = {};

---Returns the Ashita.dll module handle.
---@param self IAshitaCore
---@return number
---@nodiscard
function IAshitaCore:GetHandle() end

---Returns the Ashita installation path.
---@param self IAshitaCore
---@return string
---@nodiscard
function IAshitaCore:GetInstallPath() end

---Returns the Direct3D device pointer.
---@param self IAshitaCore
---@return number
---@nodiscard
function IAshitaCore:GetDirect3DDevice() end

---Returns the IProperties interface.
---@param self IAshitaCore
---@return IProperties
---@nodiscard
function IAshitaCore:GetProperties() end

---Returns the IChatManager interface.
---@param self IAshitaCore
---@return IChatManager
---@nodiscard
function IAshitaCore:GetChatManager() end

---Returns the IConfigurationManager interface.
---@param self IAshitaCore
---@return IConfigurationManager
---@nodiscard
function IAshitaCore:GetConfigurationManager() end

---Returns the IFontManager interface.
---@param self IAshitaCore
---@return IFontManager
---@nodiscard
function IAshitaCore:GetFontManager() end

---Returns the IGuiManager interface.
---@param self IAshitaCore
---@return IGuiManager
---@nodiscard
function IAshitaCore:GetGuiManager() end

---Returns the IInputManager interface.
---@param self IAshitaCore
---@return IInputManager
---@nodiscard
function IAshitaCore:GetInputManager() end

---Returns the IMemoryManager interface.
---@param self IAshitaCore
---@return IMemoryManager
---@nodiscard
function IAshitaCore:GetMemoryManager() end

---Returns the IOffsetManager interface.
---@param self IAshitaCore
---@return IOffsetManager
---@nodiscard
function IAshitaCore:GetOffsetManager() end

---Returns the IPacketManager interface.
---@param self IAshitaCore
---@return IPacketManager
---@nodiscard
function IAshitaCore:GetPacketManager() end

---Returns the IPluginManager interface.
---@param self IAshitaCore
---@return IPluginManager
---@nodiscard
function IAshitaCore:GetPluginManager() end

---Returns the IPolPluginManager interface.
---@param self IAshitaCore
---@return IPolPluginManager
---@nodiscard
function IAshitaCore:GetPolPluginManager() end

---Returns the IPointerManager interface.
---@param self IAshitaCore
---@return IPointerManager
---@nodiscard
function IAshitaCore:GetPointerManager() end

---Returns the IPrimitiveManager interface.
---@param self IAshitaCore
---@return IPrimitiveManager
---@nodiscard
function IAshitaCore:GetPrimitiveManager() end

---Returns the IResourceManager interface.
---@param self IAshitaCore
---@return IResourceManager
---@nodiscard
function IAshitaCore:GetResourceManager() end

---Returns the current AshitaCore pointer.
---@param self IAshitaCore
---@return number
---@nodiscard
function IAshitaCore:GetPointer() end

--[[
API Hook Forwards (Advanced Use Only!)

Note: These are for advanced users only!
--]]

---Retrieves the specified system metric or system configuration setting.
---@param self IAshitaCore
---@param index number
---@return number
---@nodiscard
function IAshitaCore:GetSystemMetrics(index) end

---Sends the specified message to a window or windows.
---@param self IAshitaCore
---@param hwnd number
---@param msg number
---@param wparam number
---@param lparam number
---@return number
function IAshitaCore:SendMessageA(hwnd, msg, wparam, lparam) end

---Moves the cursor to the specified screen coordinates.
---@param x number
---@param y number
---@return boolean
function IAshitaCore:SetCursorPos(x, y) end

---Sets the keyboard focus to the specified window.
---@param self IAshitaCore
---@param hwnd number
---@return number
function IAshitaCore:SetFocus(hwnd) end

---Brings the thread that created the specified window into the foreground and activates the window.
---@param self IAshitaCore
---@param hwnd number
---@return boolean
function IAshitaCore:SetForegroundWindow(hwnd) end

---Sets the priority class for the specified process.
---@param self IAshitaCore
---@param handle number
---@param priority_class number
---@return boolean
function IAshitaCore:SetPriorityClass(handle, priority_class) end

---@type IAshitaCore
AshitaCore = {};