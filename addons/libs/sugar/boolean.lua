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

local boolean_mt = { };

--[[
* Returns true if both values are true.
*
* @param {boolean} self - The parent value.
* @param {boolean} v - The second value to compare.
* @return {boolean} True if both values are true, false otherwise.
--]]
boolean_mt.both = function (self, v)
    return self and v;
end

--[[
* Returns true if either value is true.
*
* @param {boolean} self - The parent value.
* @param {boolean} v - The second value to compare.
* @return {boolean} True if either value is true, false otherwise.
--]]
boolean_mt.either = function (self, v)
    return self or v;
end

--[[
* Returns true if the values match.
*
* @param {boolean} self - The parent value.
* @param {boolean} v - The second value to compare.
* @return {boolean} True if the values match, false otherwise.
--]]
boolean_mt.equals = function (self, v)
    return self == v;
end

boolean_mt.is       = boolean_mt.equals;
boolean_mt.match    = boolean_mt.equals;
boolean_mt.matches  = boolean_mt.equals;
boolean_mt.same     = boolean_mt.equals;

--[[
* Returns true if the value exists.
*
* @param {boolean} self - The parent value.
* @return {boolean} True if the value exists, false otherwise.
--]]
boolean_mt.exists = function (self)
    return self ~= nil;
end

--[[
* Returns true if the value is false.
*
* @param {boolean} self - The parent value.
* @return {boolean} True if the value is false, false otherwise.
--]]
boolean_mt.isfalse = function (self)
    return self == false;
end

--[[
* Returns true if the value is true.
*
* @param {boolean} self - The parent value.
* @return {boolean} True if the value is true, false otherwise.
--]]
boolean_mt.istrue = function (self)
    return self == true;
end

--[[
* Returns the negation of the value.
*
* @param {boolean} self - The parent value.
* @return {boolean} The negated value.
--]]
boolean_mt.negate = function (self)
    return not self;
end

--[[
* Returns the number representation of the value.
*
* @param {boolean} self - The parent value.
* @return {number} 1 if true, 0 otherwise.
--]]
boolean_mt.tonumber = function (self)
    return self and 1 or 0;
end

--[[
* Returns the string representation of the value.
*
* @param {boolean} self - The parent value.
* @return {string} The value converted to a string.
--]]
boolean_mt.tostring = function (self)
    return tostring(self);
end

--[[
* Boolean Metatable Override
*
* Overrides the default metatable of a boolean value.
* Metatable overrides:
*
*   __index = Custom indexing. [boolean_mt -> error]
*   __unm   = Uses boolean_mt.negate.
--]]
debug.setmetatable(true, {
    __index = function (_, k)
        return boolean_mt[k] or error(string.format('Boolean type does not contain a definition for: %s', tostring(k)));
    end,
    __unm = boolean_mt.negate,
});

-- Return the modules metatable and functions table.
return function ()
    return boolean_mt, {};
end