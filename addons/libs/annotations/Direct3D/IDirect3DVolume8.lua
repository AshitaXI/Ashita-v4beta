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

---@class IDirect3DVolume8
IDirect3DVolume8 = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IDirect3DVolume8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DVolume8:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IDirect3DVolume8
---@return number
function IDirect3DVolume8:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IDirect3DVolume8
---@return number
function IDirect3DVolume8:Release() end

--[[
IDirect3DVolume8 Interface
--]]

---Retrieves the device associated with a resource.
---@param self IDirect3DVolume8
---@return number
---@return IDirect3DDevice8|nil
function IDirect3DVolume8:GetDevice() end

---Associates data with the volume that is intended for use by the application.
---@param self IDirect3DVolume8
---@param refguid ffi.cdata*
---@param pData ffi.cdata*
---@param SizeOfData number
---@param Flags number
---@return number
function IDirect3DVolume8:SetPrivateData(refguid, pData, SizeOfData, Flags) end

---Copies the private data associated with the volume to a provided buffer.
---@param self IDirect3DVolume8
---@param refguid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DVolume8:GetPrivateData(refguid) end

---Frees the specified private data associated with this volume.
---@param self IDirect3DVolume8
---@param refguid ffi.cdata*
---@return number
function IDirect3DVolume8:FreePrivateData(refguid) end

---Provides access to the parent volume texture object, if this surface is a child level of a volume texture.
---@param self IDirect3DVolume8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DVolume8:GetContainer(riid) end

---Retrieves a description of the volume.
---@param self IDirect3DVolume8
---@return number
---@return ffi.cdata*|nil
function IDirect3DVolume8:GetDesc() end

---Locks a box on a volume resource.
---@param self IDirect3DVolume8
---@param pBox ffi.cdata*
---@param Flags number
---@return number
---@return ffi.cdata*|nil
function IDirect3DVolume8:LockBox(pBox, Flags) end

---Unlocks a box on a volume resource.
---@param self IDirect3DVolume8
---@return number
function IDirect3DVolume8:UnlockBox() end