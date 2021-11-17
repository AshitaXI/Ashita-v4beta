--[[
* Addons - Copyright (c) 2021 Ashita Development Team
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

--[[
* This file is created using the information from the d3d8.h header file of the Direct3D 8 SDK.
--]]

require('win32types');
require('d3d8.d3d8types');

local ffi   = require('ffi');
local C     = ffi.C;

ffi.cdef[[
    typedef struct IDirect3D8Vtbl {
        /*** IUnknown methods ***/
        HRESULT     __stdcall (*QueryInterface)(IDirect3D8* This, REFIID riid, void** ppvObj);
        ULONG       __stdcall (*AddRef)(IDirect3D8* This);
        ULONG       __stdcall (*Release)(IDirect3D8* This);

        /*** IDirect3D8 methods ***/
        HRESULT     __stdcall (*RegisterSoftwareDevice)(IDirect3D8* This, void* pInitializeFunction);
        UINT        __stdcall (*GetAdapterCount)(IDirect3D8* This);
        HRESULT     __stdcall (*GetAdapterIdentifier)(IDirect3D8* This, UINT Adapter, DWORD Flags, D3DADAPTER_IDENTIFIER8* pIdentifier);
        UINT        __stdcall (*GetAdapterModeCount)(IDirect3D8* This, UINT Adapter);
        HRESULT     __stdcall (*EnumAdapterModes)(IDirect3D8* This, UINT Adapter, UINT Mode, D3DDISPLAYMODE* pMode);
        HRESULT     __stdcall (*GetAdapterDisplayMode)(IDirect3D8* This, UINT Adapter, D3DDISPLAYMODE* pMode);
        HRESULT     __stdcall (*CheckDeviceType)(IDirect3D8* This, UINT Adapter, D3DDEVTYPE CheckType, D3DFORMAT DisplayFormat, D3DFORMAT BackBufferFormat, BOOL Windowed);
        HRESULT     __stdcall (*CheckDeviceFormat)(IDirect3D8* This, UINT Adapter, D3DDEVTYPE DeviceType, D3DFORMAT AdapterFormat, DWORD Usage, D3DRESOURCETYPE RType, D3DFORMAT CheckFormat);
        HRESULT     __stdcall (*CheckDeviceMultiSampleType)(IDirect3D8* This, UINT Adapter, D3DDEVTYPE DeviceType, D3DFORMAT SurfaceFormat, BOOL Windowed, D3DMULTISAMPLE_TYPE MultiSampleType);
        HRESULT     __stdcall (*CheckDepthStencilMatch)(IDirect3D8* This, UINT Adapter, D3DDEVTYPE DeviceType, D3DFORMAT AdapterFormat, D3DFORMAT RenderTargetFormat, D3DFORMAT DepthStencilFormat);
        HRESULT     __stdcall (*GetDeviceCaps)(IDirect3D8* This, UINT Adapter, D3DDEVTYPE DeviceType, D3DCAPS8* pCaps);
        HMONITOR    __stdcall (*GetAdapterMonitor)(IDirect3D8* This, UINT Adapter);
        HRESULT     __stdcall (*CreateDevice)(IDirect3D8* This, UINT Adapter, D3DDEVTYPE DeviceType, HWND hFocusWindow, DWORD BehaviorFlags, D3DPRESENT_PARAMETERS* pPresentationParameters, IDirect3DDevice8** ppReturnedDeviceInterface);
    } IDirect3D8Vtbl;

    struct IDirect3D8
    {
        struct IDirect3D8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3D8 Vtbl Forwarding
--]]
IDirect3D8 = ffi.metatype('IDirect3D8', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- IDirect3D8 Methods
        RegisterSoftwareDevice = function (self, pInitializeFunction)
            -- Direct3D8 marks this as a dead function:
            -- "Because the pluggable software device feature is no longer supported in Microsoft DirectX® 8.x, do not use this method."
            error('Not implemented.');
        end,
        GetAdapterCount = function (self)
            return self.lpVtbl.GetAdapterCount(self);
        end,
        GetAdapterIdentifier = function (self, Adapter, Flags)
            local ident = ffi.new('D3DADAPTER_IDENTIFIER8[1]');
            local res   = self.lpVtbl.GetAdapterIdentifier(self, Adapter, Flags, ident);

            return res, res == C.S_OK and ident[0] or nil;
        end,
        GetAdapterModeCount = function (self, Adapter)
            return self.lpVtbl.GetAdapterModeCount(self, Adapter);
        end,
        EnumAdapterModes = function (self, Adapter, Mode)
            local dmode = ffi.new('D3DDISPLAYMODE[1]');
            local res   = self.lpVtbl.EnumAdapterModes(self, Adapter, Mode, dmode);

            return res, res == C.S_OK and dmode[0] or nil;
        end,
        GetAdapterDisplayMode = function (self, Adapter)
            local dmode = ffi.new('D3DDISPLAYMODE[1]');
            local res   = self.lpVtbl.GetAdapterDisplayMode(self, Adapter, dmode);

            return res, res == C.S_OK and dmode[0] or nil;
        end,
        CheckDeviceType = function (self, Adapter, CheckType, DisplayFormat, BackBufferFormat, Windowed)
            return self.lpVtbl.CheckDeviceType(self, Adapter, CheckType, DisplayFormat, BackBufferFormat, Windowed);
        end,
        CheckDeviceFormat = function (self, Adapter, DeviceType, AdapterFormat, Usage, RType, CheckFormat)
            return self.lpVtbl.CheckDeviceFormat(self, Adapter, DeviceType, AdapterFormat, Usage, RType, CheckFormat);
        end,
        CheckDeviceMultiSampleType = function (self, Adapter, DeviceType, SurfaceFormat, Windowed, MultiSampleType)
            return self.lpVtbl.CheckDeviceMultiSampleType(self, Adapter, DeviceType, SurfaceFormat, Windowed, MultiSampleType);
        end,
        CheckDepthStencilMatch = function (self, Adapter, DeviceType, AdapterFormat, RenderTargetFormat, DepthStencilFormat)
            return self.lpVtbl.CheckDepthStencilMatch(self, Adapter, DeviceType, AdapterFormat, RenderTargetFormat, DepthStencilFormat);
        end,
        GetDeviceCaps = function (self, Adapter, DeviceType)
            local caps = ffi.new('D3DCAPS8[1]');
            local res = self.lpVtbl.GetDeviceCaps(self, Adapter, DeviceType, caps);

            return res, res == C.S_OK and caps[0] or nil;
        end,
        GetAdapterMonitor = function (self, Adapter)
            return self.lpVtbl.GetAdapterMonitor(self, Adapter);
        end,
        CreateDevice = function (self, Adapter, DeviceType, hFocusWindow, BehaviorFlags, pPresentationParameters)
            local device_ptr    = ffi.new('IDirect3DDevice8*[1]');
            local res           = self.lpVtbl.CreateDevice(self, Adapter, DeviceType, hFocusWindow, BehaviorFlags, pPresentationParameters, device_ptr);
            local device        = nil;

            if (res == C.S_OK) then
                device = ffi.cast('IDirect3DDevice8*', device_ptr[0]);
            end

            return res, device;
        end,
    },
});