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
    typedef struct IDirect3DResource8Vtbl {
        /*** IUnknown methods ***/
        HRESULT         __stdcall (*QueryInterface)(IDirect3DResource8* This, REFIID riid, void** ppvObj);
        ULONG           __stdcall (*AddRef)(IDirect3DResource8* This);
        ULONG           __stdcall (*Release)(IDirect3DResource8* This);

        /*** IDirect3DResource8 methods ***/
        HRESULT         __stdcall (*GetDevice)(IDirect3DResource8* This, IDirect3DDevice8** ppDevice);
        HRESULT         __stdcall (*SetPrivateData)(IDirect3DResource8* This, REFGUID refguid, const void* pData, DWORD SizeOfData, DWORD Flags);
        HRESULT         __stdcall (*GetPrivateData)(IDirect3DResource8* This, REFGUID refguid, void* pData, DWORD* pSizeOfData);
        HRESULT         __stdcall (*FreePrivateData)(IDirect3DResource8* This, REFGUID refguid);
        DWORD           __stdcall (*SetPriority)(IDirect3DResource8* This, DWORD PriorityNew);
        DWORD           __stdcall (*GetPriority)(IDirect3DResource8* This);
        void            __stdcall (*PreLoad)(IDirect3DResource8* This);
        D3DRESOURCETYPE __stdcall (*GetType)(IDirect3DResource8* This);
    } IDirect3DResource8Vtbl;

    struct IDirect3DResource8
    {
        struct IDirect3DResource8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DResource8 Vtbl Forwarding
--]]
IDirect3DResource8 = ffi.metatype('IDirect3DResource8', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- IDirect3DResource8 Methods
        GetDevice = function (self)
            local device_ptr    = ffi.new('IDirect3DDevice8*[1]');
            local res           = self.lpVtbl.GetDevice(self, device_ptr);
            local device        = nil;

            if (res == C.S_OK) then
                device = ffi.cast('IDirect3DDevice8*', device_ptr[0]);
            end

            return res, device;
        end,
        SetPrivateData = function (self, refguid, pData, SizeOfData, Flags)
            return self.lpVtbl.SetPrivateData(self, refguid, pData, SizeOfData, Flags);
        end,
        GetPrivateData = function (self, refguid)
            -- Request the private data size..
            local size  = ffi.new('DWORD[1]', 0);
            local res   = self.lpVtbl.GePrivateData(self, refguid, nil, size);

            if (res ~= C.S_OK) then
                return res, nil;
            end

            -- Request the private data..
            local buffer    = ffi.new('uint8_t[?]', size[0]);
            res             = self.lpVtbl.GetPrivateData(self, refguid, buffer, size);

            return res, res == C.S_OK and buffer or nil;
        end,
        FreePrivateData = function (self, refguid)
            return self.lpVtbl.FreePrivateData(self, refguid);
        end,
        SetPriority = function (self, PriorityNew)
            return self.lpVtbl.SetPriority(self, PriorityNew);
        end,
        GetPriority = function (self)
            return self.lpVtbl.GetPriority(self);
        end,
        PreLoad = function (self)
            self.lpVtbl.PreLoad(self);
        end,
        GetType = function (self)
            return self.lpVtbl.GetType(self);
        end,
    },
});