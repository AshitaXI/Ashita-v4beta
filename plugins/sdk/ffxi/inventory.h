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

#ifndef ASHITA_SDK_FFXI_INVENTORY_H_INCLUDED
#define ASHITA_SDK_FFXI_INVENTORY_H_INCLUDED

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

// clang-format off
// ReSharper disable CppUnusedIncludeDirective

#include <cinttypes>
#include "enums.h"

namespace Ashita::FFXI
{
    struct item_t
    {
        uint16_t            Id;                         // The item id.
        uint16_t            Index;                      // The item index.
        uint32_t            Count;                      // The item count.
        uint32_t            Flags;                      // The item flags.
        uint32_t            Price;                      // The item price, if being sold in bazaar.
        uint8_t             Extra[28];                  // The item extra data. (Augments, charges, timers, etc.)
    };

    struct items_t
    {
        item_t              Items[81];                  // The items within a storage container.
    };

    struct treasureitem_t
    {
        uint32_t            Flags;                      // The treasure item flags.
        uint32_t            ItemId;                     // The treasure item id.
        uint32_t            Count;                      // The treasure item count.
        uint8_t             Unknown0000[36];            // Unknown
        uint32_t            Status;                     // The treasure item status.
        uint16_t            Lot;                        // The local players lot on the treasure item.
        uint16_t            WinningLot;                 // The treasure item current winning lot.
        uint32_t            WinningEntityServerId;      // The treasure item current winning lot entity server id.
        uint32_t            WinningEntityTargetIndex;   // The treasure item current winning lot entity target index.
        int8_t              WinningEntityName[16];      // The treasure item current winning lot entity name.
        uint32_t            TimeToLive;                 // The treasure item's time left in the pool.
        uint32_t            DropTime;                   // The treasure item's time it entered the pool.
    };

    struct equipmententry_t
    {
        uint32_t            Slot;                       // The equipped item slot id.
        uint32_t            Index;                      // The equipped item container and container index.
    };

    struct inventory_t
    {
        items_t             Containers[(uint32_t)Enums::Container::Max];            // Containers holding the players various items.
        uint8_t             Unknown0000[0x021C];                                    // Unknown [Potential future expansion space.]
        treasureitem_t      TreasurePool[0x000A];                                   // The treasure pool container items.
        uint32_t            TreasurePoolStatus;                                     // Flag that is set stating the status of the treasure pool. (0 = Loading, 1 = Loaded, 2 = Emptied)
        uint8_t             TreasurePoolItemCount;                                  // The number of items currently in the treasure pool.
        uint8_t             ContainerMaxCapacity[(uint32_t)Enums::Container::Max];  // Inventory container maximum counts.
        uint16_t            ContainerMaxCapacity2[(uint32_t)Enums::Container::Max]; // Inventory container maximum counts. (Duplicate.)
        uint32_t            Unknown0001;                                            // Unknown [Deals with allocation of space for inventory containers.]
        uint8_t             Unknown0002[0x0184];                                    // Unknown
        equipmententry_t    Equipment[(uint32_t)Enums::EquipmentSlot::Max];         // The players current equipment information.
        uint32_t            Unknown0003;                                            // Unknown [Deals with items in general. (Checked against 16 for max slot count.)]
        uint32_t            Unknown0004;                                            // Unknown [Deals with items in general. (Checked against 0.)]
        uint8_t             Unknown0005[0x0240];                                    // Unknown [Deals with items in general. (16 slots at 36 bytes a piece.)]
        uint8_t             Unknown0006[0x00B4];                                    // Unknown
        uint32_t            CraftStatus;                                            // The players crafting status. (Handles if the player is attempting to craft and when they are able to craft again.)
        uintptr_t           CraftCallback;                                          // Function set when attempting to craft that is invoked for the result.
        uint32_t            CraftTimestamp;                                         // The timestamp when an attempt was made to craft something.
    };

} // namespace Ashita::FFXI

#endif // ASHITA_SDK_FFXI_INVENTORY_H_INCLUDED