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

#ifndef ASHITA_SDK_FFXI_PARTY_H_INCLUDED
#define ASHITA_SDK_FFXI_PARTY_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off

#include <cinttypes>

namespace Ashita::FFXI
{
    struct allianceinfo_t
    {
        uint32_t    AllianceLeaderServerId; // The player server id of the overall alliance leader.
        uint32_t    PartyLeaderServerId1;   // The player server id of the local players party.
        uint32_t    PartyLeaderServerId2;   // The player server id of the top alliance party.
        uint32_t    PartyLeaderServerId3;   // The player server id of the middle alliance party.
        int8_t      PartyVisible1;          // The party visible flag of the local players party.
        int8_t      PartyVisible2;          // The party visible flag of the top alliance party.
        int8_t      PartyVisible3;          // The party visible flag of the middle alliance party.
        int8_t      PartyMemberCount1;      // The party member count of the local players party.
        int8_t      PartyMemberCount2;      // The party member count of the top alliance party.
        int8_t      PartyMemberCount3;      // The party member count of the middle alliance party.
        int8_t      Invited;                // Flag stating if there is a pending invite.
        int8_t      Unknown0000;            // Unknown
    };

    struct partymember_t
    {
        uintptr_t   AllianceInfo;           // Pointer to information regarding the party alliance.
        uint8_t     Index;                  // The party members index. (Index of their current party.)
        uint8_t     MemberNumber;           // The party members number. (Member number of their current party.)
        int8_t      Name[18];               // The party members name.
        uint32_t    ServerId;               // The party members server id.
        uint32_t    TargetIndex;            // The party members target index.
        uint32_t    LastUpdatedTimestamp;   // The timestamp this members entry was last updated.
        uint32_t    HP;                     // The party members current health.
        uint32_t    MP;                     // The party members current mana.
        uint32_t    TP;                     // The party members current TP.
        uint8_t     HPPercent;              // The party members current health percent.
        uint8_t     MPPercent;              // The party members current mana percent.
        uint16_t    Zone;                   // The party members current zone id.
        uint16_t    Zone2;                  // The party members current zone id. (Duplicate, only used if the member is in a different zone that the local player. 0 otherwise.)
        uint16_t    Unknown0000;            // Unknown (Usually 0, 4 when in party with a trust.)
        uint32_t    FlagMask;               // The party members flag mask.
        uint16_t    TreasureLots[10];       // The party members lots.
        uint16_t    MonstrosityItemId;      // The party members monstrosity item id, if set. (Offset the id by 0x7000)
        uint8_t     MonstrosityPrefixFlag1; // The party members monstrosity name prefix flag (1).
        uint8_t     MonstrosityPrefixFlag2; // The party members monstrosity name prefix flag (2).
        uint8_t     MonstrosityName[25];    // The party members monstrosity name buffer. (Overwrites the members name in the party list if set. Updates automatically from the item id field.)
        uint8_t     MainJob;                // The party members main job id.
        uint8_t     MainJobLevel;           // The party members main job level.
        uint8_t     SubJob;                 // The party members sub job id.
        uint8_t     SubJobLevel;            // The party members sub job level.
        uint8_t     Unknown0001[3];         // Unknown
        uint32_t    ServerId2;              // The party members server id. (Duplicate.)
        uint8_t     HPPercent2;             // The party members current health percent. (Duplicate)
        uint8_t     MPPercent2;             // The party members current mana percent. (Duplicate)
        uint8_t     IsActive;               // The party members active state. (1 is active, 0 not active.)
        uint8_t     Unknown0002;            // Unknown (Alignment padding.)
    };

    struct party_t
    {
        partymember_t Members[18];          // The party members.
    };

    struct statusiconsentry_t
    {
        uint32_t    ServerId;               // The entry owner server id.
        uint32_t    TargetIndex;            // The entry owner target index.
        uint64_t    BitMask;                // The icon bitmask for icon ids over 256.
        uint8_t     StatusIcons[32];        // The status icon data. (Bit packed.)
    };

    struct partystatusicons_t
    {
        statusiconsentry_t Members[5];      // The local party members status icon entries.
    };

} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_PARTY_H_INCLUDED