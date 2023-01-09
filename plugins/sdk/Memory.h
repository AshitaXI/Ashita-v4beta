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

#ifndef ASHITA_SDK_MEMORY_H_INCLUDED
#define ASHITA_SDK_MEMORY_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <Windows.h>
#include <algorithm>
#include <sstream>
#include <string>
#include <vector>

#pragma comment(lib, "Psapi.lib")
#include <Psapi.h>

// ReSharper disable CppTooWideScopeInitStatement

namespace Ashita
{
    template<typename T>
    struct scannableiterator_t
    {
        uintptr_t m_BaseAddress;
        uintptr_t m_Size;

        scannableiterator_t(const scannableiterator_t&) = delete;
        scannableiterator_t(void)                       = delete;

        scannableiterator_t(const uintptr_t base, const uintptr_t size)
            : m_BaseAddress(base)
            , m_Size(size)
        {}

        T* begin(void)
        {
            return (T*)this->m_BaseAddress;
        }

        T* end(void)
        {
            return (T*)(this->m_BaseAddress + this->m_Size);
        }
    };

    class Memory
    {
    public:
        /**
         * Returns the base address of the given module.
         * 
         * @param {const char*} moduleName - The name of the module to obtain the base of.
         * @return {uintptr_t} The module base address on success, 0 otherwise.
         */
        static inline uintptr_t __stdcall GetModuleBase(const char* moduleName)
        {
            const auto handle = ::GetModuleHandleA(moduleName);
            if (handle == nullptr)
                return 0;

            return (uintptr_t)handle;
        }

        /**
         * Returns the size of the given module.
         * 
         * @param {const char*} moduleName - The name of the module to obtain the size of.
         * @return {uintptr_t} The module size on success, 0 otherwise.
         */
        static inline uintptr_t __stdcall GetModuleSize(const char* moduleName)
        {
            const auto handle = ::GetModuleHandleA(moduleName);
            if (handle == nullptr)
                return 0;

            MODULEINFO mod{};
            if (!::GetModuleInformation(::GetCurrentProcess(), handle, &mod, sizeof(MODULEINFO)))
                return 0;

            return mod.SizeOfImage;
        }

        /**
         * Returns the owning module handle of the given address.
         * 
         * @param {uintptr_t} address - The address to find the owning module of.
         * @return {HMODULE} The owning module on success, nullptr otherwise.
         */
        static inline HMODULE __stdcall GetOwningModule(const uintptr_t address)
        {
            if (address == 0)
                return nullptr;

            MEMORY_BASIC_INFORMATION mbi{};
            if (::VirtualQuery((LPCVOID)address, &mbi, sizeof(MEMORY_BASIC_INFORMATION)) == sizeof(MEMORY_BASIC_INFORMATION))
                return (HMODULE)mbi.AllocationBase;

            return nullptr;
        }

    public:
        /**
         * Finds the given pattern within the given address space.
         * 
         * @param {uintptr_t} baseAddress - The address to start searching for the pattern within.
         * @param {uintptr_t} size - The size of data to search within. (Starting from baseAddress.)
         * @param {const char*} pattern - The pattern to search for.
         * @param {intptr_t} offset - The offset to add to the result if the pattern is found.
         * @param {uintptr_t} count - The result count to use if the pattern is known to be found more than once.
         * @return {uintptr_t} The address where the pattern was found on success, 0 otherwise.
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

    public:
        /**
         * Reads the value of the given address.
         * Uses exception handling to prevent crashing on invalid read attempts.
         * 
         * @param {T} <template> - The template data type.
         * @param {uintptr_t} address - The address to read the value of.
         * @param {T} defaultReturn - The default value to return on error.
         * @return {T} The read value on success, defaultReturn otherwise.
         */
        template<typename T>
        static inline T SafeRead(const uintptr_t address, T defaultReturn = T())
        {
            const auto translator = Ashita::ErrorHandling::ScopedTranslator();

            try
            {
                return address == 0 ? defaultReturn : *(T*)address;
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
         * Reads the value of the given pointer path. 
         * Uses exception handling to prevent crashing on invalid read attempts.
         * 
         * @param {T} <template> - The template data type.
         * @param {uintptr_t} address - The address to begin the pointer read from.
         * @param {std::initializer_list} offsets - List of offsets to walk through reading the full pointer path.
         * @param {T} defaultReturn - The default value to return on error.
         * @return {T} The read value on success, defaultReturn otherwise.
         */
        template<typename T>
        static inline T SafeReadPtr(uintptr_t address, const std::initializer_list<int32_t> offsets, T defaultReturn = T())
        {
            const auto translator = Ashita::ErrorHandling::ScopedTranslator();

            if (address == 0)
                return defaultReturn;

            try
            {
                for (auto iter = offsets.begin(), iterend = offsets.end(); iter != iterend; iter++)
                {
                    if (address == 0)
                        return defaultReturn;

                    if ((iter + 1) == iterend)
                        return std::is_pointer<T>::value ? (T)(address + *iter) : *(T*)(address + *iter);
                    else
                        address = *(uint32_t*)(address + *iter);
                }

                return defaultReturn;
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

    public:
        /**
         * Allocates a region of memory.
         * 
         * @param {uintptr_t} address - The address to attempt to begin the allocation at. (0 to use any address available.)
         * @param {uintptr_t} size - The size of the region to allocate.
         * @param {DWORD} protect - The new protection flags to apply to the memory.
         * @return {uintptr_t} The allocated memory pointer on success, 0 otherwise.
         */
        static inline uintptr_t Alloc(const uintptr_t address, const uintptr_t size, const DWORD protect)
        {
            return (uintptr_t)::VirtualAlloc((LPVOID)address, size, MEM_COMMIT, protect);
        }

        /**
         * Deallocates a previously allocated region of memory.
         * 
         * @param {uintptr_t} address - The address to deallocate.
         * @param {uintptr_t} size - The size of the region to deallocate.
         */
        static inline void Free(const uintptr_t address, const uintptr_t size)
        {
            ::VirtualFree((LPVOID)address, size, MEM_DECOMMIT | MEM_RELEASE);
        }

        /**
         * Protects the given region of memory, marking it with the given access rights.
         *
         * @param {uintptr_t} address - The address to protect.
         * @param {uintptr_t} size - The size of the memory region to protect.
         * @param {DWORD} protect - The new protection flags to apply to the memory.
         * @return {DWORD} The previous page protection applied to the region on success, 0 otherwise.
         */
        static inline bool Protect(const uintptr_t address, const uintptr_t size, DWORD protect)
        {
            if (::VirtualProtect((LPVOID)address, size, protect, &protect))
                return protect;

            return 0;
        }

        /**
         * Unprotects the given region of memory, marking it as PAGE_EXECUTE_READWRITE.
         *
         * @param {uintptr_t} address - The address to unprotect.
         * @param {uintptr_t} size - The size of the memory region to unprotect.
         * @return {DWORD} The previous page protection applied to the region on success, 0 otherwise.
         */
        static inline bool Unprotect(const uintptr_t address, const uintptr_t size)
        {
            if (DWORD protect; ::VirtualProtect((LPVOID)address, size, PAGE_EXECUTE_READWRITE, &protect))
                return protect;

            return 0;
        }
    };

} // namespace Ashita

#endif // ASHITA_SDK_MEMORY_H_INCLUDED