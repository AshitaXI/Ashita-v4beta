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

require('common');
require('win32types');

local chat      = require 'chat';
local ffi       = require 'ffi';
local breader   = require 'bitreader';
local time      = require 'ffxi.time';

ffi.cdef[[
    typedef struct {
        uint8_t     data[12];
        uint16_t    itemno;
        uint16_t    damage;
        uint16_t    attack_delay;
        uint16_t    shield_size;
    } augmentdata_t;

    typedef struct {
        int32_t     index;
        int32_t     value;
    } augment_t;

    typedef struct {
        augment_t   augments[50];
    } augments_t;

    typedef uint32_t(__cdecl* parse_augments_f)(augmentdata_t*, augments_t*);
    typedef int32_t (__cdecl* parse_synthesis_rate_f)(augmentdata_t*);
]];

local itemdata = T{
    -- Configuration settings used for the library..
    config = T{
        use_raw = false,
    },

    -- Pointers used for this library..
    ptrs = T{
        parse_augments = 0,
        parse_synthesis_rate = 0,
    },

    -- Base time offset..
    time_offset = 1009810800,

    -- Lookup tables for use with augment handling..
    fa = T{
    },
    nfa = T{
        index = T{
            0x0000, 0x03FF, 0x0009, 0x0009, 0x000A, 0x000A, 0x07FE, 0x07FE, 0x0013, 0x0013, 0x0015, 0x0015, 0x0012, 0x0012, 0x0014, 0x0014,
            0x0017, 0x0017, 0x0016, 0x0016, 0x0085, 0x0085, 0x0086, 0x0086, 0x0018, 0x0018, 0x0019, 0x0019, 0x001E, 0x001E, 0x07FE, 0x07FE,
            0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE,
            0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE,
            0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE,
            0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE,
            0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE,
            0x07FE, 0x07FE, 0x0147, 0x016A, 0x0171, 0x0141, 0x0140, 0x0020, 0x001D, 0x101D, 0x001A, 0x0143, 0x0149, 0x008A, 0x0024, 0x0164,
            0x8085, 0x8018, 0x8013, 0x8012, 0x801D, 0x801D, 0x8009, 0x800A, 0x8801, 0x8802, 0x8804, 0x8808, 0x8810, 0x8820, 0x8840, 0x8000,
            0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x8000, 0x808F, 0x9029, 0x8089, 0x8020, 0x4149, 0x408C, 0x07FE, 0x07FE,
            0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x07FE, 0x0092, 0x1029, 0x0033, 0x07FE, 0x07FE,
            0x07FE, 0x008D, 0x0091, 0x0090, 0x008C, 0x00E9, 0x00C3, 0x008B, 0x00D4, 0x008E, 0x008F, 0x00D3, 0x1025, 0x1026, 0x1027, 0x0801,
            0x0802, 0x0804, 0x0808, 0x0810, 0x0820, 0x0840, 0x0800, 0x0800, 0x0800, 0x0800, 0x0800, 0x0800, 0x0800, 0x0800, 0x087F, 0x0800,
            0x0100, 0x0101, 0x0102, 0x0103, 0x0104, 0x0105, 0x0106, 0x0107, 0x0108, 0x0109, 0x010A, 0x010B, 0x010C, 0x010D, 0x010E, 0x010F,
            0x0110, 0x0111, 0x0112, 0x0113, 0x0114, 0x0115, 0x0116, 0x0117, 0x0118, 0x0119, 0x011A, 0x011B, 0x011C, 0x011D, 0x011E, 0x011F,
            0x0120, 0x0121, 0x0122, 0x0123, 0x0124, 0x0125, 0x0126, 0x0127, 0x0128, 0x0129, 0x012A, 0x012B, 0x012C, 0x012D, 0x012E, 0x07FE,
        },
        rp = T{
            0x001E, 0x0032, 0x0050, 0x0078, 0x00AA, 0x00DC, 0x0118, 0x0154, 0x019A, 0x01E0, 0x0230, 0x028A, 0x02EE, 0x035C, 0x03D4, 0x0456,
            0x04E2, 0x0582, 0x062C, 0x06E0, 0x07A8, 0x087A, 0x0960, 0x0A5A, 0x0B5E, 0x0C6C, 0x0D84, 0x0EB0, 0x0FE6, 0x1130, 0x128E, 0xFFFF,
        },
    },
};

