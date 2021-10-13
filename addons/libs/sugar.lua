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

local sugar = { };

--[[
* The list of sugar sub-modules to be loaded.
*
* The order of modules here matters, tables are loaded first to be able to access table features.
--]]
local modules = {
    { 'sugar.table',    'table_mt' },
    { 'sugar.boolean',  'boolean_mt' },
    { 'sugar.function', 'function_mt' },
    { 'sugar.math',     'math_mt' },
    { 'sugar.nil',      'nil_mt' },
    { 'sugar.string',   'string_mt' },
};

for _, v in pairs(modules) do
    -- Require the sub-module..
    local f = require(v[1]);

    -- Validate the sub-module returned a function..
    if (type(f) ~= 'function') then
        error('Invalid sugar module detected; expected a function return from requiring sub-modules.');
    end

    -- Invoke the sub-modules returned function..
    local mt, funcs = f();

    -- Store the sub-modules metatable..
    sugar[v[2]] = mt or { };

    -- Store the sub-modules functions..
    if (funcs ~= nil) then
        if (type(funcs) == 'table') then
            sugar.table_mt.merge(sugar, funcs);
        else
            error('Invalid sugar module detected; expected two tables from the modules function return, or nil.');
        end
    end
end

return T(sugar);

--[[
* sugar is inspired by the following:
*
* Metatable Abuse:
*
*   http://lua-users.org/wiki/MethodChainingWrapper
*   https://gist.github.com/gvx/2277797
*   https://gist.github.com/remyroez/baa67504e7fcdea405465b2f5a68b0b3
*   https://stackoverflow.com/a/33990997
*
* Functional Lua:
*
*   https://github.com/lunarmodules/Penlight
*   https://github.com/stevedonovan/Microlight
*   https://github.com/luafun/luafun
*   https://github.com/Yonaba/Moses
*   https://github.com/mirven/underscore.lua
*   https://github.com/siffiejoe/lua-fx
*
*   Underscore.js, Lodash.js, Ramda.js, Sugar.js, Mout.js, Rx.js
*
* Misc. References:
*
*   https://github.com/lua-nucleo/lua-nucleo
*   https://github.com/lua-stdlib/lua-stdlib
*   https://github.com/Yonaba/Allen
*   https://github.com/torch/xlua
*   https://github.com/timruffles/romans
*   https://stackoverflow.com/a/32660766
*   https://riptutorial.com/lua
*   https://github.com/bjc/prosody/tree/master/util
--]]