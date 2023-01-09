/**
 * Ashita SDK - Copyright (c) 2023 Ashita Development Team
 * Contact: https://www.ashitaxi.com/
 * Contact: https://discord.gg/Ashita
 *
 * This file is part of Ashita.
 *
 * Ashita is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Ashita is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
 */

#ifndef ASHITA_SDK_BINARYDATA_H_INCLUDED
#define ASHITA_SDK_BINARYDATA_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// ReSharper disable CppInconsistentNaming
// ReSharper disable CppUnusedIncludeDirective

#include <cinttypes>

/**
 * Credits to the original ProjectXI authors that made the original versions of these functions.
 */

namespace Ashita
{
    class BinaryData
    {
    public:
        /**
         * Packs a value into the given buffer. (Big Endian)
         *
         * @param {uint8_t*} data - The data to pack the value into.
         * @param {uint64_t} value - The value to pack.
         * @param {uint32_t} byteOffset - The byte offset to pack the value at.
         * @param {uint32_t} bitOffset - The bit offset to pack the value at.
         * @param {uint8_t} len - The length of the value being packed.
         * @return {uint32_t} The bit offset where the value ends.
         */
        static uint32_t PackBitsBE(uint8_t* data, uint64_t value, uint32_t byteOffset, uint32_t bitOffset, const uint8_t len)
        {
            // Adjust the offsets as needed for bit alignment..
            byteOffset += bitOffset >> 3;
            bitOffset %= 8;

            // Prepare the bit mask and value..
            auto bitmask = (uint64_t)0xFFFFFFFFFFFFFFFFLL;
            bitmask >>= 64 - len;
            bitmask <<= bitOffset;
            value <<= bitOffset;
            value &= bitmask;
            bitmask ^= 0xFFFFFFFFFFFFFFFFLL;

            // Pack the data based on the size (type)..
            if (len + bitOffset <= 8)
            {
                const auto ptr  = &data[byteOffset];
                const auto mask = (uint8_t)bitmask;
                const auto val  = (uint8_t)value;
                *ptr &= mask;
                *ptr |= val;
            }
            else if (len + bitOffset <= 16)
            {
                const auto ptr  = (uint16_t*)&data[byteOffset];
                const auto mask = (uint16_t)bitmask;
                const auto val  = (uint16_t)value;
                *ptr &= mask;
                *ptr |= val;
            }
            else if (len + bitOffset <= 32)
            {
                const auto ptr  = (uint32_t*)&data[byteOffset];
                const auto mask = (uint32_t)bitmask;
                const auto val  = (uint32_t)value;
                *ptr &= mask;
                *ptr |= val;
            }
            else if (len + bitOffset <= 64)
            {
                const auto ptr = (uint64_t*)&data[byteOffset];
                *ptr &= bitmask;
                *ptr |= value;
            }
            else
            {
                // This should never be hit. (Data size > 64bits.)
            }

            return (byteOffset << 3) + bitOffset + len;
        }

        /**
         * Packs a value into the given buffer. (Big Endian)
         *
         * @param {uint8_t*} data - The data to pack the value into.
         * @param {uint64_t} value - The value to pack.
         * @param {uint32_t} offset - The bit offset to pack the value at.
         * @param {uint8_t} len - The length of the value being packed.
         * @return {uint32_t} The bit offset where the value ends.
         */
        static uint32_t PackBitsBE(uint8_t* data, const uint64_t value, const uint32_t offset, const uint8_t len)
        {
            return Ashita::BinaryData::PackBitsBE(data, value, 0, offset, len);
        }

