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
Ashita Table -> Regex ('ashita.regex')
--]]

---@class ashita.regex
ashita.regex = {};

---Applies the given pattern to a message to find all matches.
---
---See: https://en.cppreference.com/w/cpp/regex/regex_match.html
---@param message string
---@param pattern string
---@param flags? number
---@return table?
---@nodiscard
function ashita.regex.match(message, pattern, flags) end

---Applies the given pattern to a message to find all matches.
---
---See: https://en.cppreference.com/w/cpp/regex/regex_search.html
---@param message string
---@param pattern string
---@param flags? number
---@return table?
---@nodiscard
function ashita.regex.search(message, pattern, flags) end

---Replaces all matches within a string.
---
---See: https://en.cppreference.com/w/cpp/regex/regex_replace.html
---@overload fun(message: string, pattern: string, replace: string, flags?: number): string?
---@overload fun(message: string, pattern: string, replace: function, flags?: number): string?
---@return string?
---@nodiscard
function ashita.regex.replace(...) end

---Splits a string via the given pattern.
---
---See: https://en.cppreference.com/w/cpp/regex/regex_token_iterator.html
---@param message string
---@param pattern string
---@param flags? number
---@nodiscard
function ashita.regex.split(message, pattern, flags) end