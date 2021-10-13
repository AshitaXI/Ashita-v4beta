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

require('common');
require('win32types');

local ffi = require('ffi');
local C = ffi.C;

-- FFI Prototypes
ffi.cdef[[
    typedef struct __IO_FILE FILE;
        
    FILE* __cdecl   fopen(const char* _FileName, const char* _Mode);
    int32_t __cdecl fseek(FILE* _Stream, long _Offset, int32_t _Origin);
    long    __cdecl ftell(FILE* _Stream);
    int32_t __cdecl fread(void* _Buffer, size_t _ElementSize, size_t _ElementCount, FILE* _Stream);
    int32_t __cdecl fclose(FILE* _Stream);

    enum {
        SEEK_SET = 0,
        SEEK_CUR = 1,
        SEEK_END = 2,
    };
]];

-- Dats Variables
local dats = T{
    -- Dat lookup variables..
    path = '',
    ftable = nil,
    vtable = nil,

    -- Predefined lists..
    lists = T{
        npcs = require('ffxi.dats.npcs'),
    },
};

-- Obtain the install path to Final Fantasy XI..
do
    local lang = AshitaCore:GetConfigurationManager():GetInt32('boot', 'ashita.language', 'playonline', 2);
    if (lang > 4) then
        lang = 2;
    end
    if (lang == 4) then
        lang = 3;
    end

    dats.path = ashita.fs.get_install_dir(lang, 1);
end

-- Read and populate the file index tables..
do
    local paths = T{
        { '/FTABLE.DAT',        '/VTABLE.DAT', },
        { '/ROM2/FTABLE2.DAT',  '/ROM2/VTABLE2.DAT', },
        { '/ROM3/FTABLE3.DAT',  '/ROM3/VTABLE3.DAT', },
        { '/ROM4/FTABLE4.DAT',  '/ROM4/VTABLE4.DAT', },
        { '/ROM5/FTABLE5.DAT',  '/ROM5/VTABLE5.DAT', },
        { '/ROM6/FTABLE6.DAT',  '/ROM6/VTABLE6.DAT', },
        { '/ROM7/FTABLE7.DAT',  '/ROM7/VTABLE7.DAT', },
        { '/ROM8/FTABLE8.DAT',  '/ROM8/VTABLE8.DAT', },
        { '/ROM9/FTABLE9.DAT',  '/ROM9/VTABLE9.DAT', },
    };

    do
        -- Read the main FTABLE.DAT file..
        local f = C.fopen(dats.path + paths[1][1], 'rb');
        C.fseek(f, 0, C.SEEK_END);
        local s = C.ftell(f);
        C.fseek(f, 0, C.SEEK_SET);
        dats.ftable = ffi.new('uint16_t[?]', s / 2);
        C.fread(dats.ftable, s, 1, f);
        C.fclose(f);

        -- Read the main VTABLE.DAT file..
        f = C.fopen(dats.path + paths[1][2], 'rb');
        C.fseek(f, 0, C.SEEK_END);
        s = C.ftell(f);
        C.fseek(f, 0, C.SEEK_SET);
        dats.vtable = ffi.new('uint8_t[?]', s);
        C.fread(dats.vtable, s, 1, f);
        C.fclose(f);
    end

    do
        -- Read the additional FTABLE/VTABLE files and merge them together..
        for x = 2, #paths do
            local tempFTable = nil;
            local tempVTable = nil;

            -- Read the FTABLE DAT file..
            local f = C.fopen(dats.path + paths[x][1], 'rb');
            C.fseek(f, 0, C.SEEK_END);
            local s = C.ftell(f);
            C.fseek(f, 0, C.SEEK_SET);
            tempFTable = ffi.new('uint16_t[?]', s / 2);
            C.fread(tempFTable, s, 1, f);
            C.fclose(f);

            for y = 0, (s / 2) do
                if (tempFTable[y] > 0) then
                    dats.ftable[y] = tempFTable[y];
                end
            end

            -- Read the VTABLE DAT file..
            f = C.fopen(dats.path + paths[x][2], 'rb');
            C.fseek(f, 0, C.SEEK_END);
            s = C.ftell(f);
            C.fseek(f, 0, C.SEEK_SET);
            tempVTable = ffi.new('uint8_t[?]', s);
            C.fread(tempVTable, s, 1, f);
            C.fclose(f);

            for y = 0, s do
                if (tempVTable[y] > 0) then
                    dats.vtable[y] = tempVTable[y];
                end
            end
        end
    end
end

--[[
* Returns the path to a DAT file by its lookup id.
*
* @param {number} fileid - The DAT file id to lookup.
* @return {string|nil} The path to the DAT on success, nil otherwise.
--]]
dats.get_file_path = function (fileid)
    if (dats.ftable == nil or dats.vtable == nil) then
        return nil;
    end

    -- Ensure the file id is within a valid range..
    if (fileid > ffi.sizeof(dats.vtable) or fileid < 0) then
        return nil;
    end

    -- Obtain the expected ROM folder the file should be in..
    local r = dats.vtable[fileid];
    if (r == 0) then
        return nil;
    end

    return ('%s\\%s\\%s\\%s.DAT'):fmt(dats.path, (r == 1 and 'ROM' or ('ROM'):append(r)), bit.rshift(dats.ftable[fileid], 0x07), bit.band(dats.ftable[fileid], 0x7F));
end

--[[
* Returns the DAT id for the file containing the given zones npc list.
*
* @param {number} zid - The zone id.
* @param {number} zsubid - The zone sub id.
* @return {number|nil} The DAT file id on success, nil otherwise.
*
* @note
*
* The zone id and sub id can be obtained from the 'Zone Enter (0x000A)' packet.
*   + 0x30 = zone id
*   + 0x9E = zone sub id
--]]
dats.get_zone_npclist_id = function (zid, zsubid)
    if (zsubid < 1000 or zsubid > 1299) then
        if (zid < 256) then
            return zid + 6720;
        else
            return zid + 86235;
        end
    end

    return zsubid + 66911;
end

--[[
* Returns the path to the DAT file containing the given zones npc list.
*
* @param {number} zid - The zone id.
* @param {number} zsubid - The zone sub id.
* @return {string|nil} The path to the DAT file on success, nil otherwise.
* @note
*
* The zone id and sub id can be obtained from the 'Zone Enter (0x000A)' packet.
*   + 0x30 = zone id
*   + 0x9E = zone sub id
--]]
dats.get_zone_npclist = function (zid, zsubid)
    return dats.get_file_path(dats.get_zone_npclist_id(zid, zsubid));
end

-- Return the modules table.
return dats;