itemdata.ptrs.parse_augments        = ashita.memory.find('FFXiMain.dll', 0, '8B54240481EC????????B95A00000033', 0, 0);
itemdata.ptrs.parse_synthesis_rate  = ashita.memory.find('FFXiMain.dll', 0, '8B5424048B42088BC883E10F4983F903', 0, 0);

if (not itemdata.ptrs:all(function (v) return v ~= nil; end)) then
    error(chat.header(addon.name):append(chat.error('Error: Failed to locate required pointers for itemdata library.')));
    return;
end

--[[
* Parses an items extra data for recast/timestamp information.
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @param {boolean} is_equipped - Flag that states if the item is equipped or not.
* @return {table} The table of timer related information.
--]]
itemdata.parse_timer_info = function (item, ritem, is_equipped)
    local reader = breader:new(T{}, item.Extra);

    if (not T{4, 5}:contains(ritem.Type) or reader:read(8) ~= 1) then
        return T{};
    end

    if (ritem.MaxCharges == 0 or ritem.RecastDelay == 0 or ritem.CastDelay == 0) then
        return T{};
    end

    local data = T{ raw = T{}, };

    data.max_charges        = ritem.MaxCharges;
    data.cast_time          = ritem.CastTime;
    data.cast_delay         = ritem.CastDelay;
    data.recast_delay       = ritem.RecastDelay;
    data.remaining_charges  = reader:read(8);
    data.flags              = reader:read(16);
    local time_value1       = reader:read(32);
    local time_value2       = reader:read(32);

    local timeval1 = time.game_time_diff(time_value1);
    local timeval2 = time.game_time_diff(time_value2);

    if (not is_equipped) then
        timeval2 = data.cast_delay;
    end

    if (timeval1 < timeval2) then
        timeval1 = timeval2;
    end

    if (data.max_charges == 255) then
        data.remaining_charges = 255;
    else
        if (data.remaining_charges == 0) then
            timeval1 = 0;
        end
    end

    data.use_delay = timeval1;

    if (itemdata.config.use_raw) then
        data.raw.time_value1 = time_value1;
        data.raw.time_value2 = time_value2;
    end

    return data;
end

--[[
* Parses an items extra data for augment information using the built-in game function.
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The table of augment information parsed from the item.
--]]
itemdata.parse_augments = function (item, ritem)
    local func = ffi.cast('parse_augments_f', itemdata.ptrs.parse_augments);
    local data = ffi.new('augmentdata_t', {});
    local augs = ffi.new('augments_t', {});

    ffi.copy(data.data, item.Extra, 12);

    data.itemno         = item.Id;
    data.damage         = ritem.Type == 0x04 and ritem.Damage or 0;
    data.attack_delay   = ritem.Type == 0x04 and ritem.Delay or 0;
    data.shield_size    = ritem.Type == 0x05 and ritem.ShieldSize or 0;

    local ret = func(data, augs);
    local augments = T{};

    for x = 0, ret - 1 do
        augments[x + 1] = T{ index = augs.augments[x].index, value = augs.augments[x].value };
    end

    return augments;
end

--[[
* Parses a crafting shields synthesis success rate using the built-in game function.
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {number} The synthesis success rate.
* @note
*       Due to limitations with Lua's number system, it is not possible to accurately calculate this value
*       manually within raw Lua. There is a chance of bit loss due to the max number limit in Lua. Instead,
*       this wrapper will call the game function used to handle this calculation for us.
--]]
itemdata.parse_shield_synthesis_rate = function (item, ritem)
    local func = ffi.cast('parse_synthesis_rate_f', itemdata.ptrs.parse_synthesis_rate);
    local data = ffi.new('augmentdata_t', {});

    ffi.copy(data.data, item.Extra, 12);

    data.itemno         = item.Id;
    data.damage         = ritem.Type == 0x04 and ritem.Damage or 0;
    data.attack_delay   = ritem.Type == 0x04 and ritem.Delay or 0;
    data.shield_size    = ritem.Type == 0x05 and ritem.ShieldSize or 0;

    return func(data);
