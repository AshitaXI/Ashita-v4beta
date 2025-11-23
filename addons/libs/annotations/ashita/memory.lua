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
Ashita Table -> Memory ('ashita.memory')
Ashita Table -> Memory -> Assembler ('ashita.memory.assembler')
--]]

---@class ashita.memory
ashita.memory = {};

---@class ashita.memory.assembler
ashita.memory.assembler = {};

--[[
Memory Functions
--]]

---Returns the module base address of the current process, or the specific module, if one is given.
---@param name? string
---@return number
---@nodiscard
function ashita.memory.get_base(name) end

---Returns the module size of the current process, or the specific module, if one is given.
---@param name? string
---@return number
---@nodiscard
function ashita.memory.get_size(name) end

---Changes the memory protection of the given address.
---@param addr number
---@param size number
---@param protect number
---@return boolean status
---@return number old_protect
function ashita.memory.protect(addr, size, protect) end

---Unprotects the given memory address. (Changes its protection to PAGE_EXECUTE_READWRITE.)
---@param addr number
---@param size number
---@return boolean status
---@return number old_protect
function ashita.memory.unprotect(addr, size) end

---Allocates a block of memory.
---@param size number
---@return number?
---@nodiscard
function ashita.memory.alloc(size) end

---Deallocates a block of memory.
---@param addr number
---@return boolean
function ashita.memory.dealloc(addr) end

---Scans the given memory region for a pattern of data.
---
---If `name` is nil or `base` is 0, then the current process base address is used as the starting address.
---This function accepts special tokens for certain modules:
--- - `:boot` - The current boot files base address.
--- - `:ffximain` - The base address of FFXiMain.dll (or gamemodule setting override).
---@overload fun(name?: string, size: number, pattern: string, offset: number, usage: number): number
---@overload fun(base: number, size: number, pattern: string, offset: number, usage: number): number
function ashita.memory.find(...) end

---Reads and returns an int8 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_int8(addr) end

---Reads and returns an int16 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_int16(addr) end

---Reads and returns an int32 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_int32(addr) end

---Reads and returns an int64 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_int64(addr) end

---Reads and returns an uint8 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_uint8(addr) end

---Reads and returns an uint16 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_uint16(addr) end

---Reads and returns an uint32 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_uint32(addr) end

---Reads and returns an uint64 value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_uint64(addr) end

---Reads and returns a float value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_float(addr) end

---Reads and returns a double value from the given address.
---@param addr number
---@return number
---@nodiscard
function ashita.memory.read_double(addr) end

---Reads and returns an array of values from the given address.
---@param addr number
---@param size number
---@return table?
---@nodiscard
function ashita.memory.read_array(addr, size) end

---Reads and returns a string value from the given address.
---@param addr number
---@param size number
---@return string?
---@nodiscard
function ashita.memory.read_string(addr, size) end

---Reads and returns a literal string value from the given address.
---@param addr number
---@param size number
---@return string?
---@nodiscard
function ashita.memory.read_literal(addr, size) end


---Writes an int8 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_int8(addr, val) end

---Writes an int16 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_int16(addr, val) end

---Writes an int32 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_int32(addr, val) end

---Writes an int64 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_int64(addr, val) end

---Writes an uint8 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_uint8(addr, val) end

---Writes an uint16 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_uint16(addr, val) end

---Writes an uint32 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_uint32(addr, val) end

---Writes an uint64 value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_uint64(addr, val) end

---Writes a float value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_float(addr, val) end

---Writes a double value to the given address.
---@param addr number
---@param val number
function ashita.memory.write_double(addr, val) end

---Writes an array of byte values to the given address.
---@param addr number
---@param val table
function ashita.memory.write_array(addr, val) end

---Writes a string value to the given address.
---@param addr number
---@param str string
---@param size? number
function ashita.memory.write_string(addr, str, size) end

--[[
Assembler Functions
--]]

---Assembles and writes a 'CALL' instruction to the given address.
---@param addr number
---@param dest number
---@param nops number
function ashita.memory.assembler.call(addr, dest, nops) end

---Assembles and writes a 'JMP' instruction to the given address.
---@param addr number
---@param dest number
---@param nops number
function ashita.memory.assembler.jmp(addr, dest, nops) end

---Assembles and writes one or more 'NOP' instructions to the given address.
---@param addr number
---@param nops number
function ashita.memory.assembler.nop(addr, nops) end

---Assembles and returns the given x86 assembly instructions as bytes.
---@param str string
---@return table?
---@nodiscard
function ashita.memory.assembler.assemble(str) end

---Assembles and injects the given x86 assembly instructions as a code cave. Returns the allocated code cave address.
---@param str string
---@return number?
---@nodiscard
function ashita.memory.assembler.cave(str) end

---Releases the given allocated address.
---@param addr number
function ashita.memory.assembler.release(addr) end