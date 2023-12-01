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

#ifndef ASHITA_SDK_FFXI_ENUMS_H_INCLUDED
#define ASHITA_SDK_FFXI_ENUMS_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include <cinttypes>

namespace Ashita::FFXI::Enums
{
    ////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Entity Related Enumerations
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////

    enum class EntityHair : uint32_t
    {
        Hair1A = 0,
        Hair1B,
        Hair2A,
        Hair2B,
        Hair3A,
        Hair3B,
        Hair4A,
        Hair4B,
        Hair5A,
        Hair5B,
        Hair6A,
        Hair6B,
        Hair7A,
        Hair7B,
        Hair8A,
        Hair8B,

        // Non-Player Styles
        Fomar     = 29,
        Mannequin = 30
    };

    enum class EntityRace : uint32_t
    {
        Invalid = 0,
        HumeMale,
        HumeFemale,
        ElvaanMale,
        ElvaanFemale,
        TarutaruMale,
        TarutaruFemale,
        Mithra,
        Galka,

        // Non-Player Races
        MithraChild     = 29,
        HumeChildFemale = 30,
        HumeChildMale   = 31,
        ChocoboGold     = 32,
        ChocoboBlack    = 33,
        ChocoboBlue     = 34,
        ChocoboRed      = 35,
        ChocoboGreen    = 36
    };

    enum class EntitySpawnFlags : uint32_t
    {
        Player         = 0x0001,
        Npc            = 0x0002,
        PartyMember    = 0x0004,
        AllianceMember = 0x0008,
        Monster        = 0x0010,
        Object         = 0x0020,
        Elevator       = 0x0040,
        Airship        = 0x0080,
        LocalPlayer    = 0x0200
    };

    enum class EntityType : uint32_t
    {
        Player   = 0, // Players
        Npc1     = 1, // NPC Entity (Town Folk)
        Npc2     = 2, // NPC Entity (Home Points, Moogles, Coffers, Town Folk, etc.)
        Npc3     = 3, // NPC Entity (Doors, Lights, Unique Objects, Bridges, etc.)
        Elevator = 4, // Elevators
        Airship  = 5  // Airships and Boats
    };

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Inventory Related Enumerations
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////

    enum class Container : uint32_t
    {
        Inventory = 0,
        Safe,
        Storage,
        Temporary,
        Locker,
        Satchel,
        Sack,
        Case,
        Wardrobe,
        Safe2,
        Wardrobe2,
        Wardrobe3,
        Wardrobe4,
        Wardrobe5,
        Wardrobe6,
        Wardrobe7,
        Wardrobe8,
        Recycle,
        Max
    };

    enum class CraftRank : uint32_t
    {
        Amateur = 0,
        Recruit,
        Initiate,
        Novice,
        Apprentice,
        Journeyman,
        Craftsman,
        Artisan,
        Adept,
        Veteran,
        Expert,

        Max
    };

    enum class EquipmentSlot : uint32_t
    {
        Main = 0,
        Sub,
        Range,
        Ammo,
        Head,
        Body,
        Hands,
        Legs,
        Feet,
        Neck,
        Waist,
        Ear1,
        Ear2,
        Ring1,
        Ring2,
        Back,

        Max
    };

    enum class SkillType : uint32_t
    {
        None = 0,

        // Weapon Skills
        HandToHand  = 1,
        Dagger      = 2,
        Sword       = 3,
        GreatSword  = 4,
        Axe         = 5,
        GreatAxe    = 6,
        Scythe      = 7,
        Polarm      = 8,
        Katana      = 9,
        GreatKatana = 10,
        Club        = 11,
        Staff       = 12,

        // Automaton Skills
        AutomatonMelee  = 22,
        AutomatonRanged = 23,
        AutomatonMagic  = 24,

        // Combat Skills
        Archery      = 25,
        Marksmanship = 26,
        Throwing     = 27,
        Guard        = 28,
        Evasion      = 29,
        Shield       = 30,
        Parry        = 31,
        Divine       = 32,
        Healing      = 33,
        Enhancing    = 34,
        Enfeebling   = 35,
        Elemental    = 36,
        Dark         = 37,
        Summoning    = 38,
        Ninjutsu     = 39,
        Singing      = 40,
        String       = 41,
        Wind         = 42,
        BlueMagic    = 43,
        Geomancy     = 44,
        Handbell     = 45,

