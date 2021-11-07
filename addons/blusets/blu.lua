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
local chat = require('chat');
local ffi = require('ffi');

-- FFI Prototypes
ffi.cdef[[
    /**
     * Extended equip packet sender. Used for BLU spells, PUP attachments, etc.
     *
     * @param {uint8_t} isSubJob - Flag if the used job is currently subbed or not. (ie. If using BLU, is BLU subbed?)
     * @param {uint16_t} jobType - Flag used for the job packet type. (BLU = 0x1000, PUP = 0x1200)
     * @param {uint16_t} index - The index of the slot being manipulated. (ie. The BLU spell slot.)
     * @param {uint8_t} id - The id of the spell, attachment, etc. being set. (BLU spells are id - 512.)
     * @return {uint8_t} 1 on success, 0 otherwise.
     * @note
     *  This calls the in-game function that is used to send the 0x102 packets.
     */
    typedef uint8_t (__cdecl *equipex_t)(uint8_t isSubJob, uint16_t jobType, uint16_t index, uint8_t id);

    // Packet: 0x0102 - Extended Equip (Client To Server)
    typedef struct packet_equipex_c2s_t {
        uint16_t    IdSize;             /* Packet id and size. */
        uint16_t    Sync;               /* Packet sync count. */
        uint8_t     SpellId;            /* If setting a spell, this is set to the spell id being placed in a 'Spells' entry. If unsetting, it is set to 0. */
        uint8_t     Unknown0000;        /* Forced to 0 by the client. */
        uint16_t    Unknown0001;        /* Unused. */
    
        /**
         * The following data is job specific, this is how it is defined for BLU.
         */
    
        uint8_t     JobId;              /* Set to 0x10, BLU's job id. */
        uint8_t     IsSubJob;           /* Flag set if BLU is currently the players sub job. */
        uint16_t    Unknown0002;        /* Unused. (Padding) */
        uint8_t     Spells[20];         /* Array of the BLU spell slots. */
        uint8_t     Unknown0003[132];   /* Unused. */
    } packet_equipex_c2s_t;
]];

-- Blue Mage Helper Library
local blu = T{
    offset  = ffi.cast('uint32_t*', ashita.memory.find('FFXiMain.dll', 0, 'C1E1032BC8B0018D????????????B9????????F3A55F5E5B', 10, 0)),
    points  = ffi.cast('uint8_t***', ashita.memory.find('FFXiMain.dll', 0, 'A1????????33C98A4E5E33D28A565D5F5E8950148948185B83C414C20400', 1, 0)),
    equipex = ffi.cast('equipex_t', ashita.memory.find('FFXiMain.dll', 0, '8B0D????????81EC9C00000085C95356570F??????????8B', 0, 0)),

    --[[
    Packet Sender Mode

    Sets the mode that will be used when queueing and sending packets by blusets.

        safe - Uses the games actual functions to rate limit and send the packet properly.
        fast - Uses custom injected packets with custom rate limiting to bypass the internal client buffer limit.
    --]]
    mode = 'safe',

    -- The delay between packet sends when loading a spell set. (If safe mode is on, 1.0 is forced.)
    delay = 0.65,
};

--[[
* Returns if the players main job is BLU.
*
* @return {boolean} True if BLU main, false otherwise.
--]]
function blu.is_blu_main()
    return AshitaCore:GetMemoryManager():GetPlayer():GetMainJob() == 16;
end

--[[
* Returns if the players sub job is BLU.
*
* @return {boolean} True if BLU sub, false otherwise.
--]]
function blu.is_blu_sub()
    return AshitaCore:GetMemoryManager():GetPlayer():GetSubJob() == 16;
end

--[[
* Returns the number of available BLU points.
*
* @return {number} The number of available BLU points.
--]]
function blu.get_available_points()
    local max = blu.points[0][0][0x18];
    if (max > 0) then
        return max - blu.points[0][0][0x14];
    end
    return 0;
end

--[[
* Returns the total number of spent BLU points.
*
* @return {number} The number of spent BLU points.
--]]
function blu.get_spent_points()
    return blu.points[0][0][0x14];
end

--[[
* Returns the total number of available BLU points.
*
* @return {number} The number of available BLU points.
--]]
function blu.get_max_points()
    return blu.points[0][0][0x18];
end

--[[
* Returns the raw buffer used in BLU spell packets.
*
* @return {number} The current BLU raw buffer pointer.
* @note
*   On private servers, there is a rare chance this buffer is not properly updated immediately until you open an
*   equipment menu or open the BLU set spells window. Because of this, you may send a bad job id for the packets
*   that rely on this buffers data if used directly.
--]]
function blu.get_blu_buffer_ptr()
    local ptr = ashita.memory.read_uint32(AshitaCore:GetPointerManager():Get('inventory'));
    if (ptr == 0) then
        return 0;
    end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then
        return 0;
    end
    return ptr + blu.offset[0] + (blu.is_blu_main() and 0x00 or 0x9C);
end

--[[
* Returns the table of current set BLU spells.
*
* @return {table} The current set BLU spells.
--]]
function blu.get_spells()
    local ptr = ashita.memory.read_uint32(AshitaCore:GetPointerManager():Get('inventory'));
    if (ptr == 0) then
        return T{ };
    end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then
        return T{ };
    end
    return T(ashita.memory.read_array((ptr + blu.offset[0]) + (blu.is_blu_main() and 0x04 or 0xA0), 0x14));
end