        /**
         * Packs a value into the given buffer. (Little Endian)
         *
         * @param {uint8_t*} data - The data to pack the value into.
         * @param {uint64_t} value - The value to pack.
         * @param {uint32_t} byteOffset - The byte offset to pack the value at.
         * @param {uint32_t} bitOffset - The bit offset to pack the value at.
         * @param {uint8_t} len - The length of the value being packed.
         * @return {uint32_t} The bit offset where the value ends.
         */
        static uint32_t PackBitsLE(uint8_t* data, const uint64_t value, uint32_t byteOffset, uint32_t bitOffset, const uint8_t len)
        {
            // Adjust the offsets as needed for bit alignment..
            byteOffset += bitOffset >> 3;
            bitOffset %= 8;

            // Determine the bytes required..
            uint8_t bytesNeeded;
            if (bitOffset + len <= 8)
                bytesNeeded = 1;
            else if (bitOffset + len <= 16)
                bytesNeeded = 2;
            else if (bitOffset + len <= 32)
                bytesNeeded = 4;
            else if (bitOffset + len <= 64)
                bytesNeeded = 8;
            else
            {
                // This should never be hit. (Data size > 64bits.)
                return 0;
            }

            // Write the packed data..
            auto modified = new uint8_t[bytesNeeded];
            for (uint8_t c = 0; c < bytesNeeded; ++c)
                modified[c] = data[byteOffset + (bytesNeeded - 1) - c];

            const int32_t nbo = (bytesNeeded << 3) - (bitOffset + len);
            Ashita::BinaryData::PackBitsBE(&modified[0], value, 0, nbo, len);

            for (uint8_t c = 0; c < bytesNeeded; ++c)
                data[byteOffset + (bytesNeeded - 1) - c] = modified[c];

            // Cleanup..
            if (modified)
            {
                delete[] modified;
                modified = nullptr;
            }

            return (byteOffset << 3) + bitOffset + len;
        }

        /**
         * Packs a value into the given buffer. (Little Endian)
         *
         * @param {uint8_t*} data - The data to pack the value into.
         * @param {uint64_t} value - The value to pack.
         * @param {uint32_t} offset - The bit offset to pack the value at.
         * @param {uint8_t} len - The length of the value being packed.
         * @return {uint32_t} The bit offset where the value ends.
         */
        static uint32_t PackBitsLE(uint8_t* data, const uint64_t value, const uint32_t offset, const uint8_t len)
        {
            return Ashita::BinaryData::PackBitsLE(data, value, 0, offset, len);
        }

        /**
         * Unpacks a value from the given buffer. (Big Endian)
         *
         * @param {uint8_t*} data - The data to unpack the value from.
         * @param {uint32_t} byteOffset - The byte offset to unpack the value at.
         * @param {uint32_t} bitOffset - The bit offset to unpack the value at.
         * @param {uint8_t} len - The length of bits to unpack.
         * @return {uint64_t} The unpacked value.
         */
        static uint64_t UnpackBitsBE(uint8_t* data, uint32_t byteOffset, uint32_t bitOffset, const uint8_t len)
        {
            // Adjust the offsets as needed for bit alignment..
            byteOffset += bitOffset >> 3;
            bitOffset %= 8;

            // Prepare the bit mask..
            auto bitmask = (uint64_t)0xFFFFFFFFFFFFFFFFLL;
            bitmask >>= 64 - len;
            bitmask <<= bitOffset;

            // Unpack the value based on the size (type)..
            uint64_t ret;
            if (len + bitOffset <= 8)
            {
                const auto ptr = &data[byteOffset];
                ret            = (*ptr & (uint8_t)bitmask) >> bitOffset;
            }
            else if (len + bitOffset <= 16)
            {
                const auto ptr = (uint16_t*)&data[byteOffset];
                ret            = (*ptr & (uint16_t)bitmask) >> bitOffset;
            }
            else if (len + bitOffset <= 32)
            {
                const auto ptr = (uint32_t*)&data[byteOffset];
                ret            = (*ptr & (uint32_t)bitmask) >> bitOffset;
            }
            else if (len + bitOffset <= 64)
            {
                const auto ptr = (uint64_t*)&data[byteOffset];
                ret            = (*ptr & bitmask) >> bitOffset;
            }
            else
            {
                // This should never be hit. (Data size > 64bits.)
                return 0;
            }

            return ret;
        }

        /**
         * Unpacks a value from the given buffer. (Big Endian)
         *
         * @param {uint8_t*} data - The data to unpack the value from.
         * @param {uint32_t} offset - The bit offset to unpack the value at.
         * @param {uint8_t} len - The length of bits to unpack.
         * @return {uint64_t} The unpacked value.
         */
        static uint64_t UnpackBitsBE(uint8_t* data, const uint32_t offset, const uint8_t len)
        {
            return Ashita::BinaryData::UnpackBitsBE(data, 0, offset, len);
        }

