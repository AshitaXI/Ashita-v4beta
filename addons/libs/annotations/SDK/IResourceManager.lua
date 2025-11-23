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
IAbility Interface
--]]

---@class IAbility
---@field Id number
---@field Type number
---@field Element number
---@field ListIconId number
---@field ManaCost number
---@field RecastTimerId number
---@field Targets number
---@field TPCost number
---@field MenuCategoryId number
---@field MonsterLevel number
---@field Range number
---@field AreaRange number
---@field AreaShapeType number
---@field CursorTargetType number
---@field Unknown0000 number
---@field Unknown0001 number
---@field Unknown0002 number
---@field Unknown0003 number
---@field Unknown0004 number
---@field Unknown0005 number
---@field Unknown0006 number
---@field Unknown0007 number
---@field Unknown0008 number
---@field Unknown0009 table
---@field EOE number
---@field Name table
---@field Description table
local IAbility = {};

--[[
ISpell Interface
--]]

---@class ISpell
---@field Index number
---@field Type number
---@field Element number
---@field Targets number
---@field Skill number
---@field ManaCost number
---@field CastTime number
---@field RecastDelay number
---@field LevelRequired table
---@field Id number
---@field ListIconNQ number
---@field ListIconHQ number
---@field Requirements number
---@field Range number
---@field AreaRange number
---@field AreaShapeType number
---@field CursorTargetType number
---@field Unknown0000 table
---@field AreaFlags number
---@field Unknown0001 number
---@field Unknown0002 number
---@field Unknown0003 number
---@field Unknown0004 table
---@field JobPointMask number
---@field Unknown0005 table
---@field EOE number
---@field Name table
---@field Description table
local ISpell = {};

--[[
IMonAbility Interface
--]]

---@class IMonAbility
---@field AbilityId number
---@field Level number
---@field Unknown0000 number
local IMonAbility = {};

--[[
IItem Interface
--]]

---@class IItem
---@field Id number
---@field Flags number
---@field StackSize number
---@field Type number
---@field ResourceId number
---@field Targets number
---@field Level number
---@field Slots number
---@field Races number
---@field Jobs number
---@field SuperiorLevel number
---@field ShieldSize number
---@field MaxCharges number
---@field CastTime number
---@field CastDelay number
---@field RecastDelay number
---@field BaseItemId number
---@field ItemLevel number
---@field Damage number
---@field Delay number
---@field DPS number
---@field Skill number
---@field JugSize number
---@field WeaponUnknown0000 number
---@field Range number
---@field AreaRange number
---@field AreaShapeType number
---@field AreaCursorTargetType number
---@field Element number
---@field Storage number
---@field AttachmentFlags number
---@field InstinctCost number
---@field MonstrosityId number
---@field MonstrosityName string
---@field MonstrosityData string
---@field MonstrosityAbilities IMonAbility[]
---@field PuppetSlotId number
---@field PuppetElements number
---@field SlipData string
---@field UsableData0000 number
---@field UsableData0001 number
---@field UsableData0002 number
---@field Article number
---@field Name table
---@field Description table
---@field LogNameSingular table
---@field LogNamePlural table
---@field ImageSize number
---@field ImageType number
---@field ImageName string
---@field Bitmap string
local IItem = {};

--[[
IStatusIcon Interface
--]]

---@class IStatusIcon
---@field Index number
---@field Id number
---@field CanCancel number
---@field HideTimer number
---@field Description table
---@field ImageSize number
---@field ImageType number
---@field ImageName string
---@field Bitmap string
local IStatusIcon = {};

--[[
IResourceManager Interface
--]]

---@class IResourceManager
local IResourceManager = {};

---Returns an ability by its id.
---@param self IResourceManager
---@param id number
---@return IAbility|nil
---@nodiscard
function IResourceManager:GetAbilityById(id) end

---Returns an ability by its name.
---@param self IResourceManager
---@param name number
---@param lang number
---@return IAbility|nil
---@nodiscard
function IResourceManager:GetAbilityByName(name, lang) end

