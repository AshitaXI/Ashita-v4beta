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

#ifndef ASHITA_SDK_REGISTRY_H_INCLUDED
#define ASHITA_SDK_REGISTRY_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#pragma warning(disable : 4505) // unreferenced local function has been removed

#include <Windows.h>
#include <string>
#include <vector>

namespace Ashita
{
    /**
     * Language Id Enumeration
     */
    enum class LanguageId : uint32_t
    {
        Default  = 0,
        Japanese = 1,
        English  = 2,
        European = 3,

        MaxValue
    };

    /**
     * Square Enix Game Id Enumeration
     */
    enum class SquareEnixGameId : uint32_t
    {
        PlayOnline               = 0,
        FinalFantasyXI           = 1,
        TetraMaster              = 2,
        FinalFantasyXITestClient = 3,

        MaxValue
    };

    namespace Registry
    {
        /**
         * Obtains the install path for the given Square Enix game entity.
         *
         * @param {LanguageId} lid - The language id to use for which PlayOnline registry key to look within.
         * @param {SquareEnixGameId} gid - The game entity id to lookup.
         * @param {LPSTR} buffer - The output buffer to store the path.
         * @param {uint32_t} size - The size of the output buffer.
         * @return {bool} True on success, false otherwise.
         */
        static bool GetInstallPath(const LanguageId lid, const SquareEnixGameId gid, const LPSTR buffer, const uint32_t size)
        {
            // Validate the parameters..
            if ((uint32_t)lid < 0 || lid >= LanguageId::MaxValue ||
                (uint32_t)gid < 0 || gid >= SquareEnixGameId::MaxValue ||
                buffer == nullptr || size == 0)
                return false;

            constexpr char tags[4][255] = {"US", "", "US", "EU"};
            constexpr char path[4][255] = {"1000", "0001", "0002", "0015"};

            // Build the initial registry key path to the install folder information..
            char regpath[MAX_PATH]{};
            sprintf_s(regpath, MAX_PATH, "SOFTWARE\\PlayOnline%s\\InstallFolder", tags[(uint32_t)lid]);

            // Open the registry for reading..
            HKEY key = nullptr;
            if (!(::RegOpenKeyExA(HKEY_LOCAL_MACHINE, regpath, 0, KEY_QUERY_VALUE | KEY_WOW64_32KEY, &key) == ERROR_SUCCESS))
                return false;

            // Read the install path from the registry..
            const char ipath[MAX_PATH]{};
            DWORD ksize = MAX_PATH;
            auto ktype  = REG_DWORD;
            if (!(::RegQueryValueExA(key, path[(uint32_t)gid], nullptr, &ktype, (LPBYTE)ipath, &ksize) == ERROR_SUCCESS))
            {
                ::RegCloseKey(key);
                return false;
            }
            ::RegCloseKey(key);

            // Ensure the output buffer is large enough for the path..
            if (strlen(ipath) > size)
                return false;

            // Copy the result into the output buffer..
            strcpy_s(buffer, size, ipath);

            return true;
        }

        /**
         * Returns the value of a registry key from the games registry data.
         *
         * @param {LanguageId} lid - The language id to use for which PlayOnline registry key to look within.
         * @param {const char*} parent - The inner-parent key holding the value to obtain.
         * @param {const char*} keyName - The key name of the value to read.
         * @return {uint32_t} The value of the key on success, 0 otherwise.
         */
        static uint32_t GetValue(const LanguageId lid, const char* parent, const char* keyName)
        {
            // Validate the parameters..
            if ((uint32_t)lid < 0 || lid >= LanguageId::MaxValue)
                return 0;

            constexpr char tags[4][255] = {"US", "", "US", "EU"};

            // Build the path to the registry value..
            char regpath[MAX_PATH]{};
            sprintf_s(regpath, MAX_PATH, "SOFTWARE\\PlayOnline%s\\%s", tags[(uint32_t)lid], parent);

            // Open the registry for reading..
            HKEY key = nullptr;
            if (!(::RegOpenKeyExA(HKEY_LOCAL_MACHINE, regpath, 0, KEY_QUERY_VALUE | KEY_WOW64_32KEY, &key) == ERROR_SUCCESS))
                return 0;

            DWORD ksize = 4;
            auto ktype  = REG_DWORD;
            DWORD value = 0;

            // Read the value..
            if (!(::RegQueryValueExA(key, keyName, nullptr, &ktype, (LPBYTE)&value, &ksize) == ERROR_SUCCESS))
            {
                ::RegCloseKey(key);
                return 0;
            }

            ::RegCloseKey(key);
            return value;
        }

        /**
         * Sets the value of a registry key from the games registry data.
         *
         * @param {LanguageId} lid - The language id to use for which PlayOnline registry key to look within.
         * @param {const char*} parent - The inner-parent key holding the value to write to.
         * @param {const char*} keyName - The key name of the value to write.
         * @return {bool} True on success, false otherwise.
         */
        static bool SetValue(const LanguageId lid, const char* parent, const char* keyName, const uint32_t value)
        {
            // Validate the parameters..
            if ((uint32_t)lid < 0 || lid >= LanguageId::MaxValue)
                return false;

            constexpr char tags[4][255] = {"US", "", "US", "EU"};

            // Build the path to the registry value..
            char regpath[MAX_PATH]{};
            sprintf_s(regpath, MAX_PATH, "SOFTWARE\\PlayOnline%s\\%s", tags[(uint32_t)lid], parent);

            // Open the registry for writing..
            HKEY key = nullptr;
            if (!(::RegOpenKeyExA(HKEY_LOCAL_MACHINE, regpath, 0, KEY_WRITE | KEY_QUERY_VALUE | KEY_WOW64_32KEY, &key) == ERROR_SUCCESS))
                return false;

            // Write the value..
            const auto ret = ::RegSetValueExA(key, keyName, 0, REG_DWORD, (LPBYTE)&value, sizeof(uint32_t));
            ::RegCloseKey(key);

            return ret == ERROR_SUCCESS;
        }
    } // namespace Registry

} // namespace Ashita

#endif // ASHITA_SDK_REGISTRY_H_INCLUDED