end

--[[
* Returns the name of a linkshell parsed from the given packed data.
*
* @param {string} data - The data holding the name to be parsed.
* @param {number|nil} offset - The offset to begin parsing the name at. (optional)
* @return {string} The name of the linkshell.
--]]
itemdata.parse_linkshell_name = function (data, offset)
    if (data == nil or type(data) ~= 'string') then
        return '';
    end

    offset = offset + 1 or 1;

    return data:slice(offset):split(''):map(string.zerofill-{8} .. math.binary .. string.byte)
        :flatten():concat():chunks(6)
        :map(rawget+{('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'):split('')} .. tonumber-{2})
        :flatten():concat():trim('\0');
end

--[[
* Returns the name of a signature parsed from the given packed data.
*
* @param {string} data - The data holding the name to be parsed.
* @param {number|nil} offset - The offset to begin parsing the name at. (optional)
* @return {string} The name of the signature.
--]]
itemdata.parse_signature = function (data, offset)
    if (data == nil or type(data) ~= 'string') then
        return '';
    end

    offset = offset + 1 or 1;

    return data:slice(offset):split(''):map(string.zerofill-{8} .. math.binary .. string.byte)
        :flatten():concat():chunks(6)
        :map(rawget+{('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz{'):split('')} .. tonumber-{2})
        :flatten():concat():trim('\0');
end

--[[
* Returns the name of a signature parsed from the given packed data.
*
* @param {string} data - The data holding the name to be parsed.
* @param {number|nil} offset - The offset to begin parsing the name at. (optional)
* @return {string} The name of the signature.
--]]
itemdata.parse_signature_soul_plate = function (data, offset)
    if (data == nil or type(data) ~= 'string') then
        return '';
    end

    offset = offset + 1 or 1;

    local function convert_char(v)
        return (v ~= 0 and v < 32) and 32 or v;
    end

    return data:slice(offset):split(''):map(string.zerofill-{8} .. math.binary .. string.byte)
        :flatten():concat():chunks(7)
        :map(string.char .. convert_char .. tonumber-{2})
        :flatten():concat():trim('\0');
end

