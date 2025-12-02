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

---@class IDirect3D8
IDirect3D8 = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IDirect3D8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3D8:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IDirect3D8
---@return number
function IDirect3D8:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IDirect3D8
---@return number
function IDirect3D8:Release() end

--[[
IDirect3D8 Interface
--]]

---Not implemented.
---@param self IDirect3D8
---@deprecated
function IDirect3D8:RegisterSoftwareDevice() end

---Returns the number of adapters on the system.
---@param self IDirect3D8
---@return number
function IDirect3D8:GetAdapterCount() end

---Describes the physical display adapters present in the system when the IDirect3D8 interface was instantiated.
---@param self IDirect3D8
---@param Adapter number
---@param Flags number
---@return number
---@return ffi.cdata*|nil
function IDirect3D8:GetAdapterIdentifier(Adapter, Flags) end

---Returns the number of display modes available on this adapter.
---@param self IDirect3D8
---@param Adapter number
---@return number
function IDirect3D8:GetAdapterModeCount(Adapter) end

---Enumerates the display modes of an adapter.
---@param self IDirect3D8
---@param Adapter number
---@param Mode number
---@return number
---@return ffi.cdata*|nil
function IDirect3D8:EnumAdapterModes(Adapter, Mode) end

---Retrieves the current display mode of the adapter.
---@param self IDirect3D8
---@param Adapter number
---@return number
---@return ffi.cdata*|nil
function IDirect3D8:GetAdapterDisplayMode(Adapter) end

---Verifies whether or not a certain device type can be used on this adapter and expect hardware acceleration using the given formats.
---@param self IDirect3D8
---@param Adapter number
---@param CheckType number
---@param DisplayFormat number
---@param BackBufferFormat number
---@param Windowed boolean
---@return number
function IDirect3D8:CheckDeviceType(Adapter, CheckType, DisplayFormat, BackBufferFormat, Windowed) end

---Determines whether a surface format is available as a specified resource type and can be used as a texture, depth-stencil buffer, or render target, or any combination of the three, on a device representing this adapter.
---@param self IDirect3D8
---@param Adapter number
---@param DeviceType number
---@param AdapterFormat number
---@param Usage number
---@param RType number
---@param CheckFormat number
---@return number
function IDirect3D8:CheckDeviceFormat(Adapter, DeviceType, AdapterFormat, Usage, RType, CheckFormat) end

---Determines if a multisampling technique is available on this device.
---@param self IDirect3D8
---@param Adapter number
---@param DeviceType number
---@param SurfaceFormat number
---@param Windowed boolean
---@param MultiSampleType number
---@return number
function IDirect3D8:CheckDeviceMultiSampleType(Adapter, DeviceType, SurfaceFormat, Windowed, MultiSampleType) end

---Determines whether or not a depth-stencil format is compatible with a render target format in a particular display mode.
---@param self IDirect3D8
---@param Adapter number
---@param DeviceType number
---@param AdapterFormat number
---@param RenderTargetFormat number
---@param DepthStencilFormat number
---@return number
function IDirect3D8:CheckDepthStencilMatch(Adapter, DeviceType, AdapterFormat, RenderTargetFormat, DepthStencilFormat) end

---Retrieves device-specific information about a device.
---@param self IDirect3D8
---@param Adapter number
---@param DeviceType number
---@return number
---@return ffi.cdata*|nil
function IDirect3D8:GetDeviceCaps(Adapter, DeviceType) end

---Returns the handle of the monitor associated with the Direct3D object.
---@param self IDirect3D8
---@param Adapter number
---@return number
function IDirect3D8:GetAdapterMonitor(Adapter) end

---Creates a device to represent the display adapter.
---@param self IDirect3D8
---@param Adapter number
---@param DeviceType number
---@param hFocusWindow ffi.cdata*
---@param BehaviorFlags number
---@param pPresentationParameters ffi.cdata*
---@return number
---@return IDirect3DDevice8|nil
function IDirect3D8:CreateDevice(Adapter, DeviceType, hFocusWindow, BehaviorFlags, pPresentationParameters) end