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

#ifndef ASHITA_SDK_FFXI_ENTITY_H_INCLUDED
#define ASHITA_SDK_FFXI_ENTITY_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off

#include <cinttypes>

namespace Ashita::FFXI
{
    struct position_t
    {
        float           X;
        float           Z;
        float           Y;
        float           W;
        float           Roll;
        float           Yaw;
        float           Pitch;
        float           Unknown0000;
    };

    struct move_t
    {
        float           X;
        float           Z;
        float           Y;
        float           W;
        float           DeltaX;         // (LastPosition.X - LocalPosition.X) / LocalMoveCount
        float           DeltaZ;         // (LastPosition.Z - LocalPosition.Z) / LocalMoveCount
        float           DeltaY;         // (LastPosition.Y - LocalPosition.Y) / LocalMoveCount
        float           DeltaW;
        float           DeltaRoll;      // (LastPosition.Roll - LocalPosition.Roll) * 0.0625
        float           DeltaYaw;       // (LastPosition.Yaw - LocalPosition.Yaw) * 0.0625
        float           DeltaPitch;     // (LastPosition.Pitch - LocalPosition.Pitch) * 0.0625
        float           Unknown0000;
    };

    struct movement_t
    {
        position_t      LocalPosition;
        position_t      LastPosition;
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
        uint32_t        Flags8;                 // Overhead Flags (Job mastery party.)
    };

