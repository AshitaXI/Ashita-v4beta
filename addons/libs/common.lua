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

-- Monotonic os.clock shim: Windows CRT clock() is a 32-bit millisecond
-- counter that wraps negative after ~24.855 days of process uptime
-- (2^31 ms), breaking any comparison of os.clock() against 0-initialized
-- deadlines. Rebase to this Lua state's load time and accumulate across
-- wraps so os.clock() is always monotonic and never negative.
if not os.__monotonic_clock then
    os.__monotonic_clock = true;
    local real = os.clock;
    local base = real();
    local last = base;
    local offset = 0;
    os.clock = function()
        local c = real();
        if (c < last) then
            offset = offset + 4294967.296; -- 2^32 ms, one full wrap
        end
        last = c;
        return (c - base) + offset;
    end
end

---@overload fun(value: any, cases: table<any, function>): nil|any
switch = require 'switch';

-- Extension Libraries
local sugar = require 'sugar';

-- Return a table containing any common module forwards..
return {
    sugar = sugar,
};