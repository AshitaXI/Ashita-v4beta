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

#ifndef ASHITA_SDK_FFXI_ENTITY_H_INCLUDED
#define ASHITA_SDK_FFXI_ENTITY_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off
// ReSharper disable CppUnusedIncludeDirective

#include <cinttypes>

namespace Ashita::FFXI
{
    struct position_t
    {
        float           X;
        float           Z;
        float           Y;
        float           Unknown0000;            // Unknown [Always 1.]
        float           Roll;
        float           Yaw;
        float           Pitch;
    };

    struct move_t
    {
        float           X;
        float           Z;
        float           Y;
        float           Unknown0000;            // Unknown [Always 1.]
    };

    struct movement_t
    {
        position_t      LocalPosition;
        float           Unknown0000;            // Unknown [Always 1.]
        position_t      LastPosition;
        uint32_t        Unknown0001;            // Unknown
        move_t          Move;
    };

    struct look_t
    {
        uint16_t        Hair;                   // Hair Style
        uint16_t        Head;                   // Head Armor       (Starts at 0x1000)
        uint16_t        Body;                   // Body Armor       (Starts at 0x2000)
        uint16_t        Hands;                  // Hands Armor      (Starts at 0x3000)
        uint16_t        Legs;                   // Legs Armor       (Starts at 0x4000)
        uint16_t        Feet;                   // Feet Armor       (Starts at 0x5000)
        uint16_t        Main;                   // Main Weapon      (Starts at 0x6000)
        uint16_t        Sub;                    // Sub Weapon       (Starts at 0x7000)
        uint16_t        Ranged;                 // Ranged Weapon    (Starts at 0x8000)
        uint8_t         Unknown0000[14];        // Unknown [Part of the entity look block based on the entity creation setup.]
    };

    struct render_t
    {
        uint32_t        Flags0;                 // Main Render Flags
        uint32_t        Flags1;                 // Name Flags (Party, Away, Anon)
        uint32_t        Flags2;                 // Name Flags (Bazaar, GM Icon, etc.)
        uint32_t        Flags3;                 // Entity Flags (Shadow)
        uint32_t        Flags4;                 // Name Flags (Name Visibility)
        uint32_t        Flags5;                 // Geomancer Indi's
        uint32_t        Flags6;                 // Unknown
        uint32_t        Flags7;                 // Overhead Flags (Hi-word: Jump Emote, Model Visibility etc.) (Low-word: Job Mastery Stars, Party Seek Mastery Star, etc. [Low-Byte:] Timer of some sort.)
    };

