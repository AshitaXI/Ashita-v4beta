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

#include <cinttypes>

namespace Ashita::FFXI
{
    struct arrowposition_t
    {
        float           X;
        float           Z;
        float           Y;
        float           W;
    };

    // CKaTarget
    struct targetentry_t
    {
        uint32_t        Index;                  // The target index.
        uint32_t        ServerId;               // The target server id.
        uintptr_t       EntityPointer;          // The target entity pointer.
        uintptr_t       ActorPointer;           // The target actor pointer.
        arrowposition_t ArrowPosition;          // The target arrow position. [IsArrowActive must be 1 to use this.]
        uint8_t         IsActive;               // Flag if the target is active.
        uint8_t         IsModelActor;           // Flag if the target entity is a model actor.
        uint8_t         IsArrowActive;          // Flag if the target free-floating arrow is active.
        uint8_t         Unknown0000;            // Unknown [Always 0x7F]
        uint16_t        Checksum;               // The target checksum.
        uint16_t        Unknown0001;            // Unknown [This used to be a mask of some sort.]
    };

    // CTkInputCtrl
    struct target_t
    {
        targetentry_t   Targets[2];             // m_MainTarget, m_OldTarget
        uint8_t         IsWalk;                 // Flag if the character is walking instead of running.
        uint8_t         IsAutoNotice;           // Flag if the game will automatically lock onto targets when engaging them. [The game refers to 'Locked On' as 'Notice'.]
        uint8_t         IsSubTargetActive;      // Flag if the sub target is active.
        uint8_t         DeactivateTarget;       // Flag if 1 will undo one step of the targeting windows.
        uint8_t         ModeChangeLock;         // Flag used when changing the menu locks while targeting.
        uint8_t         IsMouseRequestStack;    // Flag used in relation to the mouse.
        uint8_t         IsMouseRequestCancel;   // Flag used in relation to the mouse.
        uint8_t         IsPlayerMoving;         // Flag that is set whenever the character is moving (or trying to move).
        uint8_t         Unknown0000;            // Unknown [Flag set when targeting / untargeting.]
        uint8_t         Unknown0001;            // Unknown [Flag that changes the area display circle to show on the player instead of target.]
        uint8_t         Unknown0002;            // Unknown
        uint8_t         Unknown0003;            // Unknown
        uint32_t        LockedOnFlags;          // (IsNotice) Flags involved with being locked onto a target. [0x01 = locked on, 0x04 = locked on with sub-target.]
        uint32_t        SubTargetFlags;         // (targetType) Flags involving the sub-targets validity for an action or spell. (See notes below.)
        uint32_t        Unknown0004;            // Unknown [Used when subtarget is active.]
        uint16_t        DefaultMode;            // Unknown [Related to the menu system.]
        uint16_t        MenuTargetLock;         // Unknown [Related to the menu system.]
        uint8_t         ActionTargetActive;     // Flag if the target selection for an action is active.
        uint8_t         ActionTargetMaxYalms;   // The maximum distance of the current target selection in yalms for the given action. (FF means self-targeting only actions.)
        uint8_t         Unknown0005;            // Unknown [Related to action target.]
        uint8_t         Unknown0006;            // Unknown [Similar to ActionTargetActive, set to 1 when selecting a target.]
        uint8_t         Unknown0007;            // Unknown [Related to action target.]
        uint8_t         Unknown0008;            // Unknown [Related to action target.]
        uint8_t         Unknown0009;            // Unknown [Related to action target.]
        uint8_t         Unknown0010;            // Unknown [Related to action target.]
        uint8_t         IsMenuOpen;             // (TargetLock) Flag if any game menu is currently open.
        uint8_t         IsActionAoe;            // Flag if the select target action is aoe or not.
        uint8_t         ActionType;             // The select target action type. (ie. 42 = curing spells.)
        uint8_t         ActionAoeRange;         // The aoe range, in yalms, of the select target action.
        uint32_t        ActionId;               // The select target action id. (ie. 1 = Cure, 2 = Cure 2, etc.)
        uint32_t        ActionTargetServerId;   // The select target server id.
        uint16_t        Unknown0011;            // Unknown [Action related.]
        uint8_t         Unknown0012;            // Unknown [Action related.]
        uint8_t         Unknown0013;            // Unknown [Action related.]
        uint32_t        FocusTargetIndex;       // The current focus target index.
        uint32_t        FocusTargetServerId;    // The current focus target server id.
        float           TargetPosF[4];          // The mouse cursor position relative to the screen center. [Values are -1.0 to 1.0]
        int8_t          LastTargetName[25];     // The name of the entity last taken action on.
        uint8_t         Padding0000[3];         // Padding.
        uint32_t        LastTargetIndex;        // The last target index.       [Last target the player took action on.]
        uint32_t        LastTargetServerId;     // The last target server id.   [Last target the player took action on.]
        uint32_t        LastTargetChecksum;     // The last target checksum.    [Last target the player took action on.]
        uintptr_t       ActionCallback;         // Callback function. [Callback invoked when a given action is selected.]
        uintptr_t       CancelCallback;         // Callback function. [Callback invoked when cancelling an action selection.]
        uintptr_t       MyroomCallback;         // Callback function. [Callback invoked when selecting an exit door within a mog house.]
        uintptr_t       ActionAoeCallback;      // Callback function. [Callback invoked to display the area display for certain AoE actions.]
    };

