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
Ashita Table -> Bits ('ashita.bits')
--]]

---@class ashita.bits
ashita.bits = {};

---Packs data. (Big Endian)
---@overload fun(data: userdata, value: number, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: userdata, value: number, offset: number, len: number): number
---@overload fun(data: table, value: number, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: table, value: number, offset: number, len: number): number
function ashita.bits.pack_be(...) end

---Packs data. (Little Endian)
---@overload fun(data: userdata, value: number, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: userdata, value: number, offset: number, len: number): number
---@overload fun(data: table, value: number, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: table, value: number, offset: number, len: number): number
function ashita.bits.pack_le(...) end

---Unpacks data. (Big Endian)
---@overload fun(data: userdata, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: userdata, offset: number, len: number): number
---@overload fun(data: table, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: table, offset: number, len: number): number
function ashita.bits.unpack_be(...) end

---Unpacks data. (Little Endian)
---@overload fun(data: userdata, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: userdata, offset: number, len: number): number
---@overload fun(data: table, byte_offset: number, bit_offset: number, len: number): number
---@overload fun(data: table, offset: number, len: number): number
function ashita.bits.unpack_le(...) end