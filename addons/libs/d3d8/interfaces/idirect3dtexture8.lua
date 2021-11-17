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
    typedef struct IDirect3DTexture8Vtbl {
        /*** IUnknown methods ***/
        HRESULT         __stdcall (*QueryInterface)(IDirect3DTexture8* This, REFIID riid, void** ppvObj);
        ULONG           __stdcall (*AddRef)(IDirect3DTexture8* This);
        ULONG           __stdcall (*Release)(IDirect3DTexture8* This);

        /*** IDirect3DResource8 methods ***/
        HRESULT         __stdcall (*GetDevice)(IDirect3DTexture8* This, IDirect3DDevice8** ppDevice);
        HRESULT         __stdcall (*SetPrivateData)(IDirect3DTexture8* This, REFGUID refguid, const void* pData, DWORD SizeOfData, DWORD Flags);
        HRESULT         __stdcall (*GetPrivateData)(IDirect3DTexture8* This, REFGUID refguid, void* pData, DWORD* pSizeOfData);
        HRESULT         __stdcall (*FreePrivateData)(IDirect3DTexture8* This, REFGUID refguid);
        DWORD           __stdcall (*SetPriority)(IDirect3DTexture8* This, DWORD PriorityNew);
        DWORD           __stdcall (*GetPriority)(IDirect3DTexture8* This);
        void            __stdcall (*PreLoad)(IDirect3DTexture8* This);
        D3DRESOURCETYPE __stdcall (*GetType)(IDirect3DTexture8* This);

        /*** IDirect3DBaseTexture8 methods ***/
        DWORD           __stdcall (*SetLOD)(IDirect3DCubeTexture8* This, DWORD LODNew);
        DWORD           __stdcall (*GetLOD)(IDirect3DCubeTexture8* This);
        DWORD           __stdcall (*GetLevelCount)(IDirect3DCubeTexture8* This);

        /*** IDirect3DTexture8 methods ***/
        HRESULT         __stdcall (*GetLevelDesc)(IDirect3DTexture8* This, UINT Level, D3DSURFACE_DESC *pDesc);
        HRESULT         __stdcall (*GetSurfaceLevel)(IDirect3DTexture8* This, UINT Level, IDirect3DSurface8** ppCubeMapSurface);
        HRESULT         __stdcall (*LockRect)(IDirect3DTexture8* This, UINT Level, D3DLOCKED_RECT* pLockedRect, const RECT* pRect, DWORD Flags);
        HRESULT         __stdcall (*UnlockRect)(IDirect3DTexture8* This, UINT Level);
        HRESULT         __stdcall (*AddDirtyRect)(IDirect3DTexture8* This, const RECT* pDirtyRect);
    } IDirect3DTexture8Vtbl;

    struct IDirect3DTexture8
    {
        struct IDirect3DTexture8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DTexture8 Vtbl Forwarding
--]]
IDirect3DTexture8 = ffi.metatype('IDirect3DTexture8', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- IDirect3DResource8 Methods
        GetDevice       = IDirect3DResource8.GetDevice,
        SetPrivateData  = IDirect3DResource8.SetPrivateData,
        GetPrivateData  = IDirect3DResource8.GetPrivateData,
        FreePrivateData = IDirect3DResource8.FreePrivateData,
        SetPriority     = IDirect3DResource8.SetPriority,
        GetPriority     = IDirect3DResource8.GetPriority,
        PreLoad         = IDirect3DResource8.PreLoad,
        GetType         = IDirect3DResource8.GetType,

        -- IDirect3DBaseTexture8 Methods
        SetLOD          = IDirect3DBaseTexture8.SetLOD,
        GetLOD          = IDirect3DBaseTexture8.GetLOD,
        GetLevelCount   = IDirect3DBaseTexture8.GetLevelCount,

        -- IDirect3DTexture8 Methods
        GetLevelDesc = function (self, Level)
            local desc = ffi.new('D3DSURFACE_DESC[1]');
            local res   = self.lpVtbl.GetLevelDesc(self, Level, desc);

            return res, res == C.S_OK and desc[0] or nil;
        end,
        GetSurfaceLevel = function (self, Level)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.GetSurfaceLevel(self, Level, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
        LockRect = function (self, Level, pRect, Flags)
            local lock  = ffi.new('D3DLOCKED_RECT[1]');
            local res   = self.lpVtbl.LockRect(self, Level, lock, pRect, Flags);

            return res, res == C.S_OK and lock[0] or nil;
        end,
        UnlockRect = function (self, Level)
            return self.lpVtbl.UnlockRect(self, Level);
        end,
        AddDirtyRect = function (self, pDirtyRect)
            return self.lpVtbl.AddDirtyRect(self, pDirtyRect);
        end,
    },
});