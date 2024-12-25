--[[
* Addons - Copyright (c) 2024 Ashita Development Team
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
    typedef struct {
        uint32_t    State;
        float       x;
        float       y;
        float       z;
        uint32_t    ActIndex    : 16;
        uint32_t    Level       : 8;
        uint32_t    unused00    : 8;
    } GC_TRACKING_NOW;

    typedef struct {
        uint32_t    GuideNo;
        uint32_t    UniqueNo;
    } CHAR_ID;

    typedef struct {
        uint8_t     padding00[116];
        CHAR_ID     id;
    } XiAtelBuff;

    typedef XiAtelBuff*         (__stdcall* SeekBattleActor_f)(void);
    typedef const char*         (__cdecl* GetMonsterName_f)(uint16_t);
    typedef const char*         (__stdcall* ntSysGetLastTeller_f)(void);
    typedef GC_TRACKING_NOW*    (__stdcall* gcTrackingPosGet_f)(void);
]];

local targetslib = T{
    ptrs = T{
        bt          = ashita.memory.find('FFXiMain.dll', 0, '66A1????????83EC186685C053565774??0FBFC08B0C85', 0, 0),-- SeekBattleActor
        mon_name    = ashita.memory.find('FFXiMain.dll', 0, '53568B35????????33C085F6577E??8B', 0, 0),              -- GetMonsterName
        r           = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????85C9750333C0C36A00', 0, 0),                -- ntSysGetLastTeller
        scan        = ashita.memory.find('FFXiMain.dll', 0, 'A1????????85C074??F7', 0, 0),                          -- gcTrackingPosGet
    },
    type = T{
        bt      = 0x00, -- Battle Target [Tag: <bt>]
        focust  = 0x01, -- Focus Target [Tag: <focust>]
        ft      = 0x02, -- Adventuring Fellow [Tag: <ft>]
        ht      = 0x03, -- Closest Help Target [Tag: <ht>]
        lastst  = 0x04, -- Last Selected Target [Tag: <lastst>]
        me      = 0x05, -- Self [Tag: <me>]
        pet     = 0x06, -- Pet [Tag: <pet>]
        r       = 0x07, -- Last Teller [Tag: <r>]
        scan    = 0x08, -- Wide Scan Tracked [Tag: <scan>]
        st      = 0x09, -- Sub-Target [Tag: N/A]
        t       = 0x0A, -- Target [Tag: <t>]
        p0      = 0x14, -- Party Member 1 [Tag: <p0>]
        p1      = 0x15, -- Party Member 2 [Tag: <p1>]
        p2      = 0x16, -- Party Member 3 [Tag: <p2>]
        p3      = 0x17, -- Party Member 4 [Tag: <p3>]
        p4      = 0x18, -- Party Member 5 [Tag: <p4>]
        p5      = 0x19, -- Party Member 6 [Tag: <p5>]
        a10     = 0x1A, -- Alliance 1 Member 1 [Tag: <a10>]
        a11     = 0x1B, -- Alliance 1 Member 2 [Tag: <a11>]
        a12     = 0x1C, -- Alliance 1 Member 3 [Tag: <a12>]
        a13     = 0x1D, -- Alliance 1 Member 4 [Tag: <a13>]
        a14     = 0x1E, -- Alliance 1 Member 5 [Tag: <a14>]
        a15     = 0x1F, -- Alliance 1 Member 6 [Tag: <a15>]
        a20     = 0x20, -- Alliance 2 Member 1 [Tag: <a20>]
        a21     = 0x21, -- Alliance 2 Member 2 [Tag: <a21>]
        a22     = 0x22, -- Alliance 2 Member 3 [Tag: <a22>]
        a23     = 0x23, -- Alliance 2 Member 4 [Tag: <a23>]
        a24     = 0x24, -- Alliance 2 Member 5 [Tag: <a24>]
        a25     = 0x25, -- Alliance 2 Member 6 [Tag: <a25>]
    },
};

if (not targetslib.ptrs:all(function (v) return v ~= nil and v ~= 0; end)) then
    error(chat.header(addon.name):append(chat.error('[lib.target] Error: Failed to locate required pointer(s).')));
    return;
end

