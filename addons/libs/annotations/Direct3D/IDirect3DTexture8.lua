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

---@class IDirect3DTexture8
IDirect3DTexture8 = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IDirect3DTexture8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DTexture8:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IDirect3DTexture8
---@return number
function IDirect3DTexture8:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IDirect3DTexture8
---@return number
function IDirect3DTexture8:Release() end

--[[
IDirect3DResource8 Interface
--]]

---Retrieves the device associated with a resource.
---@param self IDirect3DTexture8
---@return number
---@return IDirect3DDevice8|nil
function IDirect3DTexture8:GetDevice() end

---Associates data with the resource that is intended for use by the application.
---@param self IDirect3DTexture8
---@param refguid ffi.cdata*
---@param pData ffi.cdata*
---@param SizeOfData number
---@param Flags number
---@return number
function IDirect3DTexture8:SetPrivateData(refguid, pData, SizeOfData, Flags) end

---Copies the private data associated with the resource to a provided buffer.
---@param self IDirect3DTexture8
---@param refguid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DTexture8:GetPrivateData(refguid) end

---Frees the specified private data associated with this resource.
---@param self IDirect3DTexture8
---@param refguid ffi.cdata*
---@return number
function IDirect3DTexture8:FreePrivateData(refguid) end

---Assigns the resource-management priority for this resource.
---@param self IDirect3DTexture8
---@param PriorityNew number
---@return number
function IDirect3DTexture8:SetPriority(PriorityNew) end

---Retrieves the priority for this resource.
---@param self IDirect3DTexture8
---@return number
function IDirect3DTexture8:GetPriority() end

---Preloads a managed resource.
---@param self IDirect3DTexture8
function IDirect3DTexture8:PreLoad() end

---Returns the type of the resource.
---@param self IDirect3DTexture8
---@return number
function IDirect3DTexture8:GetType() end

--[[
IDirect3DBaseTexture8 Interface
--]]

---Sets the most detailed level of detail (LOD) for a managed texture.
---@param self IDirect3DTexture8
---@param LODNew number
---@return number
function IDirect3DTexture8:SetLOD(LODNew) end

---Returns a value clamped to the maximum level of detail (LOD) set for a managed texture.
---@param self IDirect3DTexture8
---@return number
function IDirect3DTexture8:GetLOD() end

---Returns the number of texture levels in a multilevel texture.
---@param self IDirect3DTexture8
---@return number
function IDirect3DTexture8:GetLevelCount() end

--[[
IDirect3DTexture8 Interface
--]]

---Retrieves a level description of a texture resource.
---@param self IDirect3DTexture8
---@param Level number
---@return number
---@return ffi.cdata*|nil
function IDirect3DTexture8:GetLevelDesc(Level) end

---Retrieves the specified texture surface level.
---@param self IDirect3DTexture8
---@param Level number
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DTexture8:GetSurfaceLevel(Level) end

---Locks a rectangle on a texture resource.
---@param self IDirect3DTexture8
---@param Level number
---@param pRect? ffi.cdata*
---@param Flags number
---@return number
---@return ffi.cdata*|nil
function IDirect3DTexture8:LockRect(Level, pRect, Flags) end

---Unlocks a rectangle on a texture resource.
---@param self IDirect3DTexture8
---@param Level number
---@return number
function IDirect3DTexture8:UnlockRect(Level) end

---Adds a dirty region to a texture resource.
---@param self IDirect3DTexture8
---@param pDirtyRect ffi.cdata*
---@return number
function IDirect3DTexture8:AddDirtyRect(pDirtyRect) end