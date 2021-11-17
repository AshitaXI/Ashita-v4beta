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
    typedef struct IUnknownVtbl {
        /*** IUnknown methods ***/
        HRESULT __stdcall (*QueryInterface)(IUnknown* This, REFIID riid, void** ppvObj);
        ULONG   __stdcall (*AddRef)(IUnknown* This);
        ULONG   __stdcall (*Release)(IUnknown* This);
    } IUnknownVtbl;

    struct IUnknown
    {
        struct IUnknownVtbl* lpVtbl;
    };
]];

--[[
* IUnknown Vtbl Forwarding
--]]
IUnknown = ffi.metatype('IUnknown', {
    __index = {
        -- IUnknown Methods
        QueryInterface = function (self, riid)
            local unk_ptr   = ffi.new('void*[1]');
            local res       = self.lpVtbl.QueryInterface(self, riid, unk_ptr);
            local unk       = nil;

            if (res == C.S_OK) then
                unk = ffi.cast('IUnknown*', unk_ptr[0]);
            end

            return res, unk;
        end,
        AddRef = function (self)
            return self.lpVtbl.AddRef(self);
        end,
        Release = function (self)
            return self.lpVtbl.Release(self);
        end,
    },
});