        // Crafting Skills
        Fishing        = 48,
        Woodworking    = 49,
        Smithing       = 50,
        Goldsmithing   = 51,
        Clothcraft     = 52,
        Leathercraft   = 53,
        Bonecraft      = 54,
        Alchemy        = 55,
        Cooking        = 56,
        Synergy        = 57,
        ChocoboDigging = 58,
    };

    enum class TreasureStatus : uint32_t
    {
        None = 0,
        Pass,
        Lot
    };

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Player Related Enumerations
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////

    enum class Job : uint32_t
    {
        None         = 0,
        Warrior      = 1,
        Monk         = 2,
        WhiteMage    = 3,
        BlackMage    = 4,
        RedMage      = 5,
        Thief        = 6,
        Paladin      = 7,
        DarkKnight   = 8,
        Beastmaster  = 9,
        Bard         = 10,
        Ranger       = 11,
        Samurai      = 12,
        Ninja        = 13,
        Dragoon      = 14,
        Summoner     = 15,
        BlueMage     = 16,
        Corsair      = 17,
        Puppetmaster = 18,
        Dancer       = 19,
        Scholar      = 20,
        Geomancer    = 21,
        RuneFencer   = 22,
        Monstrosity  = 23, // Used during Monstrosity.
    };

    enum class LoginStatus : uint32_t
    {
        LoginScreen = 0,
        Loading     = 1,
        LoggedIn    = 2
    };

    enum class Nation : uint32_t
    {
        SandOria,
        Bastok,
        Windurst
    };

    enum class ViewMode : uint32_t
    {
        ThirdPerson,
        FirstPerson
    };

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Resource Related Enumerations
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////

    enum class AbilityType : uint32_t
    {
        General = 0,
        JobAbility,
        PetCommand,
        WeaponSkill,
        Trait,
        Unused0000 = 5, // Currently unused.
        BloodPactRage,
        Unused0001 = 7, // Currently unused.
        CorsairRoll,
        CorsairShot,
        BloodPactWard,
        DancerSamba,
        DancerWaltz,
        DancerStep,
        DancerFlorish1,
        ScholarStratagem,
        DancerJig,
        DancerFlorish2,
        BeastmasterSic,
        DancerFlorish3,
        MonsterSkill,
        RuneEnhancement,
        RuneWard,
        RuneEffusion,
    };

    enum class CombatType : uint32_t
    {
        Magic  = 0x1000,
        Combat = 0x2000
    };

    enum class EquipmentSlotMask : uint32_t
    {
        None  = 0x0000,
        Main  = 0x0001,
        Sub   = 0x0002,
        Range = 0x0004,
        Ammo  = 0x0008,
        Head  = 0x0010,
        Body  = 0x0020,
        Hands = 0x0040,
        Legs  = 0x0080,
        Feet  = 0x0100,
        Neck  = 0x0200,
        Waist = 0x0400,
        LEar  = 0x0800,
        REar  = 0x1000,
        LRing = 0x2000,
        RRing = 0x4000,
        Back  = 0x8000,

        // Slot Groups
        Ears  = LEar | REar,
        Rings = LRing | RRing,

        // All Slots
        All = 0xFFFF
    };

    enum class ElementColor : uint32_t
    {
        Red,
        Clear,
        Green,
        Yellow,
        Purple,
        Blue,
        White,
        Black
    };

    enum class ElementType : uint32_t
    {
        Fire,
        Ice,
        Air,
        Earth,
        Thunder,
        Water,
        Light,
        Dark,

        Special = 0x0F,
        Unknown = 0xFF
    };

    enum class ItemFlags : uint32_t
    {
        None        = 0x0000,
        WallHanging = 0x0001,
        Flag1       = 0x0002,
        Flag2       = 0x0004,
        Flag3       = 0x0008,
        CanSendPol  = 0x0010, // Can send within POL account.
        Inscribable = 0x0020,
        NoAuction   = 0x0040,
        Scroll      = 0x0080,
        Linkshell   = 0x0100,
        CanUse      = 0x0200,
        CanTradeNpc = 0x0400,
        CanEquip    = 0x0800,
        NoSale      = 0x1000,
        NoDelivery  = 0x2000,
        NoTrade     = 0x4000,
        Rare        = 0x8000,

        Exclusive = NoAuction | NoDelivery | NoTrade,
        Nothing   = Linkshell | NoSale | Exclusive | Rare
    };

