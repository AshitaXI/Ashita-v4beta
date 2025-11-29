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

---@class MemoryPatch
---@field private address_ number
---@field private backup_ table
---@field private enabled_ boolean
---@field private patch_ table
---@field private patch_gc_ ffi.cdata*
local patch_type = T{};

---Creates a new memory patch object.
---@param self MemoryPatch
---@param address number The address to write the patch to.
---@param patch table The table of bytes to write to the address.
---@return MemoryPatch
---@nodiscard
function patch_type:new(address, patch)
    local o = T{};

    setmetatable(o, self);
    self.__index = self;

    o.enabled_  = false;
    o.address_  = address;
    o.backup_   = ashita.memory.read_array(address, #patch);
    o.patch_    = patch;
    o.patch_gc_ = ffi.gc(ffi.cast('uint8_t*', 0), function ()
        o:disable();
    end);

    return o;
end

---Enables the patch.
---@param self MemoryPatch
function patch_type:enable()
    if (self.enabled_) then
        return;
    end
    local ret, prot = ashita.memory.unprotect(self.address_, #self.patch_);
    if (ret) then
        ashita.memory.write_array(self.address_, self.patch_);
        ashita.memory.protect(self.address_, #self.patch_, prot);

        self.enabled_ = true;
    end
end

---Disables the patch.
---@param self MemoryPatch
function patch_type:disable()
    if (not self.enabled_) then
        return;
    end
    local ret, prot = ashita.memory.unprotect(self.address_, #self.patch_);
    if (ret) then
        ashita.memory.write_array(self.address_, self.backup_);
        ashita.memory.protect(self.address_, #self.patch_, prot);

        self.enabled_ = false;
    end
end

---Returns if the patch is currently enabled.
---@param self MemoryPatch
---@return boolean
---@nodiscard
function patch_type:enabled()
    return self.enabled_;
end

return patch_type;