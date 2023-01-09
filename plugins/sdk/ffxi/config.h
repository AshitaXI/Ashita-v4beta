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

#ifndef ASHITA_SDK_FFXI_CONFIG_H_INCLUDED
#define ASHITA_SDK_FFXI_CONFIG_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off
// ReSharper disable CppUnusedIncludeDirective

#include <cinttypes>

/**
 * Misc structures used for various configurations of the client. Some of these structures
 * relate to memory in different parts of the client. (polcore.dll, FFXiMain.dll, etc.)
 *
 * Structures should be marked with as much detail as possible to where they are located
 * and what they include.
 */

namespace Ashita::FFXI::Configurations
{
    /**
     * Module: polcore.dll
     *
     * Auto-disconnection configuration settings.
     */
    struct autodisconnect_t
    {
        uint32_t    IsEnbled;                   // Flag if the auto-disconnect feature is enabled or disabled.
        uint32_t    NextIdleTimeout;            // The next timestamp when the client will auto-disconnect, updated each time there is input to the client. (GetTickCount + the timeout setting offset in milliseconds.)
        uint32_t    Timeout;                    // The idle timeout setting that is currently selected. (In milliseconds.)
        uint32_t    Unknown0000;                // Unknown [Callback function for unknown purpose.]
        uint32_t    Unknown0001;                // Unknown [Callback function for unknown purpose.]
        uint32_t    Unknown0002;                // Unknown [Callback function for unknown purpose.]
    };

    /**
     * Module: FFXiMain.dll
     *
     * Chat language filter configuration settings. (Id: 24)
     */
    struct chatlanguagefilter_t
    {
        uintptr_t   VTablePointer;              // VTable pointer to the settings class.
        uint32_t    Enabled;                    // The chat language filter enabled flag. (0 = Enabled, 1 = Disabled)
        uintptr_t   VulgarDictionaryPointer1;   // Pointer to the vulgar dictionary lookup tables. (Null when disabled.)
        uintptr_t   VulgarDictionaryPointer2;   // Pointer to the vulgar dictionary lookup tables. (Copy. Null when disabled.)
        uint32_t    Vulgar2DictionarySize;      // Size of the vulgar2.dic file.
    };

} // namespace Ashita::FFXI::Configurations

#endif // ASHITA_SDK_FFXI_CONFIG_H_INCLUDED