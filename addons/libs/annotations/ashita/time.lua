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

---@meta

--[[
Ashita Table -> Time ('ashita.time')
--]]

---@class ashita.time
ashita.time = {};

---@class HighResClock
---@field s number The number of seconds since epoch.
---@field ms number The number of milliseconds since epoch.
---@field micro number The number of microseconds since epoch.
---@field nano number The number of nanoseconds since epoch.
local HighResClock = {};

---@class SystemTime
---@field day number The current day of the month.
---@field dayofweek number The current day of the week.
---@field hour number The current hour.
---@field minute number The current minute.
---@field month number The current month.
---@field ms number The current millisecond.
---@field second number The current second.
---@field year number The current year.
---@field d number The current day of the month. (Shorthand.)
---@field wd number The current day of the week. (Shorthand.)
---@field hh number The current hour. (Shorthand.)
---@field mm number The current minute. (Shorthand.)
---@field m number The current month. (Shorthand.)
---@field ss number The current second. (Shorthand.)
---@field y number The current year. (Shorthand.)
local SystemTime = {};

---@class LargeInteger
---@field quad_part number The number quad part.
---@field high_part number The number high part.
---@field low_part number The number low part.
---@field q number The number quad part. (Shorthand.)
---@field h number The number high part. (Shorthand.)
---@field l number The number low part. (Shorthand.)
local LargeInteger = {};

---Returns a table containing high-resolution times since epoch.
---
---See: https://en.cppreference.com/w/cpp/chrono/high_resolution_clock.html
---@return HighResClock
---@nodiscard
function ashita.time.clock() end

---Returns a table containing the local time.
---
---See: https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getlocaltime
---@return SystemTime
---@nodiscard
function ashita.time.get_localtime() end

---Returns a table containing the system time.
---
---See: https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-getsystemtime
---@return SystemTime
---@nodiscard
function ashita.time.get_systemtime() end

---Returns the current system tick count.
---
---See: https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-gettickcount
---@return number
---@nodiscard
function ashita.time.get_tick() end

---Returns the current system tick count. (64bit)
---
---See: https://learn.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-gettickcount64
---@return number
---@nodiscard
function ashita.time.get_tick64() end

---Returns the current performance counter.
---
---See: https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter
---@return LargeInteger
---@nodiscard
function ashita.time.query_performance_counter() end

---Returns the current performance frequency.
---
---See: https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancefrequency
---@return LargeInteger
---@nodiscard
function ashita.time.query_performance_frequency() end

--[[
Forwards
--]]

ashita.time.glt     = ashita.time.get_localtime;
ashita.time.gst     = ashita.time.get_systemtime;
ashita.time.qpc     = ashita.time.query_performance_counter;
ashita.time.qpf     = ashita.time.query_performance_frequency;
ashita.time.tick    = ashita.time.get_tick;
ashita.time.tick64  = ashita.time.get_tick64;