--[[
* Parses the extra data of an item. [Kind: 0x03 - Fish]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_fish = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind = ritem.Type,
    };

    data.size       = reader:read(16);
    data.weight     = reader:read(16);
    data.is_ranked  = reader:read(1) >= 1 and true or false;

    return data;
end

--[[
* Parses the raw augment information on certain kinds of items.
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
* @note
*
*   This library will not make use of this function by default. It must be manually enabled when
*   the library is included. Otherwise, it is just wasted processing power that does not need to
*   happen. If you wish to enable raw value information, you can do the following when including
*   this library:
*
*   local itemdata = require 'ffxi.itemdata';
*   itemdata.config.use_raw = true;
*
--]]
itemdata.parse_raw_augments = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind    = ritem.Type,
        raw     = T{},
    };

    --[[
    Note:   This function is entirely optional and not needed. It is simply here to demonstrate how the 'parse_augments'
            function works by reimplementing it in Lua. This shows how the various augment information is packed and read
            then recalculated to its proper augment values.

            The information returned by this function should match that of the 'parse_augments' function call.

            There are some conditions this setup makes use of that are technically not possible, but need to be checked
            for proper handling of augments and to align to how the retail client functions.

            01 01 - Usable items with timers. [Not handled by this function!]
            02 03 - Ambuscade Capes, Incursion, Reisenjima, Sinister Reign, Skirmish, Sortie, Some specific items like Moonshade Earrings
            02 23 - Delve, Escha, JSE Weapons
            02 43 - Dynamis-Divergence, Trial of the Magians
            03 83 - Odyssey, Dynamis-Divergence JSE Necklaces, Unity (Belts)
            02 10 - Fishing Rods (Lu Shangs +1 / Ebisu +1)
    --]]

    --[[
    Warn:   This method is designed in a special manner to function exactly like the client does. Please do not
            reorder the manner in which things are checked or parsed! This can cause bugs and improper parsing!
    --]]

    -- Handle general and usable items.. (This is used for Evoliths.)
    if (item.Id < 10240) then
        data.raw.augment = reader:read(10);
        data.raw.shape   = reader:read(4);
        data.raw.element = reader:read(3);
        data.raw.bonus   = reader:read(4);

        return data;
    end

    data.augment_kind       = reader:read(8);
    data.augment_subkind    = reader:read(8);

    -- Check for fixed-stat augment systems..
    if (data.augment_kind ~= 2) then

        -- Handle fixed-stat augments..
        if (data.augment_kind == 3 and bit.band(data.augment_subkind, 0x80) ~= 0) then

            --[[
            TODO: Handle fixed-stat augments..
            --]]

            return data;
        end

        -- Unexpected augment system..
        return data;
    end

    -- Note: This check is adjusted to work with Lua's number limitations..
    if (data.augment_subkind >= 0 and bit.band(data.augment_subkind, 0x80) == 0) then

        -- Handle fishing rods..
        if (bit.band(data.augment_subkind, 0x10) ~= 0) then
            _                   = reader:read(16);
            data.server_index   = reader:read(8);
            _                   = reader:read(8);
            data.rod_id         = reader:read(16);
            data.signature      = itemdata.parse_signature(item.Extra, 12);

            return data;
        end

        -- Handle non-fixed-stat augments..
        if (bit.band(data.augment_subkind, 0x20) ~= 0) then
            data.raw = T{
                augments    = T{},
                processed   = T{},
            };

            data.type       = reader:read(2);
            data.rank       = reader:read(5);
            _               = reader:read(9);
            data.raw.rp     = reader:read(16);
            data.rp_display = (itemdata.nfa.rp[data.rank + 1] - data.raw.rp):clamp(0, 65535);
            data.rp_rank    = itemdata.nfa.rp[data.rank + 1];

            for x = 0, 2 do
                data.raw.augments[x + 1] = T{ index = reader:read(8), value = reader:read(8) + 1, };
            end

            for x = 0, 2 do
                local augment   = data.raw.augments[x + 1];
                local value     = augment.value;
                local aindex    = itemdata.nfa.index[augment.index + 1];
                local is_base   = bit.band(aindex, 0x0800) ~= 0;
                local index     = bit.band(aindex, is_base and 0x7F or 0x7FF);
                local is_neg    = bit.band(aindex, 0x1000) ~= 0;
                local target    = bit.band(bit.rshift(aindex, 0x0E), 0xFF);

                if (aindex > 0) then
                    if (augment.index >= 2 and augment.index <= 95 and bit.band(augment.index, 1) ~= 0) then
                        value = value + 256;
                    end

                    if (is_neg) then
                        value = -value;
                    end

                    if (target == 1) then
                        data.raw.processed:append(T{ index = 2045, value = 0, });
                    elseif (target == 2) then
                        data.raw.processed:append(T{ index = 128, value = 0, });
                    end

                    if (is_base) then
                        for y = 0, 6 do
                            if (bit.band(index, bit.lshift(1, y)) ~= 0) then
                                data.raw.processed:append(T{ index = y + 11, value = value, });
                            end
                        end
                    else
                        data.raw.processed:append(T{ index = index, value = value, });
                    end
                end
            end

            data.signature = itemdata.parse_signature(item.Extra, 12);

            return data;
        end

        -- Handle crafting shields..
        if (bit.band(data.augment_subkind, 0x08) ~= 0) then
            data.raw = T{};

            _                           = reader:read(16);
            data.raw.status             = reader:read(8);
            data.raw.requirement        = reader:read(8);
            data.raw.craftmanship       = reader:read(16);
            data.raw.craftmanship_kind  = reader:read(4);
            data.raw.synthesis_rate     = reader:read(16);
            data.signature              = itemdata.parse_signature(item.Extra, 12);

            if (data.raw.status == 0 or data.raw.craftmanship_kind == 0) then
                return data;
            end

            local rate = itemdata.parse_shield_synthesis_rate(item, ritem);
            if (rate > 0) then
                data.synthesis_rate = -rate;
            else
                data.synthesis_rate = 0;
            end

            if (data.raw.requirement > 0) then
                data.requirement = data.raw.requirement + 1949;
            else
                data.requirement = 0;
            end

            local divisor = switch(data.raw.craftmanship_kind, T{
                [1] = function () return 3000; end,
                [2] = function () return 5000; end,
                [3] = function () return 10000; end,
                [4] = function () return 30000; end,
                [switch.default] = function () return 9999; end,
            });

            local val = 10000 * data.raw.craftmanship / divisor;
            if (val > 10000) then
                val = 10000;
            end
            if (val > 0) then
                val = val / 100;
            end

            data.craftmanship       = val;
            data.craftmanship_kind  = data.raw.craftmanship_kind;

            return data;
        end

        -- Handle standard augments and trial based augments..

        --[[
        Note:   This section is used to handle default augments and items that are trial based. The client
                parses these together, determining the number of augments the item may have based on if the
                item is part of a trial.
        --]]

        data.raw = T{ augments = T{}, };
        data.raw.is_trial = bit.band(data.augment_subkind, 0x40) ~= 0;

        for x = 0, (data.raw.is_trial and 3 or 4) do
            data.raw.augments[x + 1] = T{ index = reader:read(11), value = reader:read(5), };
        end

        if (data.raw.is_trial) then
            local val = reader:read(16);

            data.raw.trial              = bit.band(val, 0x7FFF);
            data.raw.is_trial_completed = bit.band(val, 0x0800) ~= 0;
        end

        data.signature = itemdata.parse_signature(item.Extra, 12);

        return data;
    else
        -- Handle Evolith equipment augments..
        data.raw = T{
            augments    = T{},
            shape       = T{},
            bonus       = T{},
            element     = T{},
        };

        for x = 0, 2 do
            data.raw.augments[x + 1] = T{ index = reader:read(11), value = reader:read(4), bit = reader:read(1), };
        end

        data.raw.shape  = T{ [1] = reader:read(4),      [2] = reader:read(4),       [3] = reader:read(4), };
        data.raw.bonus  = T{ [1] = reader:read(4) + 1,  [2] = reader:read(4) + 1,   [3] = reader:read(4) + 1, };
        data.raw.element= T{ [1] = reader:read(3),      [2] = reader:read(3),       [3] = reader:read(2), };

        if (data.raw.augments[3].bit == 1) then
            data.raw.element[3] = data.raw.element[3] + 4;
        end

        data.signature = itemdata.parse_signature(item.Extra, 12);

        return data;
    end

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x04 - Weapon]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @param {boolean} is_equipped - Flag that states if the item is equipped or not.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_weapon = function (item, ritem, is_equipped)
    local data = T{
        kind        = ritem.Type,
        augments    = itemdata.parse_augments(item, ritem),
    };

    if (itemdata.config.use_raw) then
        data:merge(itemdata.parse_raw_augments(item, ritem));
    end

    return data:merge(itemdata.parse_timer_info(item, ritem, is_equipped));