    enum class ItemType : uint32_t
    {
        None          = 0,
        Item          = 1,
        QuestItem     = 2,
        Fish          = 3,
        Weapon        = 4,
        Armor         = 5,
        Linkshell     = 6,
        UsableItem    = 7,
        Crystal       = 8,
        Currency      = 9,
        Furnishing    = 10,
        Plant         = 11,
        Flowerpot     = 12,
        PuppetItem    = 13,
        Mannequin     = 14,
        Book          = 15,
        RacingForm    = 16,
        BettingSlip   = 17,
        SoulPlate     = 18,
        Reflector     = 19,
        Logs          = 20,
        LotteryTicket = 21,
        TabulaM       = 22,
        TabulaR       = 23,
        Voucher       = 24,
        Rune          = 25,
        Evolith       = 26,
        StorageSlip   = 27,
        Type1         = 28,
        Unknown0000   = 29,
        Instinct      = 30,
    };

    enum class JobMask : uint32_t
    {
        None  = 0x00000000,
        WAR   = 0x00000002,
        MNK   = 0x00000004,
        WHM   = 0x00000008,
        BLM   = 0x00000010,
        RDM   = 0x00000020,
        THF   = 0x00000040,
        PLD   = 0x00000080,
        DRK   = 0x00000100,
        BST   = 0x00000200,
        BRD   = 0x00000400,
        RNG   = 0x00000800,
        SAM   = 0x00001000,
        NIN   = 0x00002000,
        DRG   = 0x00004000,
        SMN   = 0x00008000,
        BLU   = 0x00010000,
        COR   = 0x00020000,
        PUP   = 0x00040000,
        DNC   = 0x00080000,
        SCH   = 0x00100000,
        GEO   = 0x00200000,
        RUN   = 0x00400000,
        MON   = 0x00800000,
        JOB24 = 0x01000000,
        JOB25 = 0x02000000,
        JOB26 = 0x04000000,
        JOB27 = 0x08000000,
        JOB28 = 0x10000000,
        JOB29 = 0x20000000,
        JOB30 = 0x40000000,
        JOB31 = 0x80000000,

        AllJobs = 0x007FFFFE,
    };

    enum class MagicType : uint32_t
    {
        None       = 0,
        WhiteMagic = 1,
        BlackMagic = 2,
        Summon     = 3,
        Ninjutsu   = 4,
        Song       = 5,
        BlueMagic  = 6,
        Geomancy   = 7,
        Trust      = 8
    };

    enum class PuppetSlot : uint32_t
    {
        None,
        Head,
        Body,
        Attachment
    };

    enum class RaceMask : uint32_t
    {
        None           = 0x0000,
        HumeMale       = 0x0002,
        HumeFemale     = 0x0004,
        ElvaanMale     = 0x0008,
        ElvaanFemale   = 0x0010,
        TarutaruMale   = 0x0020,
        TarutaruFemale = 0x0040,
        Mithra         = 0x0080,
        Galka          = 0x0100,
        Hume           = 0x0006,
        Elvaan         = 0x0018,
        Tarutaru       = 0x0060,

        Male   = 0x012A,
        Female = 0x00D4,

        All = 0x01FE,
    };

    enum class TargetFlags : uint32_t
    {
        None           = 0x00,
        Self           = 0x01,
        Player         = 0x02,
        PartyMember    = 0x04,
        AllianceMember = 0x08,
        Npc            = 0x10,
        Enemy          = 0x20,
        Unknown        = 0x40,
        Object         = 0x60,
        CorpseOnly     = 0x80,
        Corpse         = 0x9D
    };

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Vana'diel Related Enumerations
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////

    enum class MoonPhase : uint32_t
    {
        New,
        WaxingCrescent,
        WaxingCrescent2,
        FirstQuarter,
        WaxingGibbous,
        WaxingGibbous2,
        Full,
        WaningGibbous,
        WaningGibbous2,
        LastQuarter,
        WaningCrescent,
        WaningCrescent2,

        Unknown
    };

    enum class Weather : uint32_t
    {
        Clear = 0,
        Sunny,
        Cloudy,
        Fog,
        Fire,
        FireTwo,
        Water,
        WaterTwo,
        Earth,
        EarthTwo,
        Wind,
        WindTwo,
        Ice,
        IceTwo,
        Lightning,
        LightningTwo,
        Light,
        LightTwo,
        Dark,
        DarkTwo
    };

    enum class Weekday : uint32_t
    {
        Firesday,
        Earthsday,
        Watersday,
        Windsday,
        Iceday,
        Lightningday,
        Lightsday,
        Darksday,

        Unknown
    };

} // namespace Ashita::FFXI::Enums

#endif // ASHITA_SDK_FFXI_ENUMS_H_INCLUDED