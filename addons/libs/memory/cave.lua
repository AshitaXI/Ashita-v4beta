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

local ffi = require 'ffi';

local cave_type = T{};

--[[
* Creates a new memory cave object.
*
* @param {number} address - The address to apply the code cave to. [Will inject an 0xE8 call opcode at this address.]
* @param {number} size - The size of the instruction(s) byte code being overwritten.
* @param {number} nops - The number of additional nops to inject.
* @param {string} cave_code - The code cave assembly, in AsmJit format.
* @return {table} The created code cave object.
--]]
function cave_type:new(address, size, nops, cave_code)
    local o = T{};

    setmetatable(o, self);
    self.__index = self;

    o.enabled_  = false;
    o.address_  = address;
    o.offset_   = 4;
    o.size_     = size;
    o.nops_     = nops;
    o.backup_   = ashita.memory.read_array(address, size);
    o.cave_     = ashita.memory.assembler.cave(cave_code);
    o.cave_gc_  = ffi.gc(ffi.cast('uint8_t*', 0), function ()
        o:disable();
        ashita.memory.assembler.release(o.cave_);
    end);

    return o;
end

--[[
* Enables the code cave.
--]]
function cave_type:enable()
    if (self.enabled_) then
        return;
    end
    local ret, prot = ashita.memory.unprotect(self.address_, #self.backup_);
    if (ret) then
        ashita.memory.assembler.call(self.address_, self.cave_ + self.offset_, self.nops_);
        ashita.memory.protect(self.address_, #self.backup_, prot);

        self.enabled_ = true;
    end
end

--[[
* Disables the code cave.
--]]
function cave_type:disable()
    if (not self.enabled_) then
        return;
    end
    local ret, prot = ashita.memory.unprotect(self.address_, #self.backup_);
    if (ret) then
        ashita.memory.write_array(self.address_, self.backup_);
        ashita.memory.protect(self.address_, #self.backup_, prot);

        self.enabled_ = false;
    end
end

--[[
* Sets the offset into the code cave that the injected call should be calculated to.
*
* @param {number} offset - The offset into the code cave that the injected call will be calculated to.
--]]
function cave_type:set_offset(offset)
    self.offset_ = offset;
end

--[[
* Returns if the code cave is currently enabled.
*
* @returns {boolean} True if enabled, false otherwise.
--]]
function cave_type:enabled()
    return self.enabled_;
end

--[[
* Returns the address of the code cave.
*
* @returns {number} The address of the code cave.
--]]
function cave_type:get_cave_address()
    return self.cave_;
end

return cave_type;