--[[
* Returns the current battle target entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_bt = function ()
    local ent = ffi.cast('SeekBattleActor_f', targetslib.ptrs.bt)();
    if (ent == nil) then
        return nil;
    end
    return GetEntity(ent.id.GuideNo);
end

--[[
* Returns the current focus target entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_focust = function ()
    return GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetFocusTargetIndex());
end

--[[
* Returns the players fellow target entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_ft = function ()
    return GetEntity(GetPlayerEntity().FellowTargetIndex);
end

--[[
* Returns the closest entity who is called for help on.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_ht = function ()
    local player = GetPlayerEntity();
    if (player == nil) then
        return nil;
    end

    local dst = 0.0;
    local ent = nil;

    table.range(0, 2302)
        :map(GetEntity)
        :filter(function (e)
            if (e.ActorPointer == nil) then
                return false;
            end
            if (bit.band(e.Render.Flags0, 0x2000) == 0 or bit.band(e.Render.Flags1, 0x1000000) == 0) then
                return false;
            end
            if (e.Status == 2 or e.Status == 3) then
                return false;
            end
            return true;
        end)
        :each(function (e)
            local x = (player.Movement.LocalPosition.X - e.Movement.LocalPosition.X);
            local y = (player.Movement.LocalPosition.Z - e.Movement.LocalPosition.Z) * -1.0;
            local d = math.sqrt(y * y + x * x);
            if (dst == 0.0 or d < dst) then
                dst = d;
                ent = e;
            end
        end);

    return ent;
end

--[[
* Returns the entity of the last selected target.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_lastst = function ()
    return GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetLastTargetIndex());
end

--[[
* Returns the players entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_me = function ()
    return GetPlayerEntity();
end

--[[
* Returns the players pet entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_pet = function ()
    local player = GetPlayerEntity();
    if (player == nil) then
        return nil;
    end
    return GetEntity(player.PetTargetIndex);
end

--[[
* Returns the entity of the last person to whisper the client.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_r = function ()
    local name = ffi.cast('ntSysGetLastTeller_f', targetslib.ptrs.r)();
    if (name == nil) then
        return nil;
    end

    name = ffi.string(name);

    return table.range(0, 2302)
        :map(GetEntity)
        :filter(function (e) return e.Name == name; end)
        :flatten()
        :first();
end

--[[
* Returns the name of the last person to whisper the client.
*
* @return {string|nil} The entity name on success, nil otherwise.
--]]
targetslib.get_last_teller_name = function ()
    local name = ffi.cast('ntSysGetLastTeller_f', targetslib.ptrs.r)();
    if (name == nil) then
        return nil;
    end

    return ffi.string(name);
end

--[[
* Returns the current widescan tracked entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_scan = function ()
    local track = ffi.cast('gcTrackingPosGet_f', targetslib.ptrs.scan)();
    if (track == nil) then
        return nil;
    end
    if (track.State ~= 1) then
        return nil;
    end
    return GetEntity(track.ActIndex);
end

--[[
* Returns the current widescan tracked entity name.
*
* @return {string|nil} The entity name on success, nil otherwise.
--]]
targetslib.get_scan_name = function ()
    local track = ffi.cast('gcTrackingPosGet_f', targetslib.ptrs.scan)();
    if (track == nil) then
        return nil;
    end
    if (track.State ~= 1) then
        return nil;
    end

    local name = ffi.cast('GetMonsterName_f', targetslib.ptrs.mon_name)(track.ActIndex);
    if (name == nil) then
        return nil;
    end

    return ffi.string(name);
end

--[[
* Returns the current sub-targeted entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_st = function ()
    local target = AshitaCore:GetMemoryManager():GetTarget();
    if (target:GetIsSubTargetActive() == 0) then
        return nil;
    end
    return GetEntity(target:GetTargetIndex(0));
end

--[[
* Returns the current targeted entity.
*
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_t = function ()
    local target = AshitaCore:GetMemoryManager():GetTarget();
    if (target:GetIsSubTargetActive() == 0) then
        return GetEntity(target:GetTargetIndex(0));
    end
    return GetEntity(target:GetTargetIndex(1));
end

--[[
* Returns the entity of the given party member, by their index.
*
* @param {number} index - The party member index.
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get_party_member = function (index)
    if (index >= 18) then
        error('invalid party member index; expected 0 to 5');
    end
    return GetEntity(AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(index));
end

--[[
* Returns the desired entity of the given target type.
*
* @param {number} ttype - The target type.
* @return {userdata|nil} The entity on success, nil otherwise.
--]]
targetslib.get = function (ttype)
    return switch(ttype, T{
        [targetslib.type.bt]     = function () return targetslib.get_bt(); end,
        [targetslib.type.focust] = function () return targetslib.get_focust(); end,
        [targetslib.type.ft]     = function () return targetslib.get_ft(); end,
        [targetslib.type.ht]     = function () return targetslib.get_ht(); end,
        [targetslib.type.lastst] = function () return targetslib.get_lastst(); end,
        [targetslib.type.me]     = function () return targetslib.get_me(); end,
        [targetslib.type.pet]    = function () return targetslib.get_pet(); end,
        [targetslib.type.r]      = function () return targetslib.get_r(); end,
        [targetslib.type.scan]   = function () return targetslib.get_scan(); end,
        [targetslib.type.st]     = function () return targetslib.get_st(); end,
        [targetslib.type.t]      = function () return targetslib.get_t(); end,
        [table.range(targetslib.type.p0, targetslib.type.a25)] = function ()
            return targetslib.get_party_member(ttype - targetslib.type.p0);
        end,
        [switch.default] = function () return nil; end
    });
end

return targetslib;