        /**
         * Unpacks a value from the given buffer. (Little Endian)
         *
         * @param {uint8_t*} data - The data to unpack the value from.
         * @param {uint32_t} byteOffset - The byte offset to unpack the value at.
         * @param {uint32_t} bitOffset - The bit offset to unpack the value at.
         * @param {uint8_t} len - The length of bits to unpack.
         * @return {uint64_t} The unpacked value.
         */
        static uint64_t UnpackBitsLE(uint8_t* data, uint32_t byteOffset, uint32_t bitOffset, const uint8_t len)
        {
            // Adjust the offsets as needed for bit alignment..
            byteOffset += bitOffset >> 3;
            bitOffset %= 8;

            // Determine the bytes required..
            uint8_t bytesNeeded;
            if (bitOffset + len <= 8)
                bytesNeeded = 1;
            else if (bitOffset + len <= 16)
                bytesNeeded = 2;
            else if (bitOffset + len <= 32)
                bytesNeeded = 4;
            else if (bitOffset + len <= 64)
                bytesNeeded = 8;
            else
            {
                // This should never be hit. (Data size > 64bits.)
                return 0;
            }

            // Unpack the value based on the size (type)..
            uint64_t ret;
            auto modified = new uint8_t[bytesNeeded];
            for (uint8_t c = 0; c < bytesNeeded; ++c)
                modified[c] = data[byteOffset + (bytesNeeded - 1) - c];

            if (bytesNeeded == 1)
            {
                const uint8_t mask = 0xFF >> bitOffset;
                ret                = (uint64_t)(modified[0] & mask) >> (8 - (len + bitOffset));
            }
            else
            {
                const int32_t nbo = (bytesNeeded * 8) - (bitOffset + len);
                ret               = Ashita::BinaryData::UnpackBitsBE(&modified[0], 0, nbo, len);
            }

            if (modified)
            {
                delete[] modified;
                modified = nullptr;
            }

            return ret;
        }

        /**
         * Unpacks a value from the given buffer. (Little Endian)
         *
         * @param {uint8_t*} data - The data to unpack the value from.
         * @param {uint32_t} offset - The bit offset to unpack the value at.
         * @param {uint8_t} len - The length of bits to unpack.
         * @return {uint64_t} The unpacked value.
         */
        static uint64_t UnpackBitsLE(uint8_t* data, const uint32_t offset, const uint8_t len)
        {
            return Ashita::BinaryData::UnpackBitsLE(data, 0, offset, len);
        }

        /**
         * Tests if a bit is set within the given data.
         *
         * @param {uint16_t} value - The bit to test.
         * @param {uint8_t*} data - The data to check within.
         * @param {uint32_t} size - The size of the bits data.
         * @return {bool} True if set, false otherwise.
         */
        static bool HasBit(const uint16_t value, uint8_t* data, const uint32_t size)
        {
            // Ensure the bit position doesn't exceed the size..
            if (value >= size * 8)
                return false;
            return (data[value >> 3] & (1 << (value % 8))) > 0;
        }

        /**
         * Sets a bit within the given data.
         *
         * @param {uint16_t} value - The bit to set.
         * @param {uint8_t*} data - The data to set within.
         * @param {uint32_t} size - The size of the bits data.
         * @return {bool} True if set, false otherwise.
         */
        static bool SetBit(const uint16_t value, uint8_t* data, const uint32_t size)
        {
            // Test if the bit is already set and that the bit position doesn't exceed the size..
            if (!Ashita::BinaryData::HasBit(value, data, size) && (value < size * 8))
            {
                // Set the bit..
                data[value >> 3] |= (1 << (value % 8));
                return true;
            }
            return false;
        }

        /**
         * Unsets a bit within the given data.
         *
         * @param {uint16_t} value - The bit to unset.
         * @param {uint8_t*} data - The data to unset within.
         * @param {uint32_t} size - The size of the bits data.
         * @return {bool} True if unset, false otherwise.
         */
        static bool UnsetBit(const uint16_t value, uint8_t* data, const uint32_t size)
        {
            // Test if the bit is already set and that the bit position doesn't exceed the size..
            if (Ashita::BinaryData::HasBit(value, data, size) && (value < size * 8))
            {
                // Set the bit..
                data[value >> 3] &= ~(1 << (value % 8));
                return true;
            }
            return false;
        }
    };

} // namespace Ashita

#endif // ASHITA_SDK_BINARYDATA_H_INCLUDED