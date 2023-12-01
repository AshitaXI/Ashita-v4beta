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

#ifndef ASHITA_SDK_H_INCLUDED
#define ASHITA_SDK_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Warning Configurations
//
// Disables some warnings we do not need to care/worry about due to where they originate from.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma warning(push)
#pragma warning(disable : 26812) // Prefer 'enum class' over 'enum'.

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Plugin Interface Version
//
// Defines the current version of the Ashita plugin interface. Ashita uses this value to determine
// if a plugin is made for the current version of Ashita and can be properly loaded without issues.
//
// Invalid or mismatched versions will result in an error and the plugin will fail to load.
//
// Do not edit this value!
//
////////////////////////////////////////////////////////////////////////////////////////////////////

constexpr auto ASHITA_INTERFACE_VERSION = 4.16;

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Includes
//
////////////////////////////////////////////////////////////////////////////////////////////////////

// DirectInput SDK Version Definition
#ifndef DIRECTINPUT_VERSION
#define DIRECTINPUT_VERSION 0x0800
#endif

// General Includes
#include <Windows.h>
#include <functional>
#include "d3d8/includes/d3d8.h"
#include "d3d8/includes/d3dx8.h"
#include "d3d8/includes/dinput.h"
#include <Xinput.h>

// Ashita SDK Includes
#include "BinaryData.h"
#include "Chat.h"
#include "Commands.h"
#include "ErrorHandling.h"
#include "Memory.h"
#include "Registry.h"
#include "ScopeGuard.h"
#include "Threading.h"
#include "imgui.h"
#include "ffxi/autofollow.h"
#include "ffxi/castbar.h"
#include "ffxi/config.h"
#include "ffxi/entity.h"
#include "ffxi/enums.h"
#include "ffxi/inventory.h"
#include "ffxi/party.h"
#include "ffxi/player.h"
#include "ffxi/target.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Version Object
//
// Used with the Ashita 'GetAshitaVersion' export to obtain the full version information of Ashita.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma warning(disable : 4201)
union ashitaversion_t
{
    uint64_t Version; // The raw full version value.

    struct
    {
        uint16_t Major;    // The versions major value.
        uint16_t Minor;    // The versions minor value.
        uint16_t Build;    // The versions build value.
        uint16_t Revision; // The versions revision value.
    };

