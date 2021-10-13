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

local math_mt = { };

--[[
* Math Constants
--]]
math.e   = math.exp(1);             -- The base of natural logarithms.
math.phi = (1 + math.sqrt(5)) / 2;  -- The golden ratio.
math.tau = math.pi * 2;             -- Number of radians in a single turn.

----------------------------------------------------------------------------------------------------
--
-- Math Functions
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the number approached towards the given target.
*
* @param {number} self - The parent number.
* @param {number} target - The target to approach.
* @param {number} inc - The amount to increase the number towards the target.
* @return {number} The approached number.
--]]
math_mt.approach = function (self, target, inc)
    inc = math.abs(inc);

    if (self < target) then
        return math.min(self + inc, target);
    elseif (self > target) then
        return math.max(self - inc, target);
    end

    return target;
end

--[[
* Returns the number converted to the given base.
*
* @param {number} self - The parent number.
* @param {number} base - The base to convert to. (Inclusive; 1 to 64 are valid bases.)
* @return {string} The converted number.
--]]
math_mt.base = function (self, base)
    self = math.floor(self);

    -- Handle decimal case..
    if (not base or base == 10) then
        return tostring(self);
    end

    -- Handle unary case..
    if (base == 1) then
        return string.rep('1', self);
    end

    local ret = { };
    local sign = '';

    if (self < 0) then
        sign = '-';
        self = -self;
    end

    local dict = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    if (base == 64) then
        dict = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    end

    repeat
        local n = (self % base) + 1;
        self = math.floor(self / base);
        table.insert(ret, 1, dict:sub(n, n));
    until (self == 0);

    return sign .. table.concat(ret, '');
end

--[[
* Returns the number converted to binary. [tonumber(val, 2) forward.]
*
* @param {number} self - The parent number.
* @return {string} The converted number.
--]]
math_mt.binary = function (self)
    return math_mt.base(self, 2);
end

--[[
* Returns the number converted to its char representation. [string.char forward.]
*
* @param {number} self - The parent number.
* @return {string} The converted number.
--]]
math_mt.char = function (self)
    return string.char(self);
end

--[[
* Returns the number, clamped between two values.
*
* @param {number} self - The parent number.
* @param {number} min - The minimum value to clamp within.
* @param {number} max - The maximum value to clamp within.
* @return {number} The clamped number.
--]]
math_mt.clamp = function (self, min, max)
    if (self < min) then return min; end
    if (self > max) then return max; end

    return self;
end

--[[
* Returns the number, converted to a degree. (Radian to degree via pi.)
*
* @param {number} self - The parent number.
* @return {number} The converted number.
--]]
math_mt.degree = function (self)
    return self * (180 / math.pi);
end

--[[
* Returns the number, converted to a degree. (Radian to degree via tau.)
*
* @param {number} self - The parent number.
* @return {number} The converted number.
--]]
math_mt.degree_tau = function (self)
    return 360 * self / math.tau;
end

math_mt.deg_tau = math_mt.degree_tau;
math_mt.degtau  = math_mt.degree_tau;

--[[
* Returns the number converted to hex. [tonumber(val, 16) forward.]
*
* @param {number} self - The parent number.
* @return {string} The converted number.
--]]
math_mt.hex = function (self)
    return math_mt.base(self, 16);
end

--[[
* Returns true if the number is +/- inf.
*
* @param {number} self - The parent number.
* @return {boolean} True if the number is +/- inf., false otherwise.
--]]
math_mt.isinf = function (self)
    return self == math.huge or self == -math.huge;
end

--[[
* Returns true if the number is NaN.
*
* @param {number} self - The parent number.
* @return {boolean} True if the number is NaN, false otherwise.
--]]
math_mt.isnan = function (self)
    return self ~= self;
end

--[[
* Returns the sum of the natural numbers of 1 to n. (n(n + 1)) / 2
*
* @param {number} self - The parent number.
* @return {number} The natural sum.
--]]
math_mt.natural_sum = function (self)
    local v = 0;

    for i = self, 0, -1 do
        v = v + i;
    end

    return v;
end

math_mt.nsum        = math_mt.natural_sum;
math_mt.naturalsum  = math_mt.natural_sum;

