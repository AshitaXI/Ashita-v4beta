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

local ffi = require('ffi');

ffi.cdef[[
    typedef struct IDirect3DBaseTexture8Vtbl {
        /*** IUnknown methods ***/
        HRESULT         __stdcall (*QueryInterface)(IDirect3DBaseTexture8* This, REFIID riid, void** ppvObj);
        ULONG           __stdcall (*AddRef)(IDirect3DBaseTexture8* This);
        ULONG           __stdcall (*Release)(IDirect3DBaseTexture8* This);

        /*** IDirect3DResource8 methods ***/
        HRESULT         __stdcall (*GetDevice)(IDirect3DBaseTexture8* This, IDirect3DDevice8** ppDevice);
        HRESULT         __stdcall (*SetPrivateData)(IDirect3DBaseTexture8* This, REFGUID refguid, const void* pData, DWORD SizeOfData, DWORD Flags);
        HRESULT         __stdcall (*GetPrivateData)(IDirect3DBaseTexture8* This, REFGUID refguid, void* pData, DWORD* pSizeOfData);
        HRESULT         __stdcall (*FreePrivateData)(IDirect3DBaseTexture8* This, REFGUID refguid);
        DWORD           __stdcall (*SetPriority)(IDirect3DBaseTexture8* This, DWORD PriorityNew);
        DWORD           __stdcall (*GetPriority)(IDirect3DBaseTexture8* This);
        void            __stdcall (*PreLoad)(IDirect3DBaseTexture8* This);
        D3DRESOURCETYPE __stdcall (*GetType)(IDirect3DBaseTexture8* This);

        /*** IDirect3DBaseTexture8 methods ***/
        DWORD           __stdcall (*SetLOD)(IDirect3DBaseTexture8* This, DWORD LODNew);
        DWORD           __stdcall (*GetLOD)(IDirect3DBaseTexture8* This);
        DWORD           __stdcall (*GetLevelCount)(IDirect3DBaseTexture8* This);
    } IDirect3DBaseTexture8Vtbl;

    struct IDirect3DBaseTexture8
    {
        struct IDirect3DBaseTexture8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DBaseTexture8 Vtbl Forwarding
--]]
IDirect3DBaseTexture8 = ffi.metatype('IDirect3DBaseTexture8', {
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
        SetLOD = function (self, LODNew)
            return self.lpVtbl.SetLOD(self, LODNew);
        end,
        GetLOD = function (self)
            return self.lpVtbl.GetLOD(self);
        end,
        GetLevelCount = function (self)
            return self.lpVtbl.GetLevelCount(self);
        end,
    },
});