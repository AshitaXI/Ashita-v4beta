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

#ifndef ASHITA_SDK_FFXI_TARGET_H_INCLUDED
#define ASHITA_SDK_FFXI_TARGET_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off
// ReSharper disable CppUnusedIncludeDirective

#include <cinttypes>

namespace Ashita::FFXI
{
    struct arrowposition_t
    {
        float           X;
        float           Z;
        float           Y;
        uint32_t        Unknown;                // Doesn't seem to be used.
    };

    struct targetentry_t
    {
        uint32_t        Index;                  // The target index.
        uint32_t        ServerId;               // The target server id.
        uintptr_t       EntityPointer;          // The target entity pointer.
        uintptr_t       ActorPointer;           // The target actor pointer.
        arrowposition_t ArrowPosition;          // The target arrow position. [IsArrowActive must be 1 to use this.]
        uint8_t         IsActive;               // Flag if the target is active.
        uint8_t         Unknown0000;            // Unknown [Unknown boolean.]
        uint8_t         IsArrowActive;          // Flag if the target free-floating arrow is active.
        uint8_t         Unknown0001;            // Unknown [Always 0x7F]
        uint16_t        Checksum;               // The target checksum.
        uint16_t        Unknown0002;            // Unknown [This used to be a mask of some sort.]
    };

    struct target_t
    {
        targetentry_t   Targets[2];
        uint8_t         Unknown0000;            // Unknown [Flag read once every ~30 seconds to test for 1.]
        uint8_t         Unknown0001;            // Unknown [Padding? Never used.]
        uint8_t         IsSubTargetActive;      // Flag if the sub target is active.
        uint8_t         DeactivateTarget;       // Flag if 1 will undo one step of the targeting windows.
        uint8_t         Unknown0002;            // Unknown [Flag tested for 0 for unknown purpose.]
        uint8_t         Unknown0003;            // Unknown [Flag constantly written to flipping between 0 and 1. Used when opening/closing the menus with the mouse.]
        uint8_t         Unknown0004;            // Unknown [Flag constantly written to with 0.]
        uint8_t         IsPlayerMoving;         // Flag that is set whenever the character is moving (or trying to move).
        uint8_t         Unknown0005;            // Unknown [Flag set when targeting / untargeting.]
        uint8_t         Unknown0006;            // Unknown [Flag is constantly read.]
        uint8_t         Unknown0007;            // Unknown
        uint8_t         Unknown0008;            // Unknown
        uint32_t        LockedOnFlags;          // Flags involved with being locked onto a target. [0x01 = locked on, 0x04 = locked on with sub-target.]
        uint32_t        SubTargetFlags;         // Flags involving the sub-targets validity for an action or spell. (See notes below.)
        uint32_t        Unknown0009;            // Unknown [Used when subtarget is active.]
        uint16_t        Unknown0010;            // Unknown [Related to the menu system.]
        uint16_t        Unknown0011;            // Unknown [Related to the menu system.]
        uint8_t         ActionTargetActive;     // Flag if the target selection for an action is active.
        uint8_t         ActionTargetMaxYalms;   // The maximum distance of the current target selection in yalms for the given action. (FF means self-targeting only actions.)
        uint8_t         Unknown0012;            // Unknown [Related to action target.]
        uint8_t         Unknown0013;            // Unknown [Similar to ActionTargetActive, set to 1 when selecting a target.]
        uint8_t         Unknown0014;            // Unknown [Related to action target.]
        uint8_t         Unknown0015;            // Unknown [Related to action target.]
        uint8_t         Unknown0016;            // Unknown [Related to action target.]
        uint8_t         Unknown0017;            // Unknown [Related to action target.]
        uint8_t         IsMenuOpen;             // Flag if any game menu is currently open.
        uint8_t         IsActionAoe;            // Flag if the select target action is aoe or not.
        uint8_t         ActionType;             // The select target action type. (ie. 42 = curing spells.)
        uint8_t         ActionAoeRange;         // The aoe range, in yalms, of the select target action.
        uint32_t        ActionId;               // The select target action id. (ie. 1 = Cure, 2 = Cure 2, etc.)
        uint32_t        ActionTargetServerId;   // The select target server id.
        uint8_t         Unknown0018[12];        // Unknown [Target related.]
        float           MouseDistanceX;         // The distance the mouse is from the middle to the edge of the screen on the x axis.
        float           MouseDistanceY;         // The distance the mouse is from the middle to the edge of the screen on the y axis.
    };

    /*
    target_t Notes

        SubTargetFlags - This byte flag holds the valid target types that an action or spell can be used to target something with.
                         The bytes set depend on how an action is used. Either via the menu, typed or used with a <st> style token.

        MouseDistanceX
        MouseDistanceY - These are used to determine the distance of mouse from the center of the screen outward. The center of the
                         screen is considered 0, 0. The range is from -1 to 1 on both axis.
    */

    struct targetwindow_t
    {
        uintptr_t   VTablePointer;              // The target window class VTable pointer.
        uint32_t    Unknown0000;                // Unknown
        uintptr_t   WindowPointer;              // Pointer to the target window object.
        uint32_t    Unknown0001;                // Unknown
        uint8_t     Unknown0002;                // Unknown [Set to 1 each time you initially target something.]
        uint8_t     Unknown0003[3];             // Unknown
        int8_t      Name[48];                   // The targets name. [Client nulls 48 bytes for this when the target object is creataed.]
        uint32_t    Unknown0004;                // Unknown
        uintptr_t   EntityPointer;              // The targets entity pointer.
        uint16_t    FrameChildrenOffsetX;       // The target window frame children objects x offset.
        uint16_t    FrameChildrenOffsetY;       // The target window frame children objects y offset.
        uint32_t    IconPosition;               // The target window frame icon position. [Only the x axis is editable live.]
        uint16_t    FrameOffsetX;               // The target window frame x offset. [Not editable live. Another address resets this value.]
        uint16_t    FrameOffsetY;               // The target window frame y offset. [Not editable live. Another address resets this value.]
        uint32_t    Unknown0005;                // Unknown [Position related.]
        uint32_t    Unknown0006;                // Unknown [Force reset to its value if 0'd upon targeting.]
        uint32_t    ServerId;                   // The targets server id.                   
        uint8_t     HPPercent;                  // The targets health percent.
        uint8_t     DeathFlag;                  // Flag that states the target is dead. Dims the health bar and sets it to 0 fill.
        uint8_t     ReraiseFlag;                // Dims the health bar when target is reraising. (Death flag must be set to 1.)
        uint8_t     Unknown0007;                // Unknown [Alignment?]
        uint32_t    DeathNameColor;             // The target name color used when the target is dead.
        uint8_t     IsWindowLoaded;             // Flag that states if the target window is loaded and finished animating.
        uint8_t     Unknown0008[3];             // Unknown
        uint32_t    Unknown0009;                // Unknown [Time related to the window opening. Seems to be a tm struct ptr.]
    };

} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_TARGET_H_INCLUDED