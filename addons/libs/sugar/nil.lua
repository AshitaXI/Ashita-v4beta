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

local nil_mt = { };

--[[
* Returns nil as a string.
*
* @return {string} The string representation of nil.
--]]
nil_mt.tostring = function ()
    return 'nil';
end

nil_mt.string   = nil_mt.tostring;
nil_mt.str      = nil_mt.tostring;

--[[
* Nil Metatable Override
*
* Overrides the default metatable of a nil value.
*
* Note:
*
*   This is considered dangerous! Please do not use this unless you know what you are doing!
*
*   Lua, by default, will raise an error if you attempt to call or index a nil value. This is good
*   practice to avoid unintended situations in code and should generally always be followed. This
*   feature will remove those restrictions of Lua and allow you to attempt to call a nil function,
*   index a nil object/value, etc.
*
*   This should not be used to avoid proper error handling.
*   This should not be used to avoid fixing problems with code.
*
*   Please do not use this unless you know what it does and what you are doing!
*
* Metatable overrides:
*
*   __call      = Replaced with an empty function.
*   __index     = Custom indexing. [nil_mt -> nil]
*   __newindex  = Replaced with an empty table.
--]]
local function enable_nil_sugar()
    debug.setmetatable(nil, {
        __call = function () end,
        __index = function (_, k)
            return nil_mt[k] or nil;
        end,
        __newindex = { },
    });
end

--[[
* Disables the custom nil metatable override.
--]]
local function disable_nil_sugar()
    debug.setmetatable(nil, {});
end

-- Return the modules metatable and functions table.
return function ()
    return nil_mt, {
        enable_nil_sugar    = enable_nil_sugar,
        disable_nil_sugar   = disable_nil_sugar,
    };
end