---Returns an ability by its timer id.
---@param self IResourceManager
---@param id number
---@return IAbility|nil
---@nodiscard
function IResourceManager:GetAbilityByTimerId(id) end

---Returns a spell by its id.
---@param self IResourceManager
---@param id number
---@return ISpell|nil
---@nodiscard
function IResourceManager:GetSpellById(id) end

---Returns a spell by its name.
---@param self IResourceManager
---@param name string
---@param lang number
---@return ISpell|nil
---@nodiscard
function IResourceManager:GetSpellByName(name, lang) end

---Returns an item by its id.
---@param self IResourceManager
---@param id number
---@return IItem|nil
---@nodiscard
function IResourceManager:GetItemById(id) end

---Returns an item by its name.
---@param self IResourceManager
---@param name string
---@param lang number
---@return IItem|nil
---@nodiscard
function IResourceManager:GetItemByName(name, lang) end

---Returns a status icon by its index.
---@param self IResourceManager
---@param index number
---@return IStatusIcon|nil
---@nodiscard
function IResourceManager:GetStatusIconByIndex(index) end

---Returns a status icon by its id.
---@param self IResourceManager
---@param id number
---@return IStatusIcon|nil
---@nodiscard
function IResourceManager:GetStatusIconById(id) end

---Returns a string from a string cache table by its index.
---@param self IResourceManager
---@param tbl string
---@param index number
---@return string|nil
---@nodiscard
function IResourceManager:GetString(tbl, index) end

---Returns a string from a string cache table by its index and language.
---@param self IResourceManager
---@param tbl string
---@param index number
---@param lang number
---@return string|nil
---@nodiscard
function IResourceManager:GetString(tbl, index, lang) end

---Returns a string index from a string cache table by its string.
---@param self IResourceManager
---@param tbl string
---@param str string
---@return number
---@nodiscard
function IResourceManager:GetString(tbl, str) end

---Returns a string index from a string cache table by its string and language.
---@param self IResourceManager
---@param tbl string
---@param str string
---@param lang number
---@return number
---@nodiscard
function IResourceManager:GetString(tbl, str, lang) end

---Returns the length of a string.
---@param self IResourceManager
---@param tbl string
---@param index number
---@return number
---@nodiscard
function IResourceManager:GetStringLength(tbl, index) end

---Returns the length of a string.
---@param self IResourceManager
---@param tbl string
---@param index number
---@param lang number
---@return number
---@nodiscard
function IResourceManager:GetStringLength(tbl, index, lang) end

---Returns a cached texture by its name.
---@param self IResourceManager
---@param name string
---@return userdata|nil
---@nodiscard
function IResourceManager:GetTexture(name) end

---@class CachedTextureInfo
---@field width number
---@field height number
---@field depth number
---@field mip_levels number
---@field format number
---@field resource_type number
---@field image_file_format number
local CachedTextureInfo = {};

---Returns a cached textures information.
---@param self IResourceManager
---@param name string
---@return CachedTextureInfo
---@nodiscard
function IResourceManager:GetTextureInfo(name) end

---Returns the path to a game file by its file id.
---@param self IResourceManager
---@param id number
---@return string
---@nodiscard
function IResourceManager:GetFilePath(id) end

---Returns the abilities true range based on the games actual lookup tables.
---@param self IResourceManager
---@param id number
---@param use_area_range boolean
---@return number
---@nodiscard
function IResourceManager:GetAbilityRange(id, use_area_range) end

---Returns the true type from an ability type.
---@param self IResourceManager
---@param tid number
---@return number
---@nodiscard
function IResourceManager:GetAbilityType(tid) end

---Returns the spells true range based on the games actual lookup tables.
---@param self IResourceManager
---@param id number
---@param use_area_range boolean
---@return number
---@nodiscard
function IResourceManager:GetSpellRange(id, use_area_range) end