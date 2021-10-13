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

local string_mt = { };

--[[
* Returns if the string matches any of the given values.
*
* @param {string} self - The parent string.
* @param {...} ... - Any number of strings to compare to.
* @return {boolean} True if a match is found, false otherwise.
--]]
string_mt.any = function (self, ...)
    local v = T{...};
    local k, _ = v:find_if(function (s)
        return self:lower() == tostring(s):lower();
    end);
    return k ~= nil;
end

--[[
* Returns the concatenation of the two strings.
*
* @param {string} self - The parent string.
* @param {string} val - The second string.
* @return {string} The updated string.
--]]
string_mt.append = function (self, val)
    return self .. val;
end

string_mt.concat = string_mt.append;

--[[
* Returns a table of parsed arguments from the string.
*
* @param {string} self - The parent string.
* @return {table} The table of arguments parsed from the string.
--]]
string_mt.args = function (self)
    local STATE_NONE    = 0; -- Currently within nothing.
    local STATE_WORD    = 1; -- Currently within a word.
    local STATE_QUOTE   = 2; -- Currently within a quote.

    local currState = STATE_NONE;
    local currChar  = nil;
    local nextChar  = nil;
    local strStart  = nil;
    local args      = T{ };

    -- Loop the string and self any arguments..
    for x = 1, string.len(self) do
        -- Read the current characters..
        currChar = string.sub(self, x, x);
        nextChar = string.sub(self, x + 1, x+1);

        -- Handle non-state..
        if (currState == STATE_NONE) then
            if (currChar == '"') then
                strStart = x + 1;
                currState = STATE_QUOTE;
            else
                if (currChar ~= ' ') then
                    strStart = x;
                    currState = STATE_WORD;
                end
            end

        -- Handle quoted string state..
        elseif (currState == STATE_QUOTE) then
            if (currChar == '"') then
                currState = STATE_NONE;
                table.insert(args, #args + 1, string.sub(self, strStart, x - 1));
            end

        -- Handle word string state..
        elseif (currState == STATE_WORD) then
            if (currChar == ' ' or nextChar == nil or nextChar == '\0') then
                currState = STATE_NONE;
                table.insert(args, #args + 1, string.sub(self, strStart, x - 1));
            end
        else
            error('Reached an unknown state while parsing command arguments.');
        end
    end

    -- If in a word insert into the args table..
    if (currState == STATE_WORD) then
        table.insert(args, #args + 1, string.sub(self, strStart, #self + 1));
    end

    -- Return the found arguments..
    return args;
end

--[[
* Returns a table of parsed arguments from the string. (Retains argument quotes.)
*
* @param {string} self - The parent string.
* @return {table} The table of arguments parsed from the string.
--]]
string_mt.argsquoted = function (self)
    local STATE_NONE    = 0; -- Currently within nothing.
    local STATE_WORD    = 1; -- Currently within a word.
    local STATE_QUOTE   = 2; -- Currently within a quote.

    local currState = STATE_NONE;
    local currChar  = nil;
    local nextChar  = nil;
    local strStart  = nil;
    local prefix    = nil;
    local args      = T{ };

    -- Loop the string and self any arguments..
    for x = 1, string.len(self) do
        -- Read the current characters..
        currChar = string.sub(self, x, x);
        nextChar = string.sub(self, x + 1, x + 1);

        -- Ensure the command starts with a slash..
        if (x == 1 and currChar ~= '/') then
            return nil;
        end

        -- Handle non-state..
        if (currState == STATE_NONE) then
            if (currChar == '"') then
                strStart = x;
                currState = STATE_QUOTE;
            elseif (currChar ~= ' ') then
                strStart = x;
                currState = STATE_WORD;
            end

        -- Handle quoted string state..
        elseif (currState == STATE_QUOTE) then
            if (currChar == '"') then
                table.insert(args, #args + 1, string.sub(self, strStart, x));
                currState = STATE_NONE;
            end

        -- Handle word string state..
        elseif (currState == STATE_WORD) then
            if (currChar == ' ') then
                table.insert(args, #args+1, string.sub(self, strStart, x - 1));
                if (prefix == nil) then
                    prefix = args[#args];
                end
                currState = STATE_NONE;
            elseif (nextChar == nil or nextChar == '\0') then
                -- This section never actually seems to get hit during processing.
                -- Regardless, it needs to use a different endpoint than the block above.
                table.insert(args, #args + 1, string.sub(self, strStart, x));
                if (prefix == nil) then
                    prefix = args[#args];
                end
                currState = STATE_NONE;
            elseif (prefix == nil and currChar == '/' and x == (strStart + 1)) then
                -- If command line starts with //, put that in its own argument field
                table.insert(args, #args + 1, string.sub(self, strStart, x));
                prefix = args[#args];
                currState = STATE_NONE;
            elseif (currChar == '"') then
                -- A quote mark should start a new quote arg, even if there is no space delimiter.
                table.insert(args, #args + 1, string.sub(self, strStart, x - 1));
                currState = STATE_QUOTE;
                strStart = x;
            end
        else
            error('Reached an unknown state while parsing command arguments.');
        end
    end

    -- If in a word insert into the args table..
    if (currState == STATE_WORD) then
        table.insert(args, #args + 1, string.sub(self, strStart, #self));
    end

    -- Return the found arguments..
    return args;
end

string_mt.argsq = string_mt.argsquoted;

--[[
* Returns the character at the given index in the string.
*
* @param {string} self - The parent string.
* @param {number} idx - The index of the character to obtain.
* @return {string} The character from the string.
--]]
string_mt.at = function (self, idx)
    return string.sub(self, idx, idx);
end

--[[
* Returns a table of the strings characters.
*
* @param {string} self - The parent string.
* @return {table} The table of characters.
--]]
string_mt.chars = function (self)
    return self:psplit('.', 0, false);
end

string_mt.explode = string_mt.chars;

--[[
* Returns the string cleaned of extra whitespace.
*
* @param {string} self - The parent string.
* @param {boolean} trimend - Flag that determines if the end of the string should be trimmed. (Default true.)
* @return {string} The updated string.
--]]
string_mt.clean = function (self, trimend)
    trimend = trimend == nil and true or trimend;

    if (trimend) then
        return self:gsub('%s+', ' '):trim();
    else
        return (self:gsub('%s+', ' '));
    end
end

--[[
* Returns an empty string.
*
* @return {string} An empty string.
--]]
string_mt.clear = function ()
    return '';
end

--[[
* Returns the string with spaces (or specified character) reduced to non-repeated instances.
*
* @param {string} self - The parent string.
* @param {string} char - The character to collapse. (Default space.)
* @param {boolean} trim - Flag that states if the result should be trimmed or not.
* @return {string} The updated string.
--]]
string_mt.collapse = function (self, char, trim)
    local ret = self;

    if (char ~= nil) then
        ret = self:gsub('['  .. char ..  ']+', char);
    else
        ret = self:gsub('%s+', ' ');
    end

    return trim == true and ret:trim() or ret;
end

--[[
* Returns true if both strings are equal.
*
* @param {string} self - The parent string.
* @param {string} val - The second string.
* @param {boolean} case_insensitive - Flag that states if the comparison should be case-sensitive.
* @return {boolean} True if equal, false otherwise.
--]]
string_mt.compare = function (self, val, case_insensitive)
    case_insensitive = case_insensitive or false;

    if (case_insensitive) then
        return self:lower() == val:lower();
    end

    return self == val;
end

string_mt.cmp   = string_mt.compare;
string_mt.eq    = string_mt.compare;

--[[
* Returns true if the string contains the given sub-string.
*
* @param {string} self - The parent string.
* @param {string} sub - The sub-string to look for.
* @return {boolean} True if found, false otherwise.
--]]
string_mt.contains = function (self, sub)
    return self:find(sub, nil, true) ~= nil;
end

string_mt.has       = string_mt.contains;
string_mt.includes  = string_mt.contains;

--[[
* Returns the count of occurrences of the given sub-string within the string.
*
* @param {string} self - The parent string.
* @param {string} sub - The sub-string to look for.
* @return {number} The count of occurrences.
--]]
string_mt.count = function (self, sub)
    return select(2, string.gsub(self, sub, ''));
end

--[[
* Returns true if the string is empty.
*
* @param {string} self - The parent string.
* @return {boolean} True if the string is empty, false otherwise.
--]]
string_mt.empty = function (self)
    return self == '';
end

--[[
* Returns the string, enclosed with the given start and end strings.
*
* @param {string} self - The parent string.
* @param {string} start - The string to enclose to the start.
* @param {string} fin - The string to enclose to the end. (Defaults to start string if nil.)
* @return {string} The updated string.
--]]
string_mt.enclose = function (self, start, fin)
    fin = fin or start;

    return start .. self .. fin;
end

--[[
* Returns true if the string is enclosed with the given values.
*
* @param {string} self - The parent string.
* @param {string} start - The starting string to use.
* @param {string} fin - The ending string to use. (Defaults to start string if nil.)
* @return {boolean} True if enclosed with the values, false otherwise.
--]]
string_mt.enclosed = function (self, start, fin)
    fin = fin or start;

    return self:startswith(start) and self:endswith(fin);
end

--[[
* Returns true if the string ends with the given value.
*
* @param {string} self - The parent string.
* @param {string} val - The string to check for.
* @return {boolean} True if the string is ends with the value, false otherwise.
--]]
string_mt.endswith = function (self, val)
    return self:sub(-#val) == val;
end

--[[
* Returns the string escaped for Lua pattern characters.
*
* @param {string} self - The parent string.
* @return {string} The escaped string.
*
* @note
*   See: https://www.lua.org/manual/5.2/manual.html#6.4.1
*   See: https://www.lua.org/pil/20.2.html
--]]
string_mt.escape = function (self)
    local replacements = {
        ['('] = '%(', [')'] = '%)',
        ['.'] = '%.', ['%'] = '%%',
        ['+'] = '%+', ['-'] = '%-',
        ['*'] = '%*', ['?'] = '%?',
        ['['] = '%[', [']'] = '%]',
        ['^'] = '%^', ['$'] = '%$',
    };

    return (self:gsub('.', replacements));
end

string_mt.esc = string_mt.escape;

--[[
* Returns the string with tokens replaced with the table of substitutions. (Tokens are represented as: ${name})
*
* @param {string} self - The parent string.
* @param {table} subs - The table of token substitutions. (Keys should be the name of the token.)
* @return {string} The updated string.
--]]
string_mt.expand = function (self, subs)
    return (self:gsub('%${([%w_]+)}', subs));
end

--[[
* Returns the string converted from hex.
*
* @param {string} self - The parent string.
* @return {string} The converted string.
--]]
string_mt.fromhex = function (self)
    self = self:gsub('%s*0x', ''):gsub('[^%w]', '');

    return (self:gsub('%w%w', function (c) return string.char(tonumber(c, 16)); end));
end

--[[
* Returns the string converted to hex.
*
* @param {string} self - The parent string.
* @param {string} sep - The seperator to use between each character. (Default is space.)
* @return {string} The converted string.
--]]
string_mt.hex = function (self, sep)
    sep = sep or ' ';

    local ret = '';
    for _, v in pairs(self:totable()) do
        ret = ret .. string.format('%02X', v) .. sep;
    end

    return ret:trim(sep);
end

string_mt.tohex = string_mt.hex;

--[[
* Returns true if the two strings are equal. (Case insensitive)
*
* @param {string} self - The parent string.
* @param {string} val - The second string.
* @return {boolean} True if the strings are equal, false otherwise.
--]]
string_mt.ieq = function (self, val)
    return string_mt.compare(self, val, true);
end

string_mt.icmp = string_mt.ieq;

--[[
* Returns the string with the given value inserted at the given position.
*
* @param {string} self - The parent string.
* @param {string} pos - The position to insert the string.
* @param {string} val - The second string.
* @return {string} The updated string.
--]]
string_mt.insert = function (self, pos, val)
    local part1 = self:sub(1, pos - 1);
    local part2 = self:sub(#part1 + 1);

    return part1 .. val .. part2;
end

--[[
* Returns true if the string is alpha-only.
*
* @param {string} self - The parent string.
* @return {boolean} True if the string is alpha-only, false otherwise.
--]]
string_mt.isalpha = function (self)
    return string.find(self, '^%a+$') == 1;
end

--[[
* Returns true if the string is alpha-numeric.
*
* @param {string} self - The parent string.
* @return {boolean} True if the string is alpha-numeric, false otherwise.
--]]
string_mt.isalphanumeric = function (self)
    return string.find(self, '^%w+$') == 1;
end

string_mt.isalphanum = string_mt.isalphanumeric;

--[[
* Returns true if the string is numeric-only.
*
* @param {string} self - The parent string.
* @return {boolean} True if the string is numeric-only, false otherwise.
--]]
string_mt.isdigit = function (self)
    return string.find(self, '^%d+$') == 1;
end

string_mt.isnumeric = string_mt.isdigit;

--[[
* Returns true if the string is all lower-case.
*
* @param {string} self - The parent string.
* @return {boolean} True if the string is all lower-case, false otherwise.
--]]
string_mt.islower = function (self)
    return string.find(self, '^[%l%s]+$') == 1;
end

--[[
* Returns true if the string is quoted.
*
* @param {string} self - The parent string.
* @return {boolean,string} True if the string is quoted, false otherwise. The matched arg or nil.
--]]
string_mt.isquoted = function (self)
    local arg = string.match(self, "^\"(.*)\"$");

    return (arg ~= nil), arg;
end

--[[
* Returns true if the string contains only spaces.
*
* @param {string} self - The parent string.
* @return {boolean} True if the string contains only spaces, false otherwise.
--]]
string_mt.isspace = function (self)
    return string.find(self, '^%s+$') == 1;
end

--[[
* Returns true if the string is all upper-case.
*
* @param {string} self - The parent string.
* @return {boolean} True if the string is all upper-case, false otherwise.
--]]
string_mt.isupper = function (self)
    return string.find(self, '^[%u%s]+$') == 1;
end

--[[
* Returns an iterator that will step over each character of the string.
*
* @param {string} self - The parent string.
* @return {function} The iterator function.
--]]
string_mt.it = function (self)
    return self:gmatch('.');
end

--[[
* Returns the string and all given arguments concated together with the given separator.
*
* @param {string} self - The parent string.
* @param {string} sep - The separator to use between each joined part.
* @param {...} ... - Any additional strings to join together.
* @return {string} The joined string.
--]]
string_mt.join = function (self, sep, ...)
    return self .. sep .. table.concat({...}, sep);
end

--[[
* Returns the index of the pattern location, if found, starting from the left.
*
* @param {string} self - The parent string.
* @param {string} pattern - The pattern to look for.
* @param {number} first - The starting position to look for the pattern.
* @param {number} last - The ending position to stop looking for the pattern.
* @return {number} The index where the pattern was found in the string, nil otherwise.
--]]
string_mt.lfind = function (self, pattern, first, last)
    local a, b = string.find(self, pattern, first, true);

    if (a and (not last or b <= last)) then
        return a;
    end

    return nil;
end

--[[
* Returns the string, left-padded, with the given value n-times upto the desired length of n.
*
* @param {string} self - The parent string.
* @param {string} val - The value to pad the string with.
* @param {number} n - The number of times to pad the string up to.
* @return {string} The updated string.
--]]
string_mt.lpad = function (self, val, n)
    return (val:rep(n) .. self):sub(-(n > #self and n or #self));
end

--[[
* Returns the concated results of the given function after executing over each character of the string.
*
* @param {string} self - The parent string.
* @param {string} f - The mapping function to call with each character.
* @return {string} The mapped string.
--]]
string_mt.map = function (self, f)
    return (self:gsub('.', f));
end

--[[
* Returns the string converted to a number.
*
* @param {...} ... - Parameters forwarded to tonumber.
* @return {number} The converted value.
--]]
string_mt.number = function (...)
    return tonumber(...);
end

string_mt.num       = string_mt.number;
string_mt.tonumber  = string_mt.number;

--[[
* Returns the string converted to a number, or the default value given on error.
*
* @param {string} self - The parent string.
* @param {number} base - The base to convert the number to.
* @param {number} def - The default value to use if an error occurs.
* @return {number} The converted value.
--]]
string_mt.number_or = function (self, b, d)
    if (not d) then
        return tonumber(self) or b;
    end
    return tonumber(self, b) or d;
end

string_mt.num_or        = string_mt.number_or;
string_mt.tonumberor    = string_mt.number_or;

--[[
* Returns the string split into equal-sized parts; last entry is the remainder of data.
*
* @param {string} self - The parent string.
* @param {number} size - The size to split the parts into.
* @return {table} Table containing the split parts.
--]]
string_mt.parts = function (self, size)
    local ret = T{ };

    for x = 1, #self, size do
        rawset(ret, #ret + 1, self:sub(x, x + size - 1));
    end

    return ret;
end

string_mt.chop      = string_mt.parts;
string_mt.chunks    = string_mt.parts;

--[[
* Returns the string prepended with the given value.
*
* @param {string} self - The parent string.
* @param {string} val - The second string.
* @return {string} The updated string.
--]]
string_mt.prepend = function (self, val)
    return val .. self;
end

--[[
* Returns the string updated to proper-casing.
*
* @param {string} self - The parent string.
* @return {string} The updated string.
--]]
string_mt.proper = function (self)
    local ret   = '';
    local t     = { };

    for x = 1, self:len() do
        t[x] = self:sub(x, x);
        if (t[x - 1] == ' ' or x == 1) then
            t[x] = t[x]:upperfirst();
        end
        ret = ret .. t[x];
    end

    return ret;
end

string_mt.capitalize    = string_mt.proper;
string_mt.toproper      = string_mt.proper;
string_mt.title         = string_mt.proper;

--[[
* Returns a table of parts split from the string using the given pattern.
*
* @param {string} self - The parent string.
* @param {string} pattern - The pattern to use for splitting.
* @param {number} n - The number of times to perform the split. (Default is 0 for no limit.)
* @param {boolean} keep - Flag that states if the pattern parts should be kept in the result.
* @return {table} The table of split parts.
--]]
string_mt.psplit = function (self, pattern, n, keep)
    n = n or 0;

    return string_mt.split(self, pattern, n, keep, false);
end

--[[
* Returns the string with the character at the given index removed.
*
* @param {string} self - The parent string.
* @param {number} idx - The index of the character to remove.
* @return {string} The updated string.
--]]
string_mt.remove = function (self, idx)
    return self:sub(0, idx - 1) .. self:sub(idx + 1);
end

--[[
* Returns the string with the given pattern replaced.
*
* @param {string} self - The parent string.
* @param {string} pattern - The pattern to replace.
* @param {string} rep - The replacement to use.
* @param {number} n - The number of times to perform the replacement.
* @return {string} The updated string.
--]]
string_mt.replace = function (self, pattern, rep, n)
    return (string.gsub(self, string_mt.escape(pattern), rep:gsub('%%', '%%%%'), n));
end

--[[
* Returns the index of the pattern location, if found, starting from the right.
*
* @param {string} self - The parent string.
* @param {string} pattern - The pattern to look for.
* @param {number} first - The starting position to look for the pattern.
* @param {number} last - The ending position to stop looking for the pattern.
* @return {number} The index where the pattern was found in the string, nil otherwise.
--]]
string_mt.rfind = function (self, pattern, first, last)
    first = first or 1;
    last = last or #self;

    local a, b = string.find(self, pattern, first, true);
    local r = nil;

    while (a) do
        if (last and b > last) then
            break;
        end
        r = a;
        a, b = string.find(self, pattern, b + 1, true);
    end

    return r;
end

--[[
* Returns the string, right-padded, with the given value n-times.
*
* @param {string} self - The parent string.
* @param {string} val - The value to pad the string with.
* @param {number} n - The number of times to pad the string up to.
* @return {string} The updated string.
--]]
string_mt.rpad = function (self, val, n)
    return (self .. val:rep(n)):sub(1, n > #self and n or #self);
end

--[[
* Returns a piece of the string.
*
* @param {string} self - The parent string.
* @param {number} start - The starting index.
* @param {number} fin - The ending index.
* @return {string} The sliced piece of the string.
--]]
string_mt.slice = function (self, start, fin)
    return self:sub(start or 1, fin or #self);
end

--[[
* Returns the string with the given string inserted into it.
*
* @param {string} self - The parent string.
* @param {number} start - The starting index.
* @param {number} fin - The ending index.
* @param {string} val - The second string to insert.
* @return {string} The updated string.
--]]
string_mt.splice = function (self, start, fin, val)
    return self:sub(1, start - 1) .. val .. self:sub(fin + 1);
end

--[[
* Returns a table of parts split from the string using the given pattern.
*
* @param {string} self - The parent string.
* @param {string} pattern - The pattern to split the string by.
* @param {number} count - The number of times apply the split.
* @param {boolean} keep - Flag that states if the pattern should be kept in the split parts.
* @param {boolean} plain - Flag that states if plain finding should be used with 'string.find'.
* @return {table} The table of split parts.
--]]
string_mt.split = function (self, pattern, count, keep, plain)
    pattern = pattern or ' ';
    count = count or 0;
    keep = keep or false;
    plain = plain or false;

    local offset = 1;
    if (pattern:empty() or pattern == '.' and not plain) then
        pattern = '.';
        plain = false;
        offset = 0;
    end

    local ret = T{ };
    local n, x = 0, 0;
    local idxstart, idxstop = 0, 0;

    while (x <= #self) do
        idxstart, idxstop = self:find(pattern, x, plain);
        if (not idxstart) then
            break;
        end

        n = n + 1;
        ret[n] = self:sub(x, idxstart - offset);

        if (keep and offset ~= 0) then
            n = n + 1;
            ret[n] = self:sub(idxstart, idxstop);
        end

        if (n == count - 1) then
            x = idxstop + 1;
            break;
        end

        x = idxstop + 1;
    end

    if (offset == 1) then
        n = n + 1;
        ret[n] = self:sub(x);
    end

    return ret;
end

--[[
* Returns true if the string starts with the given sub-string.
*
* @param {string} self - The parent string.
* @param {string} val - The second string.
* @return {boolean} True if the string starts with the sub-string, false otherwise.
--]]
string_mt.startswith = function (self, val)
    return self:sub(1, #val) == val;
end

--[[
* Returns the string with the given characters stripped.
*
* @param {string} self - The parent string.
* @param {string} chars - The characters to strip.
* @return {string} The updated string.
--]]
string_mt.strip = function (self, chars)
    return (self:gsub('[' .. chars:escape() .. ']', ''));
end

--[[
* Returns the string with it's letter-casing swapped.
*
* @param {string} self - The parent string.
* @return {string} The updated string.
--]]
string_mt.swapcase = function (self)
    local ret = { };

    for c in self:it() do
        rawset(ret, #ret + 1, not c:find('%l') and c:lower() or c:upper());
    end

    return table.concat(ret);
end

--[[
* Returns a table of the strings characters converted to numbers. (Per-character.)
*
* @param {string} self - The parent string.
* @return {table} Table of the strings characters as numbers.
--]]
string_mt.tonumbers = function (self)
    local ret = T{ };
    for x = 1, self:len() do
        ret[x] = tonumber(self:sub(x, x));
    end

    return ret;
end

string_mt.nums      = string_mt.tonumbers;
string_mt.tonums    = string_mt.tonumbers;

--[[
* Returns the string. [tostring forward.]
*
* @param {string} self - The parent string.
* @return {string} The string.
--]]
string_mt.tostring = function (self)
    return self;
end

string_mt.str   = string_mt.tostring;
string_mt.tostr = string_mt.tostring;

--[[
* Returns a table of the strings characters converted to bytes.
*
* @param {string} self - The parent string.
* @param {string} useChar - Flag if conversions should use 'string.char' instead of 'string.byte'.
* @return {table} Table of the strings characters as bytes.
--]]
string_mt.totable = function (self, useChar)
    useChar = useChar or false;

    local ret = T{ };

    for x = 1, self:len() do
        if (useChar) then
            ret[x] = string.char(self, x);
        else
            ret[x] = string.byte(self, x);
        end
    end

    return ret;
end

string_mt.bytes = string_mt.totable;

--[[
* Returns the string trimmed of the given character.
*
* @param {string} self - The parent string.
* @param {string} char - The character to trim from the string. (Default is space.)
* @return {string} The trimmed string.
--]]
string_mt.trim = function (self, char)
    char = char == nil and ' ' or char;
    self = string_mt.trimstart(self, char);
    self = string_mt.trimend(self, char);
    return self;
end

--[[
* Returns the string trimmed of whitepsace using a pattern.
*
* @param {string} self - The parent string.
* @return {string} The trimmed string.
--]]
string_mt.trimex = function (self)
    return self:match('^%s*(.-)%s*$');
end

--[[
* Returns the string trimmed of the given character from its end.
*
* @param {string} self - The parent string.
* @param {string} char - The character to trim from the string. (Default is space.)
* @return {string} The trimmed string.
--]]
string_mt.trimend = function (self, char)
    char = char == nil and ' ' or char;
    if (string.sub(self, -1) == char) then
        self = string.sub(self, 0, -2);
        self = string_mt.trimend(self, char);
    end
    return self;
end

--[[
* Returns the string trimmed of the given character from its start.
*
* @param {string} self - The parent string.
* @param {string} char - The character to trim from the string. (Default is space.)
* @return {string} The trimmed string.
--]]
string_mt.trimstart = function (self, char)
    char = char == nil and ' ' or char;
    self = string.reverse(self);
    self = string_mt.trimend(self, char);
    return string.reverse(self);
end

--[[
* Returns the type of the string. [type forward.]
*
* @param {string} self - The parent string.
* @return {string} The string type.
--]]
string_mt.type = function (self)
    return type(self);
end

--[[
* Returns the string with the first letter converted to upper-case
*
* @param {string} self - The parent string.
* @return {string} The updated string.
--]]
string_mt.upperfirst = function (self)
    return self:sub(1, 1):upper() .. self:sub(2);
end

string_mt.ucfirst   = string_mt.upperfirst;

--[[
* Returns the string, filled with 0's for the given length.
*
* @param {string} self - The parent string.
* @param {number} n - The number of 0's to insert.
* @return {string} The updated string.
--]]
string_mt.zerofill = function (self, n)
    return self:lpad('0', n);
end

string_mt.zfill = string_mt.zerofill;

----------------------------------------------------------------------------------------------------
--
-- String Functions (Final Fantasy XI Specific Helpers)
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the string stripped of Final Fantasy XI color tags.
*
* @param {string} self - The parent string.
* @return {string} The updated string.
--]]
string_mt.strip_colors = function (self)
    return (self:gsub('[' .. string.char(0x1E, 0x1F, 0x7F) .. '].', ''));
end

--[[
* Returns the string stripped of Final Fantasy XI auto-translate tags.
*
* @param {string} self - The parent string.
* @param {boolean} insertBrackets - Flag if the brackets should be replaced or just removed.
* @return {string} The updated string.
--]]
string_mt.strip_translate = function (self, insertBrackets)
    insertBrackets = insertBrackets or false;

    if (not insertBrackets) then
        return (self:gsub(string.char(0xEF) .. '[' .. string.char(0x27, 0x28) .. ']', ''));
    end

    self = (self:gsub(string.char(0xEF) .. '[' .. string.char(0x27) .. ']', '{'));
    self = (self:gsub(string.char(0xEF) .. '[' .. string.char(0x28) .. ']', '}'));
    return self;
end

----------------------------------------------------------------------------------------------------
--
-- String Functions (Base Method Aliases)
--
----------------------------------------------------------------------------------------------------

string_mt.length    = string.len;
string_mt.fmt       = string.format;
string_mt.size      = string.len;

--[[
* String Metatable Override
*
* Overrides the default metatable for a string value.
* Metatable overrides:
*
*   __add   = Mimics __concat metamethod.
*   __div   = Calls string_mt.parts.
*   __index = Custom indexing. [string -> string_mt -> char sub-string if key is a number.]
*   __mul   = Calls string_mt.rep.
*   __pow   = Calls string_mt.rep.
*   __sub   = Calls string_mt.sub.
*   __unm   = Calls string.reverse.
--]]
debug.setmetatable('', {
    __add = function (self, s)
        return self .. s;
    end,
    __div = function (self, n)
        return self:parts(n);
    end,
    __index = function (self, k)
        return
            string[k] or
            string_mt[k] or
            type(k) == 'number' and (k == 0 and #self or string.sub(self, k, k)) or
            error(string.format('String type does not contain a definition for: %s', tostring(k)));
    end,
    __mul = function (self, n)
        return type(self) == 'string' and self:rep(n) or n:rep(self);
    end,
    __pow = function (self, n)
        return type(self) == 'string' and self:rep(n) or n:rep(self);
    end,
    __sub = function (self, n)
        return type(self) == 'string' and self:sub(1, #self - n) or n:sub(1 + self, #n);
    end,
    __unm = function (self)
        return self:reverse();
    end,
});

--[[
* String Metatable Override
*
* Overrides the default metatable of the string global.
* Metatable overrides:
*
*   __index = Custom indexing. [string -> string_mt -> error]
--]]
setmetatable(string, {
    __index = function (_, k)
        return
            rawget(string, k) or
            string_mt[k] or
            nil;
    end,
});

-- Return the modules metatable and functions table.
return function ()
    return string_mt, {};
end