    /*
    target_t Notes

        SubTargetFlags - This byte flag holds the valid target types that an action or spell can be used to target something with.
                         The bytes set depend on how an action is used. Either via the menu, typed or used with a <st> style token.

        TargetPosF     - This array holds the current mouse deltas from the center of the screen. The center of the screen is treated
                         as coord (0, 0) with each axis ranging from -1.0 to 1.0.
    */

    // CTkTarget
    struct targetwindow_t
    {
        // CTkMenuPrimitive
        uintptr_t       VTablePointer;
        uintptr_t       m_BaseObj;
        uintptr_t       m_pParentMCD;
        uint8_t         m_InputEnable;
        uint8_t         Unknown0000;
        uint16_t        m_SaveCursol;
        uint8_t         m_Reposition;
        uint8_t         Unknown0001[3];

        int8_t          Name[49];               // The targets name. [Window allows for longer than standard name length.]
        uint8_t         Padding0000[3];         // Padding.
        uintptr_t       EntityPointer;          // The targets entity pointer.
        uint16_t        FrameChildrenOffsetX;   // The target window frame children objects x offset.
        uint16_t        FrameChildrenOffsetY;   // The target window frame children objects y offset.
        uint16_t        IconPositionX;          // The target window frame icon position. [Only the x axis is editable live.]
        uint16_t        IconPositionY;          // The target window frame icon position. [Only the x axis is editable live.]
        uint16_t        FrameOffsetX;           // The target window frame x offset. [Not editable live. Another address resets this value.]
        uint16_t        FrameOffsetY;           // The target window frame y offset. [Not editable live. Another address resets this value.]
        uint32_t        Unknown0002;            // Unknown [Position related.]
        uint32_t        LockShape;              // The locked-on CShape object pointer.
        uint32_t        ServerId;               // The targets server id.
        uint8_t         HPPercent;              // The targets health percent.
        uint8_t         DeathFlag;              // Flag that states the target is dead. Dims the health bar and sets it to 0 fill.
        uint8_t         ReraiseFlag;            // Dims the health bar when target is reraising. (Death flag must be set to 1.)
        uint8_t         Padding0001;            // Padding.
        uint32_t        DeathNameColor;         // The target name color used when the target is dead.
        uint8_t         IsWindowLoaded;         // (m_helped) Flag that states if the target window is loaded and finished animating.
        uint8_t         Padding0002[3];         // Padding.
        uint32_t        HelpString;             // The help string to display, if set, when opening the target window.
        uint32_t        HelpTitle;              // The help title to display, if set, when opening the target window. 
        uint32_t        m_pAnkShape[16];        // The target arrow and sub-target arrow Cshape object parts.
        uint8_t         m_Sub;                  // Flag if a sub-target is being selected; causes the sub-target name to show larger.
        uint8_t         Unknown0003;            // Unknown.
        uint8_t         m_AnkNum;               // The shape index to use from m_pAnkShape.
        uint8_t         Unknown0004;            // Unknown.
        int16_t         m_AnkX;                 // The main target arrow X position.
        int16_t         m_AnkY;                 // The main target arrow Y position.
        int16_t         m_SubAnkX;              // The sub target arrow X position.
        int16_t         m_SubAnkY;              // The sub target arrow Y position.
    };
    
} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_TARGET_H_INCLUDED