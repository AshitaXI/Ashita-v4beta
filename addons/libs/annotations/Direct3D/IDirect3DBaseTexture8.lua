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

---@class IDirect3DBaseTexture8
IDirect3DBaseTexture8 = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IDirect3DBaseTexture8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DBaseTexture8:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IDirect3DBaseTexture8
---@return number
function IDirect3DBaseTexture8:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IDirect3DBaseTexture8
---@return number
function IDirect3DBaseTexture8:Release() end

--[[
IDirect3DResource8 Interface
--]]

---Retrieves the device associated with a resource.
---@param self IDirect3DBaseTexture8
---@return number
---@return IDirect3DDevice8|nil
function IDirect3DBaseTexture8:GetDevice() end

---Associates data with the resource that is intended for use by the application.
---@param self IDirect3DBaseTexture8
---@param refguid ffi.cdata*
---@param pData ffi.cdata*
---@param SizeOfData number
---@param Flags number
---@return number
function IDirect3DBaseTexture8:SetPrivateData(refguid, pData, SizeOfData, Flags) end

---Copies the private data associated with the resource to a provided buffer.
---@param self IDirect3DBaseTexture8
---@param refguid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DBaseTexture8:GetPrivateData(refguid) end

---Frees the specified private data associated with this resource.
---@param self IDirect3DBaseTexture8
---@param refguid ffi.cdata*
---@return number
function IDirect3DBaseTexture8:FreePrivateData(refguid) end

---Assigns the resource-management priority for this resource.
---@param self IDirect3DBaseTexture8
---@param PriorityNew number
---@return number
function IDirect3DBaseTexture8:SetPriority(PriorityNew) end

---Retrieves the priority for this resource.
---@param self IDirect3DBaseTexture8
---@return number
function IDirect3DBaseTexture8:GetPriority() end

---Preloads a managed resource.
---@param self IDirect3DBaseTexture8
function IDirect3DBaseTexture8:PreLoad() end

---Returns the type of the resource.
---@param self IDirect3DBaseTexture8
---@return number
function IDirect3DBaseTexture8:GetType() end

--[[
IDirect3DBaseTexture8 Interface
--]]

---Sets the most detailed level of detail (LOD) for a managed texture.
---@param self IDirect3DBaseTexture8
---@param LODNew number
---@return number
function IDirect3DBaseTexture8:SetLOD(LODNew) end

---Returns a value clamped to the maximum level of detail (LOD) set for a managed texture.
---@param self IDirect3DBaseTexture8
---@return number
function IDirect3DBaseTexture8:GetLOD() end

---Returns the number of texture levels in a multilevel texture.
---@param self IDirect3DBaseTexture8
---@return number
function IDirect3DBaseTexture8:GetLevelCount() end