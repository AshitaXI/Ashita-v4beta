/**
 * Ashita SDK - Copyright (c) 2021 Ashita Development Team
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

#ifndef ASHITA_SDK_MEMORY_H_INCLUDED
#define ASHITA_SDK_MEMORY_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <algorithm>
#include <sstream>
#include <string>
#include <vector>

#include "ErrorHandling.h"

// ReSharper disable CppTooWideScopeInitStatement

namespace Ashita
{
    /**
     * Iterable object to reduce the overhead of using the STL vector object.
     */
    template<typename T>
    struct scannableiterator_t
    {
        uintptr_t m_BaseAddress;
        uintptr_t m_Size;

        // Delete Copy Constructor
        scannableiterator_t(const scannableiterator_t&) = delete;

        /**
         * Constructor
         */
        scannableiterator_t(const uintptr_t base, const uintptr_t size)
            : m_BaseAddress(base)
            , m_Size(size)
        {}

        /**
         * Returns the start of the iteratorable memory.
         *
         * @return {T*} The starting memory address of the iterator.
         */
        T* begin(void)
        {
            return (T*)this->m_BaseAddress;
        }

        /**
         * Returns the end of the iteratorable memory.
         *
         * @return {T*} The ending memory address of the iterator.
         */
        T* end(void)
        {
            return (T*)(this->m_BaseAddress + this->m_Size);
        }
    };

    class Memory
    {
    public:
        /**
         * Finds a pattern within the given range of data.
         *
         * @param {uintptr_t} baseAddress - The address of the data to begin searching within.
         * @param {uintptr_t} size - The size of the data to search within.
         * @param {const char*} pattern - The pattern to search for.
         * @param {intptr_t} offset - The offset from the found location to add to the pointer.
         * @param {uintptr_t} count - The result count to use if the pattern is found more than once.
         * @return {uintptr_t} The address where the pattern was located, 0 otherwise.
         */
        static uintptr_t FindPattern(const uintptr_t baseAddress, const uintptr_t size, const char* pattern, const intptr_t offset, const uintptr_t count)
        {
            // Validate the base address and size parameters..
            if (baseAddress == 0 || size == 0)
                return 0;

            // Validate the incoming pattern is properly aligned..
            const auto len = strlen(pattern);
            if (len == 0 || len % 2 > 0)
                return 0;

            // Convert the pattern to a vectored pair..
            std::vector<std::pair<uint8_t, bool>> vpattern;
            for (size_t x = 0, y = len / 2; x < y; x++)
            {
                // Convert the current byte into the vectored pattern data..
                if (std::stringstream stream(std::string(pattern + (x * 2), 2)); stream.str() == "??")
                    vpattern.push_back(std::make_pair((uint8_t)0, false));
                else
                {
                    const auto b = strtol(stream.str().c_str(), nullptr, 16);
                    vpattern.push_back(std::make_pair((uint8_t)b, true));
                }
            }

            // Create a scannable iterator..
            scannableiterator_t<uint8_t> data(baseAddress, size);
            auto scanStart = data.begin();
            auto result    = (uintptr_t)0;

            while (true)
            {
                // Search for the pattern..
                auto ret = std::search(scanStart, data.end(), vpattern.begin(), vpattern.end(),
                    [&](const uint8_t curr, const std::pair<uint8_t, bool> currPattern) {
                        return !currPattern.second || curr == currPattern.first;
                    });

                // Check for a match..
                if (ret != data.end())
                {
                    // Use the current result if no increased count expected..
                    if (result == count || count == 0)
                        return std::distance(data.begin(), ret) + baseAddress + offset;

                    // Scan for the next result..
                    ++result;
                    scanStart = ++ret;
                }
                else
                    break;
            }

            return 0;
        }

        /**
         * Returns the owner module of the given address.
         *
         * @param {uintptr_t} address - The address of the owner module to locate.
         * @return {HMODULE} The module handle if found, nullptr otherwise.
         */
        static __forceinline HMODULE __stdcall GetCallingModule(const uintptr_t address)
        {
            if (address == 0)
                return nullptr;

            MEMORY_BASIC_INFORMATION mbi{};
            if (::VirtualQuery((LPCVOID)address, &mbi, sizeof(MEMORY_BASIC_INFORMATION)) == sizeof(MEMORY_BASIC_INFORMATION))
                return (HMODULE)mbi.AllocationBase;

            return nullptr;
        }

        /**
         * Reads a value from the given address using exception handling to prevent crashes.
         *
         * @param {T} <template> - The template data type.
         * @param {uintptr_t} address - The address to attempt to read the value of.
         * @param {T} defaultReturn - The default return value.
         * @return {T} The read value on success, defaultReturn value on error.
         */
        template<typename T>
        static T SafeRead(const uintptr_t address, T defaultReturn)
        {
            const auto translator = Ashita::ErrorHandling::ScopedTranslator();

            try
            {
                if (address == 0)
                    return defaultReturn;

                return *(T*)address;
            }
            catch (Ashita::ErrorHandling::Exception&)
            {
                return defaultReturn;
            }
            catch (...)
            {
                return defaultReturn;
            }
        }

        /**
         * Reads a value from the given address using exception handling to prevent crashes.
         *
         * @param {T} <template> - The template data type.
         * @param {uintptr_t} address - The address to attempt to read the value of.
         * @param {const char*} defaultReturn - The default return value.
         * @return {const char*} The read value on success, defaultReturn value on error.
         */
        template<typename T>
        static const char* SafeRead(const uintptr_t address, const char* defaultReturn)
        {
            const auto translator = Ashita::ErrorHandling::ScopedTranslator();

            try
            {
                if (address == 0)
                    return defaultReturn;

                return (const char*)address;
            }
            catch (Ashita::ErrorHandling::Exception&)
            {
                return defaultReturn;
            }
            catch (...)
            {
                return defaultReturn;
            }
        }

        /**
         * Reads a pointer (with the given offset chain) using exception handling to prevent crashes.
         *
         * @param {uintptr_t} base - The base address to begin reading the pointer at.
         * @param {std::vector} offsets - The list of offsets to use while reading into the pointer.
         * @param {bool} firstOffsetBased - True if the first offset is used with the base address, false otherwise.
         * @return {uintptr_t} The read pointer value on success, 0 otherwise.
         */
        static uintptr_t SafeReadPtr(const uintptr_t base, const std::vector<int32_t> offsets, const bool firstOffsetBased)
        {
            const auto translator = Ashita::ErrorHandling::ScopedTranslator();

            // Validate the base address..
            if (base == 0)
                return 0;

            try
            {
                uintptr_t pointer = 0;

                // Handle based offset differently..
                if (firstOffsetBased)
                {
                    // Ensure any offsets exist..
                    if (offsets.size() == 0)
                        return 0;

                    // Read the initial pointer..
                    pointer = *(uint32_t*)(base + offsets[0]);
                    if (pointer == 0)
                        return 0;
                }

                // Walk and read the pointer from the given offsets..
                for (std::size_t x = firstOffsetBased ? 1 : 0; x < offsets.size(); x++)
                {
                    if (pointer == 0)
                        return 0;

                    pointer = *(uint32_t*)(pointer + offsets[x]);
                }

                return pointer;
            }
            catch (Ashita::ErrorHandling::Exception&)
            {
                return 0;
            }
            catch (...)
            {
                return 0;
            }
        }
    };

} // namespace Ashita

#endif // ASHITA_SDK_MEMORY_H_INCLUDED