--[[
* Returns the number converted to octal. [tonumber(val, 8) forward.]
*
* @param {number} self - The parent number.
* @return {string} The converted number.
--]]
math_mt.octal = function (self)
    return math_mt.base(self, 8);
end

--[[
* Returns the number, converted to a radian. (Degree to radian via pi.)
*
* @param {number} self - The parent number.
* @return {number} The converted number.
--]]
math_mt.radian = function (self)
    return self * (math.pi / 180);
end

--[[
* Returns the number, converted to a radian. (Degree to radian via tau.)
*
* @param {number} self - The parent number.
* @return {number} The converted number.
--]]
math_mt.radian_tau = function (self)
    return math.tau * self / 360;
end

math_mt.rad_tau = math_mt.radian_tau;
math_mt.radtau  = math_mt.radian_tau;

--[[
* Returns the number, rounded to the given decimal place or 0.
*
* @param {number} self - The parent number.
* @param {number} dp - The decimal place to round to. 0 if not given.
* @return {number} The rounded number.
--]]
math_mt.round = function (self, dp)
    local m = 10 ^ (dp or 0);

    return math.floor(self * m + 0.5) / m;
end

--[[
* Returns the sign of the number.
*
* @param {number} self - The parent number.
* @return {number} 1 if positive, 0 if 0, -1 if negative.
--]]
math_mt.sign = function (self)
    return self > 0 and 1 or self < 0 and -1 or 0;
end

--[[
* Returns the number converted to a string.
*
* @param {number} self - The parent number.
* @return {string} The string representation of the number.
--]]
math_mt.tostring = function (self)
    return tostring(self);
end

math_mt.str     = math_mt.tostring;
math_mt.string  = math_mt.tostring;
math_mt.tostr   = math_mt.tostring;

--[[
* Returns the number, truncated to the given decimal place or 0, towards 0.
*
* @param {number} self - The parent number.
* @param {number} dp - The decimal place to truncate to. 0 if not given.
* @return {number} The truncated number.
--]]
math_mt.truncate = function (self, dp)
    local m = 10 ^ (dp or 0);
    local f = self < 0 and math.ceil or math.floor;

    return f(self * m) / m;
end

--[[
* Returns true if the number is within the given min and max values. (Inclusive.)
*
* @param {number} self - The parent number.
* @param {number} min - The minimum value to check within.
* @param {number} max - The maximum value to check within.
* @return {boolean} True if within the range, false otherwise.
--]]
math_mt.within = function (self, min, max)
    if (min > max or self > max or self < min) then
        return false;
    end
    return true;
end

----------------------------------------------------------------------------------------------------
--
-- Math Functions (Operators)
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the sum of the parent number and the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {number} The sum of the two numbers.
--]]
math_mt.add = function (self, val)
    return self + val;
end

--[[
* Returns the quotient of the parent number and the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {number} The quotient of the two numbers.
--]]
math_mt.div = function (self, val)
    return self / val;
end

math_mt.divide = math_mt.div;

--[[
* Returns if the number is equal to the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {boolean} True if the numbers are equal, false otherwise.
--]]
math_mt.eq = function (self, val)
    return self == val;
end

math_mt.equals = math_mt.eq;

--[[
* Returns if the number is even or not.
*
* @param {number} self - The parent number.
* @return {boolean} True if even, false otherwise.
--]]
math_mt.even = function (self)
    return self % 2 == 0;
end

math_mt.iseven = math_mt.even;

--[[
* Returns if the number is greater than or equal to the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {boolean} True if greater than or equal, false otherwise.
--]]
math_mt.ge = function (self, val)
    return self >= val;
end

--[[
* Returns if the number is greater than the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {boolean} True if greater than, false otherwise.
--]]
math_mt.gt = function (self, val)
    return self > val;
end

--[[
* Returns if the number is less than or equal to the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {boolean} True if less than or equal, false otherwise.
--]]
math_mt.le = function (self, val)
    return self <= val;
end

--[[
* Returns if the number is less than the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {boolean} True if less than, false otherwise.
--]]
math_mt.lt = function (self, val)
    return self < val;
end

--[[
* Returns the remainder of the two numbers.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {number} The remainder of the two numbers.
--]]
math_mt.mod = function (self, val)
    return self % val;
end

