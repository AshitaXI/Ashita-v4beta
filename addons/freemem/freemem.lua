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

addon.name      = 'freemem';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Memory cleanup.';
addon.link      = 'https://ashitaxi.com/';

local ffi = require('ffi');
ffi.cdef[[
    typedef long BOOL;
    typedef void* HANDLE;
    typedef unsigned long ULONG_PTR;
    typedef ULONG_PTR SIZE_T;
    HANDLE GetCurrentProcess(void);
    BOOL SetProcessWorkingSetSize(HANDLE hProcess, SIZE_T dwMinimumWorkingSetSize, SIZE_T dwMaximumWorkingSetSize);
]];

ffi.C.SetProcessWorkingSetSize(ffi.C.GetCurrentProcess(), -1, -1);