--[[
* Returns the table of current set BLU spells names.
*
* @return {table} The current set BLU spells names.
--]]
function blu.get_spells_names()
    return blu.get_spells():map(function (v)
        if (v == 0) then return ''; end
        local spell = AshitaCore:GetResourceManager():GetSpellById(v + 512);
        if (spell ~= nil) then
            return spell.Name[1];
        end
        return '';
    end);
end

--[[
* Resets all of the players current set BLU spells. (safe)
*
* Uses the in-game packet queue to properly queue a reset packet.
--]]
local function safe_reset_all_spells()
    AshitaCore:GetPacketManager():QueuePacket(0x102, 0xA4, 0x00, 0x00, 0x00, function (ptr)
        local p = ffi.cast('uint8_t*', ptr);
        ffi.fill(p + 0x04, 0xA0);
        ffi.copy(p + 0x08, ffi.cast('uint8_t*', blu.get_blu_buffer_ptr()), 0x9C);
    end);
end

--[[
* Resets all of the players current set BLU spells. (fast)
*
* Uses custom packet injection to queue a reset packet as soon as possible.
--]]
local function unsafe_reset_all_spells()
    -- Prepare the initial packet data..
    local eqex = ffi.new('packet_equipex_c2s_t', {
        0x5302, 0x0000,
        0,
        0, 0,
        0x10, blu.is_blu_sub() == true and 1 or 0,
        0
    });

    -- Populate the spell slots..
    local spells = blu.get_spells();
    for x = 1, #spells do
        eqex.Spells[x - 1] = spells[x]
    end

    -- Convert and send the packet..
    local packet = ffi.string(eqex, ffi.sizeof('packet_equipex_c2s_t')):totable();
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x102, packet);
end

--[[
* Sets a BLU spell for the give slot index. (safe)
*
* @param {number} index - The slot index to set. (1 to 10)
* @param {number} id - The spell id to set. (0 if unsetting.)
*
* Uses actual client function used to set BLU spells to safely and properly queue the packet.
--]]
local function safe_set_spell(index, id)
    blu.equipex(blu.is_blu_main() == true and 0 or 1, 0x1000, index - 1, id);
end

--[[
* Sets a BLU spell for the give slot index. (unsafe)
*
* @param {number} index - The slot index to set.
* @param {number} id - The spell id to set. (0 if unsetting.)
*
* Uses custom packet injection to queue the set spell packet as soon as possible.
--]]
local function unsafe_set_spell(index, id)
    -- Prepare the initial packet data..
    local eqex = ffi.new('packet_equipex_c2s_t', {
        0x5302, 0x0000,
        0,
        0, 0,
        0x10, blu.is_blu_sub() == true and 1 or 0,
        0
    });

    -- Handle the spell information accordingly..
    if (id == 0) then
        -- Unsetting..
        eqex.SpellId = 0;
        eqex.Spells[index - 1] = blu.get_spells()[index];
    else
        -- Setting..
        eqex.SpellId = id;
        eqex.Spells[index - 1] = id;
    end

    -- Convert and send the packet..
    local packet = ffi.string(eqex, ffi.sizeof('packet_equipex_c2s_t')):totable();
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x102, packet);
end

--[[
* Queues the packet required to unset all BLU spells.
--]]
function blu.reset_all_spells()
    if (blu.mode == 'fast') then
        unsafe_reset_all_spells();
        return;
    end
    safe_reset_all_spells();
end

--[[
* Queues the packet required to set a BLU spell. (Or unset.)
*
* @param {number} index - The slot index to set.
* @param {number} id - The spell id to set. (0 if unsetting.)
--]]
function blu.set_spell(index, id)
    if (index <= 0 or index > 20) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; invalid index given. (Params - Index: %d, Id: %d)')):fmt(index, id));
        return;
    end

    -- Check if the spell is set elsewhere already..
    local spells = blu.get_spells();
    if (id ~= 0 and spells:hasval(id)) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; spell is already assigned. (Params - Index: %d, Id: %d)')):fmt(index, id));
        return;
    end

    -- Check if the spell is being unset and has a spell in the desired slot..
    local spell = spells[index];
    if (id == 0 and (spell == nil or spell == 0)) then
        return;
    end

    -- Set the spell..
    if (blu.mode == 'fast') then
        unsafe_set_spell(index, id);
        return;
    end
    safe_set_spell(index, id);
end

--[[
* Sets the given slot index to the spell matching the given name. If no name is given, the slot is unset.
*
* @param {number} index - The slot index to set the spell into.
* @param {string|nil} name - The name of the spell to set. (nil if unsetting spell.)
--]]
function blu.set_spell_by_name(index, name)
    -- Unset the spell if no name is given..
    if (name == nil or name == '') then
        blu.set_spell(index, 0);
        return;
    end

    -- Obtain the spell resource info..
    local spell = AshitaCore:GetResourceManager():GetSpellByName(name, 0);
    if (spell == nil) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; invalid spell name given. (Params - Index: %d, Name: %s)')):fmt(index, name));
        return;
    end

    -- Ensure the spell is a BLU magic spell..
    if (spell.Index < 512 or spell.Index > 1024) then
        print(chat.header(addon.name):append(chat.error('Failed to set spell; invalid spell given. (Not Blue Magic) (Params - Index: %d, Name: %s)')):fmt(index, name));
        return;
    end

    -- Set the spell..
    blu.set_spell(index, spell.Index - 512);
end

-- Return the library table..
return blu;