    ashitaversion_t(void)
        : Version(0)
    {}
    explicit ashitaversion_t(const uint64_t version)
        : Version(version)
    {}
    ashitaversion_t(const uint16_t major, const uint16_t minor, const uint16_t build, const uint16_t revision)
        : Major(major)
        , Minor(minor)
        , Build(build)
        , Revision(revision)
    {}
};
#pragma warning(default : 4201)

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Installation Parameters
//
// Used with the Ashita 'InstallAshita' export to properly attach Ashita to the process it is
// injected into. This structure holds the parameters that Ashita uses to initialize properly.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct ashitainstallparams_t
{
    uint32_t LanguageId;       // The language id to be used within Ashita.
    char BootScript[MAX_PATH]; // The boot script to execute when Ashita is loads.
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Forward Declares
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct lua_State
{};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Enumerations
//
////////////////////////////////////////////////////////////////////////////////////////////////////

namespace Ashita
{
    /**
     * Plugin Flags Enumeration
     */
    enum class PluginFlags : uint32_t
    {
        None            = 0 << 0, // None.
        UseCommands     = 1 << 0, // The plugin will make use of the incoming command handler.
        UseText         = 1 << 1, // The plugin will make use of the incoming/outgoing text handlers.
        UsePackets      = 1 << 2, // The plugin will make use of the incoming/outgoing packet handlers.
        UseDirect3D     = 1 << 3, // The plugin will make use of the various Direct3D handlers.
        UsePluginEvents = 1 << 4, // The plugin will make use of the Ashita plugin event system. (RaiseEvent / HandleEvent)

        /**
         * Ashita v3 legacy style setup.
         */
        Legacy = UseCommands | UseText | UsePackets,

        /**
         * Ashita v3 legacy style setup. (With Direct3D.)
         */
        LegacyDirect3D = UseCommands | UseText | UsePackets | UseDirect3D,

        /**
         * For plugins that need all available flags.
         */
        All = UseCommands | UseText | UsePackets | UseDirect3D | UsePluginEvents,
    };

    /**
     * Command Mode Enumeration
     */
    enum class CommandMode : int32_t
    {
        /**
         * Ashita command modes.
         */
        AshitaForceHandle = -3, // Tells Ashita to force-handle a command.
        AshitaScript      = -2, // Tells Ashita to assume the command is from a script.
        AshitaParse       = -1, // Tells Ashita to parse the command.

        /**
         * Final Fantasy XI command modes.
         */
        Menu           = 0, // Tells Ashita to forward the command as if a game menu invoked it.
        Typed          = 1, // Tells Ashita to forward the command as if a player typed it.
        Macro          = 2, // Tells Ashita to forward the command as if a macro invoked it.
        SubTargetST    = 3, // Internal used re-processing of a command if a <st> tag is found.
        SubTargetSTPC  = 4, // Internal used re-processing of a command if a <stpc> tag is found.
        SubTargetSTNPC = 5, // Internal used re-processing of a command if a <stnpc> tag is found.
        SubTargetSTPT  = 6, // Internal used re-processing of a command if a <stpt> tag is found.
        SubTargetSTAL  = 7, // Internal used re-processing of a command if a <stal> tag is found.
    };

    /**
     * Chat Input Opened Status Enumeration
     */
    enum class ChatInputOpenStatus : uint8_t
    {
        Closed      = 0x00, // If casted to bool-like type. (Low bits used for open/closed state.)
        Opened      = 0x01, // If casted to bool-like type. (Low bits used for open/closed state.)
        OpenedChat  = 0x11, // Flag set if the chat input is open.
        OpenedOther = 0x21, // Flag set if other input methods are open. (Bazaar comment, search comment, etc.)
    };

    /**
     * Log Level Enumeration
     */
    enum class LogLevel : uint32_t
    {
        None     = 0, // Logging will output: None
        Critical = 1, // Logging will output: Critical
        Error    = 2, // Logging will output: Critical, Error
        Warn     = 3, // Logging will output: Critical, Error, Warn
        Info     = 4, // Logging will output: Critical, Error, Warn, Info
        Debug    = 5, // Logging will output: Critical, Error, Warn, Info, Debug
    };

    /**
     * Frame Anchor Enumeration
     */
    enum class FrameAnchor : uint32_t
    {
        TopLeft = 0,
        TopRight,
        BottomLeft,
        BottomRight,

        Right  = 1,
        Bottom = 2,
    };

    /**
     * Keyboard Event Enumeration
     */
    enum class KeyboardEvent : uint32_t
    {
        Down = 0, // Keyboard key down.
        Up   = 1, // Keyboard key up.
    };

    /**
     * Mouse Input Enumeration
     */
    enum class MouseEvent : uint32_t
    {
        ClickLeft   = 0, // Mouse left click.
        ClickRight  = 1, // Mouse right click.
        ClickMiddle = 2, // Mouse middle click.
        ClickX1     = 3, // Mouse x-button (1) click.
        ClickX2     = 4, // Mouse x-button (2) click.
        WheelUp     = 5, // Mouse wheel scroll up.
        WheelDown   = 6, // Mouse wheel scroll down.
        Move        = 7, // Mouse move.
    };

    /**
     * Font Border Flags Enumeration
     */
    enum class FontBorderFlags : uint32_t
    {
        None   = 0 << 0,                      // None.
        Top    = 1 << 0,                      // Font will have a top border.
        Bottom = 1 << 1,                      // Font will have a bottom border.
        Left   = 1 << 2,                      // Font will have a left border.
        Right  = 1 << 3,                      // Font will have a right border.
        All    = Top | Bottom | Left | Right, // Font will have borders on all sides.
    };

    /**
     * Font Creation Flags Enumeration
     */
    enum class FontCreateFlags : uint32_t
    {
        None          = 0 << 0, // None.
        Bold          = 1 << 0, // Font will be bold.
        Italic        = 1 << 1, // Font will be italic.
        StrikeThrough = 1 << 2, // Font will be strikethrough.
        Underlined    = 1 << 3, // Font will be underlined.
        CustomFile    = 1 << 4, // Font will be loaded from a custom file, not installed on the system.
        ClearType     = 1 << 5, // Font will be created with an alpha channel texture supporting clear type.
    };

    /**
     * Font Draw Flags Enumeration
     */
    enum class FontDrawFlags : uint32_t
    {
        None           = 0 << 0, // None.
        Filtered       = 1 << 0, // Font will be drawn filtered.
        CenterX        = 1 << 1, // Font will be drawn centered.
        CenterY        = 1 << 2, // Font will be drawn centered.
        RightJustified = 1 << 3, // Font will be drawn right-justified.
        Outlined       = 1 << 4, // Font will be drawn with a colored outline.
        ManualRender   = 1 << 5, // Font will be drawn manually by the owner with Render().
    };

    /**
     * Primitive Draw Flags Enumeration
     */
    enum class PrimitiveDrawFlags : uint32_t
    {
        None         = 0 << 0, // None.
        ManualRender = 1 << 0, // Primitive will be drawn manually by the owner with Render().
    };

    /**
     * Enumeration Operator Override Helpers
     */
#define DEFINE_ENUMCLASS_OPERATORS(EnumClass)                                       \
    constexpr EnumClass operator~(EnumClass lhs)                                    \
    {                                                                               \
        return static_cast<EnumClass>(~std::underlying_type<EnumClass>::type(lhs)); \
    }                                                                               \
    constexpr EnumClass operator&(EnumClass lhs, EnumClass rhs)                     \
    {                                                                               \
        return static_cast<EnumClass>(std::underlying_type<EnumClass>::type(lhs) &  \
                                      std::underlying_type<EnumClass>::type(rhs));  \
    }                                                                               \
    constexpr EnumClass operator|(EnumClass lhs, EnumClass rhs)                     \
    {                                                                               \
        return static_cast<EnumClass>(std::underlying_type<EnumClass>::type(lhs) |  \
                                      std::underlying_type<EnumClass>::type(rhs));  \
    }                                                                               \
    constexpr EnumClass operator^(EnumClass lhs, EnumClass rhs)                     \
    {                                                                               \
        return static_cast<EnumClass>(std::underlying_type<EnumClass>::type(lhs) ^  \
                                      std::underlying_type<EnumClass>::type(rhs));  \
    }                                                                               \
    constexpr EnumClass operator&=(EnumClass& lhs, EnumClass rhs)                   \
    {                                                                               \
        lhs = static_cast<EnumClass>(std::underlying_type<EnumClass>::type(lhs) &   \
                                     std::underlying_type<EnumClass>::type(rhs));   \
        return lhs;                                                                 \
    }                                                                               \
    constexpr EnumClass operator|=(EnumClass& lhs, EnumClass rhs)                   \
    {                                                                               \
        lhs = static_cast<EnumClass>(std::underlying_type<EnumClass>::type(lhs) |   \
                                     std::underlying_type<EnumClass>::type(rhs));   \
        return lhs;                                                                 \
    }                                                                               \
    constexpr EnumClass operator^=(EnumClass& lhs, EnumClass rhs)                   \
    {                                                                               \
        lhs = static_cast<EnumClass>(std::underlying_type<EnumClass>::type(lhs) ^   \
                                     std::underlying_type<EnumClass>::type(rhs));   \
        return lhs;                                                                 \
    }

    // Attach operator overrides to needed enums..
    DEFINE_ENUMCLASS_OPERATORS(Ashita::PluginFlags);
    DEFINE_ENUMCLASS_OPERATORS(Ashita::FrameAnchor);
    DEFINE_ENUMCLASS_OPERATORS(Ashita::FontBorderFlags);
    DEFINE_ENUMCLASS_OPERATORS(Ashita::FontCreateFlags);
    DEFINE_ENUMCLASS_OPERATORS(Ashita::FontDrawFlags);
    DEFINE_ENUMCLASS_OPERATORS(Ashita::PrimitiveDrawFlags);

} // namespace Ashita

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Input Callback Definitions
//
// getdevicedatacallback_f
//
//      https://docs.microsoft.com/en-us/previous-versions/windows/desktop/ee417894(v%3Dvs.85)/
//      Function prototype used for registered callbacks to the hooked keyboard GetDeviceData
//      method. Passes the device data to the callback to be handled before being sent to the
//      game. (Uses standard IDirectInputDevice8::GetDeviceData setup and params.)
//
// getdevicestatecallback_f
//
//      https://docs.microsoft.com/en-us/previous-versions/windows/desktop/ee417897(v%3dvs.85)/
//      Function prototype used for registered callbacks to the hooked keyboard GetDeviceState
//      method. Passes the device state to the callback to be handled before being sent to the
//      game. (Uses standard IDirectInputDevice8::GetDeviceState setup and params.)
//
// controllercallback_f
//
//      Function prototype used for registered callbacks to the hooked directinput controller
//      interface. Passes the parameters from a rgdod entry to be handled before being used
//      to update controller state and sent to the game.
//
// keyboardcallback_f
//
//      https://msdn.microsoft.com/en-us/library/windows/desktop/ms644984(v=vs.85).aspx
//      Function prototype used for registered callbacks to the hooked keyboard window message
//      events. Passes the keyboard message to the callback to be handled before being sent to
//      the game.
//
// mousecallback_f
//
//      https://msdn.microsoft.com/en-us/library/windows/desktop/ms644988(v=vs.85).aspx
//      Function prototype used for registered callbacks to the hooked mouse window message
//      events. Passes the mouse message to the callback to be handled before being sent to
//      the game.
//
// xinputgetstatecallback_f
//
//      https://learn.microsoft.com/en-us/windows/win32/api/xinput/nf-xinput-xinputgetstate
//      Function prototype used for registered callbacks to the hooked XInputGetState function.
//      Passes the device state to the callback to be handled before being sent to the game.
//
// xinputcallback_f
//
//      Function prototype used for registered callbacks to the XInput interface. Passes
//      single button events to be handled before being used to update controller state and
//      sent to the game.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef HRESULT(__stdcall* getdevicedatacallback_f)(LPDIRECTINPUTDEVICE8A, DWORD, LPDIDEVICEOBJECTDATA, LPDWORD, DWORD, DWORD);
typedef HRESULT(__stdcall* getdevicestatecallback_f)(LPDIRECTINPUTDEVICE8A, DWORD, LPVOID);
typedef BOOL(__stdcall* controllercallback_f)(uint32_t*, int32_t*, bool, bool);
typedef BOOL(__stdcall* keyboardcallback_f)(WPARAM, LPARAM, bool);
typedef BOOL(__stdcall* mousecallback_f)(uint32_t, WPARAM, LPARAM, bool);
typedef DWORD(__stdcall* xinputgetstatecallback_f)(DWORD, XINPUT_STATE*);
typedef BOOL(__stdcall* xinputcallback_f)(uint8_t*, int16_t*, bool, bool);

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Font & Primitive Object Callback Definitions
//
// fontkeyboardevent_f
//
//      Function prototype used for font objects to allow developers to monitor keyboard events
//      sent to a specific font/primitive object.
//
// fontmouseevent_f
//
//      Function prototype used for font objects to allow developers to monitor mouse events
//      sent to a specific font/primitive object.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef bool(__stdcall* fontkeyboardevent_f)(Ashita::KeyboardEvent eventId, void* object, int32_t vkey, bool down, LPARAM lParam);
typedef bool(__stdcall* fontmouseevent_f)(Ashita::MouseEvent eventId, void* object, int32_t xpos, int32_t ypos);

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Resource Interface Definitions
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IAbility
{
    uint16_t Id;              // The abilities id.
    uint8_t Type;             // The abilities type.
    uint8_t Element;          // The abilities element.
    uint16_t ListIconId;      // The abilities list icon id.
    uint16_t ManaCost;        // The abilities mana cost.
    uint16_t RecastTimerId;   // The abilities recast timer id.
    uint16_t Targets;         // The abilities valid targets.
    int16_t TPCost;           // The abilities TP cost.
    uint8_t MenuCategoryId;   // The abilities sub-category menu id.
    uint8_t MonsterLevel;     // The abilities monster level.
    int8_t Range;             // The abilities range. (Range is based on a lookup table.)
    uint8_t AreaRange;        // The abilities AoE range.  (Range is based on a lookup table.)
    uint8_t AreaShapeType;    // The abilities AoE shape.  (0 = None, 1 = Circle on self/target, 2 = Cone AoE, 3 = Circle on self while targeting enemy.)
    uint8_t CursorTargetType; // The abilities cursor target type. (0x00 to 0x0F flag determining the valid targeting type of the ability.)
    uint8_t Unknown0000;      // Unknown
    uint8_t Unknown0001;      // Unknown (Type confirmed.)
    uint16_t Unknown0002;     // Unknown (Type confirmed.)
    uint16_t Unknown0003;     // Unknown (Type confirmed.) (TP related.)
    uint16_t Unknown0004;     // Unknown (Type confirmed.) (TP related.)
    uint16_t Unknown0005;     // Unknown (Type confirmed.)
    uint16_t Unknown0006;     // Unknown (Type confirmed.)
    uint16_t Unknown0007;     // Unknown
    uint16_t Unknown0008;     // Unknown (Type confirmed.)
    uint8_t Unknown0009[11];  // Unknown
    uint8_t EOE;              // 0xFF - End of Entry

    const char* Name[3];        // The abilities name. (0 = Default, 1 = Japanese, 2 = English)
    const char* Description[3]; // The abilities description. (0 = Default, 1 = Japanese, 2 = English)
};

struct ISpell
{
    uint16_t Index;            // The spells index.
    uint16_t Type;             // The spells type.
    uint16_t Element;          // The spells element.
    uint16_t Targets;          // The spells valid targets.
    uint16_t Skill;            // The spells magic skill type.
    uint16_t ManaCost;         // The spells mana cost.
    uint8_t CastTime;          // The spells cast time.         (CastTime / 4.0) (Cast Bar: CastTime * 20)
    uint8_t RecastDelay;       // The spells recast delay.      (RecastDely / 4.0) (Cast Bar: RecastDelay * 15)
    int16_t LevelRequired[24]; // The spells level requirements.(-1 = Unlearnable, > 99 = Unlocked with job points. See: JobPointMask for validation.)
    uint16_t Id;               // The spells id.                (Old recast id; unused now except for auto-sorting.)
    uint16_t ListIconNQ;       // The spells icon id.           (Low quality menu icon, client config set to icon set 1.)
    uint16_t ListIconHQ;       // The spells icon id.           (High quality menu icon, client config set to icon set 2.)
    uint8_t Requirements;      // The spells requirements.
    int8_t Range;              // The spells casting range.     (Range is based on a lookup table.)
    uint8_t AreaRange;         // The spells AoE range.         (Range is based on a lookup table.)
    uint8_t AreaShapeType;     // The spells AoE shape.         (0 = None, 1 = Circle on self/target, 2 = Cone AoE, 3 = Circle on self while targeting enemy.)
    uint8_t CursorTargetType;  // The spells AoE target type.   (0x00 to 0x0F flag determining the valid targeting type of the spell.)
    uint8_t Unknown0000[3];    // Unknown                       (Always 00 for all spells.)
    uint32_t AreaFlags;        // The spells AoE flags.         (Flag to determine various things. Example: Divine Veil valid spell: ((val & 0x7FFF80) == 512)))
    uint16_t Unknown0001;      // Unknown
    uint8_t Unknown0002;       // Unknown
    uint8_t Unknown0003;       // Unknown                       (Type confirmed.) (Used with GEO spells, looks to be a range of some sort.)
    uint8_t Unknown0004[8];    // Unknown
    uint32_t JobPointMask;     // The spells job point mask.    (JobPointMask & (1 << ((PlayerJobU32 & 0xFF) & 0x1F))) (If true, LevelRequired turns into required job points to unlock the spell.)
    uint8_t Unknown0005[3];    // Unknown
    uint8_t EOE;               // 0xFF - End of Entry

    const char* Name[3];        // The spells name. (0 = Default, 1 = Japanese, 2 = English)
    const char* Description[3]; // The spells description. (0 = Default, 1 = Japanese, 2 = English)
};

struct IMonAbility
{
    uint16_t AbilityId;  // The monstrosity ability id.
    int8_t Level;        // The monstrosity ability level.
    uint8_t Unknown0000; // Unknown
};

struct IItem
{
    // Common Item Header
    uint32_t Id;         // The items id.
    uint16_t Flags;      // The items flags.
    uint16_t StackSize;  // The items stack size.
    uint16_t Type;       // The items type.
    uint16_t ResourceId; // The items resource id. (Mainly used for AH sorting.)
    uint16_t Targets;    // The items valid targets for use.

    // Armor & Weapon Items
    uint16_t Level;               // The items level requirement to use.
    uint16_t Slots;               // The items equipment slots where the item can be equipped to.
    uint16_t Races;               // The items races that can use the item.
    uint32_t Jobs;                // The items jobs that can use the item.
    uint16_t SuperiorLevel;       // The items superior level.
    uint16_t ShieldSize;          // The items shield size.
    uint8_t MaxCharges;           // The items max charges.
    uint16_t CastTime;            // The items cast time.
    uint16_t CastDelay;           // The items cast delay.
    uint32_t RecastDelay;         // The items recast delay.
    uint16_t BaseItemId;          // The items base item id used for upgrades.
    uint16_t ItemLevel;           // The items item level.
    uint16_t Damage;              // The items damage.
    uint16_t Delay;               // The items delay.
    uint16_t DPS;                 // The items damae per second.
    uint8_t Skill;                // The items skill type.
    uint8_t JugSize;              // The items jug size.
    uint32_t WeaponUnknown0000;   // Unknown (Some sort of flag for item types. 0-5 and 255 are valid values.)
    uint8_t Range;                // The items range.           (Range is based on a lookup table.)
    uint8_t AreaRange;            // The items AoE range.       (Range is based on a lookup table.)
    uint8_t AreaShapeType;        // The items AoE shape.       (0 = None, 1 = Circle on self/target, 2 = Cone AoE, 3 = Circle on self while targeting enemy.)
    uint8_t AreaCursorTargetType; // The items AoE target type. (0x00 to 0x0F flag determining the valid targeting type of the spell.)

    // Common Items
    uint16_t Element;         // The items elemental aura type.
    uint32_t Storage;         // The items storage amount.
    uint32_t AttachmentFlags; // The items puppet attachment flags.

    // Instinct Items
    uint16_t InstinctCost; // The items instinct cost.

    // Monstrosity Items
    uint16_t MonstrosityId;                 // The items monstrosity id.
    char MonstrosityName[0x20];             // The items monstrosity name.
    uint8_t MonstrosityData[0x0A];          // The items monstrosity data. (Unknown block of data currently.)
    IMonAbility MonstrosityAbilities[0x10]; // The items monstrosity abilities.

    // Puppet Items
    uint16_t PuppetSlotId;   // The items puppet slot id.
    uint32_t PuppetElements; // The items puppet elements.

    // Slip & Voucher Items
    uint8_t SlipData[0x46]; // The items slip data.

    // Usable Items
    uint16_t UsableData0000; // The items usable data. (0) - (Used as animation lookup types. Learnable Scrolls: 0x01000. Learnable Rolls: 0x02000)
    uint32_t UsableData0001; // The items usable data. (1) - (Used as animation ids for learnable items. Used as AoE range information for usable items.)
    uint32_t UsableData0002; // The items usable data. (2) - (Used as a flag to tell what UsableData0001 is. 0x00: Unused. 0x01: Animation Id. 0x02: AoE range information.)

    uint32_t Article; // The items article type.

    const char* Name[3];            // The items name. (0 = Default, 1 = Japanese, 2 = English)
    const char* Description[3];     // The items description. (0 = Default, 1 = Japanese, 2 = English)
    const char* LogNameSingular[3]; // The items log name (singular). (0 = Default, 1 = Japanese, 2 = English)
    const char* LogNamePlural[3];   // The items log name (plural). (0 = Default, 1 = Japanese, 2 = English)

    uint32_t ImageSize;      // The items image size.
    uint8_t ImageType;       // The items image type.
    uint8_t ImageName[0x10]; // The items image name.
    uint8_t Bitmap[0x980];   // The items bitmap data.
};

struct IStatusIcon
{
    uint16_t Index;    // The status icons index in the DAT file.
    uint16_t Id;       // The status icons id. (Most match the index, but some don't.)
    uint8_t CanCancel; // The status icons cancellable flag. (1 if it can be cancelled, 0 otherwise.)
    uint8_t HideTimer; // The status icons force-hide timer flag. (1 if the timer is hidden by force, 0 otherwise.)

    const char* Description[3]; // The status icons description. (0 = Default, 1 = Japanese, 2 = English)

    uint32_t ImageSize;      // The status icons image size.
    uint8_t ImageType;       // The status icons image type.
    uint8_t ImageName[0x10]; // The status icons image name.
    uint8_t Bitmap[0x156A];  // The status icons bitmap data.
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Memory Object Interface Definitions
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IAutoFollow
{
    /**
     * Warning!
     * 
     * Plugins should not use this function! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::autofollow_t* GetRawStructure(void) const = 0;

    // Get Properties
    virtual uint32_t GetTargetIndex(void) const          = 0;
    virtual uint32_t GetTargetServerId(void) const       = 0;
    virtual float GetFollowDeltaX(void) const            = 0;
    virtual float GetFollowDeltaZ(void) const            = 0;
    virtual float GetFollowDeltaY(void) const            = 0;
    virtual float GetFollowDeltaW(void) const            = 0;
    virtual uint32_t GetFollowTargetIndex(void) const    = 0;
    virtual uint32_t GetFollowTargetServerId(void) const = 0;
    virtual uint8_t GetIsFirstPersonCamera(void) const   = 0;
    virtual uint8_t GetIsAutoRunning(void) const         = 0;
    virtual uint8_t GetIsCameraLocked(void) const        = 0;
    virtual uint8_t GetIsCameraLockedOn(void) const      = 0;

    // Set Properties
    virtual void SetTargetIndex(uint32_t index) const                    = 0;
    virtual void SetTargetServerId(uint32_t id) const                    = 0;
    virtual void SetFollowDeltaX(float x) const                          = 0;
    virtual void SetFollowDeltaZ(float z) const                          = 0;
    virtual void SetFollowDeltaY(float y) const                          = 0;
    virtual void SetFollowDeltaW(float w) const                          = 0;
    virtual void SetFollowTargetIndex(uint32_t index) const              = 0;
    virtual void SetFollowTargetServerId(uint32_t id) const              = 0;
    virtual void SetIsFirstPersonCamera(uint8_t firstPersonCamera) const = 0;
    virtual void SetIsAutoRunning(uint8_t autoRunning) const             = 0;
    virtual void SetIsCameraLocked(uint8_t cameraLocked) const           = 0;
    virtual void SetIsCameraLockedOn(uint8_t cameraLockedOn) const       = 0;
};

struct ICastBar
{
    /**
     * Warning!
     * 
     * Plugins should not use this function! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::castbar_t* GetRawStructure(void) const = 0;

    // Get Properties
    virtual float GetMax(void) const         = 0;
    virtual float GetCount(void) const       = 0;
    virtual float GetPercent(void) const     = 0;
    virtual uint32_t GetCastType(void) const = 0;

    // Set Properties
    virtual void SetMax(float max) const          = 0;
    virtual void SetCount(float count) const      = 0;
    virtual void SetPercent(float percent) const  = 0;
    virtual void SetCastType(uint32_t type) const = 0;
};

struct IEntity
{
    /**
     * Warning!
     * 
     * Plugins should not use this function! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::entity_t* GetRawEntity(uint32_t index) const = 0;

    // Helper Methods
    virtual uint32_t GetEntityMapSize(void) const = 0;

    // Get Properties
    virtual float GetLocalPositionX(uint32_t index) const                           = 0;
    virtual float GetLocalPositionZ(uint32_t index) const                           = 0;
    virtual float GetLocalPositionY(uint32_t index) const                           = 0;
    virtual float GetLocalPositionW(uint32_t index) const                           = 0;
    virtual float GetLocalPositionRoll(uint32_t index) const                        = 0;
    virtual float GetLocalPositionYaw(uint32_t index) const                         = 0;
    virtual float GetLocalPositionPitch(uint32_t index) const                       = 0;
    virtual float GetLastPositionX(uint32_t index) const                            = 0;
    virtual float GetLastPositionZ(uint32_t index) const                            = 0;
    virtual float GetLastPositionY(uint32_t index) const                            = 0;
    virtual float GetLastPositionW(uint32_t index) const                            = 0;
    virtual float GetLastPositionRoll(uint32_t index) const                         = 0;
    virtual float GetLastPositionYaw(uint32_t index) const                          = 0;
    virtual float GetLastPositionPitch(uint32_t index) const                        = 0;
    virtual float GetMoveX(uint32_t index) const                                    = 0;
    virtual float GetMoveZ(uint32_t index) const                                    = 0;
    virtual float GetMoveY(uint32_t index) const                                    = 0;
    virtual float GetMoveW(uint32_t index) const                                    = 0;
    virtual float GetMoveDeltaX(uint32_t index) const                               = 0;
    virtual float GetMoveDeltaZ(uint32_t index) const                               = 0;
    virtual float GetMoveDeltaY(uint32_t index) const                               = 0;
    virtual float GetMoveDeltaW(uint32_t index) const                               = 0;
    virtual float GetMoveDeltaRoll(uint32_t index) const                            = 0;
    virtual float GetMoveDeltaYaw(uint32_t index) const                             = 0;
    virtual float GetMoveDeltaPitch(uint32_t index) const                           = 0;
    virtual uint32_t GetTargetIndex(uint32_t index) const                           = 0;
    virtual uint32_t GetServerId(uint32_t index) const                              = 0;
    virtual const char* GetName(uint32_t index) const                               = 0;
    virtual float GetMovementSpeed(uint32_t index) const                            = 0;
    virtual float GetAnimationSpeed(uint32_t index) const                           = 0;
    virtual uintptr_t GetActorPointer(uint32_t index) const                         = 0;
    virtual uintptr_t GetAttachment(uint32_t index, uint32_t attachmentIndex) const = 0;
    virtual uintptr_t GetEventPointer(uint32_t index) const                         = 0;
    virtual float GetDistance(uint32_t index) const                                 = 0;
    virtual uint32_t GetTurnSpeed(uint32_t index) const                             = 0;
    virtual uint32_t GetTurnSpeedHead(uint32_t index) const                         = 0;
    virtual float GetHeading(uint32_t index) const                                  = 0;
    virtual uintptr_t GetNext(uint32_t index) const                                 = 0;
    virtual uint8_t GetHPPercent(uint32_t index) const                              = 0;
    virtual uint8_t GetType(uint32_t index) const                                   = 0;
    virtual uint8_t GetRace(uint32_t index) const                                   = 0;
    virtual uint16_t GetLocalMoveCount(uint32_t index) const                        = 0;
    virtual uint16_t GetActorLockFlag(uint32_t index) const                         = 0;
    virtual uint16_t GetModelUpdateFlags(uint32_t index) const                      = 0;
    virtual uint32_t GetDoorId(uint32_t index) const                                = 0;
    virtual uint16_t GetLookHair(uint32_t index) const                              = 0;
    virtual uint16_t GetLookHead(uint32_t index) const                              = 0;
    virtual uint16_t GetLookBody(uint32_t index) const                              = 0;
    virtual uint16_t GetLookHands(uint32_t index) const                             = 0;
    virtual uint16_t GetLookLegs(uint32_t index) const                              = 0;
    virtual uint16_t GetLookFeet(uint32_t index) const                              = 0;
    virtual uint16_t GetLookMain(uint32_t index) const                              = 0;
    virtual uint16_t GetLookSub(uint32_t index) const                               = 0;
    virtual uint16_t GetLookRanged(uint32_t index) const                            = 0;
    virtual uint16_t GetActionTimer1(uint32_t index) const                          = 0;
    virtual uint16_t GetActionTimer2(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags0(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags1(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags2(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags3(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags4(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags5(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags6(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags7(uint32_t index) const                          = 0;
    virtual uint32_t GetRenderFlags8(uint32_t index) const                          = 0;
    virtual uint8_t GetPopEffect(uint32_t index) const                              = 0;
    virtual uint8_t GetUpdateMask(uint32_t index) const                             = 0;
    virtual uint16_t GetInteractionTargetIndex(uint32_t index) const                = 0;
    virtual uint16_t GetNpcSpeechFrame(uint32_t index) const                        = 0;
    virtual uint16_t GetLookAxisX(uint32_t index) const                             = 0;
    virtual uint16_t GetLookAxisY(uint32_t index) const                             = 0;
    virtual uint16_t GetMouthCounter(uint32_t index) const                          = 0;
    virtual uint16_t GetMouthWaitCounter(uint32_t index) const                      = 0;
    virtual uint16_t GetCraftTimerUnknown(uint32_t index) const                     = 0;
    virtual uint32_t GetCraftServerId(uint32_t index) const                         = 0;
    virtual uint16_t GetCraftAnimationEffect(uint32_t index) const                  = 0;
    virtual uint8_t GetCraftAnimationStep(uint32_t index) const                     = 0;
    virtual uint8_t GetCraftParam(uint32_t index) const                             = 0;
    virtual float GetMovementSpeed2(uint32_t index) const                           = 0;
    virtual uint16_t GetNpcWalkPosition1(uint32_t index) const                      = 0;
    virtual uint16_t GetNpcWalkPosition2(uint32_t index) const                      = 0;
    virtual uint16_t GetNpcWalkMode(uint32_t index) const                           = 0;
    virtual uint16_t GetCostumeId(uint32_t index) const                             = 0;
    virtual uint32_t GetMou4(uint32_t index) const                                  = 0;
    virtual uint32_t GetStatusServer(uint32_t index) const                          = 0;
    virtual uint32_t GetStatus(uint32_t index) const                                = 0;
    virtual uint32_t GetStatusEvent(uint32_t index) const                           = 0;
    virtual uint32_t GetModelTime(uint32_t index) const                             = 0;
    virtual uint32_t GetModelStartTime(uint32_t index) const                        = 0;
    virtual uint32_t GetClaimStatus(uint32_t index) const                           = 0;
    virtual uint32_t GetZoneId(uint32_t index) const                                = 0;
    virtual uint32_t GetAnimation(uint32_t index, uint32_t animationIndex) const    = 0;
    virtual uint16_t GetAnimationTime(uint32_t index) const                         = 0;
    virtual uint16_t GetAnimationStep(uint32_t index) const                         = 0;
    virtual uint8_t GetAnimationPlay(uint32_t index) const                          = 0;
    virtual uint16_t GetEmoteTargetIndex(uint32_t index) const                      = 0;
    virtual uint16_t GetEmoteId(uint32_t index) const                               = 0;
    virtual uint32_t GetEmoteIdString(uint32_t index) const                         = 0;
    virtual uintptr_t GetEmoteTargetActorPointer(uint32_t index) const              = 0;
    virtual uint32_t GetSpawnFlags(uint32_t index) const                            = 0;
    virtual uint32_t GetLinkshellColor(uint32_t index) const                        = 0;
    virtual uint16_t GetNameColor(uint32_t index) const                             = 0;
    virtual uint8_t GetCampaignNameFlag(uint32_t index) const                       = 0;
    virtual uint8_t GetMountId(uint32_t index) const                                = 0;
    virtual int32_t GetFishingUnknown0000(uint32_t index) const                     = 0;
    virtual int32_t GetFishingUnknown0001(uint32_t index) const                     = 0;
    virtual int32_t GetFishingActionCountdown(uint32_t index) const                 = 0;
    virtual int16_t GetFishingRodCastTime(uint32_t index) const                     = 0;
    virtual int16_t GetFishingUnknown0002(uint32_t index) const                     = 0;
    virtual uint32_t GetLastActionId(uint32_t index) const                          = 0;
    virtual uintptr_t GetLastActionActorPointer(uint32_t index) const               = 0;
    virtual uint16_t GetTargetedIndex(uint32_t index) const                         = 0;
    virtual uint16_t GetPetTargetIndex(uint32_t index) const                        = 0;
    virtual uint16_t GetUpdateRequestDelay(uint32_t index) const                    = 0;
    virtual uint8_t GetIsDirty(uint32_t index) const                                = 0;
    virtual uint8_t GetBallistaFlags(uint32_t index) const                          = 0;
    virtual uint8_t GetPankrationEnabled(uint32_t index) const                      = 0;
    virtual uint8_t GetPankrationFlagFlip(uint32_t index) const                     = 0;
    virtual float GetModelSize(uint32_t index) const                                = 0;
    virtual float GetModelHitboxSize(uint32_t index) const                          = 0;
    virtual uint32_t GetEnvironmentAreaId(uint32_t index) const                     = 0;
    virtual uint16_t GetMonstrosityFlag(uint32_t index) const                       = 0;
    virtual uint16_t GetMonstrosityNameId(uint32_t index) const                     = 0;
    virtual const char* GetMonstrosityName(uint32_t index) const                    = 0;
    virtual uint8_t GetMonstrosityNameEnd(uint32_t index) const                     = 0;
    virtual const char* GetMonstrosityNameAbbr(uint32_t index) const                = 0;
    virtual uint8_t GetMonstrosityNameAbbrEnd(uint32_t index) const                 = 0;
    virtual uint8_t* GetCustomProperties(uint32_t index) const                      = 0;
    virtual uint8_t* GetBallistaInfo(uint32_t index) const                          = 0;
    virtual uint16_t GetFellowTargetIndex(uint32_t index) const                     = 0;
    virtual uint16_t GetWarpTargetIndex(uint32_t index) const                       = 0;
    virtual uint16_t GetTrustOwnerTargetIndex(uint32_t index) const                 = 0;
    virtual uint16_t GetAreaDisplayTargetIndex(uint32_t index) const                = 0;

    // Set Properties
    virtual void SetLocalPositionX(uint32_t index, float x) const                                    = 0;
    virtual void SetLocalPositionZ(uint32_t index, float z) const                                    = 0;
    virtual void SetLocalPositionY(uint32_t index, float y) const                                    = 0;
    virtual void SetLocalPositionW(uint32_t index, float w) const                                    = 0;
    virtual void SetLocalPositionRoll(uint32_t index, float roll) const                              = 0;
    virtual void SetLocalPositionYaw(uint32_t index, float yaw) const                                = 0;
    virtual void SetLocalPositionPitch(uint32_t index, float pitch) const                            = 0;
    virtual void SetLastPositionX(uint32_t index, float x) const                                     = 0;
    virtual void SetLastPositionZ(uint32_t index, float z) const                                     = 0;
    virtual void SetLastPositionY(uint32_t index, float y) const                                     = 0;
    virtual void SetLastPositionW(uint32_t index, float w) const                                     = 0;
    virtual void SetLastPositionRoll(uint32_t index, float roll) const                               = 0;
    virtual void SetLastPositionYaw(uint32_t index, float yaw) const                                 = 0;
    virtual void SetLastPositionPitch(uint32_t index, float pitch) const                             = 0;
    virtual void SetMoveX(uint32_t index, float x) const                                             = 0;
    virtual void SetMoveZ(uint32_t index, float z) const                                             = 0;
    virtual void SetMoveY(uint32_t index, float y) const                                             = 0;
    virtual void SetMoveW(uint32_t index, float w) const                                             = 0;
    virtual void SetMoveDeltaX(uint32_t index, float x) const                                        = 0;
    virtual void SetMoveDeltaZ(uint32_t index, float z) const                                        = 0;
    virtual void SetMoveDeltaY(uint32_t index, float y) const                                        = 0;
    virtual void SetMoveDeltaW(uint32_t index, float w) const                                        = 0;
    virtual void SetMoveDeltaRoll(uint32_t index, float roll) const                                  = 0;
    virtual void SetMoveDeltaYaw(uint32_t index, float yaw) const                                    = 0;
    virtual void SetMoveDeltaPitch(uint32_t index, float pitch) const                                = 0;
    virtual void SetTargetIndex(uint32_t index, uint32_t targetIndex) const                          = 0;
    virtual void SetServerId(uint32_t index, uint32_t serverId) const                                = 0;
    virtual void SetName(uint32_t index, const char* name) const                                     = 0;
    virtual void SetMovementSpeed(uint32_t index, float speed) const                                 = 0;
    virtual void SetAnimationSpeed(uint32_t index, float speed) const                                = 0;
    virtual void SetActorPointer(uint32_t index, uintptr_t pointer) const                            = 0;
    virtual void SetAttachment(uint32_t index, uint32_t attachmentIndex, uintptr_t attachment) const = 0;
    virtual void SetEventPointer(uint32_t index, uintptr_t pointer) const                            = 0;
    virtual void SetDistance(uint32_t index, float distance) const                                   = 0;
    virtual void SetTurnSpeed(uint32_t index, uint32_t speed) const                                  = 0;
    virtual void SetTurnSpeedHead(uint32_t index, uint32_t speed) const                              = 0;
    virtual void SetHeading(uint32_t index, float heading) const                                     = 0;
    virtual void SetNext(uint32_t index, uintptr_t next) const                                       = 0;
    virtual void SetHPPercent(uint32_t index, uint8_t hpp) const                                     = 0;
    virtual void SetType(uint32_t index, uint8_t type) const                                         = 0;
    virtual void SetRace(uint32_t index, uint8_t race) const                                         = 0;
    virtual void SetLocalMoveCount(uint32_t index, uint16_t moveCount) const                         = 0;
    virtual void SetActorLockFlag(uint32_t index, uint16_t flag) const                               = 0;
    virtual void SetModelUpdateFlags(uint32_t index, uint16_t flags) const                           = 0;
    virtual void SetDoorId(uint32_t index, uint32_t doorId) const                                    = 0;
    virtual void SetLookHair(uint32_t index, uint16_t hair) const                                    = 0;
    virtual void SetLookHead(uint32_t index, uint16_t head) const                                    = 0;
    virtual void SetLookBody(uint32_t index, uint16_t body) const                                    = 0;
    virtual void SetLookHands(uint32_t index, uint16_t hands) const                                  = 0;
    virtual void SetLookLegs(uint32_t index, uint16_t legs) const                                    = 0;
    virtual void SetLookFeet(uint32_t index, uint16_t feet) const                                    = 0;
    virtual void SetLookMain(uint32_t index, uint16_t main) const                                    = 0;
    virtual void SetLookSub(uint32_t index, uint16_t sub) const                                      = 0;
    virtual void SetLookRanged(uint32_t index, uint16_t ranged) const                                = 0;
    virtual void SetActionTimer1(uint32_t index, uint16_t timer) const                               = 0;
    virtual void SetActionTimer2(uint32_t index, uint16_t timer) const                               = 0;
    virtual void SetRenderFlags0(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags1(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags2(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags3(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags4(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags5(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags6(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags7(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetRenderFlags8(uint32_t index, uint32_t flags) const                               = 0;
    virtual void SetPopEffect(uint32_t index, uint8_t effect) const                                  = 0;
    virtual void SetUpdateMask(uint32_t index, uint8_t mask) const                                   = 0;
    virtual void SetInteractionTargetIndex(uint32_t index, uint16_t targetIndex) const               = 0;
    virtual void SetNpcSpeechFrame(uint32_t index, uint16_t frame) const                             = 0;
    virtual void SetLookAxisX(uint32_t index, uint16_t x) const                                      = 0;
    virtual void SetLookAxisY(uint32_t index, uint16_t y) const                                      = 0;
    virtual void SetMouthCounter(uint32_t index, uint16_t counter) const                             = 0;
    virtual void SetMouthWaitCounter(uint32_t index, uint16_t counter) const                         = 0;
    virtual void SetCraftTimerUnknown(uint32_t index, uint16_t timer) const                          = 0;
    virtual void SetCraftServerId(uint32_t index, uint32_t serverId) const                           = 0;
    virtual void SetCraftAnimationEffect(uint32_t index, uint16_t animationEffect) const             = 0;
    virtual void SetCraftAnimationStep(uint32_t index, uint8_t animationStep) const                  = 0;
    virtual void SetCraftParam(uint32_t index, uint8_t param) const                                  = 0;
    virtual void SetMovementSpeed2(uint32_t index, float speed) const                                = 0;
    virtual void SetNpcWalkPosition1(uint32_t index, uint16_t pos) const                             = 0;
    virtual void SetNpcWalkPosition2(uint32_t index, uint16_t pos) const                             = 0;
    virtual void SetNpcWalkMode(uint32_t index, uint16_t mode) const                                 = 0;
    virtual void SetCostumeId(uint32_t index, uint16_t id) const                                     = 0;
    virtual void SetMou4(uint32_t index, uint32_t mou4) const                                        = 0;
    virtual void SetStatusServer(uint32_t index, uint32_t status) const                              = 0;
    virtual void SetStatus(uint32_t index, uint32_t status) const                                    = 0;
    virtual void SetStatusEvent(uint32_t index, uint32_t status) const                               = 0;
    virtual void SetModelTime(uint32_t index, uint32_t time) const                                   = 0;
    virtual void SetModelStartTime(uint32_t index, uint32_t time) const                              = 0;
    virtual void SetClaimStatus(uint32_t index, uint32_t status) const                               = 0;
    virtual void SetZoneId(uint32_t index, uint32_t zoneId) const                                    = 0;
    virtual void SetAnimation(uint32_t index, uint32_t animationIndex, uint32_t animation) const     = 0;
    virtual void SetAnimationTime(uint32_t index, uint16_t time) const                               = 0;
    virtual void SetAnimationStep(uint32_t index, uint16_t step) const                               = 0;
    virtual void SetAnimationPlay(uint32_t index, uint8_t play) const                                = 0;
    virtual void SetEmoteTargetIndex(uint32_t index, uint16_t targetIndex) const                     = 0;
    virtual void SetEmoteId(uint32_t index, uint16_t id) const                                       = 0;
    virtual void SetEmoteIdString(uint32_t index, uint32_t emoteString) const                        = 0;
    virtual void SetEmoteTargetActorPointer(uint32_t index, uintptr_t pointer) const                 = 0;
    virtual void SetSpawnFlags(uint32_t index, uint32_t flags) const                                 = 0;
    virtual void SetLinkshellColor(uint32_t index, uint32_t color) const                             = 0;
    virtual void SetNameColor(uint32_t index, uint16_t color) const                                  = 0;
    virtual void SetCampaignNameFlag(uint32_t index, uint8_t flag) const                             = 0;
    virtual void SetMountId(uint32_t index, uint8_t mount) const                                     = 0;
    virtual void SetFishingUnknown0000(uint32_t index, int32_t unknown) const                        = 0;
    virtual void SetFishingUnknown0001(uint32_t index, int32_t unknown) const                        = 0;
    virtual void SetFishingActionCountdown(uint32_t index, int16_t time) const                       = 0;
    virtual void SetFishingRodCastTime(uint32_t index, int16_t time) const                           = 0;
    virtual void SetFishingUnknown0002(uint32_t index, int16_t unknown) const                        = 0;
    virtual void SetLastActionId(uint32_t index, uint32_t action) const                              = 0;
    virtual void SetLastActionActorPointer(uint32_t index, uintptr_t pointer) const                  = 0;
    virtual void SetTargetedIndex(uint32_t index, uint16_t targetIndex) const                        = 0;
    virtual void SetPetTargetIndex(uint32_t index, uint16_t targetIndex) const                       = 0;
    virtual void SetUpdateRequestDelay(uint32_t index, uint16_t delay) const                         = 0;
    virtual void SetIsDirty(uint32_t index, uint8_t dirty) const                                     = 0;
    virtual void SetBallistaFlags(uint32_t index, uint8_t flags) const                               = 0;
    virtual void SetPankrationEnabled(uint32_t index, uint8_t enabled) const                         = 0;
    virtual void SetPankrationFlagFlip(uint32_t index, uint8_t flagflip) const                       = 0;
    virtual void SetModelSize(uint32_t index, float size) const                                      = 0;
    virtual void SetModelHitboxSize(uint32_t index, float size) const                                = 0;
    virtual void SetEnvironmentAreaId(uint32_t index, uint32_t id) const                             = 0;
    virtual void SetMonstrosityFlag(uint32_t index, uint16_t flag) const                             = 0;
    virtual void SetMonstrosityNameId(uint32_t index, uint16_t id) const                             = 0;
    virtual void SetMonstrosityName(uint32_t index, const char* name) const                          = 0;
    virtual void SetMonstrosityNameEnd(uint32_t index, uint8_t end) const                            = 0;
    virtual void SetMonstrosityNameAbbr(uint32_t index, const char* name) const                      = 0;
    virtual void SetMonstrosityNameAbbrEnd(uint32_t index, uint8_t end) const                        = 0;
    virtual void SetCustomProperties(uint32_t index, uint8_t* props) const                           = 0;
    virtual void SetBallistaInfo(uint32_t index, uint8_t* info) const                                = 0;
    virtual void SetFellowTargetIndex(uint32_t index, uint16_t targetIndex) const                    = 0;
    virtual void SetWarpTargetIndex(uint32_t index, uint16_t targetIndex) const                      = 0;
    virtual void SetTrustOwnerTargetIndex(uint32_t index, uint16_t targetIndex) const                = 0;
    virtual void SetAreaDisplayTargetIndex(uint32_t index, uint16_t targetIndex) const               = 0;
};

struct IInventory
{
    /**
     * Warning!
     * 
     * Plugins should not use this function! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::inventory_t* GetRawStructure(void) const = 0;

    // Get Properties (Items)
    virtual Ashita::FFXI::item_t* GetContainerItem(uint32_t containerId, uint32_t index) const = 0;
    virtual uint32_t GetContainerCount(uint32_t containerId) const                             = 0;
    virtual uint32_t GetContainerCountMax(uint32_t containerId) const                          = 0;

    // Get Properties (Treasure Pool)
    virtual Ashita::FFXI::treasureitem_t* GetTreasurePoolItem(uint32_t index) const = 0;
    virtual uint32_t GetTreasurePoolStatus(void) const                              = 0;
    virtual uint32_t GetTreasurePoolItemCount(void) const                           = 0;

    // Get Properties (Misc)
    virtual uint32_t GetContainerUpdateCounter(void) const = 0;
    virtual uint32_t GetContainerUpdateFlags(void) const   = 0;
    virtual uint32_t GetDisplayItemSlot(void) const        = 0;
    virtual uint32_t GetDisplayItemPointer(void) const     = 0;

    // Get Properties (Equipment)
    virtual Ashita::FFXI::equipmententry_t* GetEquippedItem(uint32_t index) const = 0;

    // Get Properties (Check)
    virtual Ashita::FFXI::itemcheck_t* GetCheckEquippedItem(uint32_t index) const = 0;
    virtual uint32_t GetCheckTargetIndex(void) const                              = 0;
    virtual uint32_t GetCheckServerId(void) const                                 = 0;
    virtual uint32_t GetCheckFlags(void) const                                    = 0;
    virtual uint8_t GetCheckMainJob(void) const                                   = 0;
    virtual uint8_t GetCheckSubJob(void) const                                    = 0;
    virtual uint8_t GetCheckMainJobLevel(void) const                              = 0;
    virtual uint8_t GetCheckSubJobLevel(void) const                               = 0;
    virtual uint8_t GetCheckMainJob2(void) const                                  = 0;
    virtual uint8_t GetCheckMasteryLevel(void) const                              = 0;
    virtual uint8_t GetCheckMasteryFlags(void) const                              = 0;
    virtual uint8_t* GetCheckLinkshellName(void) const                            = 0;
    virtual uint16_t GetCheckLinkshellColor(void) const                           = 0;
    virtual uint8_t GetCheckLinkshellIconSetId(void) const                        = 0;
    virtual uint8_t GetCheckLinkshellIconSetIndex(void) const                     = 0;
    virtual uint32_t GetCheckBallistaChevronCount(void) const                     = 0;
    virtual uint16_t GetCheckBallistaChevronFlags(void) const                     = 0;
    virtual uint16_t GetCheckBallistaFlags(void) const                            = 0;

    // Get Properties (Search Comment)
    virtual const char* GetSearchComment(void) const = 0;

    // Get Properties (Crafting)
    virtual uint32_t GetCraftStatus(void) const            = 0;
    virtual uintptr_t GetCraftCallback(void) const         = 0;
    virtual uint32_t GetCraftTimestampAttempt(void) const  = 0;
    virtual uint32_t GetCraftTimestampResponse(void) const = 0;

    // Set Properties (Crafting)
    virtual void SetCraftStatus(uint32_t status) const               = 0;
    virtual void SetCraftCallback(uintptr_t callback) const          = 0;
    virtual void SetCraftTimestampAttempt(uint32_t timestamp) const  = 0;
    virtual void SetCraftTimestampResponse(uint32_t timestamp) const = 0;

    // Get Properties (Selected Item)
    virtual const char* GetSelectedItemName(void) const = 0;
    virtual uint16_t GetSelectedItemId(void) const      = 0;
    virtual uint8_t GetSelectedItemIndex(void) const    = 0;
};

struct IParty
{
    /**
     * Warning!
     * 
     * Plugins should not use this function! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::party_t* GetRawStructure(void) const = 0;

    // Get Properties (Alliance)
    virtual uint32_t GetAllianceLeaderServerId(void) const       = 0;
    virtual uint32_t GetAlliancePartyLeaderServerId1(void) const = 0;
    virtual uint32_t GetAlliancePartyLeaderServerId2(void) const = 0;
    virtual uint32_t GetAlliancePartyLeaderServerId3(void) const = 0;
    virtual int8_t GetAlliancePartyVisible1(void) const          = 0;
    virtual int8_t GetAlliancePartyVisible2(void) const          = 0;
    virtual int8_t GetAlliancePartyVisible3(void) const          = 0;
    virtual int8_t GetAlliancePartyMemberCount1(void) const      = 0;
    virtual int8_t GetAlliancePartyMemberCount2(void) const      = 0;
    virtual int8_t GetAlliancePartyMemberCount3(void) const      = 0;
    virtual int8_t GetAllianceInvited(void) const                = 0;

    // Get Properties (Party Members)
    virtual uint8_t GetMemberIndex(uint32_t index) const                       = 0;
    virtual uint8_t GetMemberNumber(uint32_t index) const                      = 0;
    virtual const char* GetMemberName(uint32_t index) const                    = 0;
    virtual uint32_t GetMemberServerId(uint32_t index) const                   = 0;
    virtual uint32_t GetMemberTargetIndex(uint32_t index) const                = 0;
    virtual uint32_t GetMemberLastUpdatedTimestamp(uint32_t index) const       = 0;
    virtual uint32_t GetMemberHP(uint32_t index) const                         = 0;
    virtual uint32_t GetMemberMP(uint32_t index) const                         = 0;
    virtual uint32_t GetMemberTP(uint32_t index) const                         = 0;
    virtual uint8_t GetMemberHPPercent(uint32_t index) const                   = 0;
    virtual uint8_t GetMemberMPPercent(uint32_t index) const                   = 0;
    virtual uint16_t GetMemberZone(uint32_t index) const                       = 0;
    virtual uint16_t GetMemberZone2(uint32_t index) const                      = 0;
    virtual uint32_t GetMemberFlagMask(uint32_t index) const                   = 0;
    virtual uint16_t GetMemberTreasureLot(uint32_t index, uint32_t slot) const = 0;
    virtual uint16_t GetMemberMonstrosityItemId(uint32_t index) const          = 0;
    virtual uint8_t GetMemberMonstrosityPrefixFlag1(uint32_t index) const      = 0;
    virtual uint8_t GetMemberMonstrosityPrefixFlag2(uint32_t index) const      = 0;
    virtual const char* GetMemberMonstrosityName(uint32_t index) const         = 0;
    virtual uint8_t GetMemberMainJob(uint32_t index) const                     = 0;
    virtual uint8_t GetMemberMainJobLevel(uint32_t index) const                = 0;
    virtual uint8_t GetMemberSubJob(uint32_t index) const                      = 0;
    virtual uint8_t GetMemberSubJobLevel(uint32_t index) const                 = 0;
    virtual uint32_t GetMemberServerId2(uint32_t index) const                  = 0;
    virtual uint8_t GetMemberHPPercent2(uint32_t index) const                  = 0;
    virtual uint8_t GetMemberMPPercent2(uint32_t index) const                  = 0;
    virtual uint8_t GetMemberIsActive(uint32_t index) const                    = 0;

    /**
     * Warning!
     * 
     * Plugins should not use this function! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::partystatusicons_t* GetRawStructureStatusIcons(void) const = 0;

    // Get Properties (Status Icons)
    virtual uint32_t GetStatusIconsServerId(uint32_t index) const    = 0;
    virtual uint32_t GetStatusIconsTargetIndex(uint32_t index) const = 0;
    virtual uint64_t GetStatusIconsBitMask(uint32_t index) const     = 0;
    virtual uint8_t* GetStatusIcons(uint32_t index) const            = 0;
};

struct IPlayer
{
    /**
     * Warning!
     * 
     * Plugins should not use this function! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::player_t* GetRawStructure(void) const = 0;

    // Get Properties (Player Info)
    virtual uint32_t GetHPMax(void) const                                  = 0;
    virtual uint32_t GetMPMax(void) const                                  = 0;
    virtual uint8_t GetMainJob(void) const                                 = 0;
    virtual uint8_t GetMainJobLevel(void) const                            = 0;
    virtual uint8_t GetSubJob(void) const                                  = 0;
    virtual uint8_t GetSubJobLevel(void) const                             = 0;
    virtual uint16_t GetExpCurrent(void) const                             = 0;
    virtual uint16_t GetExpNeeded(void) const                              = 0;
    virtual int16_t GetStat(uint32_t sid) const                            = 0;
    virtual int16_t GetStatModifier(uint32_t sid) const                    = 0;
    virtual int16_t GetAttack(void) const                                  = 0;
    virtual int16_t GetDefense(void) const                                 = 0;
    virtual int16_t GetResist(uint32_t rid) const                          = 0;
    virtual uint16_t GetTitle(void) const                                  = 0;
    virtual uint16_t GetRank(void) const                                   = 0;
    virtual uint16_t GetRankPoints(void) const                             = 0;
    virtual uint16_t GetHomepoint(void) const                              = 0;
    virtual uint8_t GetNation(void) const                                  = 0;
    virtual uint8_t GetResidence(void) const                               = 0;
    virtual uint16_t GetSuLevel(void) const                                = 0;
    virtual uint8_t GetHighestItemLevel(void) const                        = 0;
    virtual uint8_t GetItemLevel(void) const                               = 0;
    virtual uint8_t GetMainHandItemLevel(void) const                       = 0;
    virtual uint8_t GetRangedItemLevel(void) const                         = 0;
    virtual uint32_t GetUnityFaction(void) const                           = 0;
    virtual uint32_t GetUnityPoints(void) const                            = 0;
    virtual uint16_t GetUnityPartialPersonalEvalutionPoints(void) const    = 0;
    virtual uint16_t GetUnityPersonalEvaluationPoints(void) const          = 0;
    virtual uint32_t GetUnityChatColorFlag(void) const                     = 0;
    virtual uint8_t GetMasteryJob(void) const                              = 0;
    virtual uint8_t GetMasteryJobLevel(void) const                         = 0;
    virtual uint8_t GetMasteryFlags(void) const                            = 0;
    virtual uint8_t GetMasteryUnknown0000(void) const                      = 0;
    virtual uint32_t GetMasteryExp(void) const                             = 0;
    virtual uint32_t GetMasteryExpNeeded(void) const                       = 0;
    virtual Ashita::FFXI::combatskill_t GetCombatSkill(uint32_t sid) const = 0;
    virtual Ashita::FFXI::craftskill_t GetCraftSkill(uint32_t sid) const   = 0;
    virtual uint16_t GetAbilityRecast(uint32_t index) const                = 0;
    virtual uint8_t GetAbilityRecastCalc1(uint32_t index) const            = 0;
    virtual uint16_t GetAbilityRecastTimerId(uint32_t index) const         = 0;
    virtual int16_t GetAbilityRecastCalc2(uint32_t index) const            = 0;
    virtual uint32_t GetMountRecast(void) const                            = 0;
    virtual uint32_t GetMountRecastTimerId(void) const                     = 0;
    virtual uint8_t GetDataLoadedFlags(void) const                         = 0;
    virtual uint16_t GetLimitPoints(void) const                            = 0;
    virtual uint8_t GetMeritPoints(void) const                             = 0;
    virtual uint8_t GetAssimilationPoints(void) const                      = 0;
    virtual bool GetIsLimitBreaker(void) const                             = 0;
    virtual bool GetIsExperiencePointsLocked(void) const                   = 0;
    virtual bool GetIsLimitModeEnabled(void) const                         = 0;
    virtual uint8_t GetMeritPointsMax(void) const                          = 0;
    virtual uint8_t* GetHomepointMasks(void) const                         = 0;
    virtual uint32_t GetIsZoning(void) const                               = 0;
    virtual float GetStatusOffset1X(void) const                            = 0;
    virtual float GetStatusOffset1Z(void) const                            = 0;
    virtual float GetStatusOffset1Y(void) const                            = 0;
    virtual float GetStatusOffset1W(void) const                            = 0;
    virtual float GetStatusOffset2X(void) const                            = 0;
    virtual float GetStatusOffset2Z(void) const                            = 0;
    virtual float GetStatusOffset2Y(void) const                            = 0;
    virtual float GetStatusOffset2W(void) const                            = 0;
    virtual float GetStatusOffset3X(void) const                            = 0;
    virtual float GetStatusOffset3Z(void) const                            = 0;
    virtual float GetStatusOffset3Y(void) const                            = 0;
    virtual float GetStatusOffset3W(void) const                            = 0;
    virtual float GetStatusOffset4X(void) const                            = 0;
    virtual float GetStatusOffset4Z(void) const                            = 0;
    virtual float GetStatusOffset4Y(void) const                            = 0;
    virtual float GetStatusOffset4W(void) const                            = 0;

    // Get Properties (Job Points)
    virtual uint16_t GetCapacityPoints(uint32_t jobid) const = 0;
    virtual uint16_t GetJobPoints(uint32_t jobid) const      = 0;
    virtual uint16_t GetJobPointsSpent(uint32_t jobid) const = 0;

    // Get Properties (Status Icons / Buffs)
    virtual int16_t* GetStatusIcons(void) const   = 0;
    virtual uint32_t* GetStatusTimers(void) const = 0;
    virtual int16_t* GetBuffs(void) const         = 0;

    // Get Properties (Pet Info)
    virtual uint8_t GetPetMPPercent(void) const = 0;
    virtual uint32_t GetPetTP(void) const       = 0;

    // Get Properties (Extra Info)
    virtual uint8_t GetJobLevel(uint32_t jobid) const       = 0;
    virtual uint32_t GetJobMasterFlags(void) const          = 0;
    virtual uint8_t GetJobMasterLevel(uint32_t jobid) const = 0;
    virtual uint8_t GetLoginStatus(void) const              = 0;

    // Helper Functions
    virtual bool HasAbilityData(void) const        = 0;
    virtual bool HasSpellData(void) const          = 0;
    virtual bool HasAbility(uint32_t id) const     = 0;
    virtual bool HasPetCommand(uint32_t id) const  = 0;
    virtual bool HasSpell(uint32_t id) const       = 0;
    virtual bool HasTrait(uint32_t id) const       = 0;
    virtual bool HasWeaponSkill(uint32_t id) const = 0;
    virtual bool HasKeyItem(uint32_t id) const     = 0;
};

struct IRecast
{
    // Get Properties
    virtual uint32_t GetAbilityRecast(uint32_t index) const  = 0;
    virtual uint8_t GetAbilityCalc1(uint32_t index) const    = 0;
    virtual uint32_t GetAbilityTimerId(uint32_t index) const = 0;
    virtual int16_t GetAbilityCalc2(uint32_t index) const    = 0;
    virtual uint32_t GetAbilityTimer(uint32_t index) const   = 0;
    virtual uint32_t GetSpellTimer(uint32_t index) const     = 0;
};

struct ITarget
{
    /**
     * Warning!
     * 
     * Plugins should not use these functions! Use the Get/Set properties instead!
     */
    virtual Ashita::FFXI::target_t* GetRawStructure(void) const             = 0;
    virtual Ashita::FFXI::targetwindow_t* GetRawStructureWindow(void) const = 0;

    // Get Properties (Target Entry)
    virtual uint32_t GetTargetIndex(uint32_t index) const    = 0;
    virtual uint32_t GetServerId(uint32_t index) const       = 0;
    virtual uintptr_t GetEntityPointer(uint32_t index) const = 0;
    virtual uintptr_t GetActorPointer(uint32_t index) const  = 0;
    virtual float GetArrowPositionX(uint32_t index) const    = 0;
    virtual float GetArrowPositionZ(uint32_t index) const    = 0;
    virtual float GetArrowPositionY(uint32_t index) const    = 0;
    virtual float GetArrowPositionW(uint32_t index) const    = 0;
    virtual uint8_t GetIsActive(uint32_t index) const        = 0;
    virtual uint8_t GetIsModelActor(uint32_t index) const    = 0;
    virtual uint8_t GetIsArrowActive(uint32_t index) const   = 0;
    virtual uint16_t GetChecksum(uint32_t index) const       = 0;

    // Get Properties (Target Misc)
    virtual uint8_t GetIsWalk(void) const                = 0;
    virtual uint8_t GetIsAutoNotice(void) const          = 0;
    virtual uint8_t GetIsSubTargetActive(void) const     = 0;
    virtual uint8_t GetDeactivateTarget(void) const      = 0;
    virtual uint8_t GetModeChangeLock(void) const        = 0;
    virtual uint8_t GetIsMouseRequestStack(void) const   = 0;
    virtual uint8_t GetIsMouseRequestCancel(void) const  = 0;
    virtual uint8_t GetIsPlayerMoving(void) const        = 0;
    virtual uint32_t GetLockedOnFlags(void) const        = 0;
    virtual uint32_t GetSubTargetFlags(void) const       = 0;
    virtual uint16_t GetDefaultMode(void) const          = 0;
    virtual uint16_t GetMenuTargetLock(void) const       = 0;
    virtual uint8_t GetActionTargetActive(void) const    = 0;
    virtual uint8_t GetActionTargetMaxYalms(void) const  = 0;
    virtual uint8_t GetIsMenuOpen(void) const            = 0;
    virtual uint8_t GetIsActionAoe(void) const           = 0;
    virtual uint8_t GetActionType(void) const            = 0;
    virtual uint8_t GetActionAoeRange(void) const        = 0;
    virtual uint32_t GetActionId(void) const             = 0;
    virtual uint32_t GetActionTargetServerId(void) const = 0;
    virtual uint32_t GetFocusTargetIndex(void) const     = 0;
    virtual uint32_t GetFocusTargetServerId(void) const  = 0;
    virtual float GetTargetPosF(uint32_t index) const    = 0;
    virtual const char* GetLastTargetName(void) const    = 0;
    virtual uint32_t GetLastTargetIndex(void)            = 0;
    virtual uint32_t GetLastTargetServerId(void)         = 0;
    virtual uint32_t GetLastTargetChecksum(void)         = 0;
    virtual uintptr_t GetActionCallback(void) const      = 0;
    virtual uintptr_t GetCancelCallback(void) const      = 0;
    virtual uintptr_t GetMyroomCallback(void) const      = 0;
    virtual uintptr_t GetActionAoeCallback(void) const   = 0;

    // Get Properties (Target Window)
    virtual const char* GetWindowName(void) const              = 0;
    virtual uintptr_t GetWindowEntityPointer(void) const       = 0;
    virtual uint16_t GetWindowFrameChildrenOffsetX(void) const = 0;
    virtual uint16_t GetWindowFrameChildrenOffsetY(void) const = 0;
    virtual uint16_t GetWindowIconPositionX(void) const        = 0;
    virtual uint16_t GetWindowIconPositionY(void) const        = 0;
    virtual uint16_t GetWindowFrameOffsetX(void) const         = 0;
    virtual uint16_t GetWindowFrameOffsetY(void) const         = 0;
    virtual uint32_t GetWindowLockShape(void) const            = 0;
    virtual uint32_t GetWindowServerId(void) const             = 0;
    virtual uint8_t GetWindowHPPercent(void) const             = 0;
    virtual uint8_t GetWindowDeathFlag(void) const             = 0;
    virtual uint8_t GetWindowReraiseFlag(void) const           = 0;
    virtual uint32_t GetWindowDeathNameColor(void) const       = 0;
    virtual uint8_t GetWindowIsWindowLoaded(void) const        = 0;
    virtual uint32_t GetWindowHelpString(void) const           = 0;
    virtual uint32_t GetWindowHelpTitle(void) const            = 0;
    virtual uint32_t GetWindowAnkShape(uint32_t index) const   = 0;
    virtual uint8_t GetWindowSub(void) const                   = 0;
    virtual uint8_t GetWindowAnkNum(void) const                = 0;
    virtual int16_t GetWindowAnkX(void) const                  = 0;
    virtual int16_t GetWindowAnkY(void) const                  = 0;
    virtual int16_t GetWindowSubAnkX(void) const               = 0;
    virtual int16_t GetWindowSubAnkY(void) const               = 0;

    // Helper Functions
    virtual void SetTarget(uint32_t index, bool force) const = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Input Interface Definitions
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IController
{
    // Methods (Callbacks)
    virtual void AddCallback(const char* alias, const getdevicedatacallback_f& datacb, const getdevicestatecallback_f& statecb, const controllercallback_f& controllercb) = 0;
    virtual void RemoveCallback(const char* alias)                                                                                                                        = 0;

    // Methods (Input Injection)
    virtual void QueueButtonData(DWORD dwOfs, DWORD dwData) = 0;

    // Properties
    virtual bool GetTrackDeadZone(void) const = 0;
    virtual void SetTrackDeadZone(bool track) = 0;
};

struct IKeyboard
{
    // Methods (Keybinds)
    virtual void Bind(uint32_t key, bool down, bool alt, bool apps, bool ctrl, bool shift, bool win, const char* command) = 0;
    virtual void Unbind(uint32_t key, bool down, bool alt, bool apps, bool ctrl, bool shift, bool win)                    = 0;
    virtual void UnbindAll(void)                                                                                          = 0;
    virtual bool IsBound(uint32_t key, bool down, bool alt, bool apps, bool ctrl, bool shift, bool win)                   = 0;

    // Methods (Callbacks)
    virtual void AddCallback(const char* alias, const getdevicedatacallback_f& datacb, const getdevicestatecallback_f& statecb, const keyboardcallback_f& keyboardcb) = 0;
    virtual void RemoveCallback(const char* alias)                                                                                                                    = 0;

    // Methods (Key Conversions)
    virtual uint32_t V2D(uint32_t key) const    = 0;
    virtual uint32_t D2V(uint32_t key) const    = 0;
    virtual uint32_t S2D(const char* key) const = 0;
    virtual const char* D2S(uint32_t key) const = 0;

    // Properties
    virtual bool GetWindowsKeyEnabled(void) const   = 0;
    virtual void SetWindowsKeyEnabled(bool enabled) = 0;

    virtual bool GetBlockInput(void) const   = 0;
    virtual void SetBlockInput(bool blocked) = 0;

    virtual bool GetBlockBindsDuringInput(void) const   = 0;
    virtual void SetBlockBindsDuringInput(bool blocked) = 0;

    virtual bool GetSilentBinds(void) const  = 0;
    virtual void SetSilentBinds(bool silent) = 0;
};

struct IMouse
{
    // Methods (Callbacks)
    virtual void AddCallback(const char* alias, mousecallback_f callback) = 0;
    virtual void RemoveCallback(const char* alias)                        = 0;

    // Properties
    virtual bool GetBlockInput(void) const   = 0;
    virtual void SetBlockInput(bool blocked) = 0;
};

struct IXInput
{
    // Methods (Callbacks)
    virtual void AddCallback(const char* alias, const xinputgetstatecallback_f& statecb, const xinputcallback_f& controllercb) = 0;
    virtual void RemoveCallback(const char* alias)                                                                             = 0;

    // Methods (Input Injection)
    virtual void QueueButtonData(uint8_t button, int16_t state) = 0;

    // Properties
    virtual bool GetTrackDeadZone(void) const = 0;
    virtual void SetTrackDeadZone(bool track) = 0;
};

struct IInputManager
{
    // Methods (Input Objects)
    virtual IController* GetController(void) const = 0;
    virtual IKeyboard* GetKeyboard(void) const     = 0;
    virtual IMouse* GetMouse(void) const           = 0;
    virtual IXInput* GetXInput(void) const         = 0;

    // Properties
    virtual bool GetAllowGamepadInBackground(void) const = 0;
    virtual void SetAllowGamepadInBackground(bool allow) = 0;

    virtual bool GetDisableGamepad(void) const    = 0;
    virtual void SetDisableGamepad(bool disabled) = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Interface Definitions
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IChatManager
{
    // Methods
    virtual void ParseCommand(int32_t mode, const char* command)                                                      = 0;
    virtual void QueueCommand(int32_t mode, const char* command)                                                      = 0;
    virtual void Write(int32_t mode, bool indent, const char* message)                                                = 0;
    virtual void Writef(int32_t mode, bool indent, const char* format, ...)                                           = 0;
    virtual void AddChatMessage(int32_t mode, bool indent, const char* message)                                       = 0;
    virtual int32_t ParseAutoTranslate(const char* message, char* buffer, int32_t bufferSize, bool useBrackets) const = 0;
    virtual void ExecuteScript(const char* file, const char* arguments, bool threaded)                                = 0;
    virtual void ExecuteScriptString(const char* string, const char* arguments, bool threaded)                        = 0;

    // Properties
    virtual const char* GetInputTextRaw(void) const                        = 0;
    virtual void SetInputTextRaw(const char* message, uint32_t size) const = 0;
    virtual uint32_t GetInputTextRawLength(void) const                     = 0;
    virtual uint32_t GetInputTextRawCaretPosition(void) const              = 0;
    virtual const char* GetInputTextParsed(void) const                     = 0;
    virtual void SetInputTextParsed(const char* message) const             = 0;
    virtual uint32_t GetInputTextParsedLength(void) const                  = 0;
    virtual uint32_t GetInputTextParsedLengthMax(void) const               = 0;
    virtual const char* GetInputTextDisplay(void) const                    = 0;
    virtual void SetInputTextDisplay(const char* message) const            = 0;
    virtual void SetInputText(const char* message) const                   = 0;

    // Helpers
    virtual uint8_t IsInputOpen(void) const = 0;

    // Properties
    virtual bool GetSilentAliases(void) const  = 0;
    virtual void SetSilentAliases(bool silent) = 0;
};

struct IConfigurationManager
{
    // Methods (Files)
    virtual bool Load(const char* alias, const char* file) = 0;
    virtual bool Save(const char* alias, const char* file) = 0;
    virtual void Delete(const char* alias)                 = 0;

    // Methods (Section Helpers)
    virtual uint32_t GetSections(const char* alias, char* buffer, uint32_t bufferSize)                         = 0;
    virtual uint32_t GetSectionKeys(const char* alias, const char* section, char* buffer, uint32_t bufferSize) = 0;

    // Methods (Value Helpers)
    virtual const char* GetString(const char* alias, const char* section, const char* key)            = 0;
    virtual void SetValue(const char* alias, const char* section, const char* key, const char* value) = 0;

    // Methods (Value Getters)
    virtual bool GetBool(const char* alias, const char* section, const char* key, bool defaultValue)           = 0;
    virtual uint8_t GetUInt8(const char* alias, const char* section, const char* key, uint8_t defaultValue)    = 0;
    virtual uint16_t GetUInt16(const char* alias, const char* section, const char* key, uint16_t defaultValue) = 0;
    virtual uint32_t GetUInt32(const char* alias, const char* section, const char* key, uint32_t defaultValue) = 0;
    virtual uint64_t GetUInt64(const char* alias, const char* section, const char* key, uint64_t defaultValue) = 0;
    virtual int8_t GetInt8(const char* alias, const char* section, const char* key, int8_t defaultValue)       = 0;
    virtual int16_t GetInt16(const char* alias, const char* section, const char* key, int16_t defaultValue)    = 0;
    virtual int32_t GetInt32(const char* alias, const char* section, const char* key, int32_t defaultValue)    = 0;
    virtual int64_t GetInt64(const char* alias, const char* section, const char* key, int64_t defaultValue)    = 0;
    virtual float GetFloat(const char* alias, const char* section, const char* key, float defaultValue)        = 0;
    virtual double GetDouble(const char* alias, const char* section, const char* key, double defaultValue)     = 0;
};

struct IMemoryManager
{
    // Methods (Memory Objects)
    virtual IAutoFollow* GetAutoFollow(void) const = 0;
    virtual ICastBar* GetCastBar(void) const       = 0;
    virtual IEntity* GetEntity(void) const         = 0;
    virtual IInventory* GetInventory(void) const   = 0;
    virtual IParty* GetParty(void) const           = 0;
    virtual IPlayer* GetPlayer(void) const         = 0;
    virtual IRecast* GetRecast(void) const         = 0;
    virtual ITarget* GetTarget(void) const         = 0;
};

struct IOffsetManager
{
    // Methods
    virtual void Add(const char* section, const char* key, int32_t offset) = 0;
    virtual int32_t Get(const char* section, const char* key) const        = 0;
    virtual void Delete(const char* section)                               = 0;
    virtual void Delete(const char* section, const char* key)              = 0;
};

struct IPacketManager
{
    // Methods (Custom Packet Injection)
    virtual void AddIncomingPacket(uint16_t id, uint32_t len, uint8_t* data) = 0;
    virtual void AddOutgoingPacket(uint16_t id, uint32_t len, uint8_t* data) = 0;

    // Methods (Game Packet Queueing)
    virtual bool QueueOutgoingPacket(uint16_t id, uint16_t len, uint16_t align, uint32_t pparam1, uint32_t pparam2, std::function<void(uint8_t*)> callback) const = 0;
};

struct IPluginManager
{
    // Methods
    virtual bool Load(const char* name, const char* args) = 0;
    virtual bool Unload(const char* name)                 = 0;
    virtual void UnloadAll(void)                          = 0;

    virtual bool IsLoaded(const char* name) = 0;
    virtual void* Get(const char* name)     = 0;
    virtual void* Get(uint32_t index)       = 0;
    virtual uint32_t Count(void)            = 0;

    // Methods (Events)
    virtual void RaiseEvent(const char* eventName, const void* eventData, uint32_t eventSize) = 0;

    // Properties
    virtual bool GetSilentPlugins(void) const  = 0;
    virtual void SetSilentPlugins(bool silent) = 0;
};

struct IPolPluginManager
{
    // Methods
    virtual bool Load(const char* name, const char* args) = 0;
    virtual bool Unload(const char* name)                 = 0;
    virtual void UnloadAll(void)                          = 0;

    virtual bool IsLoaded(const char* name) = 0;
    virtual void* Get(const char* name)     = 0;
    virtual void* Get(uint32_t index)       = 0;
    virtual uint32_t Count(void)            = 0;

    // Methods (Events)
    virtual void RaiseEvent(const char* eventName, const void* eventData, uint32_t eventSize) = 0;
};

struct IPointerManager
{
    // Methods
    virtual void Add(const char* name, uintptr_t pointer)                                                                = 0;
    virtual uintptr_t Add(const char* name, const char* moduleName, const char* pattern, int32_t offset, uint32_t count) = 0;
    virtual uintptr_t Get(const char* name) const                                                                        = 0;
    virtual void Delete(const char* name)                                                                                = 0;
};

struct IResourceManager
{
    // Methods (Abilities)
    virtual IAbility* GetAbilityById(uint32_t id) const                         = 0;
    virtual IAbility* GetAbilityByName(const char* name, uint32_t langId) const = 0;
    virtual IAbility* GetAbilityByTimerId(uint32_t id) const                    = 0;

    // Methods (Spells)
    virtual ISpell* GetSpellById(uint32_t id) const                         = 0;
    virtual ISpell* GetSpellByName(const char* name, uint32_t langId) const = 0;

    // Methods (Items)
    virtual IItem* GetItemById(uint32_t id) const                         = 0;
    virtual IItem* GetItemByName(const char* name, uint32_t langId) const = 0;

    // Methods (Entities)
    virtual uint32_t GetEntityCount(void) const                    = 0;
    virtual uint32_t GetEntityIndexById(uint32_t id) const         = 0;
    virtual uint32_t GetEntityIdByIndex(uint32_t index) const      = 0;
    virtual const char* GetEntityNameByIndex(uint32_t index) const = 0;
    virtual const char* GetEntityNameById(uint32_t id) const       = 0;

    // Methods (Status Icons)
    virtual IStatusIcon* GetStatusIconByIndex(uint16_t index) const = 0;
    virtual IStatusIcon* GetStatusIconById(uint16_t id) const       = 0;

    // Methods (Strings)
    virtual const char* GetString(const char* table, uint32_t index) const                    = 0;
    virtual const char* GetString(const char* table, uint32_t index, uint32_t langId) const   = 0;
    virtual int32_t GetString(const char* table, const char* str) const                       = 0;
    virtual int32_t GetString(const char* table, const char* str, uint32_t langId) const      = 0;
    virtual int32_t GetStringLength(const char* table, uint32_t index) const                  = 0;
    virtual int32_t GetStringLength(const char* table, uint32_t index, uint32_t langId) const = 0;

    // Methods (Textures)
    virtual IDirect3DTexture8* GetTexture(const char* name) const = 0;
    virtual D3DXIMAGE_INFO GetTextureInfo(const char* name) const = 0;

    // Helpers
    virtual uint32_t GetFilePath(uint32_t fileId, char* buffer, uint32_t bufferSize) = 0;
    virtual uint32_t GetAbilityRange(uint32_t abilityId, bool useAreaRange) const    = 0;
    virtual uint32_t GetAbilityType(uint32_t type) const                             = 0;
    virtual uint32_t GetSpellRange(uint32_t spellId, bool useAreaRange) const        = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Direct3D8 Font/Primitive Interface Definitions
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IPrimitiveObject
{
    // Methods
    virtual void Render(void) const                                                                 = 0;
    virtual bool SetTextureFromFile(const char* path)                                               = 0;
    virtual bool SetTextureFromMemory(const void* data, uint32_t size, D3DCOLOR colorKey)           = 0;
    virtual bool SetTextureFromResource(const char* moduleName, const char* resName)                = 0;
    virtual bool SetTextureFromResourceCache(const char* name)                                      = 0;
    virtual bool SetTextureFromTexture(IDirect3DTexture8* texture, uint32_t width, uint32_t height) = 0;
    virtual bool HitTest(int32_t x, int32_t y) const                                                = 0;

    // Properties
    virtual const char* GetAlias(void) const                    = 0;
    virtual float GetTextureOffsetX(void) const                 = 0;
    virtual float GetTextureOffsetY(void) const                 = 0;
    virtual bool GetBorderVisible(void) const                   = 0;
    virtual D3DCOLOR GetBorderColor(void) const                 = 0;
    virtual Ashita::FontBorderFlags GetBorderFlags(void) const  = 0;
    virtual RECT GetBorderSizes(void) const                     = 0;
    virtual bool GetVisible(void) const                         = 0;
    virtual float GetPositionX(void) const                      = 0;
    virtual float GetPositionY(void) const                      = 0;
    virtual bool GetCanFocus(void) const                        = 0;
    virtual bool GetLocked(void) const                          = 0;
    virtual bool GetLockedZ(void) const                         = 0;
    virtual float GetScaleX(void) const                         = 0;
    virtual float GetScaleY(void) const                         = 0;
    virtual float GetWidth(void) const                          = 0;
    virtual float GetHeight(void) const                         = 0;
    virtual Ashita::PrimitiveDrawFlags GetDrawFlags(void) const = 0;
    virtual D3DCOLOR GetColor(void) const                       = 0;

    virtual void SetAlias(const char* alias)                    = 0;
    virtual void SetTextureOffsetX(float x)                     = 0;
    virtual void SetTextureOffsetY(float y)                     = 0;
    virtual void SetBorderVisible(bool visible)                 = 0;
    virtual void SetBorderColor(D3DCOLOR color)                 = 0;
    virtual void SetBorderFlags(Ashita::FontBorderFlags flags)  = 0;
    virtual void SetBorderSizes(RECT rect)                      = 0;
    virtual void SetVisible(bool visible)                       = 0;
    virtual void SetPositionX(float x)                          = 0;
    virtual void SetPositionY(float y)                          = 0;
    virtual void SetCanFocus(bool focus)                        = 0;
    virtual void SetLocked(bool locked)                         = 0;
    virtual void SetLockedZ(bool locked)                        = 0;
    virtual void SetScaleX(float x)                             = 0;
    virtual void SetScaleY(float y)                             = 0;
    virtual void SetWidth(float width)                          = 0;
    virtual void SetHeight(float height)                        = 0;
    virtual void SetDrawFlags(Ashita::PrimitiveDrawFlags flags) = 0;
    virtual void SetColor(D3DCOLOR color)                       = 0;

    // Properties (Callbacks)
    virtual fontkeyboardevent_f GetKeyboardCallback(void) const = 0;
    virtual fontmouseevent_f GetMouseCallback(void) const       = 0;
    virtual void SetKeyboardCallback(fontkeyboardevent_f cb)    = 0;
    virtual void SetMouseCallback(fontmouseevent_f cb)          = 0;
};

struct IPrimitiveManager
{
    // Methods
    virtual IPrimitiveObject* Create(const char* alias) = 0;
    virtual IPrimitiveObject* Get(const char* alias)    = 0;
    virtual void Delete(const char* alias)              = 0;

    // Properties
    virtual IPrimitiveObject* GetFocusedObject(void) = 0;
    virtual bool SetFocusedObject(const char* alias) = 0;

    virtual bool GetVisible(void) const   = 0;
    virtual void SetVisible(bool visible) = 0;
};

struct IFontObject
{
    // Methods
    virtual void Render(void)                        = 0;
    virtual void GetTextSize(SIZE* size) const       = 0;
    virtual bool HitTest(int32_t x, int32_t y) const = 0;

    // Properties (Parent & Background Objects)
    virtual IFontObject* GetParent(void) const          = 0;
    virtual IPrimitiveObject* GetBackground(void) const = 0;

    // Properties (Real Positions)
    virtual float GetRealPositionX(void) const = 0;
    virtual float GetRealPositionY(void) const = 0;

    // Properties
    virtual const char* GetAlias(void) const                   = 0;
    virtual bool GetVisible(void) const                        = 0;
    virtual bool GetCanFocus(void) const                       = 0;
    virtual bool GetLocked(void) const                         = 0;
    virtual bool GetLockedZ(void) const                        = 0;
    virtual bool GetIsDirty(void) const                        = 0;
    virtual float GetWindowWidth(void) const                   = 0;
    virtual float GetWindowHeight(void) const                  = 0;
    virtual const char* GetFontFile(void) const                = 0;
    virtual const char* GetFontFamily(void) const              = 0;
    virtual uint32_t GetFontHeight(void) const                 = 0;
    virtual Ashita::FontCreateFlags GetCreateFlags(void) const = 0;
    virtual Ashita::FontDrawFlags GetDrawFlags(void) const     = 0;
    virtual bool GetBold(void) const                           = 0;
    virtual bool GetItalic(void) const                         = 0;
    virtual bool GetRightJustified(void) const                 = 0;
    virtual bool GetStrikeThrough(void) const                  = 0;
    virtual bool GetUnderlined(void) const                     = 0;
    virtual D3DCOLOR GetColor(void) const                      = 0;
    virtual D3DCOLOR GetColorOutline(void) const               = 0;
    virtual float GetPadding(void) const                       = 0;
    virtual float GetPositionX(void) const                     = 0;
    virtual float GetPositionY(void) const                     = 0;
    virtual bool GetAutoResize(void) const                     = 0;
    virtual Ashita::FrameAnchor GetAnchor(void) const          = 0;
    virtual Ashita::FrameAnchor GetAnchorParent(void) const    = 0;
    virtual const char* GetText(void) const                    = 0;

    virtual void SetAlias(const char* alias)                   = 0;
    virtual void SetVisible(bool visible)                      = 0;
    virtual void SetCanFocus(bool focus)                       = 0;
    virtual void SetLocked(bool locked)                        = 0;
    virtual void SetLockedZ(bool locked)                       = 0;
    virtual void SetIsDirty(bool dirty)                        = 0;
    virtual void SetWindowWidth(float width)                   = 0;
    virtual void SetWindowHeight(float height)                 = 0;
    virtual void SetFontFile(const char* file)                 = 0;
    virtual void SetFontFamily(const char* family)             = 0;
    virtual void SetFontHeight(uint32_t height)                = 0;
    virtual void SetCreateFlags(Ashita::FontCreateFlags flags) = 0;
    virtual void SetDrawFlags(Ashita::FontDrawFlags flags)     = 0;
    virtual void SetBold(bool bold)                            = 0;
    virtual void SetItalic(bool italic)                        = 0;
    virtual void SetRightJustified(bool right)                 = 0;
    virtual void SetStrikeThrough(bool strike)                 = 0;
    virtual void SetUnderlined(bool underlined)                = 0;
    virtual void SetColor(D3DCOLOR color)                      = 0;
    virtual void SetColorOutline(D3DCOLOR color)               = 0;
    virtual void SetPadding(float padding)                     = 0;
    virtual void SetPositionX(float x)                         = 0;
    virtual void SetPositionY(float y)                         = 0;
    virtual void SetAutoResize(bool autoResize)                = 0;
    virtual void SetAnchor(Ashita::FrameAnchor anchor)         = 0;
    virtual void SetAnchorParent(Ashita::FrameAnchor anchor)   = 0;
    virtual void SetText(const char* text)                     = 0;
    virtual void SetParent(IFontObject* parent)                = 0;

    // Properties (Callbacks)
    virtual fontkeyboardevent_f GetKeyboardCallback(void) const = 0;
    virtual fontmouseevent_f GetMouseCallback(void) const       = 0;
    virtual void SetKeyboardCallback(fontkeyboardevent_f cb)    = 0;
    virtual void SetMouseCallback(fontmouseevent_f cb)          = 0;
};

struct IFontManager
{
    // Methods
    virtual IFontObject* Create(const char* alias) = 0;
    virtual IFontObject* Get(const char* alias)    = 0;
    virtual void Delete(const char* alias)         = 0;

    // Properties
    virtual IFontObject* GetFocusedObject(void)      = 0;
    virtual bool SetFocusedObject(const char* alias) = 0;

    virtual bool GetVisible(void) const   = 0;
    virtual void SetVisible(bool visible) = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// LogManager Interface Definition
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct ILogManager
{
    // Methods
    virtual bool Log(uint32_t level, const char* source, const char* message)      = 0;
    virtual bool Logf(uint32_t level, const char* source, const char* format, ...) = 0;

    // Properties
    virtual uint32_t GetLogLevel(void) const = 0;
    virtual void SetLogLevel(uint32_t level) = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// AshitaCore Interface Definition
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IProperties
{
    // PlayOnline Window Properties
    virtual HWND GetPlayOnlineHwnd(void) const        = 0;
    virtual uint32_t GetPlayOnlineStyle(void) const   = 0;
    virtual uint32_t GetPlayOnlineStyleEx(void) const = 0;
    virtual RECT GetPlayOnlineRect(void) const        = 0;
    virtual void SetPlayOnlineHwnd(HWND hWnd)         = 0;
    virtual void SetPlayOnlineStyle(uint32_t style)   = 0;
    virtual void SetPlayOnlineStyleEx(uint32_t style) = 0;
    virtual void SetPlayOnlineRect(RECT rect)         = 0;

    // PlayOnline Mask Window Properties
    virtual HWND GetPlayOnlineMaskHwnd(void) const        = 0;
    virtual uint32_t GetPlayOnlineMaskStyle(void) const   = 0;
    virtual uint32_t GetPlayOnlineMaskStyleEx(void) const = 0;
    virtual RECT GetPlayOnlineMaskRect(void) const        = 0;
    virtual void SetPlayOnlineMaskHwnd(HWND hWnd)         = 0;
    virtual void SetPlayOnlineMaskStyle(uint32_t style)   = 0;
    virtual void SetPlayOnlineMaskStyleEx(uint32_t style) = 0;
    virtual void SetPlayOnlineMaskRect(RECT rect)         = 0;

    // Final Fantasy XI Window Properties
    virtual HWND GetFinalFantasyHwnd(void) const        = 0;
    virtual uint32_t GetFinalFantasyStyle(void) const   = 0;
    virtual uint32_t GetFinalFantasyStyleEx(void) const = 0;
    virtual RECT GetFinalFantasyRect(void) const        = 0;
    virtual void SetFinalFantasyHwnd(HWND hWnd)         = 0;
    virtual void SetFinalFantasyStyle(uint32_t style)   = 0;
    virtual void SetFinalFantasyStyleEx(uint32_t style) = 0;
    virtual void SetFinalFantasyRect(RECT rect)         = 0;

    // Direct3D Properties
    virtual bool GetD3DAmbientEnabled(void) const   = 0;
    virtual uint32_t GetD3DAmbientColor(void) const = 0;
    virtual uint32_t GetD3DFillMode(void) const     = 0;
    virtual void SetD3DAmbientEnabled(bool enabled) = 0;
    virtual void SetD3DAmbientColor(uint32_t color) = 0;
    virtual void SetD3DFillMode(uint32_t fillmode)  = 0;
};

struct IAshitaCore
{
    // Properties
    virtual HMODULE GetHandle(void) const                   = 0;
    virtual const char* GetInstallPath(void) const          = 0;
    virtual IDirect3DDevice8* GetDirect3DDevice(void) const = 0;

    // Methods (Properties)
    virtual IProperties* GetProperties(void) const = 0;

    // Methods (Manager Objects)
    virtual IChatManager* GetChatManager(void) const                   = 0;
    virtual IConfigurationManager* GetConfigurationManager(void) const = 0;
    virtual IFontManager* GetFontManager(void) const                   = 0;
    virtual IGuiManager* GetGuiManager(void) const                     = 0;
    virtual IInputManager* GetInputManager(void) const                 = 0;
    virtual IMemoryManager* GetMemoryManager(void) const               = 0;
    virtual IOffsetManager* GetOffsetManager(void) const               = 0;
    virtual IPacketManager* GetPacketManager(void) const               = 0;
    virtual IPluginManager* GetPluginManager(void) const               = 0;
    virtual IPolPluginManager* GetPolPluginManager(void) const         = 0;
    virtual IPointerManager* GetPointerManager(void) const             = 0;
    virtual IPrimitiveManager* GetPrimitiveManager(void) const         = 0;
    virtual IResourceManager* GetResourceManager(void) const           = 0;

    // Methods (API Hook Forwards - DirectX)
    virtual IDirect3D8* Direct3DCreate8(UINT SDKVersion)                                                                      = 0;
    virtual HRESULT DirectInput8Create(HINSTANCE hinst, DWORD dwVersion, REFIID riidltf, LPVOID* ppvOut, LPUNKNOWN punkOuter) = 0;

    // Methods (API Hook Forwards - Mutex)
    virtual HANDLE CreateMutexA(LPSECURITY_ATTRIBUTES lpMutexAttributes, BOOL bInitialOwner, LPCSTR lpName)  = 0;
    virtual HANDLE CreateMutexW(LPSECURITY_ATTRIBUTES lpMutexAttributes, BOOL bInitialOwner, LPCWSTR lpName) = 0;
    virtual HANDLE OpenMutexA(DWORD dwDesiredAccess, BOOL bInheritHandle, LPCSTR lpName)                     = 0;
    virtual HANDLE OpenMutexW(DWORD dwDesiredAccess, BOOL bInheritHandle, LPCWSTR lpName)                    = 0;

    // Methods (API Hook Forwards - Registry)
    virtual LSTATUS RegQueryValueExA(HKEY hKey, LPCSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData) = 0;

    // Methods (API Hook Forwards - Window)
    virtual HWND CreateWindowExA(DWORD dwExStyle, LPCSTR lpClassName, LPCSTR lpWindowName, DWORD dwStyle, int X, int Y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam)   = 0;
    virtual HWND CreateWindowExW(DWORD dwExStyle, LPCWSTR lpClassName, LPCWSTR lpWindowName, DWORD dwStyle, int X, int Y, int nWidth, int nHeight, HWND hWndParent, HMENU hMenu, HINSTANCE hInstance, LPVOID lpParam) = 0;
    virtual void ExitProcess(UINT uExitCode)                                                                                                                                                                          = 0;
    virtual int GetSystemMetrics(int nIndex)                                                                                                                                                                          = 0;
    virtual int GetWindowTextA(HWND hWnd, LPSTR lpString, int nMaxCount)                                                                                                                                              = 0;
    virtual int GetWindowTextW(HWND hWnd, LPWSTR lpString, int nMaxCount)                                                                                                                                             = 0;
    virtual HBITMAP LoadBitmapW(HINSTANCE hInstance, LPCWSTR lpBitmapName)                                                                                                                                            = 0;
    virtual ATOM RegisterClassA(CONST WNDCLASSA* lpWndClass)                                                                                                                                                          = 0;
    virtual ATOM RegisterClassW(CONST WNDCLASSW* lpWndClass)                                                                                                                                                          = 0;
    virtual ATOM RegisterClassExA(CONST WNDCLASSEXA* lpWndClass)                                                                                                                                                      = 0;
    virtual ATOM RegisterClassExW(CONST WNDCLASSEXW* lpWndClass)                                                                                                                                                      = 0;
    virtual BOOL RemoveMenu(HMENU hMenu, UINT uPosition, UINT uFlags)                                                                                                                                                 = 0;
    virtual LRESULT SendMessageA(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)                                                                                                                                  = 0;
    virtual BOOL SetCursorPos(int X, int Y)                                                                                                                                                                           = 0;
    virtual HWND SetFocus(HWND hWnd)                                                                                                                                                                                  = 0;
    virtual BOOL SetForegroundWindow(HWND hWnd)                                                                                                                                                                       = 0;
    virtual BOOL SetPriorityClass(HANDLE hProcess, DWORD dwPriorityClass)                                                                                                                                             = 0;
    virtual HHOOK SetWindowsHookExA(int idHook, HOOKPROC lpfn, HINSTANCE hmod, DWORD dwThreadId)                                                                                                                      = 0;
    virtual BOOL SetWindowTextA(HWND hWnd, LPCSTR lpString)                                                                                                                                                           = 0;
    virtual BOOL SetWindowTextW(HWND hWnd, LPCWSTR lpString)                                                                                                                                                          = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Plugin Base Interface
//
// The base interface that defines the implementation of a plugins main class. Plugins should not
// directly inherit from this interface, they should inherit IPlugin instead.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IPluginBase
{
    // Properties (Plugin Information)
    virtual const char* GetName(void) const        = 0;
    virtual const char* GetAuthor(void) const      = 0;
    virtual const char* GetDescription(void) const = 0;
    virtual const char* GetLink(void) const        = 0;
    virtual double GetVersion(void) const          = 0;
    virtual double GetInterfaceVersion(void) const = 0;
    virtual int32_t GetPriority(void) const        = 0;
    virtual uint32_t GetFlags(void) const          = 0;

    // Methods
    virtual bool Initialize(IAshitaCore*, ILogManager*, uint32_t) = 0;
    virtual void Release(void)                                    = 0;

    // Event Callbacks: PluginManager
    virtual void HandleEvent(const char*, const void*, uint32_t) = 0;

    // Event Callbacks: ChatManager
    virtual bool HandleCommand(int32_t, const char*, bool)                                          = 0;
    virtual bool HandleIncomingText(int32_t, bool, const char*, int32_t*, bool*, char*, bool, bool) = 0;
    virtual bool HandleOutgoingText(int32_t, const char*, int32_t*, char*, bool, bool)              = 0;

    // Event Callbacks: PacketManager
    virtual bool HandleIncomingPacket(uint16_t, uint32_t, const uint8_t*, uint8_t*, uint32_t, const uint8_t*, bool, bool) = 0;
    virtual bool HandleOutgoingPacket(uint16_t, uint32_t, const uint8_t*, uint8_t*, uint32_t, const uint8_t*, bool, bool) = 0;

    // Event Callbacks: Direct3D
    virtual bool Direct3DInitialize(IDirect3DDevice8*)                                                                         = 0;
    virtual void Direct3DBeginScene(bool)                                                                                      = 0;
    virtual void Direct3DEndScene(bool)                                                                                        = 0;
    virtual void Direct3DPresent(const RECT*, const RECT*, HWND, const RGNDATA*)                                               = 0;
    virtual bool Direct3DSetRenderState(D3DRENDERSTATETYPE, DWORD*)                                                            = 0;
    virtual bool Direct3DDrawPrimitive(D3DPRIMITIVETYPE, UINT, UINT)                                                           = 0;
    virtual bool Direct3DDrawIndexedPrimitive(D3DPRIMITIVETYPE, UINT, UINT, UINT, UINT)                                        = 0;
    virtual bool Direct3DDrawPrimitiveUP(D3DPRIMITIVETYPE, UINT, CONST void*, UINT)                                            = 0;
    virtual bool Direct3DDrawIndexedPrimitiveUP(D3DPRIMITIVETYPE, UINT, UINT, UINT, CONST void*, D3DFORMAT, CONST void*, UINT) = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Plugin Base Class
//
// The base class that all plugins must inherit from. Implements default handlers for all events
// which developers can override if they wish to handle manually. (The main class object returned
// from the 'expCreatePlugin' export of your plugin must inherit from this class.)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

class IPlugin : public IPluginBase
{
public:
    /**
     * Constructor and Deconstructor
     */
    IPlugin(void)
    {}
    virtual ~IPlugin(void)
    {}

    /**
     * Returns the plugins name.
     *
     * @return {const char*} The plugins name.
     */
    const char* GetName(void) const override
    {
        return "PluginBase";
    }

    /**
     * Returns the plugins author.
     *
     * @return {const char*} The plugins author.
     */
    const char* GetAuthor(void) const override
    {
        return "Ashita Development Team";
    }

    /**
     * Returns the plugins description.
     *
     * @return {const char*} The plugins description.
     */
    const char* GetDescription(void) const override
    {
        return "Ashita Plugin Base";
    }

    /**
     * Returns the plugins homepage link.
     *
     * @return {const char*} The plugins homepage link.
     */
    const char* GetLink(void) const override
    {
        return "https://www.ashitaxi.com/";
    }

    /**
     * Returns the plugins version.
     *
     * @return {double} The plugins version.
     */
    double GetVersion(void) const override
    {
        return 1.0f;
    }

    /**
     * Returns the plugins Ashita SDK interface version it was compiled against.
     *
     * @return {double} The plugins interface version.
     */
    double GetInterfaceVersion(void) const override
    {
        return ASHITA_INTERFACE_VERSION;
    }

    /**
     * Returns the plugins execution priority.
     *
     * @return {int32_t} The plugins execution priority.
     * @notes
     *
     *      The priority value is used to determine the execution order of the plugins loaded in Ashita. When an event is fired, Ashita
     *      will loop through each of the loaded plugins and allow them to attempt to handle the event. The order that the plugins are
     *      passed the event is determined by this priority. By default, 0 will load a plugin 'next' in the list of plugins who also are
     *      set to 0. Meaning if other plugins are already loaded at 0, and your plugin is also 0 your plugin will be last.
     *      
     *      Plugins can force themselves sooner or later into the execution order by using this value (both negative and position).
     *      Negative values will place your plugin sooner in the execution order, while positive values will place it later.
     *      
     *      Plugins should use 0 by default if order does not matter to their purpose.
     */
    int32_t GetPriority(void) const override
    {
        return 0;
    }

    /**
     * Returns the plugins flags.
     *
     * @return {uint32_t} The plugins flags.
     * @notes
     * 
     *      Ashita offers a various number of events that can be invoked inside of a plugin, allowing plugins to have a lot of control
     *      over the flow of the game. However, this can create a lot of overhead, more specifically on lower end machines. Plugins can
     *      use this property to specify the exact events it plans to make use of, allowing Ashita to only invoke ones it needs.
     *      
     *      Plugins should explicitly state which flags they plan to make use of and avoid using 'All' flags.
     *      This can help with the performance of the game for lower end machines.
     *      
     *      See the 'Ashita::PluginFlags' enumeration for more information on what each flag does.
     */
    uint32_t GetFlags(void) const override
    {
        return (uint32_t)Ashita::PluginFlags::None;
    }

    /**
     * Event invoked when the plugin is being loaded and initialized.
     *
     * @param {IAshitaCore*} core - The main Ashita core instance used to interact with the Ashita hook.
     * @param {ILogManager*} logger - The log manager instance used to write to the debug log files.
     * @param {uint32_t} id - The plugins unique id. (Matches the plugins module base address.)
     * @return {bool} True on success, false otherwise.
     *
     * @notes
     * 
     *      Plugins must return true from this function in order to be considered valid and continue to load.
     *      If your plugin fails to meet any requirements you feel are manditory for it to run, you should return false here and prevent it
     *      from loading further.
     */
    bool Initialize(IAshitaCore* core, ILogManager* logger, const uint32_t id) override
    {
        UNREFERENCED_PARAMETER(core);
        UNREFERENCED_PARAMETER(logger);
        UNREFERENCED_PARAMETER(id);

        return false;
    }

    /**
     * Event invoked when the plugin is being unloaded.
     *
     * @notes
     *
     *      Plugins should use this event to cleanup all resources they created or used during their lifespan.
     *      (ie. Fonts, primitives, textures, Direct3D related resources, memory allocations, etc.)
     */
    void Release(void) override
    {}

    /**
     * Event invoked when another plugin has raised a custom event for other plugins to handle.
     *
     * @param {const char*} eventName - The name of the custom event being raised.
     * @param {const void*} eventData - The custom event data to pass through the event.
     * @param {uint32_t} eventSize - The size of the custom event data buffer.
     * 
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UsePluginEvents flag is set.
     *
     *      Plugins can make use of the custom event system as a way to talk to other plugins in a safe manner.
     *      Events can be raised via the PluginManager::RaiseEvent method which will cause this handler to be
     *      invoked in all loaded plugins with the given event information.
     */
    void HandleEvent(const char* eventName, const void* eventData, const uint32_t eventSize) override
    {
        UNREFERENCED_PARAMETER(eventName);
        UNREFERENCED_PARAMETER(eventData);
        UNREFERENCED_PARAMETER(eventSize);
    }

    /**
     * Event invoked when an input command is being processed by the game client.
     *
     * @param {int32_t} mode - The mode of the command. (See: Ashita::CommandMode)
     * @param {const char*} command - The raw command string.
     * @param {bool} injected - Flag if the command was injected from an Ashita related resource. (Addon, plugin or internally.)
     * @return {bool} True if handled and should be blocked, false otherwise.
     *
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UseCommands flag is set.
     *      
     *      Any commands sent through the games input handler will be passed to plugins to be processed first allowing plugins to intercept
     *      and handle any kind of command they wish. This includes commands typed into the chat bar, commands invoked from macros, menu items
     *      and so on. Commands that have been injected by Ashita or another plugin will be marked via the injected parameter.
     *      
     *      If a plugin returns true, the command is blocked from further processing by Ashita or the game client and is considered handled.
     *      
     *      Plugins should return true for any commands they have handled or reacted to when appropriate. To prevent deadlocks by trying to
     *      inject another command here, plugins should instead use the IChatManager::QueueCommand function for any manual command inserts
     *      back into the game.
     */
    bool HandleCommand(int32_t mode, const char* command, bool injected) override
    {
        UNREFERENCED_PARAMETER(mode);
        UNREFERENCED_PARAMETER(command);
        UNREFERENCED_PARAMETER(injected);

        return false;
    }

    /**
     * Event invoked when incoming text is being processed by the game client, to be added to the chat window.
     *
     * @param {int32_t} mode - The message mode. (Determines its base color.)
     * @param {bool} indent - Flag that determines if the message is indented.
     * @param {const char*} message - The raw message string.
     * @param {int32_t*} modifiedMode - The modified mode, if any, that has been altered by another addon/plugin.
     * @param {bool*} modifiedIndent - The modified indent flag, if any, that has been altered by another addon/plugin.
     * @param {char*} modifiedMessage - The modified message string, if any, that has been altered by another addon/plugin.
     * @param {bool} injected - Flag if the message was injected from an Ashita related resource. (Addon, plugin, or internally.)
     * @param {bool} blocked - Flag if the message has been blocked by another addon/plugin.
     * @return {bool} True if handled and should be blocked, false otherwise.
     *
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UseText flag is set.
     *      
     *      If a plugin returns true, the block flag is set to true (cannot be unset), however the message will still be passed to all loaded
     *      plugins whom are marked to accept the event. Plugins should check if the blocked flag has been set first before reacting to messages
     *      in case a previous plugin has deemed it to not be displayed in the game chat log. Unless your plugin requires reacting to certain/all
     *      messages, then it should simply return immediately if blocked is already true.
     *      
     *      mode and message contain the original, unmodified data of the event which can be used to see what was originally used to invoke the 
     *      event, as well as for plugins that require the original unedited message to properly operate. Plugins should however check for changes
     *      by seeing if modifiedMessage has been altered. If modifiedMessage has any value (strlen > 0) then plugins should honor previous plugin
     *      changes made to the message. You should only completely overwrite modifiedMessage if your plugin specifically needs to take over a given
     *      message. (For example if a certain plugin injects color tags into a message, your plugin should not remove them unless absolutely necessary.)
     *      
     *      modifiedMessage is an internal buffer of 4096 bytes, therefore it should have plenty of space for any message you wish to add.
     *      
     *      You should not call Write, Writef, or AddChatMessage functions here! Otherwise you will cause a stack overflow.
     */
    bool HandleIncomingText(int32_t mode, bool indent, const char* message, int32_t* modifiedMode, bool* modifiedIndent, char* modifiedMessage, bool injected, bool blocked) override
    {
        UNREFERENCED_PARAMETER(mode);
        UNREFERENCED_PARAMETER(indent);
        UNREFERENCED_PARAMETER(message);
        UNREFERENCED_PARAMETER(modifiedMode);
        UNREFERENCED_PARAMETER(modifiedIndent);
        UNREFERENCED_PARAMETER(modifiedMessage);
        UNREFERENCED_PARAMETER(injected);
        UNREFERENCED_PARAMETER(blocked);

        return false;
    }

    /**
     * Event invoked when the game client is sending text to the server. 
     *
     * @param {int32_t} mode - The message mode. (See: Ashita::CommandMode)
     * @param {const char*} message - The raw message string.
     * @param {int32_t*} modifiedMode - The modified mode, if any, that has been altered by another addon/plugin.
     * @param {char*} modifiedMessage - The modified message string, if any, that has been altered by another addon/plugin.
     * @param {bool} injected - Flag if the message was injected from an Ashita related resource. (Addon, plugin, or internally.)
     * @param {bool} blocked - Flag if the message has been blocked by another addon/plugin.
     * @return {bool} True if handled and should be blocked, false otherwise.
     *
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UseText flag is set.
     *      
     *      This event is invoked after an input command has gone unhandled and is about to be sent to the game client, potentially to the server. This
     *      can be used as an end-all-catch-all of processing input commands. Actual command handling should be done in the HandleCommand event though.
     *      
     *      If a plugin returns true, the command is blocked from further processing by Ashita or the game client and is considered handled.
     *      
     *      Plugins should return true for any commands they have handled or reacted to when appropriate. To prevent deadlocks by trying to
     *      inject another command here, plugins should instead use the IChatManager::QueueCommand function for any manual command inserts
     *      back into the game.
     *      
     *      mode and message contain the original, unmodified data of the event which can be used to see what was originally used to invoke the 
     *      event, as well as for plugins that require the original unedited message to properly operate. Plugins should however check for changes
     *      by seeing if modifiedMessage has been altered. If modifiedMessage has any value (strlen > 0) then plugins should honor previous plugin
     *      changes made to the message. You should only completely overwrite modifiedMessage if your plugin specifically needs to take over a given
     *      message. 
     *      
     *      modifiedMessage is an internal buffer of 4096 bytes, therefore it should have plenty of space for any message you wish to add. 
     */
    bool HandleOutgoingText(int32_t mode, const char* message, int32_t* modifiedMode, char* modifiedMessage, bool injected, bool blocked) override
    {
        UNREFERENCED_PARAMETER(mode);
        UNREFERENCED_PARAMETER(message);
        UNREFERENCED_PARAMETER(modifiedMode);
        UNREFERENCED_PARAMETER(modifiedMessage);
        UNREFERENCED_PARAMETER(injected);
        UNREFERENCED_PARAMETER(blocked);

        return false;
    }

    /**
     * Event invoked when the game client is processing an incoming packet.
     *
     * @param {uint16_t} id - The id of the packet.
     * @param {uint32_t} size - The size of the packet.
     * @param {const uint8_t*} data - The raw data of the packet.
     * @param {uint8_t*} modified - The modified packet data, if any, that has been altered by another addon/plugin.
     * @param {uint32_t} sizeChunk - The size of the full packet chunk that contained the packet.
     * @param {const uint8_t*} dataChunk - The raw data of the full packet chunk that contained the packet.
     * @param {bool} injected - Flag if the packet was injected from an Ashita related resource. (Addon, plugin, or internally.)
     * @param {bool} blocked - Flag if the packet has been blocked by another addon/plugin.
     * @return {bool} True if handled and should be blocked, false otherwise.
     *
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UsePackets flag is set.
     *      
     *      If a plugin returns true, the block flag is set to true (cannot be unset), however the event will still be passed to all loaded
     *      plugins whom are marked to accept it. Plugins should check if the blocked flag has been set first before reacting to the event
     *      in case a previous plugin has deemed it to be blocked. Unless your plugin requires reacting to certain/all packets, then it 
     *      should simply return immediately if blocked is already true.
     *      
     *      Packets in FFXI are sent in chunks, meaning there are multiple packets inside of each chunk. This information may be needed when
     *      dealing with certain packet ids, thus Ashita offers the ability to see the full chunk each packet was part of.
     *      
     *      id, size, and data are all specific to the individual packet that caused the event to be invoked and contain the unmodified
     *      information about the individual packet. These should not be edited.
     *      
     *      modified should be used to determine if changes have been made to the packet by Ashita or another addon/plugin. By default, 
     *      modified is a direct copy of the original packet data.
     *      
     *      sizeChunk and dataChunk hold the data of the entire chunk the packet was part of that is being processed in the event. These can
     *      be useful for plugins that may need to look at other packets in the chunk that relate to the current packet of the event. These
     *      should not be edited.
     */
    bool HandleIncomingPacket(uint16_t id, uint32_t size, const uint8_t* data, uint8_t* modified, uint32_t sizeChunk, const uint8_t* dataChunk, bool injected, bool blocked) override
    {
        UNREFERENCED_PARAMETER(id);
        UNREFERENCED_PARAMETER(size);
        UNREFERENCED_PARAMETER(data);
        UNREFERENCED_PARAMETER(modified);
        UNREFERENCED_PARAMETER(sizeChunk);
        UNREFERENCED_PARAMETER(dataChunk);
        UNREFERENCED_PARAMETER(injected);
        UNREFERENCED_PARAMETER(blocked);

        return false;
    }

    /**
     * Event invoked when the game client is processing an outgoing packet.
     *
     * @param {uint16_t} id - The id of the packet.
     * @param {uint32_t} size - The size of the packet.
     * @param {const uint8_t*} data - The raw data of the packet.
     * @param {uint8_t*} modified - The modified packet data, if any, that has been altered by another addon/plugin.
     * @param {uint32_t} sizeChunk - The size of the full packet chunk that contained the packet.
     * @param {const uint8_t*} dataChunk - The raw data of the full packet chunk that contained the packet.
     * @param {bool} injected - Flag if the packet was injected from an Ashita related resource. (Addon, plugin, or internally.)
     * @param {bool} blocked - Flag if the packet has been blocked by another addon/plugin.
     * @return {bool} True if handled and should be blocked, false otherwise.
     *
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UsePackets flag is set.
     *      
     *      If a plugin returns true, the block flag is set to true (cannot be unset), however the event will still be passed to all loaded
     *      plugins whom are marked to accept it. Plugins should check if the blocked flag has been set first before reacting to the event
     *      in case a previous plugin has deemed it to be blocked. Unless your plugin requires reacting to certain/all packets, then it 
     *      should simply return immediately if blocked is already true.
     *      
     *      Packets in FFXI are sent in chunks, meaning there are multiple packets inside of each chunk. This information may be needed when
     *      dealing with certain packet ids, thus Ashita offers the ability to see the full chunk each packet was part of.
     *      
     *      id, size, and data are all specific to the individual packet that caused the event to be invoked and contain the unmodified
     *      information about the individual packet. These should not be edited.
     *      
     *      modified should be used to determine if changes have been made to the packet by Ashita or another addon/plugin. By default, 
     *      modified is a direct copy of the original packet data.
     *      
     *      sizeChunk and dataChunk hold the data of the entire chunk the packet was part of that is being processed in the event. These can
     *      be useful for plugins that may need to look at other packets in the chunk that relate to the current packet of the event. These
     *      should not be edited.
     */
    bool HandleOutgoingPacket(uint16_t id, uint32_t size, const uint8_t* data, uint8_t* modified, uint32_t sizeChunk, const uint8_t* dataChunk, bool injected, bool blocked) override
    {
        UNREFERENCED_PARAMETER(id);
        UNREFERENCED_PARAMETER(size);
        UNREFERENCED_PARAMETER(data);
        UNREFERENCED_PARAMETER(modified);
        UNREFERENCED_PARAMETER(sizeChunk);
        UNREFERENCED_PARAMETER(dataChunk);
        UNREFERENCED_PARAMETER(injected);
        UNREFERENCED_PARAMETER(blocked);

        return false;
    }

    /**
     * Event invoked when the plugin is being initialized for Direct3D usage.
     *
     * @param {IDirect3DDevice8*} device - The Direct3D8 device object.
     * @return {bool} True on success, false otherwise.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     * 
     *      Plugins must return true from this function in order to be considered valid and continue to load if they do use Direct3D features.
     *      
     *      If your plugin fails to meet any Direct3D requirements you feel are manditory for it to run, you should return false here and
     *      prevent it from loading further.
     */
    bool Direct3DInitialize(IDirect3DDevice8* device) override
    {
        UNREFERENCED_PARAMETER(device);

        return false;
    }

    /**
     * Event invoked when the Direct3D device is beginning a scene.
     *
     * @param {bool} isRenderingBackBuffer - Flag set if the scene is being rendered to the back buffer.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     *
     *      This event is invoked before the actual IDirect3DDevice8::BeginScene call is invoked.
     *
     *      Multiple scenes can be rendered each frame, thus the isRenderingBackBuffer flag is available to determine when the scene is being
     *      rendered to the back buffer render target. (Previous Ashita versions only invoked this event when this flag would be true.)
     */
    void Direct3DBeginScene(bool isRenderingBackBuffer) override
    {
        UNREFERENCED_PARAMETER(isRenderingBackBuffer);
    }

    /**
     * Event invoked when the Direct3D device is ending a scene.
     *
     * @param {bool} isRenderingBackBuffer - Flag set if the scene is being rendered to the back buffer.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     *
     *      This event is invoked before the actual IDirect3DDevice8::EndScene call is invoked.
     *
     *      Multiple scenes can be rendered each frame, thus the isRenderingBackBuffer flag is available to determine when the scene is being
     *      rendered to the back buffer render target. (Previous Ashita versions only invoked this event when this flag would be true.)
     */
    void Direct3DEndScene(bool isRenderingBackBuffer) override
    {
        UNREFERENCED_PARAMETER(isRenderingBackBuffer);
    }

    /**
     * Event invoked when the Direct3D device is presenting a scene.
     *
     * @param {const RECT*} pSourceRect - The source rect being presented.
     * @param {const RECT*} pDestRect - The destination rect being presented into.
     * @param {HWND} hDestWindowOverride - The override window handle to present into.
     * @param {const RGNDATA*} pDirtyRegion - The present dirty regions.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     *
     *      This event is invoked before the actual IDirect3DDevice8::Present call is invoked.
     *
     *      For best results of custom Direct3D rendering, it is best to do your own custom drawing here to draw over-top of all game related
     *      scenes and objects. Usage of ImGui should be done here as well.
     */
    void Direct3DPresent(const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion) override
    {
        UNREFERENCED_PARAMETER(pSourceRect);
        UNREFERENCED_PARAMETER(pDestRect);
        UNREFERENCED_PARAMETER(hDestWindowOverride);
        UNREFERENCED_PARAMETER(pDirtyRegion);
    }

    /**
     * Event invoked when the Direct3D device is setting a render state.
     *
     * @param {D3DRENDERSTATETYPE} State - The render state type.
     * @param {DWORD*} Value - Pointer to the render state value.
     * @return {bool} True if blocked, false otherwise.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     *
     *      If a plugin returns true, the render state is prevented from being set and is blocked from further processing by Ashita 
     *      or the game client and is considered handled.
     *
     *      Plugins can edit the value being set by writing to the Value pointer. 
     */
    bool Direct3DSetRenderState(D3DRENDERSTATETYPE State, DWORD* Value) override
    {
        UNREFERENCED_PARAMETER(State);
        UNREFERENCED_PARAMETER(Value);

        return false;
    }

    /**
     * Event invoked when the Direct3D device is drawing a primitive. (DrawPrimitive)
     *
     * @param {D3DPRIMITIVETYPE} PrimitiveType - The type of primitive being rendered.
     * @param {UINT} StartVertex - Index of the first vertex to load.
     * @param {UINT} PrimitiveCount - Number of primitives to render.
     * @return {bool} True if blocked, false otherwise.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     */
    bool Direct3DDrawPrimitive(D3DPRIMITIVETYPE PrimitiveType, UINT StartVertex, UINT PrimitiveCount) override
    {
        UNREFERENCED_PARAMETER(PrimitiveType);
        UNREFERENCED_PARAMETER(StartVertex);
        UNREFERENCED_PARAMETER(PrimitiveCount);

        return false;
    }

    /**
     * Event invoked when the Direct3D device is drawing a primitive. (DrawIndexedPrimitive)
     *
     * @param {D3DPRIMITIVETYPE} PrimitiveType - The type of primitive being rendered.
     * @param {UINT} minIndex - Minimum vertex index for the vertices used during this call.
     * @param {UINT} NumVertices - Number of vertices used during this call.
     * @param {UINT} startIndex - Location in the index array to start reading indices.
     * @param {UINT} primCount - Number of primitives to render.
     * @return {bool} True if blocked, false otherwise.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     */
    bool Direct3DDrawIndexedPrimitive(D3DPRIMITIVETYPE PrimitiveType, UINT minIndex, UINT NumVertices, UINT startIndex, UINT primCount) override
    {
        UNREFERENCED_PARAMETER(PrimitiveType);
        UNREFERENCED_PARAMETER(minIndex);
        UNREFERENCED_PARAMETER(NumVertices);
        UNREFERENCED_PARAMETER(startIndex);
        UNREFERENCED_PARAMETER(primCount);

        return false;
    }

    /**
     * Event invoked when the Direct3D device is drawing a primitive. (DrawPrimitiveUP)
     *
     * @param {D3DPRIMITIVETYPE} PrimitiveType - The type of primitive being rendered.
     * @param {UINT} PrimitiveCount - Number of primitives to render.
     * @param {const void*} pVertexStreamZeroData - User memory pointer to vertex data to use for vertex stream zero.
     * @param {UINT} VertexStreamZeroStride - Stride between data for each vertex, in bytes.
     * @return {bool} True if blocked, false otherwise.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     */
    bool Direct3DDrawPrimitiveUP(D3DPRIMITIVETYPE PrimitiveType, UINT PrimitiveCount, CONST void* pVertexStreamZeroData, UINT VertexStreamZeroStride) override
    {
        UNREFERENCED_PARAMETER(PrimitiveType);
        UNREFERENCED_PARAMETER(PrimitiveCount);
        UNREFERENCED_PARAMETER(pVertexStreamZeroData);
        UNREFERENCED_PARAMETER(VertexStreamZeroStride);

        return false;
    }

    /**
     * Event invoked when the Direct3D device is drawing a primitive. (DrawIndexedPrimitiveUP)
     *
     * @param {D3DPRIMITIVETYPE} PrimitiveType - The type of primitive being rendered.
     * @param {UINT} MinVertexIndex - Minimum vertex index, relative to zero, for vertices used during this call. 
     * @param {UINT} NumVertexIndices - Number of vertices used during this call.
     * @param {UINT} PrimitiveCount - Number of primitives to render.
     * @param {const void*} pIndexData - User memory pointer to the index data.
     * @param {D3DFORMAT} IndexDataFormat - The format type of the index data.
     * @param {const void*} pVertexStreamZeroData - User memory pointer to vertex data to use for vertex stream zero.
     * @param {UINT} VertexStreamZeroStride - Stride between data for each vertex, in bytes.
     * @return {bool} True if blocked, false otherwise.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     */
    bool Direct3DDrawIndexedPrimitiveUP(D3DPRIMITIVETYPE PrimitiveType, UINT MinVertexIndex, UINT NumVertexIndices, UINT PrimitiveCount, CONST void* pIndexData, D3DFORMAT IndexDataFormat, CONST void* pVertexStreamZeroData, UINT VertexStreamZeroStride) override
    {
        UNREFERENCED_PARAMETER(PrimitiveType);
        UNREFERENCED_PARAMETER(MinVertexIndex);
        UNREFERENCED_PARAMETER(NumVertexIndices);
        UNREFERENCED_PARAMETER(PrimitiveCount);
        UNREFERENCED_PARAMETER(pIndexData);
        UNREFERENCED_PARAMETER(IndexDataFormat);
        UNREFERENCED_PARAMETER(pVertexStreamZeroData);
        UNREFERENCED_PARAMETER(VertexStreamZeroStride);

        return false;
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita Plugin Exports
//
// These are the required function exports that all plugins must have in order to be considered a
// valid plugin and be loaded properly. Failure to export any of these exports will automatically
// deem your plugin invalid and it will fail to load.
//
// Please be mindful of the calling conventions of these exports. Failure to adhere to the proper
// conventions can lead to undefined behavior and crashes. All exports are of the __stdcall type.
//
// export_CreatePlugin_f            [Export As: expCreatePlugin]
//
//      Exported function that returns a new instance of the plugins main class, which must inherit
//      the IPlugin class. This is the main method used by Ashita to communicate with your plugin.
//
// export_GetInterfaceVersion_f     [Export As: expGetInterfaceVersion]
//
//      Exported function that returns the Ashita interface version that the plugin was compiled
//      against. This is used to determine if the plugin is 'safe' to load in the current Ashita
//      version that is being used.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef IPlugin* /**/ (__stdcall* export_CreatePlugin_f)(const char* args);
typedef double /**/ (__stdcall* export_GetInterfaceVersion_f)(void);

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita POL Plugin Base Interface
//
// The base interface that defines the implementation of a POL plugins main class. POL plugins
// should not directly inherit from this interface, they should inherit IPolPlugin instead.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

struct IPolPluginBase
{
    // Properties (POL Plugin Information)
    virtual const char* GetName(void) const        = 0;
    virtual const char* GetAuthor(void) const      = 0;
    virtual const char* GetDescription(void) const = 0;
    virtual const char* GetLink(void) const        = 0;
    virtual double GetVersion(void) const          = 0;
    virtual double GetInterfaceVersion(void) const = 0;
    virtual uint32_t GetFlags(void) const          = 0;

    // Methods
    virtual bool Initialize(IAshitaCore*, ILogManager*, uint32_t) = 0;
    virtual void Release(void)                                    = 0;

    // Event Callbacks: PolPluginManager
    virtual void HandleEvent(const char*, const void*, uint32_t) = 0;

    // Event Callbacks: ChatManager
    virtual bool HandleCommand(int32_t, const char*, bool) = 0;

    // Event Callbacks: Direct3D
    virtual void Direct3DBeginScene(bool)                                        = 0;
    virtual void Direct3DEndScene(bool)                                          = 0;
    virtual void Direct3DPresent(const RECT*, const RECT*, HWND, const RGNDATA*) = 0;
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita POL Plugin Base Class
//
// The base class that all POL plugins must inherit from. Implements default handlers for all events
// which developers can override if they wish to handle manually. (The main class object returned
// from the 'expCreatePolPlugin' export of your plugin must inherit from this class.)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

class IPolPlugin : public IPolPluginBase
{
public:
    /**
     * Constructor and Deconstructor
     */
    IPolPlugin(void)
    {}
    virtual ~IPolPlugin(void)
    {}

    /**
     * Returns the plugins name.
     *
     * @return {const char*} The plugins name.
     */
    const char* GetName(void) const override
    {
        return "PolPluginBase";
    }

    /**
     * Returns the plugins author.
     *
     * @return {const char*} The plugins author.
     */
    const char* GetAuthor(void) const override
    {
        return "Ashita Development Team";
    }

    /**
     * Returns the plugins description.
     *
     * @return {const char*} The plugins description.
     */
    const char* GetDescription(void) const override
    {
        return "Ashita POL Plugin Base";
    }

    /**
     * Returns the plugins homepage link.
     *
     * @return {const char*} The plugins homepage link.
     */
    const char* GetLink(void) const override
    {
        return "https://www.ashitaxi.com/";
    }

    /**
     * Returns the plugins version.
     *
     * @return {double} The plugins version.
     */
    double GetVersion(void) const override
    {
        return 1.0f;
    }

    /**
     * Returns the plugins Ashita SDK interface version it was compiled against.
     *
     * @return {double} The plugins interface version.
     */
    double GetInterfaceVersion(void) const override
    {
        return ASHITA_INTERFACE_VERSION;
    }

    /**
     * Returns the plugins flags.
     *
     * @return {uint32_t} The plugins flags.
     * @notes
     * 
     *      Unlike normal plugins, POL plugins have a limited amount of access to the events fired within Ashita. These plugins are not meant
     *      to be used as standard plugins, and therefore do not need access to everything normal plugins can do. However, there is still a
     *      reason to avoid unneeded overhead in calling events the POL plugin does not make use of.
     *
     *      Please also understand that some events are bare-minimum implementations for POL plugins, such as the Direct3D events. While POL
     *      plugins will gain access to BeginScene, EndScene and Present calls, they are not given calls for initialization or releasing. It
     *      is up to you to manage your resources properly.
     *
     *      Plugins should explicitly state which flags they plan to make use of and avoid using 'All' flags.
     *      This can help with the performance of the game for lower end machines.
     *      
     *      See the 'Ashita::PluginFlags' enumeration for more information on what each flag does.
     */
    uint32_t GetFlags(void) const override
    {
        return (uint32_t)Ashita::PluginFlags::None;
    }

    /**
     * Event invoked when the POL plugin is being loaded and initialized.
     *
     * @param {IAshitaCore*} core - The main Ashita core instance used to interact with the Ashita hook.
     * @param {ILogManager*} logger - The log manager instance used to write to the debug log files.
     * @param {uint32_t} id - The plugins unique id. (Matches the plugins module base address.)
     * @return {bool} True on success, false otherwise.
     *
     * @notes
     * 
     *      POL plugins must return true from this function in order to be considered valid and continue to load.
     *      If your plugin fails to meet any requirements you feel are manditory for it to run, you should return false here and prevent it
     *      from loading further.
     *
     *      Caution! POL plugins are loaded as soon as possible. Because of this, most of the pointers within the AshitaCore object will not
     *      yet be valid. You should always check pointer objects before attempting to use them to prevent crashes!
     */
    bool Initialize(IAshitaCore* core, ILogManager* logger, const uint32_t id) override
    {
        UNREFERENCED_PARAMETER(core);
        UNREFERENCED_PARAMETER(logger);
        UNREFERENCED_PARAMETER(id);

        return false;
    }

    /**
     * Event invoked when the POL plugin is being unloaded.
     *
     * @notes
     *
     *      Plugins should use this event to cleanup all resources they created or used during their lifespan.
     */
    void Release(void) override
    {}

    /**
     * Event invoked when another plugin has raised a custom event for other plugins to handle.
     *
     * @param {const char*} eventName - The name of the custom event being raised.
     * @param {const void*} eventData - The custom event data to pass through the event.
     * @param {uint32_t} eventSize - The size of the custom event data buffer.
     * 
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UsePluginEvents flag is set.
     *
     *      Plugins can make use of the custom event system as a way to talk to other plugins in a safe manner.
     *      Events can be raised via the PluginManager::RaiseEvent method which will cause this handler to be
     *      invoked in all loaded plugins with the given event information.
     */
    void HandleEvent(const char* eventName, const void* eventData, const uint32_t eventSize) override
    {
        UNREFERENCED_PARAMETER(eventName);
        UNREFERENCED_PARAMETER(eventData);
        UNREFERENCED_PARAMETER(eventSize);
    }

    /**
     * Event invoked when an input command is being processed by the game client.
     *
     * @param {int32_t} mode - The mode of the command. (See: Ashita::CommandMode)
     * @param {const char*} command - The raw command string.
     * @param {bool} injected - Flag if the command was injected from an Ashita related resource. (Addon, plugin or internally.)
     * @return {bool} True if handled and should be blocked, false otherwise.
     *
     * @notes
     * 
     *      Only invoked if Ashita::PluginFlags::UseCommands flag is set.
     *      
     *      Any commands sent through the games input handler will be passed to plugins to be processed first allowing plugins to intercept
     *      and handle any kind of command they wish. This includes commands typed into the chat bar, commands invoked from macros, menu items
     *      and so on. Commands that have been injected by Ashita or another plugin will be marked via the injected parameter.
     *      
     *      If a plugin returns true, the command is blocked from further processing by Ashita or the game client and is considered handled.
     *      
     *      Plugins should return true for any commands they have handled or reacted to when appropriate. To prevent deadlocks by trying to
     *      inject another command here, plugins should instead use the IChatManager::QueueCommand function for any manual command inserts
     *      back into the game.
     */
    bool HandleCommand(int32_t mode, const char* command, bool injected) override
    {
        UNREFERENCED_PARAMETER(mode);
        UNREFERENCED_PARAMETER(command);
        UNREFERENCED_PARAMETER(injected);

        return false;
    }

    /**
     * Event invoked when the Direct3D device is beginning a scene.
     *
     * @param {bool} isRenderingBackBuffer - Flag set if the scene is being rendered to the back buffer.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     *
     *      This event is invoked before the actual IDirect3DDevice8::BeginScene call is invoked.
     *
     *      Multiple scenes can be rendered each frame, thus the isRenderingBackBuffer flag is available to determine when the scene is being
     *      rendered to the back buffer render target. (Previous Ashita versions only invoked this event when this flag would be true.)
     */
    void Direct3DBeginScene(bool isRenderingBackBuffer) override
    {
        UNREFERENCED_PARAMETER(isRenderingBackBuffer);
    }

    /**
     * Event invoked when the Direct3D device is ending a scene.
     *
     * @param {bool} isRenderingBackBuffer - Flag set if the scene is being rendered to the back buffer.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     *
     *      This event is invoked before the actual IDirect3DDevice8::EndScene call is invoked.
     *
     *      Multiple scenes can be rendered each frame, thus the isRenderingBackBuffer flag is available to determine when the scene is being
     *      rendered to the back buffer render target. (Previous Ashita versions only invoked this event when this flag would be true.)
     */
    void Direct3DEndScene(bool isRenderingBackBuffer) override
    {
        UNREFERENCED_PARAMETER(isRenderingBackBuffer);
    }

    /**
     * Event invoked when the Direct3D device is presenting a scene.
     *
     * @param {const RECT*} pSourceRect - The source rect being presented.
     * @param {const RECT*} pDestRect - The destination rect being presented into.
     * @param {HWND} hDestWindowOverride - The override window handle to present into.
     * @param {const RGNDATA*} pDirtyRegion - The present dirty regions.
     *
     * @notes
     *
     *      Only invoked if Ashita::PluginFlags::UseDirect3D flag is set.
     *
     *      This event is invoked before the actual IDirect3DDevice8::Present call is invoked.
     *
     *      For best results of custom Direct3D rendering, it is best to do your own custom drawing here to draw over-top of all game related
     *      scenes and objects. Usage of ImGui should be done here as well.
     */
    void Direct3DPresent(const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion) override
    {
        UNREFERENCED_PARAMETER(pSourceRect);
        UNREFERENCED_PARAMETER(pDestRect);
        UNREFERENCED_PARAMETER(hDestWindowOverride);
        UNREFERENCED_PARAMETER(pDirtyRegion);
    }
};

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Ashita POL Plugin Exports
//
// These are the required function exports that all POL plugins must have in order to be considered
// a valid plugin and be loaded properly. Failure to export any of these exports will automatically
// deem your plugin invalid and it will fail to load.
//
// Please be mindful of the calling conventions of these exports. Failure to adhere to the proper
// conventions can lead to undefined behavior and crashes. All exports are of the __stdcall type.
//
// export_CreatePolPlugin_f             [Export As: expCreatePolPlugin]
//
//      Exported function that returns a new instance of the plugins main class, which must inherit
//      the IPolPlugin class. This is the main method used by Ashita to communicate with your plugin.
//
// export_GetInterfaceVersion_f     [Export As: expGetInterfaceVersion]
//
//      Exported function that returns the Ashita interface version that the plugin was compiled
//      against. This is used to determine if the plugin is 'safe' to load in the current Ashita
//      version that is being used. (See above prototype for implementation.)
//
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef IPolPlugin* /**/ (__stdcall* export_CreatePolPlugin_f)(const char* args);

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Pop warning disables.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma warning(pop)

#endif // ASHITA_SDK_H_INCLUDED