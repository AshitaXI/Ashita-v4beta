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

---@class IDirect3DSwapChain8
IDirect3DSwapChain8 = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IDirect3DSwapChain8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DSwapChain8:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IDirect3DSwapChain8
---@return number
function IDirect3DSwapChain8:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IDirect3DSwapChain8
---@return number
function IDirect3DSwapChain8:Release() end

--[[
IDirect3DSwapChain8 Interface
--]]

---Retrieves the device associated with a surface.
---@param self IDirect3DSwapChain8
---@param pSourceRect? ffi.cdata*
---@param pDestRect? ffi.cdata*
---@param hDestWindowOverride? ffi.cdata*
---@param pDirtyRegion? ffi.cdata*
---@return number
function IDirect3DSwapChain8:Present(pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion) end

---Retrieves a back buffer from the swap chain of the device.
---@param self IDirect3DSwapChain8
---@param BackBuffer number
---@param Type number
---@return number
---@return ffi.cdata*|nil
function IDirect3DSwapChain8:GetBackBuffer(BackBuffer, Type) end