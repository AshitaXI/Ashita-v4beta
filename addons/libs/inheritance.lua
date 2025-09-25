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

--[[
* Inheritance Helper
*
* This file implements helper functions that can be used with LuaJIT's FFI library to mimic
* C++ style base classes through metatable hacks. Normally, structures can only be defined
* following the C99 language standard, meaning that C++ class inheritance is not supported. 
*
* Due to this, doing manual inheritance handling leads to a messy chain of member variables
* being indexed to access a value. The methods in this library allow you to make use of
* 'ffi.metatype' overrides to directly access base class member variables instead of
* manually having to walk the full chain.
*
* For example:
*
*       Before: obj.BaseClass.BaseClass.BaseClass.name
*        After: obj.name
*
* Usage:
*
    To make use of this library, simply name any base class inheritance member in your
*   structures 'BaseClass'. Then make use of the 'ffi.metatype' function to override
*   your classes metatype using the below index and newindex functions. These must be
*   bound using the sugar library for proper usage!
*
*       local inheritance = require 'inheritance';
*
*       ffi.metatype('CYourClassName', T{
*           __index = inheritance.index:bindn(3, function (self, k)
*               -- Your own overrides here..
*           end),
*           __newindex = inheritance.newindex:bindn(3, function (self, k, v)
*               -- Your own overrides here..
*           end),
*       });
*
*   If you have a class that is inherited but does not need any special override
*   handling, you can make use of the `inheritance.proxy' call to register the
*   bare-minimum metatype for you. This will create the base __index and __newindex
*   callbacks with basic error reporting when an invalid member access is attempted.
*
*       inheritance.proxy(2, 'CYourClassName1');
*       inheritance.proxy(3, 'CYourClassName2');
*
--]]

require 'common';

local ffi = require 'ffi';

local inheritance = T{};

--[[
* Metamethod override helper for ctype objects to enable C++ style inheritance. (__index)
*
* @param {number} depth - The inheritance depth the 'self' object supports.
* @param {function} callback - Callback function to be invoked to allow for manual member overrides.
* @param {userdata} self - The parent object.
* @param {string} k - The name of the member variable being accessed.
* @return {any} The desired member value.
--]]
inheritance.index = function (depth, callback, self, k)
    -- Check for the lowest depth reachable to exit early..
    if (depth == 0) then
        return callback(self, k);
    end

    -- Check the override callback for the desired member..
    local ret, val = pcall(function () return callback(self, k); end);
    if (ret) then
        return val;
    end

    -- Check for a valid inheritance path..
    if (self.BaseClass == nil) then
        error(('[inheritance] Invalid inheritance chain detected! Missing \'BaseClass\' member! (p: %s)'):fmt(tostring(self)));
    end

    -- Fallthrough..
    return self.BaseClass[k];
end

--[[
* Metamethod override helper for ctype objects to enable C++ style inheritance. (__newindex)
*
* @param {number} depth - The inheritance depth the 'self' object supports.
* @param {function} callback - Callback function to be invoked to allow for manual member overrides.
* @param {userdata} self - The parent object.
* @param {string} k - The name of the member variable being accessed.
* @param {any} v - The new value to be set.
--]]
inheritance.newindex = function (depth, callback, self, k, v)
    -- Check for the lowest depth reachable to exit early..
    if (depth == 0) then
        callback(self, k, v);
        return;
    end

    -- Check the override callback for the desired member..
    local ret, _ = pcall(function () callback(self, k, v); end);
    if (ret) then return; end

    -- Check for a valid inheritance path..
    if (self.BaseClass == nil) then
        error(('[inheritance] Invalid inheritance chain detected! Missing \'BaseClass\' member! (p: %s)'):fmt(tostring(self)));
    end

    -- Fallthrough..
    self.BaseClass[k] = v;
end

--[[
* Registers a bare minimum metatype for the given ctype to allow inheritance to function properly.
*
* @param {number} depth - The depth of the inheritance chain.
* @param {string} tname - The ctype name to register the metatype for.
--]]
inheritance.proxy = function (depth, tname)
    ffi.metatype(tname, T{
        __index = inheritance.index:bindn(depth, function (_, k)
            error(('struct \'%s\' has no member: %s'):fmt(tname, k));
        end),
        __newindex = inheritance.newindex:bindn(depth, function (_, k, _)
            error(('struct \'%s\' has no member: %s'):fmt(tname, k));
        end),
    });
end

return inheritance;