end

--[[
* Parses the extra data of an item. [Kind: 0x05 - Armor]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @param {boolean} is_equipped - Flag that states if the item is equipped or not.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_armor = function (item, ritem, is_equipped)
    local data = T{
        kind        = ritem.Type,
        augments    = itemdata.parse_augments(item, ritem),
    };

    if (itemdata.config.use_raw) then
        data:merge(itemdata.parse_raw_augments(item, ritem));
    end

    return data:merge(itemdata.parse_timer_info(item, ritem, is_equipped));
end

--[[
* Parses the extra data of an item. [Kind: 0x06 - Linkshell, Linksack, Linkpearl]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_linkshell = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind = ritem.Type,
        name = itemdata.parse_linkshell_name(item.Extra, 0x09),
    };

    data.group_id   = reader:read(32);
    data.group_key  = reader:read(16);
    data.r          = reader:read(4);
    data.g          = reader:read(4);
    data.b          = reader:read(4);
    data.a          = reader:read(4);
    data.flag       = reader:read(8);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x0A - Furnishing]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_furnishing = function (item, ritem)
    local reader = breader:new(T{}, item.Extra, 1);
    local data = T{
        kind    = ritem.Type,
        element = ritem.Element,
        storage = ritem.Storage,
    };

    data.flags      = reader:read(8);
    _               = reader:read(32);
    data.x          = reader:read(8);
    data.z          = reader:read(8);
    data.y          = reader:read(8);
    data.rotation   = reader:read(8);
    data.signature  = itemdata.parse_signature(item.Extra, 0x0A);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x0C - Flower Pot]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_flowerpot = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind    = ritem.Type,
        element = ritem.Element,
        storage = ritem.Storage,
    };

    local function reader_read_then(r, size, func, ...)
        local ret = r:read(size);
        if (ret == 0) then
            return 0;
        end
        return func(ret, ...);
    end

    data.step           = reader:read(8);
    data.flags          = reader:read(8);
    data.crystal1       = reader_read_then(reader, 8, math.add, 4095);
    data.crystal2       = reader_read_then(reader, 8, math.add, 4095);
    data.kind           = reader:read(8);
    _                   = reader:read(8);
    data.x              = reader:read(8);
    data.z              = reader:read(8);
    data.y              = reader:read(8);
    data.rotation       = reader:read(8);
    _                   = reader:read(16);
    data.time_planted   = reader_read_then(reader, 32, math.add, itemdata.time_offset);
    data.time_next_step = reader_read_then(reader, 32, math.add, itemdata.time_offset);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x0E - Mannequin]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_mannequin = function (item, ritem)
    local reader = breader:new(T{}, item.Extra, 1);
    local data = T{
        kind        = ritem.Type,
        element     = ritem.Element,
        storage     = ritem.Storage,
        equipment   = T{},
    };

    data.flags              = reader:read(8);
    _                       = reader:read(32);
    data.x                  = reader:read(8);
    data.z                  = reader:read(8);
    data.y                  = reader:read(8);
    data.rotation           = reader:read(8);
    data.equipment.main     = reader:read(8);
    data.equipment.sub      = reader:read(8);
    data.equipment.ranged   = reader:read(8);
    data.equipment.head     = reader:read(8);
    data.equipment.body     = reader:read(8);
    data.equipment.hands    = reader:read(8);
    data.equipment.legs     = reader:read(8);
    data.equipment.feet     = reader:read(8);
    data.race               = reader:read(8);
    data.pose               = reader:read(8);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x0F - Book]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_book = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind = ritem.Type,
    };

    data.mode = struct.unpack('b', item.Extra, 0x0B + 0x01);

    local timeval   = 0;
    local level     = 0;

    if (data.mode == 0) then
        timeval = reader:read(29);
        level   = bit.band(reader:read(3), 0xFF);
    elseif (data.mode == 1) then
        timeval = reader:read(32);
        level   = bit.band(reader:read(32), 0xFF);
    end

    data.time   = timeval + itemdata.time_offset;
    data.level  = level == 0 and 99 or 10 * (7 - level);

    if (data.mode >= 2) then
        data.time   = 0;
        data.level  = 0;
    end

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x11 - Betting Slip]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_betting_slip = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind = ritem.Type,
    };

    data.race_id        = reader:read(18);
    data.race_grade     = reader:read(6);
    data.race_pairing_l = item.Id ~= 2481 and reader:read(4) + 1 or nil;
    data.race_pairing_r = item.Id ~= 2481 and reader:read(4) + 1 or nil;
    data.quills         = item.Id ~= 2481 and reader:read(10) or nil;

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x12 - Soul Plate]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_soul_plate = function (item, ritem)
    local reader = breader:new(T{}, item.Extra, 18);
    local data = T{
        kind        = ritem.Type,
        signature   = itemdata.parse_signature_soul_plate(item.Extra, 0x00),
    };

    --[[
    TODO:   The 'unknown00' and 'unknown01' values are not used by the client but they
            may contain additional information that could be useful.
    --]]

    data.unknown00      = reader:read(16);
    data.level          = reader:read(7);
    data.feral_skill    = reader:read(12);
    data.feral_points   = reader:read(7);
    data.unknown01      = reader:read(6);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x13 - Reflector]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_reflector = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind = ritem.Type,
    };

    --[[
    TODO:   The 'unknown00' and 'unknown01' values are not used by the client but they
            contain additional information. This includes things such as:
            mjob, sjob, family, etc.
    --]]

    data.name_first = reader:read(6);
    data.name_last  = reader:read(6) + 64;
    data.unknown00  = reader:read(20); -- Note: Bit size is not correct! (This holds multiple values.)
    data.unknown01  = reader:read(20); -- Note: Bit size is not correct! (This holds multiple values.)
    data.level      = reader:read(7);
    data.unknown02  = reader:read(5);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x14 - Log]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_log = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind = ritem.Type,
    };

    data.flag1  = reader:read(1) == 1 and true or false;
    data.flag2  = reader:read(1) == 1 and true or false;
    data.flag3  = reader:read(1) == 1 and true or false;
    data.flag4  = reader:read(1) == 1 and true or false;
    data.flag5  = reader:read(1) == 1 and true or false;
    data.flag6  = reader:read(1) == 1 and true or false;
    data.flag7  = reader:read(1) == 1 and true or false;
    data.flag8  = reader:read(1) == 1 and true or false;
    data.flag9  = reader:read(1) == 1 and true or false;
    data.flag10 = reader:read(1) == 1 and true or false;

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x15 - Lottery Tickets]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
* @note
*       Mog Bonanza Marbles/Pearls will hide the contest name if the
*       given title index is larger than the known count of strings.
*
*       Mog Bonanza Marbles are intended to display 5 numbers. (Can display 8.)
*       Mog Bonanza Pearls are intended to display 3 numbers. (Can display 8.)
--]]
itemdata.parse_item_lottery_ticket = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind    = ritem.Type,
        limit   = item.Id == 4089 and 3 or 5,
    };

    data.numbers    = reader:read(24);
    data.title      = reader:read(8);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x16 - Tabula (M)]
