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
    typedef struct IDirect3DIndexBuffer8Vtbl {
        /*** IUnknown methods ***/
        HRESULT         __stdcall (*QueryInterface)(IDirect3DIndexBuffer8* This, REFIID riid, void** ppvObj);
        ULONG           __stdcall (*AddRef)(IDirect3DIndexBuffer8* This);
        ULONG           __stdcall (*Release)(IDirect3DIndexBuffer8* This);

        /*** IDirect3DResource8 methods ***/
        HRESULT         __stdcall (*GetDevice)(IDirect3DIndexBuffer8* This, IDirect3DDevice8** ppDevice);
        HRESULT         __stdcall (*SetPrivateData)(IDirect3DIndexBuffer8* This, REFGUID refguid, const void* pData, DWORD SizeOfData, DWORD Flags);
        HRESULT         __stdcall (*GetPrivateData)(IDirect3DIndexBuffer8* This, REFGUID refguid, void* pData, DWORD* pSizeOfData);
        HRESULT         __stdcall (*FreePrivateData)(IDirect3DIndexBuffer8* This, REFGUID refguid);
        DWORD           __stdcall (*SetPriority)(IDirect3DIndexBuffer8* This, DWORD PriorityNew);
        DWORD           __stdcall (*GetPriority)(IDirect3DIndexBuffer8* This);
        void            __stdcall (*PreLoad)(IDirect3DIndexBuffer8* This);
        D3DRESOURCETYPE __stdcall (*GetType)(IDirect3DIndexBuffer8* This);

        /*** IDirect3DIndexBuffer8 methods ***/
        HRESULT         __stdcall (*Lock)(IDirect3DIndexBuffer8* This, UINT OffsetToLock, UINT SizeToLock, BYTE** ppbData, DWORD Flags);
        HRESULT         __stdcall (*Unlock)(IDirect3DIndexBuffer8* This);
        HRESULT         __stdcall (*GetDesc)(IDirect3DIndexBuffer8* This, D3DINDEXBUFFER_DESC *pDesc);
    } IDirect3DIndexBuffer8Vtbl;

    struct IDirect3DIndexBuffer8
    {
        struct IDirect3DIndexBuffer8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DIndexBuffer8 Vtbl Forwarding
--]]
IDirect3DIndexBuffer8 = ffi.metatype('IDirect3DIndexBuffer8', {
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

        -- IDirect3DIndexBuffer8 Methods
        Lock = function (self, OffsetToLock, SizeToLock, Flags)
            local data_ptr  = ffi.new('BYTE*[1]');
            local res       = self.lpVtbl.Lock(self, OffsetToLock, SizeToLock, data_ptr, Flags);
            local data      = nil;

            if (res == C.S_OK) then
                data = ffi.cast('BYTE*', data_ptr[0]);
            end

            return res, data;
        end,
        Unlock = function (self)
            return self.lpVtbl.Unlock(self);
        end,
        GetDesc = function (self)
            local desc  = ffi.new('D3DINDEXBUFFER_DESC[1]');
            local res   = self.lpVtbl.GetDesc(self, desc);

            return res, res == C.S_OK and desc[0] or nil;
        end,
    },
});