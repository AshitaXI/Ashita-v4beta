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
IController Interface
--]]

---@class IController
local IController = {};

---Queues button data.
---@param self IController
---@param button number
---@param data number
function IController:QueueButtonData(button, data) end

---Returns the controller track dead zone flag.
---@param self IController
---@return boolean
---@nodiscard
function IController:GetTrackDeadZone() end

---Sets the controller track dead zone flag.
---@param self IController
---@param flag boolean
function IController:SetTrackDeadZone(flag) end

--[[
IKeyboard Interface
--]]

---@class IKeyboard
local IKeyboard = {};

---Binds a key combination to the given command.
---@param self IKeyboard
---@param key number
---@param down boolean
---@param alt boolean
---@param apps boolean
---@param ctrl boolean
---@param shift boolean
---@param win boolean
---@param req_input_closed boolean
---@param req_input_open boolean
---@param command string
function IKeyboard:Bind(key, down, alt, apps, ctrl, shift, win, req_input_closed, req_input_open, command) end

---Unbinds a key combination.
---@param self IKeyboard
---@param key number
---@param down boolean
---@param alt boolean
---@param apps boolean
---@param ctrl boolean
---@param shift boolean
---@param win boolean
---@param req_input_closed boolean
---@param req_input_open boolean
function IKeyboard:Unbind(key, down, alt, apps, ctrl, shift, win, req_input_closed, req_input_open) end

---Unbinds all key combinations.
---@param self IKeyboard
function IKeyboard:UnbindAll() end

---Returns if a key combination is bound.
---@param self IKeyboard
---@param key number
---@param down boolean
---@param alt boolean
---@param apps boolean
---@param ctrl boolean
---@param shift boolean
---@param win boolean
---@param req_input_closed boolean
---@param req_input_open boolean
---@return boolean
---@nodiscard
function IKeyboard:IsBound(key, down, alt, apps, ctrl, shift, win, req_input_closed, req_input_open) end

---Converts a virtual key code to a DirectInput key scan code.
---@param self IKeyboard
---@param key number
---@return number
---@nodiscard
function IKeyboard:V2D(key) end

---Converts a DirectInput key scan code into a virtual key code.
---@param self IKeyboard
---@param key number
---@return number
---@nodiscard
function IKeyboard:D2V(key) end

---Converts a key string into a DirectInput key scan code.
---@param self IKeyboard
---@param key string
---@return number
---@nodiscard
function IKeyboard:S2D(key) end

---Converts a DirectInput key scan code into a key string.
---@param self IKeyboard
---@param key number
---@return string
function IKeyboard:D2S(key) end

---Returns the Windows key enabled flag.
---@param self IKeyboard
---@return boolean
---@nodiscard
function IKeyboard:GetWindowsKeyEnabled() end

---Sets the Windows key enabled flag.
---@param self IKeyboard
---@param flag boolean
function IKeyboard:SetWindowsKeyEnabled(flag) end

---Returns the keyboard block input flag.
---@param self IKeyboard
---@return boolean
---@nodiscard
function IKeyboard:GetBlockInput() end

---Sets the keyboard block input flag.
---@param self IKeyboard
---@param flag boolean
function IKeyboard:SetBlockInput(flag) end

---Returns the keyboard block binds during input flag.
---@param self IKeyboard
---@return boolean
---@nodiscard
function IKeyboard:GetBlockBindsDuringInput() end

---Sets the keyboard block binds during input flag.
---@param self IKeyboard
---@param flag boolean
function IKeyboard:SetBlockBindsDuringInput(flag) end

---Returns the keyboard silent binds flag.
---@param self IKeyboard
---@return boolean
---@nodiscard
function IKeyboard:GetSilentBinds() end

---Sets the keyboard silent binds flag.
---@param self IKeyboard
---@param flag boolean
function IKeyboard:SetSilentBinds(flag) end

--[[
IMouse Interface
--]]

---@class IMouse
local IMouse = {};

---Returns the mouse block input flag.
---@param self IMouse
---@return boolean
---@nodiscard
function IMouse:GetBlockInput() end

---Sets the mouse block input flag.
---@param self IMouse
---@param flag boolean
function IMouse:SetBlockInput(flag) end

--[[
IXInput Interface
--]]

---@class IXInput
local IXInput = {};

---Queues button data.
---@param self IXInput
---@param button number
---@param state number
function IXInput:QueueButtonData(button, state) end

---Returns the track dead zone flag.
---@param self IXInput
---@return boolean
---@nodiscard
function IXInput:GetTrackDeadZone() end

---Sets the track dead zone flag.
---@param self IXInput
---@param flag boolean
function IXInput:SetTrackDeadZone(flag) end

--[[
IInputManager Interface
--]]

---@class IInputManager
local IInputManager = {};

---Returns the controller object.
---@param self IInputManager
---@return IController
---@nodiscard
function IInputManager:GetController() end

---Returns the keyboard object.
---@param self IInputManager
---@return IKeyboard
---@nodiscard
function IInputManager:GetKeyboard() end

---Returns the mouse object.
---@param self IInputManager
---@return IMouse
---@nodiscard
function IInputManager:GetMouse() end

---Returns the XInput object.
---@param self IInputManager
---@return IXInput
---@nodiscard
function IInputManager:GetXInput() end

---Returns the allow gamepad in background flag.
---@param self IInputManager
---@return boolean
function IInputManager:GetAllowGamepadInBackground() end

---Sets the allow gamepad in background flag.
---@param self IInputManager
---@param flag boolean
function IInputManager:SetAllowGamepadInBackground(flag) end

---Returns the disable gamepad flag.
---@param self IInputManager
---@return boolean
function IInputManager:GetDisableGamepad() end

---Sets the disable gamepad flag.
---@param self IInputManager
---@param flag boolean
function IInputManager:SetDisableGamepad(flag) end