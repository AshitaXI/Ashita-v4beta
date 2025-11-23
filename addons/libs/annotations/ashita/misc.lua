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
Ashita Table -> Misc ('ashita.misc')
--]]

---@class ashita.misc
ashita.misc = {};

--[[
Clipboard Functions
--]]

---Returns the current clipboard content. (String)
---@return string?
---@nodiscard
function ashita.misc.get_clipboard() end

---Sets the current clipboard content. (String)
---@param str string
---@return boolean
function ashita.misc.set_clipboard(str) end

--[[
Console Functions
--]]

---Hides the process console window.
function ashita.misc.hide_console() end

---Shows the process console window.
function ashita.misc.show_console() end

--[[
Execution Functions
--]]

---Performs an operation on the specified file. (Uses ShellExecuteA with the 'open' operation.)
---@param path string
---@param args string
---@param mode? number
function ashita.misc.execute(path, args, mode) end

---Opens a URL. (Uses ShellExecuteA with the 'open' operation.)
---@param url string
function ashita.misc.open_url(url) end

--[[
Sound Functions
--]]

---Plays a sound file. (Uses PlaySoundA with the 'SND_FILENAME | SND_ASYNC' sound flags.)
---@param path string
function ashita.misc.play_sound(path) end