* Parses the extra data of an item. [Kind: 0x17 - Tabula (R)]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_tabula = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind    = ritem.Type,
        runes   = T{},
    };

    data.voucher        = reader:read(7);
    data.board_pieces   = reader:read(25);

    for x = 0, 11 do
        data.runes[x + 1] = T{ id = reader:read(9), rot = 0, };
    end

    for x = 0, 11 do
        data.runes[x + 1].rot = reader:read(2);
    end

    -- Tabula (R) remaining uses..
    data.uses = ritem.Type == 0x17 and reader:read(7) or 0;

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x1A - Evolith]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_evolith = function (item, ritem)
    local data = T{
        kind        = ritem.Type,
        augments    = itemdata.parse_augments(item, ritem),
    };

    if (itemdata.config.use_raw) then
        data:merge(itemdata.parse_raw_augments(item, ritem));
    end

    return data;
end

--[[
* Parses the extra data of an item. [Kind: 0x1F - Crafting Set]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_crafting_set = function (item, ritem)
    local reader = breader:new(T{}, item.Extra, 2);
    local data = T{
        kind        = ritem.Type,
        signature   = itemdata.parse_signature(item.Extra, 12),
    };

    data.quality = reader:read(16);

    return data;
end

--[[
* Parses the extra data of an item. [Kind: (default)]
*
* @param {userdata} item - The item object to be parsed.
* @param {userdata} ritem - The item resource object.
* @return {table} The parsed item information.
--]]
itemdata.parse_item_default = function (item, ritem)
    local reader = breader:new(T{}, item.Extra);
    local data = T{
        kind = ritem.Type,
    };

    switch(item.Id, T{
        -- Perpetual Hourglass, Glowing Lamp
        [T{ 4237, 5414 }] = function ()
            local val1  = reader:read(16);
            local val2  = reader:read(3);
            _           = reader:read(13);
            _           = reader:read(32);
            local val5  = reader:read(32);
            _           = reader:read(32);
            local val7  = reader:read(16);

            if (item.Id == 4237) then
                data.zone       = val7;
                data.zone_name  = AshitaCore:GetResourceManager():GetString('zones.names', val7);
            else
                data.chamber        = math.max(val1 - 29, 0);
                data.chamber_name   = T{ 'Rossweisse', 'Grimgerde', 'Siegrune', 'Helmwige', 'Schwertleite', 'Waltraute', 'Ortlinde', 'Gerhilde', 'Brunhilde', 'Odin', }[data.chamber] or '(null)';
            end

            data.flags      = val2;
            data.timestamp  = val5;
        end,

        -- Legion Pass
        [3528] = function ()
            data.timestamp  = reader:read(32);
            data.title      = reader:read(32) - 653;
            data.signature  = itemdata.parse_signature(item.Extra, 12);
        end,

        -- Default
        [switch.default] = function ()
            -- Do nothing for now..
        end,
    });

    return data;
end

--[[
* Parses the extra data of the given item.
*
* @param {userdata} item - The item object to be parsed.
* @param {boolean|nil} is_equipped - Flag that states if the item being pased is currently equipped. (Optional)
* @return {table} The table of parsed information.
* @note
*       The 'is_equipped' flag is used for equipment based items to properly allow for certain time based calculations
*       to be performed. If this flag is not given for equipped items, then there is a chance the returned time related
*       information may be incorrect!
--]]
itemdata.parse = function (item, is_equipped)
    if (item == nil) then
        return T{};
    end

    is_equipped = is_equipped or false;

    local ritem = AshitaCore:GetResourceManager():GetItemById(item.Id);
    if (ritem == nil) then
        return T{};
    end

    return switch(ritem.Type, T{
        [0x03] = function () return itemdata.parse_item_fish(item, ritem); end,
        [0x04] = function () return itemdata.parse_item_weapon(item, ritem, is_equipped); end,
        [0x05] = function () return itemdata.parse_item_armor(item, ritem, is_equipped); end,
        [0x06] = function () return itemdata.parse_item_linkshell(item, ritem); end,
        [0x0A] = function () return itemdata.parse_item_furnishing(item, ritem); end,
        [0x0C] = function () return itemdata.parse_item_flowerpot(item, ritem); end,
        [0x0E] = function () return itemdata.parse_item_mannequin(item, ritem); end,
        [0x0F] = function () return itemdata.parse_item_book(item, ritem); end,
        [0x11] = function () return itemdata.parse_item_betting_slip(item, ritem); end,
        [0x12] = function () return itemdata.parse_item_soul_plate(item, ritem); end,
        [0x13] = function () return itemdata.parse_item_reflector(item, ritem); end,
        [0x14] = function () return itemdata.parse_item_log(item, ritem); end,
        [0x15] = function () return itemdata.parse_item_lottery_ticket(item, ritem); end,
        [T{ 0x16, 0x17 }] = function () return itemdata.parse_item_tabula(item, ritem); end,
        [0x1A] = function () return itemdata.parse_item_evolith(item, ritem); end,
        [0x1F] = function () return itemdata.parse_item_crafting_set(item, ritem); end,
        [switch.default] = function () return itemdata.parse_item_default(item, ritem); end,
    });
end

return itemdata;