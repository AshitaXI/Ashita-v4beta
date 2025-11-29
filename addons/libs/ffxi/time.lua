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

require 'common';
require 'win32types';

local chat  = require 'chat';
local ffi   = require 'ffi';
local jit   = require 'jit';

ffi.cdef[[
    typedef struct tm {
        int32_t tm_sec;
        int32_t tm_min;
        int32_t tm_hour;
        int32_t tm_mday;
        int32_t tm_mon;
        int32_t tm_year;
        int32_t tm_wday;
        int32_t tm_yday;
        int32_t tm_isdst;
    } tm_t;

    typedef uint32_t    (__cdecl*   ntGameTimeDiff_f)(uint32_t);
    typedef uint32_t    (__stdcall* ntGameTimeGet_f)(void);
    typedef uint32_t    (__stdcall* ntGameTimeFunc_f)(uint32_t);
    typedef uint32_t    (__stdcall* xiGetTime_f)(void);
    typedef const char* (__stdcall* YkGetTimeString_f)(uint32_t, uint8_t);
    typedef tm*         (__cdecl*   sqLocalTime_f)(uint32_t);
]];

local timelib = T{
    ptrs = T{
        -- Helpers
        time_diff   = ashita.memory.find(0, 0, 'E8????????8BC88B4424043BC876??2BC1488BC8B8FFFFFF7F', 0, 0), -- ntGameTimeDiff

        -- Vana'diel Time
        game_time   = ashita.memory.find(0, 0, 'E8????????0305????????C3', 0, 0),       -- ntGameTimeGet
        weekday     = ashita.memory.find(0, 0, '8B44240433D2B9006C0000F7F1', 0, 0),     -- ntGameDayWeekGet
        day         = ashita.memory.find(0, 0, '8B44240433D2B900950100F7F1', 0, 0),     -- ntGameDayGet
        month       = ashita.memory.find(0, 0, '8B44240433D2B900FC1200F7F1', 0, 0),     -- ntGameMonthGet
        year        = ashita.memory.find(0, 0, 'B84134F81AF7642404C1EA118BC2C3', 0, 0), -- ntGameYearGet
        minutes     = ashita.memory.find(0, 0, '8B44240433D2B990000000F7F1', 0, 0),     -- ntGameMinGet
        hours       = ashita.memory.find(0, 0, '8B44240433D2B9800D0000F7F1', 0, 0),     -- ntGameHourGet
        moon        = ashita.memory.find(0, 0, '8B4C2404B8DB4B682FF7E12BCA', 0, 0),     -- ntGameMoonGet
        moon_percent= ashita.memory.find(0, 0, '8B4C2404B8DB4B682FF7E18BC1', 0, 0),     -- ntGameMoonPerGet

        -- World (Earth) Time
        world_time  = ashita.memory.find(0, 0, '518D44240050E8????????8B44240483C408C3', 0, 0),         -- xiGetTime
        time_str    = ashita.memory.find(0, 0, '8B44240481EC8000000053555633F685C05774??50E8', 0, 0),   -- YkGetTimeString

        -- Local Time
        local_time  = ashita.memory.find(0, 0, '8B442404568BC833F63D8017E87F894C2408', 0, 0), -- sqLocalTime
    },
    temp = T{
        nums = ffi.new('uint32_t[?]', 3),
    },
};

if (not timelib.ptrs:all(function (v) return v ~= nil and v ~= 0; end)) then
    error(chat.header(addon.name):append(chat.error('[lib.time] Error: Failed to locate required pointer(s).')));
    return;
end

---Returns the game time difference between the given time and the current game time.
---@param time number The time value to adjust.
---@return number
---@nodiscard
timelib.game_time_diff = function (time)
    return ffi.cast('ntGameTimeDiff_f', timelib.ptrs.time_diff)(time);
end
jit.off(timelib.game_time_diff);

---Returns the current raw game timestamp.
---@return number
---@nodiscard
timelib.get_game_time_raw = function ()
    return ffi.cast('ntGameTimeGet_f', timelib.ptrs.game_time)();
end
jit.off(timelib.get_game_time_raw);

---Returns the current epoch timestamp. (UTC)
---@return number
---@nodiscard
timelib.get_unix_timestamp = function ()
    return ffi.cast('xiGetTime_f', timelib.ptrs.world_time)();
end
jit.off(timelib.get_unix_timestamp);

---Returns the local time struct from the given epoch timestamp.
---@param time number The timestamp value.
---@return userdata|nil
---@nodiscard
timelib.get_local_time = function (time)
    local tm = ffi.cast('sqLocalTime_f', timelib.ptrs.local_time)(time);
    if (tm == nil) then
        return nil;
    end

    tm.tm_year = tm.tm_year + 1900;

    return tm;
end
jit.off(timelib.get_local_time);

---Returns the current Vana'diel week day.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_weekday = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.weekday)(time);
end
jit.off(timelib.get_game_weekday);

---Returns the current Vana'diel day.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_day = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.day)(time) + 1;
end
jit.off(timelib.get_game_day);

---Returns the current Vana'diel month.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_month = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.month)(time) + 1;
end
jit.off(timelib.get_game_month);

---Returns the current Vana'diel year.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_year = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.year)(time) + 886;
end
jit.off(timelib.get_game_year);

---Returns the current Vana'diel minutes.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_minutes = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.minutes)(time);
end
jit.off(timelib.get_game_minutes);

---Returns the current Vana'diel hours.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_hours = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.hours)(time);
end
jit.off(timelib.get_game_hours);

---Returns the current Vana'diel moon phase.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_moon_phase = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.moon)(time);
end
jit.off(timelib.get_game_moon_phase);

---Returns the current Vana'diel moon percent.
---@param time? number The timestamp to perform the calculation against, if given.
---@return number
---@nodiscard
timelib.get_game_moon_percent = function (time)
    time = time or timelib.get_game_time_raw();
    return ffi.cast('ntGameTimeFunc_f', timelib.ptrs.moon_percent)(time);
end
jit.off(timelib.get_game_moon_percent);

---Returns a formatted time string using the given timestamp.
---@param time number The timestamp value.
---@param flags number The flags used for formatting.
---@return string|nil
---@nodiscard
timelib.get_time_string = function (time, flags)
    local str= ffi.cast('YkGetTimeString_f', timelib.ptrs.time_str)(time, flags);
    if (str == nil) then
        return nil;
    end
    return ffi.string(str);
end
jit.off(timelib.get_time_string);

---Returns the proper calculated status timer value from its raw value.
---@param raw_time number
---@return number
---@nodiscard
timelib.get_calculated_status_time = function (raw_time)
    timelib.temp.nums[0] = 60 * timelib.get_game_time_raw();
    timelib.temp.nums[1] = raw_time;
    timelib.temp.nums[2] = (timelib.temp.nums[1] - timelib.temp.nums[0] + 59) / 60;

    return tonumber(timelib.temp.nums[2]);
end
jit.off(timelib.get_calculated_status_time);

return timelib;