    struct entity_t
    {
        uintptr_t       VTablePointer;          // The base CYyObject VTable pointer.
        movement_t      Movement;               // The entities various movement information.
        uint8_t         Unknown0000[32];        // Unknown [Misc floats used for position updates.]
        uint32_t        TargetIndex;            // The entities target index.
        uint32_t        ServerId;               // The entities server id.
        int8_t          Name[28];               // The entities name. [Last 4 bytes are used as a flag for some entities.]
        float           MovementSpeed;          // The entities movement speed.
        float           AnimationSpeed;         // The entities animation speed.
        uintptr_t       WarpPointer;            // The entities warp pointer. [Points to the entities model and editable movement information.]
        uintptr_t       Attachments[12];        // The entities attachments. [ie. CXiSkeletonActor - Used with things such as GEO Indi's.]
        uintptr_t       EventPointer;           // The entities event pointer. [Points to the XiEvent object that is being processed for the current event the entity is in.]
        float           Distance;               // The entities distance to the local player.
        uint32_t        Unknown0001;            // Unknown [0x64 - Used with movement calculations while talking to npcs during events.]
        uint32_t        Unknown0002;            // Unknown [0x64 - Used with movement calculations while talking to npcs during events.]
        float           Heading;                // The entities heading direction. (Yaw)
        uintptr_t       Unknown0003;            // Unknown [Used to be pet owner id, set to the entity pointer you are closest to within 1.2 yalms.]
        uint8_t         HPPercent;              // The entities health percent.
        uint8_t         Unknown0004;            // Unknown [Used to be pet mp percent, not used anymore.]
        uint8_t         Type;                   // The entities object type. [0 = PC, 1 = NPC, 2 = NPC (Fixed Models), 3 = Doors etc.]
        uint8_t         Race;                   // The entities race id.
        uint16_t        Unknown0005;            // Unknown [Used for position updates, set usually when the entity is moving. Used as a countdown.]
        uint16_t        Unknown0006;            // Unknown [Used to constantly validate the entity for something. Prevents model updates if set.]
        uint16_t        ModelUpdateFlags;       // The entities update flags when the model is being refreshed. (ie. Gear swaps.)
        uint8_t         Unknown0007[6];         // Unknown [Some parts seem used, unsure what for. Trusts generally have the second byte as 255.]
        look_t          Look;                   // The entities model appearance information.
        uint16_t        ActionTimer1;           // The entities action timer. (1)
        uint16_t        ActionTimer2;           // The entities action timer. (2)
        render_t        Render;                 // The entities various render flags.
        uint16_t        PopEffect;              // The entities pop effect. [3 and 6 are valid values. Calls function with 'pop0' or 'pop1' effect.]
        uint16_t        InteractionTargetIndex; // The target index of the entities last interaction target. (When talking to an npc, it will set it to your local target index for them to look at you.)
        uint16_t        NpcSpeechFrame;         // The frame of the entities current speech event. (Usually set to 6 when first talking.)
        uint16_t        Unknown0008;            // Unknown
        uint16_t        Unknown0009;            // Unknown
        uint16_t        Unknown0010;            // Unknown
        uint16_t        Unknown0011;            // Unknown
        uint16_t        CraftTimerUnknown;      // Unknown timer based value that is converted to a float. (Updated from synthesis animation packet. Incoming 0x0030)
        uint32_t        CraftServerId;          // The server id of the parent entity causing this entity to synth.
        uint16_t        CraftAnimationEffect;   // The crafting animation effect. (If >= 100, -0x235B otherwise +0x1330 for the true id.)
        uint8_t         CraftAnimationStep;     // The crafting animation step. [Crystal Animation order: 0 (start), 10 (sit), 11, 1, 2 or 4, 3]
        uint8_t         CraftParam;             // The crafting animation parameter. [0 = NQ, 1 = Break, 2 = HQ, etc.]
        float           MovementSpeed2;         // The entities movement speed. (Editable)
        uint16_t        NpcWalkPosition1;       // The entities walk delta position.
        uint16_t        NpcWalkPosition2;       // The entities walk delta position.
        uint16_t        NpcWalkMode;            // The entities walk mode.
        uint16_t        CostumeId;              // The entities costume id.
        uint32_t        Mou4;                   // Unknown [Always 'mou4'.]
        uint32_t        StatusServer;           // The entities status. (Updated from character update packet. Incoming 0x0037)
        uint32_t        Status;                 // The entities status. (Synced from StatusServer, main status value used in the client for most validations.)
        uint32_t        StatusEvent;            // The entities status. (Used while talking to an npc / in an event.)
        uint32_t        Unknown0012;            // Unknown
        uint32_t        Unknown0013;            // Unknown
        uint32_t        Unknown0014;            // Unknown
        uint32_t        Unknown0015;            // Unknown
        uint32_t        ClaimStatus;            // The entities current claim information / last claimed info for dead entities. [Low-word holds the claimer server id. High-word is a 0/1 flag.]
        uint32_t        ZoneId;                 // The entities zone id. (This is only set for the local player under certain conditions.)
        uint32_t        Animations[10];         // The entities animations.
        uint16_t        AnimationTime;          // The current time/duration of the animation. (ie. Counts up while walking.)
        uint16_t        AnimationStep;          // The current step of the animation. [Set via: rand() % 600 + 600]
        uint8_t         AnimationPlay;          // Flag used to cause the entities set animation to play. [6 = Sit/Stand, 12 = Play Emote, 21 = Sit, etc.]
        uint8_t         Unknown0016;            // Unknown [Animation related flag, used with mounts.]
        uint16_t        EmoteTargetIndex;       // The target index of the entity that is the target of the emote.
        uint16_t        EmoteId;                // The emote id of the emote the entity is performing.
        uint16_t        Unknown0017;            // Unknown [Assumed emote related, does not appear to be used.]
        uint32_t        EmoteIdString;          // The string id of the emote.
        uintptr_t       EmoteTargetWarpPointer; // The target warp pointer of the entity that is the target of the emote.
        uint32_t        Unknown0018;            // Unknown [Emote related, set and read when an emote is used.]
        uint32_t        SpawnFlags;             // The entities spawn flags. [0x01 = PC, 0x02 = NPC, 0x10 = Mob, 0x0D = Local Player]
        uint32_t        LinkshellColor;         // The entities linkshell color. [BGR format, alpha is ignored.]
        uint16_t        NameColor;              // The entities name color. [Predefined numerical codes are used.]
        uint16_t        CampaignNameFlag;       // The entities campaign name flag. [If enabled, shows the sword icon next to the entities name.]
        int32_t         FishingUnknown0000;     // Unknown (Old fishing system?) [Timer used to handle fishing action packet sends.] [Set via: rand() % 601 + 900] [Sends 0x66 packet if <= 0.]
        int32_t         FishingUnknown0001;     // Unknown (Old fishing system?) [Set to 0xB4 when you start fishing, then altered depending on how the fishing results.] [Sends 0x66 packet if <= 0.]
        int32_t         FishingActionCountdown; // The countdown until a fish either bits or not. [Sends 0x110 packet if <= 0.]
        int16_t         FishingRodCastTime;     // The countdown until the rod cast animation finishes and the client tells the server you are fishing. [Sends 0x110 packet if <= 0.]
        int16_t         FishingUnknown0002;     // Unknown [Set to 1800 when fishing.] [Sends 0x110 packet if <= 0.]
        uint8_t         Unknown0019[12];        // Unknown [First 8 bytes are used during events, seems to be checked as warp pointers.]
        uint16_t        TargetedIndex;          // The target index of the entities target. [Not always populated. Not populated for local player.]
        uint16_t        PetTargetIndex;         // The entities pet target index.
        uint16_t        UpdateRequestDelay;     // Timer used to delay 0x16 packet requests when IsDirty is set to true.
        uint8_t         IsDirty;                // Flag used to mark the entity dirty and requires a forced update. [Sends a 0x16 packet when set to 1 and UpdateRequestDelay hits 0.]
        uint8_t         BallistaFlags;          // The entities Ballista flags. [Handles setting the players name icon, name color, and displaying the game score.]
        uint8_t         PankrationEnabled;      // Flag used with Pankration.
        uint8_t         PankrationFlagFlip;     // Flag used with Pankration.
        uint16_t        Unknown0020;            // Unknown [Used with the 2nd entity attachment; timer value when a player casts an indi spell.]
        float           ModelSize;              // The entities model size. [Generally -1 as default.]
        float           Unknown0021;            // Unknown [Set from player updates, value is (uint8_t)data * 0.10. Read and used when attacking something and selecting a sub-target to switch to.]
        uint32_t        Unknown0022;            // Unknown
        uint16_t        MonstrosityFlag;        // The entities monstrosity enabled flag.
        uint16_t        MonstrosityNameId;      // The entities monstrosity name id if enabled. [High-byte used as 0/1 flag for 2nd name table.]
        int8_t          MonstrosityName[32];    // The entities monstrosity name if enabled.
        uint8_t         Unknown0023;            // Unknown [Forced to 0 when the monstrosity name is set.]
        uint8_t         MonstrosityNameAbbr[24];// The entities monstrosity name abbreviation.
        uint8_t         Unknown0024[3];         // Unknown
        uint8_t         Unknown0025[44];        // Unknown
        uint8_t         Unknown0026[36];        // Unknown
        uint16_t        FellowTargetIndex;      // The target index of the entities adventuring fellow.
        uint16_t        WarpTargetIndex;        // The target index to follow or warp to. (If used on local player you will warp instantly to the target index. Use with caution!)
        uint16_t        Unknown0027;            // Unknown
        uint16_t        Unknown0028;            // Unknown [Set to a target index based on the last action / selection arrow target.]
        uint32_t        Unknown0029;            // Unknown
    };

} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_ENTITY_H_INCLUDED