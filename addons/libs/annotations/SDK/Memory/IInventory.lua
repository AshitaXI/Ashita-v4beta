--[[
* Addons - Copyright (c) 2025 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

---@meta

--[[
item_t Structure
--]]

---@class item_t
---@field Id number
---@field Index number
---@field Count number
---@field Flags number
---@field Price number
---@field Extra string
local item_t = {};

--[[
items_t Structure
--]]

---@class items_t
---@field Items item_t[]
local items_t = {};

--[[
treasureitem_t Structure
--]]

---@class treasureitem_t
---@field Use number
---@field ItemId number
---@field Count number
---@field Flags number
---@field Price number
---@field Extra string
---@field Status number
---@field Lot number
---@field WinningLot number
---@field WinningEntityServerId number
---@field WinningEntityTargetIndex number
---@field WinningEntityName string
---@field TimeToLive number
---@field DropTime number
local treasureitem_t = {};

--[[
equipmententry_t Structure
--]]

---@class equipmententry_t
---@field Slot number
---@field Index number
local equipmententry_t = {};

--[[
itemcheck_t Structure
--]]

---@class itemcheck_t
---@field Slot number
---@field ItemId number
---@field Extra string
local itemcheck_t = {};

--[[
inventory_t Structure
--]]

---@class inventory_t
---@field Containers items_t
---@field iLookItem number
---@field pItem number
---@field unknownFAA0 table
---@field TreasurePool treasureitem_t[]
---@field TreasurePoolStatus number
---@field TreasurePoolItemCount number
---@field ContainerMaxCapacity table
---@field ContainerMaxCapacity2 table
---@field ContainerUpdateCounter number
---@field ContainerUpdateFlags number
---@field ContainerUpdateBuffer table
---@field ContainerUpdateIndex number
---@field Equipment equipmententry_t[]
---@field DisplayItemSlot number
---@field DisplayItemPointer number
---@field CheckEquipment itemcheck_t[]
---@field CheckTargetIndex number
---@field CheckServerId number
---@field CheckFlags number
---@field CheckMainJob number
---@field CheckSubJob number
---@field CheckMainJobLevel number
---@field CheckSubJobLevel number
---@field CheckMainJob2 number
---@field CheckMasteryLevel number
---@field CheckMasteryFlags number
---@field CheckLinkshellName string
---@field CheckLinkshellColor number
---@field CheckLinkshellIconSetId number
---@field CheckLinkshellIconSetIndex number
---@field CheckBallistaChevronCount number
---@field CheckBallistaChevronFlags number
---@field CheckBallistaFlags number
---@field UserMessageCount number
---@field SearchComment string
---@field CraftStatus number
---@field CraftCallback number
---@field CraftTimestampResponse number
---@field CraftTimestampAttempt number
local inventory_t = {};

--[[
IInventory Interface
--]]

---@class IInventory
local IInventory = {};

---Returns the raw inventory structure.
---@param self IInventory
---@return inventory_t
---@nodiscard
function IInventory:GetRawStructure() end

---Returns the requested container item.
---@param self IInventory
---@param container number
---@param index number
---@return item_t?
---@nodiscard
function IInventory:GetContainerItem(container, index) end

---Returns the requested containers count.
---@param self IInventory
---@param container number
---@return number
---@nodiscard
function IInventory:GetContainerCount(container) end

---Returns the requested containers max count.
---@param self IInventory
---@param container number
---@return number
---@nodiscard
function IInventory:GetContainerCountMax(container) end

---Returns the requested treasure pool item.
---@param self IInventory
---@param index number
---@return treasureitem_t?
---@nodiscard
function IInventory:GetTreasurePoolItem(index) end

---Returns the treasure pool status.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetTreasurePoolStatus() end

---Returns the treasure pool item count.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetTreasurePoolItemCount() end

---Returns the container update counter.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetContainerUpdateCounter() end

---Returns the container update flags.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetContainerUpdateFlags() end

---Returns the display item slot.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetDisplayItemSlot() end

---Returns the display item pointer.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetDisplayItemPointer() end

---Returns the requested equipped item.
---@param self IInventory
---@param index number
---@return equipmententry_t?
---@nodiscard
function IInventory:GetEquippedItem(index) end

---Returns the requested check equipped item.
---@param self IInventory
---@param index number
---@return itemcheck_t?
---@nodiscard
function IInventory:GetCheckEquippedItem(index) end

---Returns the check target index.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckTargetIndex() end

---Returns the check server id.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckServerId() end

---Returns the check flags.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckFlags() end

---Returns the check main job.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckMainJob() end

---Returns the check sub job.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckSubJob() end

---Returns the check main job level.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckMainJobLevel() end

---Returns the check sub job level.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckSubJobLevel() end

---Returns the check main job (2).
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckMainJob2() end

---Returns the check mastery level.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckMasteryLevel() end

---Returns the check mastery flags.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckMasteryFlags() end

---Returns the check linkshell name.
---@param self IInventory
---@return string
---@nodiscard
function IInventory:GetCheckLinkshellName() end

---Returns the check linkshell color.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckLinkshellColor() end

---Returns the check check linkshell icon set id.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckLinkshellIconSetId() end

---Returns the check check linkshell icon set index.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckLinkshellIconSetIndex() end

---Returns the check Ballista chevron count.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckBallistaChevronCount() end

---Returns the check Ballista chevron flags.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckBallistaChevronFlags() end

---Returns the check Ballista flags.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCheckBallistaFlags() end

---Returns the search comment.
---@param self IInventory
---@return string
---@nodiscard
function IInventory:GetSearchComment() end

---Returns the craft status.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCraftStatus() end

---Returns the craft callback.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCraftCallback() end

---Returns the craft timestamp attempt.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCraftTimestampAttempt() end

---Returns the craft timestamp response.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetCraftTimestampResponse() end

---Sets the craft status.
---@param self IInventory
---@param status number
function IInventory:SetCraftStatus(status) end

---Sets the craft callback.
---@param self IInventory
---@param callback number
function IInventory:SetCraftCallback(callback) end

---Sets the craft timestamp attempt.
---@param self IInventory
---@param timestamp number
function IInventory:SetCraftTimestampAttempt(timestamp) end

---Sets the craft timestamp response.
---@param self IInventory
---@param timestamp number
function IInventory:SetCraftTimestampResponse(timestamp) end

---Returns the selected item name.
---@param self IInventory
---@return string
---@nodiscard
function IInventory:GetSelectedItemName() end

---Returns the selected item id.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetSelectedItemId() end

---Returns the selected item index.
---@param self IInventory
---@return number
---@nodiscard
function IInventory:GetSelectedItemIndex() end