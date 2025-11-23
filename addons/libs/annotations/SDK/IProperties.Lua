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
IProperties Interface
--]]

---@class IProperties
local IProperties = {};

---Returns the stored PlayOnline window handle.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetPlayOnlineHwnd() end

---Returns the stored PlayOnline window style.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetPlayOnlineStyle() end

---Returns the stored PlayOnline window ex style.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetPlayOnlineStyleEx() end

---Returns the stored PlayOnline window rect.
---@param self IProperties
---@return RECT
---@nodiscard
function IProperties:GetPlayOnlineRect() end

---Sets the stored PlayOnline window handle.
---@param self IProperties
---@param hwnd number
function IProperties:SetPlayOnlineHwnd(hwnd) end

---Sets the stored PlayOnline window style.
---@param self IProperties
---@param style number
function IProperties:SetPlayOnlineStyle(style) end

---Sets the stored PlayOnline window ex style.
---@param self IProperties
---@param style number
function IProperties:SetPlayOnlineStyleEx(style) end

---Sets the stored PlayOnline window rect.
---@param self IProperties
---@param rect RECT
function IProperties:SetPlayOnlineRect(rect) end

---Returns the stored PlayOnline Mask window handle.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetPlayOnlineMaskHwnd() end

---Returns the stored PlayOnline Mask window style.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetPlayOnlineMaskStyle() end

---Returns the stored PlayOnline Mask window ex style.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetPlayOnlineMaskStyleEx() end

---Returns the stored PlayOnline Mask window rect.
---@param self IProperties
---@return RECT
---@nodiscard
function IProperties:GetPlayOnlineMaskRect() end

---Sets the stored PlayOnline Mask window handle.
---@param self IProperties
---@param hwnd number
function IProperties:SetPlayOnlineMaskHwnd(hwnd) end

---Sets the stored PlayOnline Mask window style.
---@param self IProperties
---@param style number
function IProperties:SetPlayOnlineMaskStyle(style) end

---Sets the stored PlayOnline Mask window ex style.
---@param self IProperties
---@param style number
function IProperties:SetPlayOnlineMaskStyleEx(style) end

---Sets the stored PlayOnline Mask window rect.
---@param self IProperties
---@param rect RECT
function IProperties:SetPlayOnlineMaskRect(rect) end

---Returns the stored Final Fantasy window handle.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetFinalFantasyHwnd() end

---Returns the stored Final Fantasy window style.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetFinalFantasyStyle() end

---Returns the stored Final Fantasy window ex style.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetFinalFantasyStyleEx() end

---Returns the stored Final Fantasy window rect.
---@param self IProperties
---@return RECT
---@nodiscard
function IProperties:GetFinalFantasyRect() end

---Sets the stored Final Fantasy window handle.
---@param self IProperties
---@param hwnd number
function IProperties:SetFinalFantasyHwnd(hwnd) end

---Sets the stored Final Fantasy window style.
---@param self IProperties
---@param style number
function IProperties:SetFinalFantasyStyle(style) end

---Sets the stored Final Fantasy window ex style.
---@param self IProperties
---@param style number
function IProperties:SetFinalFantasyStyleEx(style) end

---Sets the stored Final Fantasy window rect.
---@param self IProperties
---@param rect RECT
function IProperties:SetFinalFantasyRect(rect) end

---Returns the Direct3D ambient lighting enabled flag.
---@param self IProperties
---@return boolean
---@nodiscard
function IProperties:GetD3DAmbientEnabled() end

---Returns the Direct3D ambient lighting color.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetD3DAmbientColor() end

---Returns the Direct3D fill mode.
---@param self IProperties
---@return number
---@nodiscard
function IProperties:GetD3DFillMode() end

---Sets the Direct3D ambient lighting enable flag.
---@param self IProperties
---@param enabled boolean
function IProperties:SetD3DAmbientEnabled(enabled) end

---Sets the Direct3D ambient lighting color.
---@param self IProperties
---@param color number
function IProperties:SetD3DAmbientColor(color) end

---Sets the Direct3D fill mode.
---@param self IProperties
---@param mode number
function IProperties:SetD3DFillMode(mode) end