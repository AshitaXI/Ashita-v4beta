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

#ifndef ASHITA_SDK_FFXI_PLAYER_H_INCLUDED
#define ASHITA_SDK_FFXI_PLAYER_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off

#include <cinttypes>

namespace Ashita::FFXI
{
    struct playerstats_t
    {
        int16_t Strength;
        int16_t Dexterity;
        int16_t Vitality;
        int16_t Agility;
        int16_t Intelligence;
        int16_t Mind;
        int16_t Charisma;
    };

    struct playerresists_t
    {
        int16_t Fire;
        int16_t Ice;
        int16_t Wind;
        int16_t Earth;
        int16_t Lightning;
        int16_t Water;
        int16_t Light;
        int16_t Dark;
    };

    struct combatskill_t
    {
        uint16_t Raw;

        uint16_t GetSkill(void) const { return (uint16_t)(this->Raw & 0x7FFF); }
        bool IsCapped(void)     const { return (this->Raw & 0x8000) == 0 ? false : true; }
    };

    struct craftskill_t
    {
        uint16_t Raw;

        uint16_t GetSkill(void) const { return (this->Raw & 0x1FE0) >> 5; }
        uint16_t GetRank(void)  const { return (uint16_t)(this->Raw & 0x1F); }
        bool IsCapped(void)     const { return (this->Raw & 0x8000) >> 15 == 0 ? false : true; }
    };

    struct combatskills_t
    {
        combatskill_t Unknown;
        combatskill_t HandToHand;
        combatskill_t Dagger;
        combatskill_t Sword;
        combatskill_t GreatSword;
        combatskill_t Axe;
        combatskill_t GreatAxe;
        combatskill_t Scythe;
        combatskill_t Polearm;
        combatskill_t Katana;
        combatskill_t GreatKatana;
        combatskill_t Club;
        combatskill_t Staff;
        combatskill_t Unused0000;
        combatskill_t Unused0001;
        combatskill_t Unused0002;
        combatskill_t Unused0003;
        combatskill_t Unused0004;
        combatskill_t Unused0005;
        combatskill_t Unused0006;
        combatskill_t Unused0007;
        combatskill_t Unused0008;
        combatskill_t AutomatonMelee;
        combatskill_t AutomatonRanged;
        combatskill_t AutomatonMagic;
        combatskill_t Archery;
        combatskill_t Marksmanship;
        combatskill_t Throwing;
        combatskill_t Guarding;
        combatskill_t Evasion;
        combatskill_t Shield;
        combatskill_t Parrying;
        combatskill_t Divine;
        combatskill_t Healing;
        combatskill_t Enhancing;
        combatskill_t Enfeebling;
        combatskill_t Elemental;
        combatskill_t Dark;
        combatskill_t Summon;
        combatskill_t Ninjutsu;
        combatskill_t Singing;
        combatskill_t String;
        combatskill_t Wind;
        combatskill_t BlueMagic;
        combatskill_t Geomancy;
        combatskill_t Handbell;
        combatskill_t Unused0009;
        combatskill_t Unused0010;
    };

    struct craftskills_t
    {
        craftskill_t Fishing;
        craftskill_t Woodworking;
        craftskill_t Smithing;
        craftskill_t Goldsmithing;
        craftskill_t Clothcraft;
        craftskill_t Leathercraft;
        craftskill_t Bonecraft;
        craftskill_t Alchemy;
        craftskill_t Cooking;
        craftskill_t Synergy;
        craftskill_t Riding;
        craftskill_t Digging;
        craftskill_t Unused0000;
        craftskill_t Unused0001;
        craftskill_t Unused0002;
        craftskill_t Unused0003;
    };

    struct abilityrecast_t
    {
        uint16_t    Recast;         // The ability recast timer at the time of use.
        uint8_t     RecastCalc1;    // Calculation related value when determining an abilities current charges and recast timer.
        uint8_t     TimerId;        // The ability recast timer id.
        int16_t     RecastCalc2;    // Calculation related value when determining an abilities current charges and recast timer.
        int16_t     Unknown0000;    // Unknown
    };

    struct mountrecast_t
    {
        uint32_t Recast;
        uint32_t TimerId;
    };

    union unityinfo_t
    {
        uint32_t Raw;
        struct
        {
            uint32_t Faction : 4;
            uint32_t Unknown : 6;
            uint32_t Points : 22;
        } Bits;
    };

    struct jobpointentry_t
    {
        uint16_t CapacityPoints;
        uint16_t Points;
        uint16_t PointsSpent;
    };

    struct jobpointsinfo_t
    {
        uint32_t        Unknown0000;
        jobpointentry_t Jobs[24];
    };

    struct statusoffset_t
    {
        float X;
        float Z;
        float Y;
        float W;
    };

