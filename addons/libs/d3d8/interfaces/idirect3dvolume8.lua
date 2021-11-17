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
    typedef struct IDirect3DVolume8Vtbl {
        /*** IUnknown methods ***/
        HRESULT __stdcall (*QueryInterface)(IDirect3DVolume8* This, REFIID riid, void** ppvObj);
        ULONG   __stdcall (*AddRef)(IDirect3DVolume8* This);
        ULONG   __stdcall (*Release)(IDirect3DVolume8* This);

        /*** IDirect3DVolume8 methods ***/
        HRESULT __stdcall (*GetDevice)(IDirect3DVolume8* This, IDirect3DDevice8** ppDevice);
        HRESULT __stdcall (*SetPrivateData)(IDirect3DVolume8* This, REFGUID refguid, const void* pData, DWORD SizeOfData, DWORD Flags);
        HRESULT __stdcall (*GetPrivateData)(IDirect3DVolume8* This, REFGUID refguid, void* pData, DWORD* pSizeOfData);
        HRESULT __stdcall (*FreePrivateData)(IDirect3DVolume8* This, REFGUID refguid);
        HRESULT __stdcall (*GetContainer)(IDirect3DVolume8* This, REFIID riid, void** ppContainer);
        HRESULT __stdcall (*GetDesc)(IDirect3DVolume8* This, D3DVOLUME_DESC* pDesc);
        HRESULT __stdcall (*LockBox)(IDirect3DVolume8* This, D3DLOCKED_BOX* pLockedVolume, const D3DBOX* pBox, DWORD Flags);
        HRESULT __stdcall (*UnlockBox)(IDirect3DVolume8* This);
    } IDirect3DVolume8Vtbl;

    struct IDirect3DVolume8
    {
        struct IDirect3DVolume8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DVolume8 Vtbl Forwarding
--]]
IDirect3DVolume8 = ffi.metatype('IDirect3DVolume8', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- IDirect3DVolume8 Methods
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
        GetContainer = function (self, riid)
            local container_ptr = ffi.new('void*[1]');
            local res           = self.lpVtbl.GetContainer(self, riid, container_ptr);
            local container     = nil;

            if (res == C.S_OK) then
                container = ffi.cast('void*', container_ptr[0]);
            end

            return res, container;
        end,
        GetDesc = function (self)
            local desc = ffi.new('D3DVOLUME_DESC[1]');
            local res   = self.lpVtbl.GetDesc(self, desc);

            return res, res == C.S_OK and desc[0] or nil;
        end,
        LockBox = function (self, pBox, Flags)
            local lock  = ffi.new('D3DLOCKED_BOX[1]');
            local res   = self.lpVtbl.LockBox(self, lock, pBox, Flags);

            return res, res == C.S_OK and lock[0] or nil;
        end,
        UnlockBox = function (self)
            return self.lpVtbl.UnlockBox(self);
        end,
    },
});