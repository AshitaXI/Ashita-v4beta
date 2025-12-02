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

---@class IDirect3DCubeTexture8
IDirect3DCubeTexture8 = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IDirect3DCubeTexture8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DCubeTexture8:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IDirect3DCubeTexture8
---@return number
function IDirect3DCubeTexture8:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IDirect3DCubeTexture8
---@return number
function IDirect3DCubeTexture8:Release() end

--[[
IDirect3DResource8 Interface
--]]

---Retrieves the device associated with a resource.
---@param self IDirect3DCubeTexture8
---@return number
---@return IDirect3DDevice8|nil
function IDirect3DCubeTexture8:GetDevice() end

---Associates data with the resource that is intended for use by the application.
---@param self IDirect3DCubeTexture8
---@param refguid ffi.cdata*
---@param pData ffi.cdata*
---@param SizeOfData number
---@param Flags number
---@return number
function IDirect3DCubeTexture8:SetPrivateData(refguid, pData, SizeOfData, Flags) end

---Copies the private data associated with the resource to a provided buffer.
---@param self IDirect3DCubeTexture8
---@param refguid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DCubeTexture8:GetPrivateData(refguid) end

---Frees the specified private data associated with this resource.
---@param self IDirect3DCubeTexture8
---@param refguid ffi.cdata*
---@return number
function IDirect3DCubeTexture8:FreePrivateData(refguid) end

---Assigns the resource-management priority for this resource.
---@param self IDirect3DCubeTexture8
---@param PriorityNew number
---@return number
function IDirect3DCubeTexture8:SetPriority(PriorityNew) end

---Retrieves the priority for this resource.
---@param self IDirect3DCubeTexture8
---@return number
function IDirect3DCubeTexture8:GetPriority() end

---Preloads a managed resource.
---@param self IDirect3DCubeTexture8
function IDirect3DCubeTexture8:PreLoad() end

---Returns the type of the resource.
---@param self IDirect3DCubeTexture8
---@return number
function IDirect3DCubeTexture8:GetType() end

--[[
IDirect3DBaseTexture8 Interface
--]]

---Sets the most detailed level of detail (LOD) for a managed texture.
---@param self IDirect3DCubeTexture8
---@param LODNew number
---@return number
function IDirect3DCubeTexture8:SetLOD(LODNew) end

---Returns a value clamped to the maximum level of detail (LOD) set for a managed texture.
---@param self IDirect3DCubeTexture8
---@return number
function IDirect3DCubeTexture8:GetLOD() end

---Returns the number of texture levels in a multilevel texture.
---@param self IDirect3DCubeTexture8
---@return number
function IDirect3DCubeTexture8:GetLevelCount() end

--[[
IDirect3DCubeTexture8 Interface
--]]

---Retrieves a description of one face of the specified cube texture level.
---@param self IDirect3DCubeTexture8
---@param Level number
---@return number
---@return ffi.cdata*|nil
function IDirect3DCubeTexture8:GetLevelDesc(Level) end

---Retrieves a cube texture map surface.
---@param self IDirect3DCubeTexture8
---@param FaceType number
---@param Level number
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DCubeTexture8:GetCubeMapSurface(FaceType, Level) end

---Locks a rectangle on a cube texture resource.
---@param self IDirect3DCubeTexture8
---@param FaceType number
---@param Level number
---@param pRect? ffi.cdata*
---@param Flags number
---@return number
---@return ffi.cdata*|nil
function IDirect3DCubeTexture8:LockRect(FaceType, Level, pRect, Flags) end

---Unlocks a rectangle on a cube texture resource.
---@param self IDirect3DCubeTexture8
---@param FaceType number
---@param Level number
---@return number
function IDirect3DCubeTexture8:UnlockRect(FaceType, Level) end

---Adds a dirty region to a cube texture resource.
---@param self IDirect3DCubeTexture8
---@param FaceType number
---@param pDirtyRect? ffi.cdata*
---@return number
function IDirect3DCubeTexture8:AddDirtyRect(FaceType, pDirtyRect) end