    struct player_t
    {
        uint32_t        HPMax;                                  // The players max health.
        uint32_t        MPMax;                                  // The players max mana.
        uint8_t         MainJob;                                // The players main job id.
        uint8_t         MainJobLevel;                           // The players main job level.
        uint8_t         SubJob;                                 // The players sub job id.
        uint8_t         SubJobLevel;                            // The players sub job level.
        uint16_t        ExpCurrent;                             // The players current experience points.
        uint16_t        ExpNeeded;                              // The players current experience points needed to level.
        playerstats_t   Stats;                                  // The players base stats.
        playerstats_t   StatsModifiers;                         // The players stat modifiers.
        int16_t         Attack;                                 // The players attack.
        int16_t         Defense;                                // The players defense.
        playerresists_t Resists;                                // The players elemental resists.
        uint16_t        Title;                                  // The players title id.
        uint16_t        Rank;                                   // The players rank number.
        uint16_t        RankPoints;                             // The players rank points. [Two values packed.]
        uint16_t        Homepoint;                              // The players homepoint.
        uint32_t        Unknown0000;                            // Unknown (Set from 0x61 packet. Offset: 0x4C) [Potentially BindZoneNo.]
        uint8_t         Nation;                                 // The players nation id.
        uint8_t         Residence;                              // The players residence id.
        uint16_t        SuLevel;                                // The players Superior Equipment level.
        uint8_t         HighestItemLevel;                       // The players highest equipped item level.
        uint8_t         ItemLevel;                              // The players item level. (1 = 100, increases from there. -1 from what the value is in memory.)
        uint8_t         MainHandItemLevel;                      // The players main hand item level.
        uint8_t         RangedItemLevel;                        // The players ranged weapon item level.
        unityinfo_t     UnityInfo;                              // The players unity faction and points.
        uint16_t        UnityPartialPersonalEvalutionPoints;    // The players partial unity personal evaluation points.
        uint16_t        UnityPersonalEvaluationPoints;          // The players personal unity evaluation points.
        uint32_t        UnityChatColorFlag;                     // Alters the color of the unity faction name when the chat bar is open for /unity chat.
        uint8_t         MasteryJob;                             // The players set Mastery job id.
        uint8_t         MasteryJobLevel;                        // The players current Mastery job level.
        uint8_t         MasteryFlags;                           // Flags that control how the Mastery system works and displays information.
        uint8_t         MasteryUnknown0000;                     // Unknown [Potentially padding.]
        uint32_t        MasteryExp;                             // The players current Mastery job experience points.
        uint32_t        MasteryExpNeeded;                       // The players current Mastery job experience points needed to level. 
        combatskills_t  CombatSkills;                           // The players combat skills.
        craftskills_t   CraftSkills;                            // The players crafting skills.
        abilityrecast_t AbilityInfo[31];                        // The players ability recast information.
        mountrecast_t   MountRecast;                            // The players mount recast information.
        uint8_t         DataLoadedFlags;                        // Flags that control what player information has been populated. Controls text visiiblity in player menus, unity information, etc.
        uint8_t         Unknown0001;                            // Unknown [Potentially padding.]
        uint16_t        LimitPoints;                            // The players current limit points.
        uint16_t        MeritPoints: 7;                         // The players current merit points.
        uint16_t        AssimilationPoints: 6;                  // The players assimilation points.
        uint16_t        IsLimitBreaker: 1;                      // Flag if the player has unlocked earning merit points.
        uint16_t        IsExperiencePointsLocked: 1;            // Flag if the player has max experience points. (Also set to 1 if limit mode is enabled.)
        uint16_t        IsLimitModeEnabled: 1;                  // Flag if the player has limit mode enabled.
        uint8_t         MeritPointsMax;                         // The players max merits.
        uint8_t         Unknown0002[3];                         // Unknown [Set with MeritPointsMax, looks to be just junk.]
        uint16_t        Unknown0003;                            // Unknown
        jobpointsinfo_t JobPoints;                              // The players current job point information.
        uint8_t         HomepointMasks[64];                     // The players known homepoints. [Bitpacked masks.]
        int16_t         StatusIcons[32];                        // The players status icons used for status timers.
        uint32_t        StatusTimers[32];                       // The players status timers.
        uint8_t         Unknown0004[32];                        // Unknown [Set from 0x63 packet, case 0x0A.]
        uint32_t        IsZoning;                               // Flag if the player is zoning and the client should send an 0x0C request.
        statusoffset_t  StatusOffset1;                          // Status based movement offsets.
        statusoffset_t  StatusOffset2;                          // Status based movement offsets.
        statusoffset_t  StatusOffset3;                          // Status based movement offsets.
        statusoffset_t  StatusOffset4;                          // Status based movement offsets.
        uint32_t        Unknown0005;                            // Unknown [Set from 0x10E packet, casted to a double later in usages.]
        uint32_t        Unknown0006;                            // Unknown
        int16_t         Buffs[32];                              // The players current status effect icon ids.
    };

    constexpr auto pos_ = offsetof(player_t, Buffs);

} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_PLAYER_H_INCLUDED