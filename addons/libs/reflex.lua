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

local reflect   = require 'reflect';
local reflex    = T{};

---@class ReflexMember
---@field bits number
---@field ctype? string
---@field element_count number
---@field element_size number
---@field enum_type string
---@field is_array boolean
---@field is_bitfield boolean
---@field is_bool boolean
---@field is_const boolean
---@field is_enum boolean
---@field is_function boolean
---@field is_ptr boolean
---@field is_struct boolean
---@field is_transparent boolean
---@field is_union boolean
---@field is_unsigned boolean
---@field is_vla boolean
---@field is_volatile boolean
---@field memory_size number
---@field name string
---@field offset number
---@field struct? table<number, ReflexMember>
local member_properties = T{
    bits            = 0,
    ctype           = '',
    element_count   = 0,
    element_size    = 0,
    enum_type       = '',
    is_array        = false,
    is_bitfield     = false,
    is_bool         = false,
    is_const        = false,
    is_enum         = false,
    is_function     = false,
    is_ptr          = false,
    is_struct       = false,
    is_transparent  = false,
    is_union        = false,
    is_unsigned     = false,
    is_vla          = false,
    is_volatile     = false,
    memory_size     = 0,
    name            = '(anonymous)',
    offset          = 0,
    struct          = nil,
};

---@class ReflexOptions
---@field expand_base_classes? boolean
local reflex_options = {};

---Populates common flags for the given structure member.
---@param member ReflexMember The processed member table.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
reflex.populate_flags = function (member, m, options)
    if (not member.is_bool)     then member.is_bool     = m.bool        and true or false; end
    if (not member.is_const)    then member.is_const    = m.const       and true or false; end
    if (not member.is_unsigned) then member.is_unsigned = m.unsigned    and true or false; end
    if (not member.is_vla)      then member.is_vla      = m.vla         and true or false; end
    if (not member.is_volatile) then member.is_volatile = m.volatile    and true or false; end

    if (m.type) then
        reflex.populate_flags(member, m.type, options);
    end

    if (m.element_type) then
        reflex.populate_flags(member, m.element_type, options);
    end
end

---Process an array structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.array = function (m, options)
    local member = T{};

    member.is_array         = true;
    member.element_count    = m.size / m.element_type.size;
    member.element_size     = m.element_type.size;

    return member:merge(reflex.parse_member(m.element_type, options));
end

---Process a bitfield structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.bitfield = function (m, options)
    local member = T{};

    member.is_bitfield  = true;
    member.bits         = m.size * 8;

    return member:merge(reflex.parse_member(m.type, options));
end

---Process an enum structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.enum = function (m, options)
    local member = T{};

    member.is_enum      = true;
    member.enum_type    = m.name;

    return member:merge(reflex.parse_member(m.type, options));
end

---Process a field structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.field = function (m, options)
    return reflex.parse_member(m.type, options);
end

---Process a float/double structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.float = function (m, options)
    local member = T{};

    member.ctype = switch(m.size, T{
        [4] = function () return 'float'; end,
        [8] = function () return 'double'; end,
        [switch.default] = function()
            error(('reflex: unsupported float size: %d'):fmt(m.size));
        end,
    });

    return member;
end

---Process a function structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.func = function (m, options)
    local member = T{};

    member.is_function  = true;
    member.ctype        = 'func';

    -- TODO:
    -- Further processing can be done here to reflect the function arguments, calling conventions, return type, etc.

    return member;
end

---Process a integer structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.int = function (m, options)
    local member = T{};

    member.ctype = switch(m.size, T{
        [1] = function ()
            if (m.bool) then
                return 'bool';
            end
            return m.unsigned and 'uint8_t' or 'int8_t';
        end,
        [2] = function () return m.unsigned and 'uint16_t' or 'int16_t'; end,
        [4] = function () return m.unsigned and 'uint32_t' or 'int32_t'; end,
        [8] = function () return m.unsigned and 'uint64_t' or 'int64_t'; end,
        [switch.default] = function()
            error(('reflex: unsupported int size: %d'):fmt(m.size));
        end,
    });

    return member;
end

---Process a pointer structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.ptr = function (m, options)
    local member = T{};

    member.is_ptr = true;
    member:merge(reflex.parse_member(m.element_type, options));
    member.ctype = member.ctype .. '*';

    return member;
end

---Process a struct structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.struct = function (m, options)
    local member = T{};

    member.is_struct    = true;
    member.ctype        = m.name;
    member.struct       = reflex.reflect(m.name, options);

    -- TODO:
    -- Add prevention for stack overflows when structures are self-referencing.

    return member;
end

---Process a union structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.union = function (m, options)
    local member = T{};

    member.is_union         = true;
    member.ctype            = 'union';
    member.memory_size      = m.size;
    member.is_transparent   = m.transparent and true or false;
    member.struct           = reflex.reflect(m.typeid, options);

    -- TODO:
    -- Further process the unions members to expand them outside of the 'struct' field?

    return member;
end

---Process a void structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.void = function (m, options)
    local member = T{};

    member.ctype = 'void';

    return member;
end

---Process a structure member.
---@param m table The structure member being processed.
---@param options ReflexOptions Reflection options.
---@return ReflexMember
---@nodiscard
reflex.parse_member = function (m, options)
    local f = reflex[m.what];
    if (not f) then
        error(('reflex: unsupported member type: %s'):fmt(m.what));
    end
    return f(m, options);
end

---Reflects an FFI ctype back into a Lua table of structure members.
---@param ctype string|number The C-type to reflect.
---@param options? ReflexOptions Reflection options.
---@return table<number, ReflexMember>
---@nodiscard
reflex.reflect = function (ctype, options)
    options = options or T{};
    options.expand_base_classes = options.expand_base_classes or false;

    local t = type(ctype) == 'number' and reflect.fromid(ctype) or reflect.typeof(ctype);
    if (t == nil) then
        error('reflex: invalid ctype!');
    end

    if (not T{ 'struct', 'union', }:contains(t.what)) then
        error(('reflex: invalid ctype; expected \'struct\', got: %s'):fmt(t.what));
    end

    local members = T{};

    for m in t:members() do
        local member = member_properties:clone();

        reflex.populate_flags(member, m, options);

        member.name     = m.name and m.name or '(anonymous)';
        member.offset   = m.offset;

        if (m.type) then
            member.memory_size = m.type.size;
        end

        -- Support expanding custom 'BaseClass' inheritance chains..
        if (options.expand_base_classes and member.name == 'BaseClass') then
            reflex.parse_member(m, options):merge(member, false).struct:each(function (v) members:append(v); end);
        else
            members:append(reflex.parse_member(m, options):merge(member, false));
        end
    end

    return members;
end

return reflex;