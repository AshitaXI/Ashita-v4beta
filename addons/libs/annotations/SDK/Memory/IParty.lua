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
allianceinfo_t Structure
--]]

---@class allianceinfo_t
---@field AllianceLeaderServerId number
---@field PartyLeaderServerId1 number
---@field PartyLeaderServerId2 number
---@field PartyLeaderServerId3 number
---@field PartyVisible1 number
---@field PartyVisible2 number
---@field PartyVisible3 number
---@field PartyMemberCount1 number
---@field PartyMemberCount2 number
---@field PartyMemberCount3 number
---@field Invited number
---@field InviteParty number
local allianceinfo_t = {};

--[[
partymember_t Structure
--]]

---@class partymember_t
---@field AllianceInfo allianceinfo_t
---@field Index number
---@field MemberNumber number
---@field Name string
---@field ServerId number
---@field TargetIndex number
---@field LastUpdatedTimestamp number
---@field HP number
---@field MP number
---@field TP number
---@field HPPercent number
---@field MPPercent number
---@field Zone number
---@field Zone2 number
---@field unknown0036 number
---@field FlagMask number
---@field TreasureLots table
---@field MonstrosityItemId number
---@field MonstrosityPrefixFlag1 number
---@field MonstrosityPrefixFlag2 number
---@field MonstrosityName string
---@field MainJob number
---@field MainJobLevel number
---@field SubJob number
---@field SubJobLevel number
---@field MasterLevel number
---@field MasterBreaker number
---@field unknown0073 number
---@field ServerId2 number
---@field HPPercent2 number
---@field MPPercent2 number
---@field IsActive number
local partymember_t = {};

--[[
party_t Structure
--]]

---@class party_t
---@field Members partymember_t[]
local party_t = {};

--[[
statusiconsentry_t Structure
--]]

---@class statusiconsentry_t
---@field ServerId number
---@field TargetIndex number
---@field BitMask number
---@field StatusIcons number
local statusiconsentry_t = {};

--[[
partystatusicons_t Structure
--]]

---@class partystatusicons_t
---@field Members statusiconsentry_t[]
local partystatusicons_t = {};

--[[
IParty Interface
--]]

---@class IParty
local IParty = {};

---Returns the raw party structure.
---@param self IParty
---@return party_t
---@nodiscard
function IParty:GetRawStructure() end

---Returns the raw party status icons structure.
---@param self IParty
---@return partystatusicons_t
---@nodiscard
function IParty:GetRawStructureStatusIcons() end

---Returns the alliance leader server id.
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAllianceLeaderServerId() end

---Returns the alliance party leader server id (1).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyLeaderServerId1() end

---Returns the alliance party leader server id (2).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyLeaderServerId2() end

---Returns the alliance party leader server id (3).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyLeaderServerId3() end

---Returns the alliance party visible (1).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyVisible1() end

---Returns the alliance party visible (2).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyVisible2() end

---Returns the alliance party visible (3).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyVisible3() end

---Returns the alliance party member count (1).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyMemberCount1() end

---Returns the alliance party member count (2).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyMemberCount2() end

---Returns the alliance party member count (3).
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAlliancePartyMemberCount3() end

---Returns the alliance invited flag.
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAllianceInvited() end

---Returns the alliance invite party flag.
---@param self IParty
---@return number
---@nodiscard
function IParty:GetAllianceInviteParty() end

---Returns the party members index.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberIndex(index) end

---Returns the party members number.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberNumber(index) end

---Returns the party members name.
---@param self IParty
---@param index number
---@return string
---@nodiscard
function IParty:GetMemberName(index) end

---Returns the party members server id.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberServerId(index) end

---Returns the party members target index.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberTargetIndex(index) end

---Returns the party members last updated timestamp.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberLastUpdatedTimestamp(index) end

---Returns the party members HP.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberHP(index) end

---Returns the party members MP.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMP(index) end

---Returns the party members TP.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberTP(index) end

---Returns the party members HP percent.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberHPPercent(index) end

---Returns the party members MP percent.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMPPercent(index) end

---Returns the party members zone.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberZone(index) end

---Returns the party members zone (2).
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberZone2(index) end

---Returns the party members flag mask.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberFlagMask(index) end

---Returns the party members treasure lot.
---@param self IParty
---@param index number
---@param slot number
---@return number
---@nodiscard
function IParty:GetMemberTreasureLot(index, slot) end

---Returns the party members Monstrosity item id.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMonstrosityItemId(index) end

---Returns the party members Monstrosity prefix flag (1).
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMonstrosityPrefixFlag1(index) end

---Returns the party members Monstrosity prefix flag (2).
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMonstrosityPrefixFlag2(index) end

---Returns the party members Monstrosity name.
---@param self IParty
---@param index number
---@return string
---@nodiscard
function IParty:GetMemberMonstrosityName(index) end

---Returns the party members main job.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMainJob(index) end

---Returns the party members main job level.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMainJobLevel(index) end

---Returns the party members sub job.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberSubJob(index) end

---Returns the party members sub job level.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberSubJobLevel(index) end

---Returns the party members master level.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMasterLevel(index) end

---Returns the party members master breaker.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMasterBreaker(index) end

---Returns the party members server id (2).
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberServerId2(index) end

---Returns the party members HP percent (2).
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberHPPercent2(index) end

---Returns the party members MP percent (2).
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberMPPercent2(index) end

---Returns the party members active flag.
---@param self IParty
---@param index number
---@return number
---@nodiscard
function IParty:GetMemberIsActive(index) end

---Returns the status icon server id.
---@param self IParty
---@param index any
---@return number
---@@nodiscard
function IParty:GetStatusIconsServerId(index) end

---Returns the status icon target index.
---@param self IParty
---@param index any
---@return number
---@@nodiscard
function IParty:GetStatusIconsTargetIndex(index) end

---Returns the status icon bitmask.
---@param self IParty
---@param index any
---@return number
---@@nodiscard
function IParty:GetStatusIconsBitMask(index) end

---Returns the status icons.
---@param self IParty
---@param index any
---@return number
---@@nodiscard
function IParty:GetStatusIcons(index) end