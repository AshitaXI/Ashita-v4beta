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
    typedef struct IDirect3DVertexBuffer8Vtbl {
        /*** IUnknown methods ***/
        HRESULT         __stdcall (*QueryInterface)(IDirect3DVertexBuffer8* This, REFIID riid, void** ppvObj);
        ULONG           __stdcall (*AddRef)(IDirect3DVertexBuffer8* This);
        ULONG           __stdcall (*Release)(IDirect3DVertexBuffer8* This);

        /*** IDirect3DResource8 methods ***/
        HRESULT         __stdcall (*GetDevice)(IDirect3DVertexBuffer8* This, IDirect3DDevice8** ppDevice);
        HRESULT         __stdcall (*SetPrivateData)(IDirect3DVertexBuffer8* This, REFGUID refguid, const void* pData, DWORD SizeOfData, DWORD Flags);
        HRESULT         __stdcall (*GetPrivateData)(IDirect3DVertexBuffer8* This, REFGUID refguid, void* pData, DWORD* pSizeOfData);
        HRESULT         __stdcall (*FreePrivateData)(IDirect3DVertexBuffer8* This, REFGUID refguid);
        DWORD           __stdcall (*SetPriority)(IDirect3DVertexBuffer8* This, DWORD PriorityNew);
        DWORD           __stdcall (*GetPriority)(IDirect3DVertexBuffer8* This);
        void            __stdcall (*PreLoad)(IDirect3DVertexBuffer8* This);
        D3DRESOURCETYPE __stdcall (*GetType)(IDirect3DVertexBuffer8* This);

        /*** IDirect3DVertexBuffer8 methods ***/
        HRESULT         __stdcall (*Lock)(IDirect3DVertexBuffer8* This, UINT OffsetToLock, UINT SizeToLock, BYTE** ppbData, DWORD Flags);
        HRESULT         __stdcall (*Unlock)(IDirect3DVertexBuffer8* This);
        HRESULT         __stdcall (*GetDesc)(IDirect3DVertexBuffer8* This, D3DVERTEXBUFFER_DESC *pDesc);
    } IDirect3DVertexBuffer8Vtbl;

    struct IDirect3DVertexBuffer8
    {
        struct IDirect3DVertexBuffer8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DVertexBuffer8 Vtbl Forwarding
--]]
IDirect3DVertexBuffer8 = ffi.metatype('IDirect3DVertexBuffer8', {
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

        -- IDirect3DVertexBuffer8 Methods
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
            local desc  = ffi.new('D3DVERTEXBUFFER_DESC[1]');
            local res   = self.lpVtbl.GetDesc(self, desc);

            return res, res == C.S_OK and desc[0] or nil;
        end,
    },
});