    struct entity_t
    {
        uintptr_t       VTablePointer;          // The base CYyObject VTable pointer.
        movement_t      Movement;               // The entities various movement information.
        uint32_t        TargetIndex;            // The entities target index.
        uint32_t        ServerId;               // The entities server id.
        int8_t          Name[28];               // The entities name. [Last 4 bytes are used as a flag for some entities.]
        float           MovementSpeed;          // The entities movement speed.
        float           AnimationSpeed;         // The entities animation speed.
        uintptr_t       ActorPointer;           // The entities actor pointer.
        uintptr_t       Attachments[12];        // The entities attachments. [ie. CXiSkeletonActor - Used with things such as GEO Indi's.]
        uintptr_t       EventPointer;           // The entities event pointer. [Points to the XiEvent object that is being processed for the current event the entity is in.]
        float           Distance;               // The entities distance to the local player.
        uint32_t        TurnSpeed;              // The entities speed in which they will turn to talk to/interact with something. [Default: 0x64, Set in event VM opcode: 0x0059]
        uint32_t        TurnSpeedHead;          // The entities speed in which they will turn their head and look at something. [Default: 0x64, Set in event VM opcode: 0x0059]
        float           Heading;                // The entities heading direction. (Yaw)
        uintptr_t       Next;                   // Set to the entity pointer you are closest to within 1.2 yalms. Used as a linked list if you are close to multiple entities.
        uint8_t         HPPercent;              // The entities health percent.
        uint8_t         Unknown0000;            // Unknown [Used to be pet mp percent, not used anymore.]
        uint8_t         Type;                   // The entities object type. [0 = PC, 1 = NPC, 2 = NPC (Fixed Models), 3 = Doors etc.]
        uint8_t         Race;                   // The entities race id.
        uint16_t        LocalMoveCount;         // The entities local movement counter used to handle delta movement calculations.
        uint16_t        ActorLockFlag;          // The entities lock flag. If set, the entity will ignore model updates from gear changes.
        uint16_t        ModelUpdateFlags;       // The entities update flags when the model is being refreshed. (ie. Gear swaps.)
        uint16_t        Unknown0001;            // Unknown [Some parts seem used, unsure what for. Trusts generally have the second byte as 255.]
        uint32_t        DoorId;                 // The entities door id, if entity is a door. (ie. _6er)
        look_t          Look;                   // The entities model appearance information.
        uint16_t        ActionTimer1;           // The entities action timer. [The action lock count.]
        uint16_t        ActionTimer2;           // The entities action timer. [The action lock timeout.]
        render_t        Render;                 // The entities various render flags.
        uint8_t         PopEffect;              // The entities pop effect. [3 and 6 are valid values. Calls function with 'pop0' or 'pop1' effect.]
        uint8_t         UpdateMask;             // The entities last update mask sent in an 0x000D or 0x000E packet that updated this information.
        uint16_t        InteractionTargetIndex; // The target index of the entities last interaction target. (When talking to an npc, it will set it to your local target index for them to look at you.)
        uint16_t        NpcSpeechFrame;         // The frame of the entities current speech event. (Usually set to 6 when first talking.)
        uint16_t        LookAxisX;              // The entities look axis X. (Direction their head is set to look at when Render.Flags3 has a specific flag set.) [Set in event VM opcode: 0x0079]
        uint16_t        LookAxisY;              // The entities look axis Y. (Direction their head is set to look at when Render.Flags3 has a specific flag set.) [Set in event VM opcode: 0x0079]
        uint16_t        MouthCounter;           // The entities mouth movement counter.
        uint16_t        MouthWaitCounter;       // The entities mouth movement wait counter.
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
        uint32_t        Mou4;                   // Unknown animation fourcc.
        uint32_t        StatusServer;           // The entities status. (Updated from character update packet. Incoming 0x0037)
        uint32_t        Status;                 // The entities status. (Synced from StatusServer, main status value used in the client for most validations.)
        uint32_t        StatusEvent;            // The entities status. (Used while talking to an npc / in an event.)
        uint32_t        Unknown0002;            // Unknown [PS2: Potentially ActorStatus]
        uint32_t        Unknown0003;            // Unknown [PS2: Potentially CliStatus]
        uint32_t        ModelTime;              // The entities model time. [ie. Used with elevators for their lift animations.]
        uint32_t        ModelStartTime;         // The entities model start time. [ie. Used with elevators for their lift animations.]
        uint32_t        ClaimStatus;            // The entities current claim information / last claimed info for dead entities. [Low-word holds the claimer server id. High-word is a 0/1 flag.]
        uint32_t        ZoneId;                 // The entities zone id. (This is only set for the local player under certain conditions.)
        uint32_t        Animations[10];         // The entities animations.
        uint16_t        AnimationTime;          // The current time/duration of the animation. (ie. Counts up while walking.)
        uint16_t        AnimationStep;          // The current step of the animation. [Set via: rand() % 600 + 600]
        uint8_t         AnimationPlay;          // Flag used to cause the entities set animation to play. [6 = Sit/Stand, 12 = Play Emote, 21 = Sit, etc.]
        uint8_t         Unknown0004;            // Unknown [Unlocks the players model from their mount, allowing them to move freely with the mount remaining where it was when this flag was enabled.]
        uint16_t        EmoteTargetIndex;       // The target index of the entity that is the target of the emote.
        uint16_t        EmoteId;                // The emote id of the emote the entity is performing.
        uint16_t        Unknown0005;            // Unknown [Potentially padding now for alignment. Does not appear to be used/referenced.]
        uint32_t        EmoteIdString;          // The string id of the emote.
        uintptr_t       EmoteTargetActorPointer;// The target actor pointer of the entity that is the target of the emote.
        uint32_t        Unknown0006;            // Unknown [Emote related, set and read when an emote is used. Incremented or set to 0. Can be set to 150 or 151 directly as well.]
        uint32_t        SpawnFlags;             // The entities spawn flags. [0x01 = PC, 0x02 = NPC, 0x10 = Mob, 0x0D = Local Player]
        uint32_t        LinkshellColor;         // The entities linkshell color. [BGR format, alpha is ignored.]
        uint16_t        NameColor;              // The entities name color. [Predefined numerical codes are used.]
        uint8_t         CampaignNameFlag;       // The entities campaign name flag. [If enabled, shows the sword icon next to the entities name.]
        uint8_t         MountId;                // The entities mount id. [Used when status is 85.]
        int32_t         FishingUnknown0000;     // Unknown [Action countdown timer used to delay fishing action packets. Set via: rand() % 601 + 900, sends 0x66 packet if <= 0] [This works similar to FishingActionCountdown.]
        int32_t         FishingUnknown0001;     // Unknown [Used as two WORD timer values. LOWORD to 180 when fishing starts. HIWORD set to 1800 when FishingUnknown0000 <= 0. Sends 0x66 packet to finish fishing if <= 0 with stamina set to 201.] [This works similar to FishingRodCastTime.]
        int32_t         FishingActionCountdown; // The countdown until a fish either bits or not. [Sends 0x110 packet if <= 0.]
        int16_t         FishingRodCastTime;     // The countdown until the rod cast animation finishes and the client tells the server you are fishing. [Sends 0x110 packet if <= 0.]
        int16_t         FishingUnknown0002;     // Unknown [Set to 1800 when FishingActionCountdown is <= 0. Sends 0x110 packet to finish fishing if <= 0 with stamina set to 201.]
        uint32_t        LastActionId;           // The entities last action id. [For example, talking to some NPCs will set this to tlk0. Set within the event VM opcode handlers.]
        uint32_t        Unknown0007;            // Unknown [Has one usage but seems unused otherwise, usage is not referenced either.]
        uintptr_t       LastActionActorPointer; // The actor pointer used with LastActionId.
        uint16_t        TargetedIndex;          // The target index of the entities target. [Not always populated. Not populated for local player.]
        uint16_t        PetTargetIndex;         // The entities pet target index.
        uint16_t        UpdateRequestDelay;     // Timer used to delay 0x16 packet requests when IsDirty is set to true.
        uint8_t         IsDirty;                // Flag used to mark the entity dirty and requires a forced update. [Sends a 0x16 packet when set to 1 and UpdateRequestDelay hits 0.]
        uint8_t         BallistaFlags;          // The entities Ballista flags. [Handles setting the players name icon, name color, and displaying the game score.]
        uint8_t         PankrationEnabled;      // Flag used with Pankration.
        uint8_t         PankrationFlagFlip;     // Flag used with Pankration.
        uint16_t        Unknown0008;            // Unknown [Used with Attachments[1] as a timer when the entity uses an Indi spell.]
        float           ModelSize;              // The entities model size. [Generally -1 as default.]
        float           ModelHitboxSize;        // The entities model hitbox size. [Sent in packets: 0x0D, 0x0E, 0x37. Calculated as: (uint8_t)data * 0.10]
        uint32_t        EnvironmentAreaId;      // The entities environment area id. Used to override how the entity should be colored and how light affects the model. [Set in event VM opcode: 0x00AE]
        uint16_t        MonstrosityFlag;        // The entities monstrosity enabled flag.
        uint16_t        MonstrosityNameId;      // The entities monstrosity name id. [Used as two separate bytes. Each byte is used as a name prefix to be added to the main name.]
        int8_t          MonstrosityName[32];    // The entities monstrosity name if enabled.
        uint8_t         MonstrosityNameEnd;     // The entities monstrosity name end. [Used as a null terminator in the event a name gets too long and overflows the buffer.]
        uint8_t         MonstrosityNameAbbr[24];// The entities monstrosity name abbreviation.
        uint8_t         MonstrosityNameAbbrEnd; // The entities monstrosity name abbreviation end. [Used as a null terminator in the event a name gets too long and overflows the buffer.]
        uint16_t        Unknown0009;            // Unknown [Potentially padding now for alignment.]
        uint8_t         CustomProperties[44];   // The entities custom properties. [This can be used for various things such as chocobo look customizations. (color, feather changes, etc.)]
        uint8_t         BallistaInfo[36];       // Ballista information that the entity has been sent.
        uint16_t        FellowTargetIndex;      // The target index of the entities adventuring fellow.
        uint16_t        WarpTargetIndex;        // The target index to follow or warp to. (If used on local player you will warp instantly to the target index. Use with caution!)
        uint16_t        TrustOwnerTargetIndex;  // The owner target index. [Trusts have this set to their owners target index.]
        uint16_t        AreaDisplayTargetIndex; // The entities area display target index. [This is only set for the local player; used as the 'Area Display' target index to center the displayed circle around.]
        uint32_t        Unknown0010;            // Unknown [Appears to be unused now. Set to 0 when an entity is created, then no other uses found.]
    };

} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_ENTITY_H_INCLUDED