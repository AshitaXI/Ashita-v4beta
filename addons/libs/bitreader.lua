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

---@class BitReader
---@field data table The data table being read from.
---@field bit number The current bit position.
---@field pos number The current byte position.
local breader = T{
    data    = nil,
    bit     = 0,
    pos     = 0,
};

---Creates and returns a new bit reader instance.
---@param self BitReader
---@param o nil|table The default object, if provided.
---@param data nil|string|table The data to be used with this reader.
---@param pos nil|number The position within the data, if provided.
---@return BitReader
function breader:new(o, data, pos)
    o = o or T{};

    setmetatable(o, self);
    self.__index = self;

    if (data ~= nil) then
        self:set_data(data);
    end

    if (pos ~= nil) then
        self:set_pos(pos);
    end

    return o;
end

---Set the current reader data. (Resets the current position.)
---
---_The data passed to this function should either be a string containing hexadecimal
---values or a table of bytes. If the data is a string, it will be converted to a
---byte table automatically. (String usage is intended for use with literal strings
---such as packet data from the Ashita packet events.)_
---@param self BitReader
---@param data string|table The data to be used with the reader.
function breader:set_data(data)
    self.bit    = 0;
    self.data   = T{};
    self.pos    = 0;

    switch(type(data), T{
        ['string'] = function ()
            data:tohex():replace(' ', ''):gsub('(%x%x)', function (x)
                return self.data:insert(tonumber(x, 16));
            end);
        end,
        ['table'] = function ()
            if (getmetatable(data) == nil) then
                data = T(data);
            end

            ---@cast data table
            self.data = data;
        end,
        [switch.default] = function ()
            error('[bitreader] Invalid data type given for bit reader: ' .. type(data));
        end,
    });
end

---Sets the current reader bit position.
---
---_This method does not reset the byte position!_
---@param self BitReader
---@param pos number The bit position to set the reader to.
function breader:set_bit_pos(pos)
    self.bit = pos;
end

---Sets the current reader byte position.
---
---_This method resets the bit position to 0!_
---@param self BitReader
---@param pos number The byte position to set the reader to.
function breader:set_pos(pos)
    self.bit = 0;
    self.pos = pos;
end

---Reads a packed value from the current data.
---@param self BitReader
---@param bits number The number of bits to read.
---@return number
function breader:read(bits)
    local ret = 0;

    if (self.data == nil) then
        error('[bitreader] Invalid ');
    end

    if (self.pos >= self.data:len()) then
        error(('[bitreader] Invalid read attempt, buffer overrun. [pos: %d, len: %d]'):fmt(self.pos, self.data:len()));
    end

    -- Optimized read.. (8 bits)
    if (bits == 8 and self.bit == 0) then
        self.pos = self.pos + 1;
        return self.data[self.pos];
    end

    -- Optimized read.. (16 bits)
    if (bits == 16 and self.bit == 0) then
        self.pos = self.pos + 2;
        return bit.bor(bit.lshift(self.data[self.pos], 8), self.data[self.pos - 1]);
    end

    -- Optimized read.. (32 bits)
    if (bits == 32 and self.bit == 0) then
        self.pos = self.pos + 4;
        return bit.bor(bit.lshift(self.data[self.pos], 24), bit.lshift(self.data[self.pos - 1], 16), bit.lshift(self.data[self.pos - 2], 8), self.data[self.pos - 3]);
    end

    for x = 0, bits - 1 do
        local val = bit.lshift(bit.band(self.data[self.pos + 1], 1), x);
        self.data[self.pos + 1] = bit.rshift(self.data[self.pos + 1], 1);
        ret = bit.bor(ret, val);

        self.bit = self.bit + 1;
        if (self.bit == 8) then
            self.bit = 0;
            self.pos = self.pos + 1;
        end
    end

    return ret;
end

return breader;