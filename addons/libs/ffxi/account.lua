--[[
* Addons - Copyright (c) 2025 Ashita Development Team
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

require 'common';
require 'win32types';

local chat  = require 'chat';
local ffi   = require 'ffi';

ffi.cdef[[

    typedef struct TC_OPERATION_MAKE
    {
        uint16_t            mon_no;
        uint8_t             mjob_no;
        uint8_t             sjob_no;
        uint16_t            face_no;
        uint8_t             town_no;
        uint8_t             gen_flag;
        uint8_t             hair_no;
        uint8_t             size;
        uint16_t            world_no;
        uint16_t            GrapIDTbl[8];
        uint8_t             zone_no;
        uint8_t             mjob_level;
        uint8_t             open_flag;
        uint8_t             GMCallCounter;
        uint16_t            version;
        uint8_t             skill1;
        uint8_t             zone_no2;
        uint8_t             TC_OPERATION_WORK_USER_RANK_LEVEL_SD_;
        uint8_t             TC_OPERATION_WORK_USER_RANK_LEVEL_BS_;
        uint8_t             TC_OPERATION_WORK_USER_RANK_LEVEL_WS_;
        uint8_t             ErrCounter;
        uint16_t            TC_OPERATION_WORK_USER_FAME_SD_COMMON_;
        uint16_t            TC_OPERATION_WORK_USER_FAME_BS_COMMON_;
        uint16_t            TC_OPERATION_WORK_USER_FAME_WS_COMMON_;
        uint16_t            TC_OPERATION_WORK_USER_FAME_DARK_GUILD_;
        uint32_t            PlayTime;
        uint32_t            get_job_flag;
        uint8_t             job_lev[16];
        uint32_t            FirstLoginDate;
        uint32_t            Gold;
        uint8_t             skill2;
        uint8_t             skill3;
        uint8_t             skill4;
        uint8_t             skill5;
        uint32_t            ChatCounter;
        uint32_t            PartyCounter;
        uint8_t             skill6;
        uint8_t             skill7;
        uint8_t             skill8;
        uint8_t             skill9;
    } TC_OPERATION_MAKE;

    typedef struct lpkt_chr_info_sub2
    {
        uint32_t            ffxi_id;
        uint16_t            ffxi_id_world;
        uint16_t            worldid;
        uint16_t            status;
        uint8_t             renamef     : 1;
        uint8_t             race_change : 1;
        uint8_t             unused      : 6;
        uint8_t             ffxi_id_world_tbl;
        char                character_name[16];
        char                world_name[16];
        TC_OPERATION_MAKE   character_info;
    } lpkt_chr_info_sub2;

]];

local accountlib = T{
    ptrs = T{
        main_sys    = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8D04808B8481????????C3', 0, 0),
        nt_sys      = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8B81????????50E8', 0, 0),
    },
};

if (not accountlib.ptrs:all(function (v) return v ~= nil and v ~= 0; end)) then
    error(chat.header(addon.name):append(chat.error('[lib.account] Error: Failed to locate required pointer(s).')));
    return;
end

--[[
* Returns the pointer to the start of the 'pGcMainSys->work.character_info[]' array.
*
* @return {number} The base pointer.
--]]
local function get_base_address()
    local ptr = ashita.memory.read_uint32(accountlib.ptrs.main_sys + 0x02);
    local off = ashita.memory.read_uint32(accountlib.ptrs.main_sys + 0x0C);

    if (ptr == 0 or off == 0) then
        return 0;
    end

    return ashita.memory.read_uint32(ptr) + off;
end

--[[
* Returns the number of entries in the 'pGcMainSys->work.character_info[]' array.
*
* @return {number} The base pointer.
--]]
accountlib.get_character_count = function ()
    local ptr = ashita.memory.read_uint32(accountlib.ptrs.main_sys + 0x02);
    local off = ashita.memory.read_uint32(accountlib.ptrs.main_sys + 0x0C);

    if (ptr == 0 or off == 0) then
        return 0;
    end

    return ashita.memory.read_uint32(ashita.memory.read_uint32(ptr) + off - 4);
end

--[[
* Returns the current selected character index that is being played.
*
* @return {number} The current selected character index.
--]]
accountlib.get_selected_character_index = function ()
    local ptr = ashita.memory.read_uint32(accountlib.ptrs.nt_sys + 0x02);
    local off = ashita.memory.read_uint32(accountlib.ptrs.nt_sys + 0x08);

    if (ptr == 0 or off == 0) then
        return 0;
    end

    return ashita.memory.read_uint32(ashita.memory.read_uint32(ptr) + off);
end

--[[
* Returns the requested characters ffxi_id.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters ffxi_id.
--]]
accountlib.get_login_ffxi_id = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].ffxi_id;
end

--[[
* Returns the requested characters ffxi_id_world.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters ffxi_id_world.
--]]
accountlib.get_login_ffxi_id_world = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].ffxi_id_world;
end

--[[
* Returns the requested characters world_id.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters world_id.
--]]
accountlib.get_login_world_id = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].worldid;
end

--[[
* Returns the requested characters status.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters status.
--]]
accountlib.get_login_status = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].status;
end

--[[
* Returns the requested characters renamef.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters renamef.
--]]
accountlib.get_login_renamef = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].renamef;
end

--[[
* Returns the requested characters reacechangef.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters racechangef.
--]]
accountlib.get_login_racechangef = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].race_change;
end

--[[
* Returns the requested characters world_tbl.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters world_tbl.
--]]
accountlib.get_login_ffxi_id_world_tbl = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].ffxi_id_world_tbl;
end

--[[
* Returns the requested characters character_name.
*
* @param {number} idx - The requested character index.
* @return {string} The requested characters character_name.
--]]
accountlib.get_login_character_name = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return nil;
    end
    return ffi.string(cinfo[idx].character_name, 16):split('\0'):first();
end

--[[
* Returns the requested characters world_name.
*
* @param {number} idx - The requested character index.
* @return {string} The requested characters world_name.
--]]
accountlib.get_login_world_name = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return nil;
    end
    return ffi.string(cinfo[idx].world_name, 16):split('\0'):first();
end

--[[
* Returns the requested characters extended info.
*
* @param {number} idx - The requested character index.
* @return {number} The requested characters extended info.
--]]
accountlib.get_login_character_info = function (idx)
    local cinfo = ffi.cast('lpkt_chr_info_sub2*', get_base_address());
    if (cinfo == nil) then
        return 0;
    end
    return cinfo[idx].character_info;
end

return accountlib;