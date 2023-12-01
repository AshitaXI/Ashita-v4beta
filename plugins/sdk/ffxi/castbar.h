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

#ifndef ASHITA_SDK_FFXI_CASTBAR_H_INCLUDED
#define ASHITA_SDK_FFXI_CASTBAR_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off

#include <cinttypes>

namespace Ashita::FFXI
{
    struct castbar_t
    {
        // CTkMenuPrimitive
        uintptr_t   VTablePointer;
        uintptr_t   m_BaseObj;
        uintptr_t   m_pParentMCD;
        uint8_t     m_InputEnable;
        uint8_t     Unknown0000;
        uint16_t    m_SaveCursol;
        uint8_t     m_Reposition;
        uint8_t     Unknown0001[3];

        float       Max;            // The maximum value of the bar to count down from.
        float       Count;          // The current value of the bar, starting from CastBarMax and counting down to 0.
        float       Percent;        // The current cast value of the bar ranging from 0.0 to 1.0 as a float.
        uint32_t    CastType;       // The casting type that caused the menu to be opened. [0 = Magic, 1 = Items, 4 = ???]
    };

} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_CASTBAR_H_INCLUDED