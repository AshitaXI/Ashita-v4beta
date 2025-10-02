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

local coroutine_mt = {};

--[[
* Kills the given coroutine thread.
*
* @param {thread} self - The parent coroutine thread.
--]]
coroutine_mt.kill = function (self)
    coroutine.kill(self);
end

--[[
* Coroutine Metatable Overrides
*
* Overrides the default metatable of a thread value.
* Metatable overrides:
*
*   __call      = Forward helper to invoke 'coroutine.resume'.
*   __index     = Custom indexing.
--]]
debug.setmetatable(coroutine.create(function () end), {
    __call = function (self)
        return coroutine.resume(self);
    end,
    __index = function (self, k)
        return
            coroutine_mt[k] or
            error(string.format('Lua object \'thread\' does not contain a define for: \'%s\'', k));
    end,
});

-- Return the modules metatable and functions table.
return function ()
    return coroutine_mt, {
        kill = coroutine_mt.kill,
    };
end