--[[
* Returns the product of the parent number and the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {number} The product of the two numbers.
--]]
math_mt.mul = function (self, val)
    return self * val;
end

math_mt.mult        = math_mt.mul;
math_mt.multiply    = math_mt.mul;

--[[
* Returns if the number is not equal to the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {boolean} True if the numbers are not equal, false otherwise.
--]]
math_mt.ne = function (self, val)
    return self ~= val;
end

math_mt.neq         = math_mt.ne;
math_mt.notequal    = math_mt.ne;
math_mt.notequals   = math_mt.ne;

--[[
* Returns if the number is odd or not.
*
* @param {number} self - The parent number.
* @return {boolean} True if odd, false otherwise.
--]]
math_mt.odd = function (self)
    return self % 2 == 1;
end

math_mt.isodd = math_mt.odd;

--[[
* Returns the difference of the parent number and the given value.
*
* @param {number} self - The parent number.
* @param {number} val - The second number.
* @return {number} The difference of the two numbers.
--]]
math_mt.sub = function (self, val)
    return self - val;
end

math_mt.subtract = math_mt.sub;

----------------------------------------------------------------------------------------------------
--
-- Math Functions (Helpers)
--
----------------------------------------------------------------------------------------------------

--[[
* Returns the Direct3D (ARGB) color code from the given color values.
*
* @param {number} a - The alpha color code.
* @param {number} r - The red color code.
* @param {number} g - The green color code.
* @param {number} b - The blue color code.
* @return {number} The converted color code.
--]]
math.d3dcolor = function (a, r, g, b)
    local c_a = bit.lshift(bit.band(a, 0xFF), 24);
    local c_r = bit.lshift(bit.band(r, 0xFF), 16);
    local c_g = bit.lshift(bit.band(g, 0xFF), 8);
    local c_b = bit.band(b, 0xFF);

    return bit.band(bit.bor(c_a, c_r, c_g, c_b), 0xFFFFFFFF);
end

--[[
* Returns the distance between two 2D points.
*
* @param {number} x1 - The x position of the first point.
* @param {number} y1 - The y position of the first point.
* @param {number} x2 - The x position of the second point.
* @param {number} y2 - The y position of the second point.
* @return {number} The 2D distance between the two points.
--]]
math.distance2d = function (x1, y1, x2, y2)
    local x = x2 - x1;
    local y = y2 - y1;

    return math.sqrt((x * x) + (y * y));
end

--[[
* Returns the distance between two 3D points.
*
* @param {number} x1 - The x position of the first point.
* @param {number} y1 - The y position of the first point.
* @param {number} z1 - The z position of the first point.
* @param {number} x2 - The x position of the second point.
* @param {number} y2 - The y position of the second point.
* @param {number} z2 - The z position of the second point.
* @return {number} The 3D distance between the two points.
--]]
math.distance3d = function (x1, y1, z1, x2, y2, z2)
    local x = x2 - x1;
    local y = y2 - y1;
    local z = z2 - z1;

    return math.sqrt((x * x) + (y * y) + (z * z));
end

--[[
* Reurns a random number between the given min and max values.
*
* @param {number} min - The minimum number to allow.
* @param {number} max - The maximum number to allow.
* @return {number} The random generated number.
--]]
math.randomrng = function (min, max)
    return min + (max - min) * math.random();
end

math.randomrange    = math.randomrng;
math.rndrng         = math.randomrng;

--[[
* Number Metatable Override
*
* Overrides the default metatable of a number value.
* Metatable overrides:
*
*   __index = Custom indexing. [math -> math_mt -> error]
--]]
debug.setmetatable(0, {
    __index = function (_, k)
        return
            math[k] or
            math_mt[k] or
            error(string.format('Number type does not contain a definition for: %s', tostring(k)));
    end
});

--[[
* Math Metatable Override
*
* Overrides the default metatable of the math global.
* Metatable overrides:
*
*   __index = Custom indexing. [math -> math_mt -> error]
--]]
setmetatable(math, {
    __index = function (_, k)
        return
            rawget(math, k) or
            math_mt[k] or
            error(string.format('Math namespace does not contain a definition for: %s', tostring(k)));
    end,
});

-- Return the modules metatable and functions table.
return function ()
    return math_mt, {};
end