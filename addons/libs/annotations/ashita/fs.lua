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
Ashita Table -> File System ('ashita.fs')
--]]

---@class ashita.fs
---@field preferred_separator string The preferred file system path separator.
ashita.fs = {};

---@class FileSystemSpace
---@field available number
---@field capacity number
---@field free number
local space = {};

---@class FileSystemStatus
---@field permissions number
---@field exists boolean
---@field is_regular_file boolean
---@field is_directory boolean
---@field is_block_file boolean
---@field is_character_file boolean
---@field is_fifo boolean
---@field is_socket boolean
---@field is_symlink boolean
local status = {};

---Creates the given path. (Creates all missing folders within the path.)
---@param path string
---@return boolean
function ashita.fs.create_directory(path) end

---Returns (or sets) the current directory.
---@param path? string
---@return string?
---@nodiscard
function ashita.fs.current_directory(path) end

---Returns if the given paths are equal.
---@param path1 string
---@param path2 string
---@return boolean
---@nodiscard
function ashita.fs.equivalent(path1, path2) end

---Returns if the given path exists.
---@param path string
---@return boolean
---@nodiscard
function ashita.fs.exists(path) end

---Returns the given directories contents.
---@param path string
---@param mask? string
---@param subfolders? boolean
---@return table?
---@nodiscard
function ashita.fs.get_directory(path, mask, subfolders) end

---Returns the given applications install directory.
---@param lang_id number
---@param game_id number
---@return string?
---@nodiscard
function ashita.fs.get_install_directory(lang_id, game_id) end

---Returns the normalized path.
---@param path string
---@return string?
---@nodiscard
function ashita.fs.normalize(path) end

---Removes the given file or folder.
---@param path string
---@return boolean
function ashita.fs.remove(path) end

---Renames the given file or folder.
---@param path_old string
---@param path_new string
---@return boolean
function ashita.fs.rename(path_old, path_new) end

---Returns the size of a file.
---@param path string
---@return number
function ashita.fs.size(path) end

---Returns the space information for the given path.
---@param path string
---@return FileSystemSpace?
---@nodiscard
function ashita.fs.space(path) end

---Returns the status of the given file or folder.
---@param path string
---@return FileSystemStatus?
---@nodiscard
function ashita.fs.status(path) end

--[[
Forwards
--]]

ashita.fs.create_dir        = ashita.fs.create_directory;
ashita.fs.current_dir       = ashita.fs.current_directory
ashita.fs.equals            = ashita.fs.equivalent;
ashita.fs.get_dir           = ashita.fs.get_directory;
ashita.fs.get_install_dir   = ashita.fs.get_install_directory;