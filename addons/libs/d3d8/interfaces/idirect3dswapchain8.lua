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

local ffi   = require('ffi');
local C     = ffi.C;

ffi.cdef[[
    typedef struct IDirect3DSwapChain8Vtbl {
        /*** IUnknown methods ***/
        HRESULT __stdcall (*QueryInterface)(IDirect3DSwapChain8* This, REFIID riid, void** ppvObj);
        ULONG   __stdcall (*AddRef)(IDirect3DSwapChain8* This);
        ULONG   __stdcall (*Release)(IDirect3DSwapChain8* This);

        /*** IDirect3DSwapChain8 methods ***/
        HRESULT __stdcall (*Present)(IDirect3DSwapChain8* This, const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion);
        HRESULT __stdcall (*GetBackBuffer)(IDirect3DSwapChain8* This, UINT BackBuffer, D3DBACKBUFFER_TYPE Type, IDirect3DSurface8** ppBackBuffer);
    } IDirect3DSwapChain8Vtbl;

    struct IDirect3DSwapChain8
    {
        struct IDirect3DSwapChain8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DSwapChain8 Vtbl Forwarding
--]]
IDirect3DSwapChain8 = ffi.metatype('IDirect3DSwapChain8', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- IDirect3DSwapChain8 Methods
        Present = function (self, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion)
            return self.lpVtbl.Present(self, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion);
        end,
        GetBackBuffer = function (self, BackBuffer, Type)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.GetBackBuffer(self, BackBuffer, Type, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
    },
});