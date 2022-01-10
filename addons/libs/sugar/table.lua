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

local table_mt = { };

--[[
* Returns true if all values in the table validate against the given function.
*
* @param {table} self - The parent table.
* @param {function} f - The validator function. [Function arguments are passed as: value]
* @return {boolean} True if all values validated, false otherwise.
--]]
table_mt.all = function (self, f)
    f = f or function (v) return v == true; end;

    for k, v in pairs(self) do
        if (not f(v)) then
            return false;
        end
    end

    return true;
end

--[[
* Returns true if any value in the table validates against the given function.
*
* @param {table} self - The parent table.
* @param {function} f - The validator function. [Function arguments are passed as: value]
* @return {boolean} True if any value validated, false otherwise.
--]]
table_mt.any = function (self, f)
    f = f or function (v) return v == true; end;

    for k, v in pairs(self) do
        if (f(v)) then
            return true;
        end
    end

    return false;
end

--[[
* Returns the table with the given value appended.
*
* @param {table} self - The parent table.
* @param {any} val - The value to append.
* @return {table} The updated table.
--]]
table_mt.append = function (self, val)
    self[#self + 1] = val;

    return self;
end

--[[
* Returns the table with all entries set to nil.
*
* @param {table} self - The parent table.
* @return {table} The updated table.
--]]
table_mt.clear = function (self)
    for k in pairs(self) do
        rawset(self, k, nil);
    end

    return self;
end

table_mt.null = table_mt.clear;

--[[
* Returns true if the table contains the given value.
*
* @param {table} self - The parent table.
* @param {any} val - The value to look for.
* @return {boolean} True if found, false otherwise.
--]]
table_mt.contains = function (self, val)
    for _, v in pairs(self) do
        if (v == val) then
            return true;
        end
    end

    return false;
end

table_mt.hasval     = table_mt.contains;
table_mt.hasvalue   = table_mt.contains;

--[[
* Returns true if the table contains the given key.
*
* @param {table} self - The parent table.
* @param {any} key - The key to look for.
* @return {boolean} True if found, false otherwise.
--]]
table_mt.containskey = function (self, key)
    return rawget(self, key) ~= nil;
end

table_mt.haskey = table_mt.containskey;

--[[
* Returns a copy of the table.
*
* @param {table} self - The parent table.
* @param {boolean} deep - Flag that states if the copy should be done recursively for any sub-table values. (Default false.)
* @return {table} The copied table as a 'T' table.
--]]
table_mt.copy = function (self, deep)
    deep = deep or false;

    local ret = { };

    for k, v in pairs(self) do
        if (type(v) == 'table' and deep) then
            v = table_mt.copy(v, true);
        end
        ret[k] = v;
    end

    if (deep) then
        return setmetatable(ret, getmetatable(self));
    end

    return T(ret);
end

table_mt.clone = table_mt.copy;

--[[
* Returns the number of times the value appears in the table.
*
* @param {table} self - The parent table.
* @param {any} val - The value to look for.
* @return {number} The count of times the value was found.
--]]
table_mt.count = function (self, val)
    if (val == nil) then
        return 0;
    end

    local ret = 0;
    for _, v in pairs(self) do
        if (v == val) then
            ret = ret + 1;
        end
    end

    return ret;
end

--[[
* Returns the number of values that pass the given validation function.
*
* @param {table} self - The parent table.
* @param {function} f - The validator function. [Function arguments are passed as: value]
* @return {number} The count of values that validated.
--]]
table_mt.countf = function (self, f)
    local ret = 0;

    for k, v in pairs(self) do
        if (f(v)) then
            ret = ret + 1;
        end
    end

    return ret;
end

--[[
* Deletes and returns the value from the table.
*
* @param {table} self - The parent table.
* @param {any} val - The value to remove.
* @return {any} The removed value if found, nil otherwise.
--]]
table_mt.delete = function (self, val)
    for k, v in pairs(self) do
        if (v == val) then
            if (type(k) == 'number') then
                return table.remove(self, k);
            else
                local ret = self[k];
                self[k] = nil;
                return ret;
            end
        end
    end

    return nil;
end

--[[
* Executes the given function against all elements in the table, ignoring any return values.
*
* @param {table} self - The parent table.
* @param {function} f - The function to call on each element. [Function arguments are passed as: value, key]
--]]
table_mt.each = function (self, f)
    for k, v in pairs(self) do
        f(v, k);
    end
end

table_mt.foreach = table_mt.each;

--[[
* Returns true if the table is empty.
*
* @param {table} self - The parent table.
* @param {boolean} deep - Flag that states empty sub-tables are not counted as actual values.
* @return {boolean} True if empty, false otherwise.
--]]
table_mt.empty = function (self, deep)
    if (not deep) then
        return next(self) == nil;
    end

    for _, v in pairs(self) do
        if (type(v) == 'table') then
            if (not table_mt.empty(v, true)) then
                return false;
            end
        else
            return false;
        end
    end

    return true;
end

--[[
* Returns true if both tables are equal.
*
* @param {table} self - The parent table.
* @param {table} t2 - The second table to compare.
* @param {boolean} ignore_mt - Flag that states the metatable should be ignored between the tables.
* @return {boolean} True if equal, false otherwise.
--]]
table_mt.equals = function (self, t2, ignore_mt)
    -- First quick-check if we are equal as-is..
    if (self == t2) then
        return true;
    end

    -- Next, check if we are equal by type or not tables..
    local o1t = type(self);
    local o2t = type(t2);
    if (o1t ~= o2t or o1t ~= 'table') then
        return false;
    end

    -- Next, check if our metatables match if enabled..
    if (not ignore_mt) then
        local m1 = getmetatable(self);
        if (m1 and m1.__eq) then
            return self == t2;
        end
    end

    -- Match the values within the tables, tracking the valid keys..
    local keys = { };
    for k, v in pairs(self) do
        local v2 = rawget(t2, k);
        if (v2 == nil or not table_mt.equals(v, v2, ignore_mt)) then
            return false;
        end
        keys[k] = true;
    end

    -- Ensure all keys exist in t2..
    for k, _ in pairs(t2) do
        if (not keys[k]) then
            return false;
        end
    end

    return true;
end

table_mt.eq = table_mt.equals;
table_mt.is = table_mt.equals;

--[[
* Returns the table with the given value, generally another table, appended.
*
* @param {table} self - The parent table.
* @param {any} val - The value to append.
* @return {table} The updated table.
--]]
table_mt.extend = function (self, val)
    if (type(val) == 'table') then
        for _, v in ipairs(val) do
            table_mt.append(self, v);
        end
    else
        table_mt.append(self, val);
    end

    return self;
end

--[[
* Returns a table containing the values from the parent table that passed the filtering function.
*
* @param {table} self - The parent table.
* @param {function} f - The validator function. [Function arguments are passed as: value]
* @return {table} The filtered table as a 'T' table.
--]]
table_mt.filter = function (self, f)
    local ret = { };

    for k, v in pairs(self) do
        if (f(v)) then
            ret[k] = v;
        end
    end

    return T(ret);
end

--[[
* Returns a table containing the values from the parent table that passed the filtering function.
* Keys of the returned table are numeric, as an array.
*
* @param {table} self - The parent table.
* @param {function} f - The validator function. [Function arguments are passed as: value]
* @return {table} The filtered table as a 'T' table.
--]]
table_mt.filteri = function (self, f)
    local ret = { };

    for k, v in pairs(self) do
        if (f(v)) then
            ret[#ret + 1] = v;
        end
    end

    return T(ret);
end

--[[
* Returns the k, v pair of the first matching value within the table.
*
* @param {table} self - The parent table.
* @param {any} val - The value to find.
* @return {any,any} The k, v pair if found, nil, nil otherwise.
--]]
table_mt.find = function (self, val)
    for k, v in pairs(self) do
        if (v == val) then
            return k, v;
        end
    end

    return nil, nil;
end

--[[
* Returns the k, v pair of the first key, value pair within the table that passes the given function.
*
* @param {table} self - The parent table.
* @param {function} f - The validator function. [Function arguments are passed as: value]
* @return {any,any} The k, v pair if found, nil, nil otherwise.
--]]
table_mt.find_if = function (self, f)
    for k, v in pairs(self) do
        if (f(v)) then
            return k, v;
        end
    end

    return nil, nil;
end

--[[
* Returns the k, v pair of the first matching key within the table.
*
* @param {table} self - The parent table.
* @param {any} key - The key to find.
* @return {any,any} The k, v pair if found, nil, nil otherwise.
--]]
table_mt.findkey = function (self, key)
    for k, v in pairs(self) do
        if (k == key) then
            return k, v;
        end
    end

    return nil, nil;
end

--[[
* Returns the first value of the table.
*
* @param {table} self - The parent table.
* @return {any} The first value of the table.
--]]
table_mt.first = function (self)
    return self[1];
end

--[[
* Returns the table, flatted from nested tables. Nested tables are expanded at their respective positions.
*
* @param {table} self - The parent table.
* @return {table} The updated table.
--]]
table_mt.flatten = function (self)
    local ret = { };

    for _, v in pairs(self) do
        if (type(v) == 'table') then
            local flat = table_mt.flatten(v);
            flat:each(function (vv) ret[#ret + 1] = vv; end);
        else
            ret[#ret + 1] = v;
        end
    end

    return setmetatable(ret, getmetatable(self));
end

--[[
* Returns the table with its keys as values and values as keys.
*
* @param {table} self - The parent table.
* @return {table} The updated table.
*
* @note
*   There is no guarantee which value to key transition will be honored as the 'last' updated value if multiple values
*   in the table are equal.
--]]
table_mt.flip = function (self)
    local ret = { };

    for k, v in pairs(self) do
        ret[v] = k;
    end

    return setmetatable(ret, getmetatable(self));
end

--[[
* Executes the given function against all elements in the table, ignoring any return values. (Using ipairs.)
*
* @param {table} self - The parent table.
* @param {function} f - The function to call on each element. [Function arguments are passed as: value, key]
--]]
table_mt.ieach = function (self, f)
    for k, v in ipairs(self) do
        f(v, k);
    end
end

table_mt.forieach = table_mt.ieach;

--[[
* Returns the result of executing the given function against every element in the table. (The returned table is reindexed numerically, as an array.)
*
* @param {table} self - The parent table.
* @param {function} f - The mapping function. [Function arguments are passed as: value]
* @return {table} The mapped table.
--]]
table_mt.imap = function (self, f)
    local ret = { };
    local n = 0;

    for k, v in pairs(self) do
        n = n + 1;
        ret[n] = f(v);
    end

    return T(ret);
end

--[[
* Returns a table that contains the collisions of the two tables.
*
* @param {table} self - The parent table.
* @param {table} t2 - The second table.
* @param {boolean} cmpv - Flag that states if values should be compared in the collisions as well.
* @return {table} The table of collisions as a 'T' table.
--]]
table_mt.intersect = function (self, t2, cmpv)
    cmpv = cmpv or false;

    local ret = { };

    if (cmpv) then
        for k, v in pairs(self) do
            if (t2:contains(v)) then
                ret[k] = v;
            end
        end
    else
        for k, v in pairs(self) do
            local vv = rawget(t2, k);
            if (vv and not cmpv) then
                ret[k] = v;
            elseif (vv and cmpv) then
                if (table_mt.equals(v, vv)) then
                    ret[k] = v;
                end
            end
        end
    end

    return T(ret);
end

--[[
* Returns true if the table contains sequential numeric keys.
*
* @param {table} self - The parent table.
* @return {boolean} True if the table is an array, false otherwise.
--]]
table_mt.isarray = function (self)
    local cnt = 0;

    for _ in pairs(self) do
        cnt = cnt + 1;
    end

    return cnt == #self;
end

--[[
* Returns an iterator that will step over each element of the table.
*
* @param {table} self - The parent table.
* @return {function} The iterator function. [Function returns it's values as: key, value]
--]]
table_mt.it = function (self)
    -- Stateful closure to walk the table..
    local l_iter = function (t)
        local key;

        return function ()
            key = next(t, key);
            return key, t[key];
        end
    end

    -- Create a wrapped call to the stateful closure..
    return (function (t)
        return l_iter(t);
    end)(self);
end

table_mt.iter = table_mt.it;

--[[
* Returns the tables values, joined together as a string.
*
* @param {table} self - The parent table.
* @param {string} sep - The seperator to use between each value.
* @return {string} The joined string.
--]]
table_mt.join = function (self, sep)
    sep = sep or '';

    local ret = '';
    for _, v in pairs(self) do
        ret = (#ret == 0) and tostring(v) or ret .. sep .. tostring(v);
    end

    return ret;
end

--[[
* Returns a table of the tables keys.
*
* @param {table} self - The parent table.
* @return {table} Table containing the parents keys.
--]]
table_mt.keys = function (self)
    local ret = { };
    local n = 0;

    for k in pairs(self) do
        n = n + 1;
        ret[n] = k;
    end

    return T(ret);
end

table_mt.keyset = table_mt.keys;

--[[
* Returns the last value of the table.
*
* @param {table} self - The parent table.
* @return {any} The last value of the table.
--]]
table_mt.last = function (self)
    return self[#self];
end

--[[
* Returns the number of elements in the table.
*
* @param {table} self - The parent table.
* @return {number} The number of elements.
--]]
table_mt.length = function (self)
    local ret = 0;

    for _ in pairs(self) do
        ret = ret + 1;
    end

    return ret;
end

table_mt.len    = table_mt.length;
table_mt.size   = table_mt.length;

--[[
* Returns the result of executing the given function against every element in the table. (The returned table retains the original tables keys.)
*
* @param {table} self - The parent table.
* @param {function} f - The mapping function. [Function arguments are passed as: value]
* @return {table} The mapped table.
--]]
table_mt.map = function (self, f)
    local ret = { };

    for k, v in pairs(self) do
        ret[k] = f(v);
    end

    return T(ret);
end

--[[
* Returns the result of executing the given function against every element in the table.
*
* @param {table} self - The parent table.
* @param {function} f - The mapping function. [Function arguments are passed as: value]
* @return {table} The mapped table.
*
* @note
*   The returned tables keys are the result of the mapping function each call.
--]]
table_mt.mapk = function (self, f)
    local ret = { };

    for k, v in pairs(self) do
        ret[f(v)] = v;
    end

    return T(ret);
end

--[[
* Returns the highest numeric value of the table.
*
* @param {table} self - The parent table.
* @return {number} The highest numeric value.
--]]
table_mt.max = function (self)
    return table_mt.reduce(self, math.max);
end

table_mt.highest = table_mt.max;

--[[
* Returns the lowest numeric value of the table.
*
* @param {table} self - The parent table.
* @return {number} The lowest numeric value.
--]]
table_mt.min = function (self)
    return table_mt.reduce(self, math.min);
end

table_mt.lowest = table_mt.min;

--[[
* Returns the product of the tables values.
*
* @param {table} self - The parent table.
* @return {number} The product of the tables values.
--]]
table_mt.mult = function (self)
    return table_mt.reduce(self, math.mult, 1);
end

--[[
* Returns the table merged together with the given table. (self used as the destination table.)
*
* @param {table} self - The parent table.
* @param {table} src - The second table.
* @param {boolean} overwrite - Flag that states existing entries will be overwriting in the self table.
* @return {table} The updated table.
--]]
table_mt.merge = function (self, src, overwrite)
    overwrite = overwrite or false;

    for k, v in pairs(src) do
        if (type(v) == 'table') then
            if (rawget(self, k) == nil) then
                self[k] = v;
            else
                table_mt.merge(self[k], src[k], overwrite);
            end
        else
            if (rawget(self, k) == nil or overwrite == true) then
                self[k] = v;
            end
        end
    end

    return self;
end

--[[
* Returns the values, reduced, from left to right by applying them to the given function.
*
* @param {table} self - The parent table.
* @param {function} f - The reduction function. [Function arguments are passed as: value, v]
* @param {number} val - The initial value to use while reducing.
* @return {number} The resulting value.
--]]
table_mt.reduce = function (self, f, val)
    for _, v in pairs(self) do
        if (val == nil) then
            val = v;
        else
            val = f(val, v);
        end
    end

    return val;
end

--[[
* Returns the table with its elements reversed.
*
* @param {table} self - The parent table.
* @return {table} The reversed table.
--]]
table_mt.reverse = function (self)
    local len = #self;
    local ret = { };

    for x = len, 1, -1 do
        ret[len - x + 1] = self[x];
    end

    return setmetatable(ret, getmetatable(self));
end

--[[
* Returns the sorted table.
*
* @param {table} self - The parent table.
* @return {table} The sorted table.
*
* @note
*   Overrides the original table.sort function to return the sorted table as well.
--]]
table_mt.sort_original = table_mt.sort_original or table.sort;
table_mt.sort = function (self, ...)
    table_mt.sort_original(self, ...);
    return self;
end

--[[
* Returns a table containing the parents sorted keys.
*
* @param {table} self - The parent table.
* @param {function} f - Function to use for sorting.
* @return {table} The sorted table of keys.
--]]
table_mt.sortkeys = function (self, f)
    local ret = { };

    for k, _ in pairs(self) do
        table.insert(ret, k);
    end

    if (f) then
        table_mt.sort_original(ret, f);
    else
        table_mt.sort_original(ret);
    end

    return T(ret);
end

table_mt.keysort = table_mt.sortkeys;

--[[
* Returns the sliced part of the table.
*
* @param {table} self - The parent table.
* @param {number} start - The starting index
* @param {number} cnt - The count of elements to slice.
* @return {table} The sliced part of the table.
--]]
table_mt.slice = function (self, start, cnt)
    local ret = { };
    local s, e = 0, 0;

    if (start < 0) then
        s = math.max(#self + 1 + start, 1);
        e = math.min(s + cnt - 1, #self);
    else
        s = math.max(start, 1);
        e = math.min(s + cnt - 1, #self);
    end

    for x = s, e do
        ret[#ret + 1] = self[x];
    end

    return setmetatable(ret, getmetatable(self));
end

--[[
* Returns the table of removed items, while also updating the parent table with any removes and replacements based on the arguments provided.
*
* @param {table} self - The parent table.
* @param {number} start - The starting index
* @param {number} cnt - The count of elements to splice.
* @param {...} ... - The elements to use for replacements/inserts.
* @return {table} The removed elements.
*
* @note
*   This works similar to JavaScripts Array.Slice method.
*   Negative start index is supported and will instead start from the end of the table. (Left-to-right.)
*   Additional passed arguments will be used as replacements/inserts.
--]]
table_mt.splice = function (self, start, cnt, ...)
    -- Clamp the start index and deal with negative start positions by wrapping around..
    start = start == 0 and 1 or start;

    if (start < 0) then
        -- Clamp negatives..
        start = math.max(start, -#self);
    else
        -- Clamp positives..
        if (start > #self) then
            cnt = 0;
        end
        start = math.min(start, #self + 1);
    end

    start = start < 0 and #self + start + 1 or start;

    -- Clamp the count amount to fit within the tables size based on the start index..
    cnt = cnt < 0 and 0 or cnt;
    if (start + cnt - 1 > #self) then
        cnt = #self - start + 1;
    end

    -- Do nothing if we have no valid index to start at..
    if (#self == 0 or start == 0) then
        return setmetatable({}, getmetatable(self));
    end

    local ret = { };
    local acnt = select('#', ...);

    local n = 1;
    for i = start, start + math.min(cnt, acnt) - 1 do
        table.insert(ret, self[i]);
        self[i] = (select(n, ...));
        n = n + 1;
    end
    n = n - 1;

    -- Handle left over extra entries..
    for _ = 1, cnt - acnt do
        table.insert(ret, table.remove(self, start + n));
    end

    -- Insert remaining extras..
    for i = acnt - cnt, 1, -1 do
        table.insert(self, start + cnt, (select(n + i, ...)));
    end

    return setmetatable(ret, getmetatable(self));
end

--[[
* Returns the sum of the tables values.
*
* @param {table} self - The parent table.
* @return {number} The sum of the tables values.
--]]
table_mt.sum = function (self)
    return table_mt.reduce(self, math.add, 0);
end

--[[
* Returns the table after applying a function to all values in the table, updating them in-place.
*
* @param {table} self - The parent table.
* @param {function} f - The transform function. [Function arguments are passed as: value]
* @return {table} The sorted table of keys.
--]]
table_mt.transform = function (self, f)
    for k, v in pairs(self) do
        self[k] = f(v);
    end

    return self;
end

--[[
* Returns the tables values, unpacked as arguments. [unpack forward.]
*
* @param {table} self - The parent table.
* @return {...} The unpacked arguments.
--]]
table_mt.unpack = function (self)
    local f = unpack and unpack or table.unpack;

    return f(self);
end

--[[
* Returns the table values as an array.
*
* @param {table} self - The parent table.
* @return {table} The tables values as an array.
--]]
table_mt.values = function (self)
    local ret = { };
    local n = 0;

    for _, v in pairs(self) do
        n = n + 1;
        ret[n] = v;
    end

    return T(ret);
end

table_mt.vals = table_mt.values;

----------------------------------------------------------------------------------------------------
--
-- Table Functions (Helpers)
--
----------------------------------------------------------------------------------------------------

--[[
* Returns a table containing the numbers of the given range.
*
* @param {number} s - The starting number of the range.
* @param {number} e - The ending number of the range.
* @param {number} step - The stepping value of the range. (Default is 1.)
* @return {table} The table of numbers within the range as a 'T' table.
--]]
table.range = function (s, e, step)
    step = step or 1;

    local ret = { };

    if (s == e) then
        ret = { s };
    elseif (s > e and step > 0) then
        ret = { };
    elseif (e > s and step < 0) then
        ret = { };
    else
        local n = 1;
        for i = s, e, step do
            ret[n] = i;
            n = n + 1;
        end
    end

    return T(ret);
end

--[[
* Returns a metatable-enabled table object. Creates a new table or wraps an existing one.
* Indexing the returned object will make use of the 'table' table of functions.
*
* @param {table} t - The table to be converted, or nil.
* @return {table} The metatable-enabled table.
--]]
T = function (t)
    return setmetatable(t or { }, {
        __index = function (_, k)
            return table_mt[k] or table[k];
        end
    });
end

--[[
* Table Metatable Override
*
* Overrides the default metatable of the table global.
* Metatable overrides:
*
*   __index = Custom indexing. [table -> table_mt -> nil]
--]]
setmetatable(table, {
    __index = function (_, k)
        return
            rawget(table, k) or
            table_mt[k] or
            nil;
    end,
});

-- Return the modules metatable and functions table.
return function ()
    return table_mt, {};
end