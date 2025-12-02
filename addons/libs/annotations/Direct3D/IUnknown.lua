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

---@class IUnknown
IUnknown = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IUnknown
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IUnknown:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IUnknown
---@return number
function IUnknown:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IUnknown
---@return number
function IUnknown:Release() end