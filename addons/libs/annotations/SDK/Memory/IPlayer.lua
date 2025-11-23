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
playerstats_t Structure
--]]

---@class playerstats_t
---@field Strength number
---@field Dexterity number
---@field Vitality number
---@field Agility number
---@field Intelligence number
---@field Mind number
---@field Charisma number
local playerstats_t = {};

--[[
playerresists_t Structure
--]]

---@class playerresists_t
---@field Fire number
---@field Ice number
---@field Wind number
---@field Earth number
---@field Lightning number
---@field Water number
---@field Light number
---@field Dark number
local playerresists_t = {};

--[[
combatskill_t Structure
--]]

---@class combatskill_t
---@field Raw number
local combatskill_t = {};

---Returns the skill value.
---@param self combatskill_t
---@return number
---@nodiscard
function combatskill_t:GetSkill() end

---Returns the capped flag.
---@param self combatskill_t
---@return boolean
---@nodiscard
function combatskill_t:IsCapped() end

--[[
craftskill_t Structure
--]]

---@class craftskill_t
---@field Raw number
---@field GetSkill function
---@field GetRank function
---@field IsCapped function
local craftskill_t = {};

---Returns the skill value.
---@param self craftskill_t
---@return number
---@nodiscard
function craftskill_t:GetSkill() end

---Returns the rank value.
---@param self craftskill_t
---@return number
---@nodiscard
function craftskill_t:GetRank() end

---Returns the capped flag.
---@param self craftskill_t
---@return boolean
---@nodiscard
function craftskill_t:IsCapped() end

--[[
combatskills_t Structure
--]]

---@class combatskills_t
---@field Unknown combatskill_t
---@field HandToHand combatskill_t
---@field Dagger combatskill_t
---@field Sword combatskill_t
---@field GreatSword combatskill_t
---@field Axe combatskill_t
---@field GreatAxe combatskill_t
---@field Scythe combatskill_t
---@field Polearm combatskill_t
---@field Katana combatskill_t
---@field GreatKatana combatskill_t
---@field Club combatskill_t
---@field Staff combatskill_t
---@field Unused0000 combatskill_t
---@field Unused0001 combatskill_t
---@field Unused0002 combatskill_t
---@field Unused0003 combatskill_t
---@field Unused0004 combatskill_t
---@field Unused0005 combatskill_t
---@field Unused0006 combatskill_t
---@field Unused0007 combatskill_t
---@field Unused0008 combatskill_t
---@field AutomatonMelee combatskill_t
---@field AutomatonRanged combatskill_t
---@field AutomatonMagic combatskill_t
---@field Archery combatskill_t
---@field Marksmanship combatskill_t
---@field Throwing combatskill_t
---@field Guarding combatskill_t
---@field Evasion combatskill_t
---@field Shield combatskill_t
---@field Parrying combatskill_t
---@field Divine combatskill_t
---@field Healing combatskill_t
---@field Enhancing combatskill_t
---@field Enfeebling combatskill_t
---@field Elemental combatskill_t
---@field Dark combatskill_t
---@field Summon combatskill_t
---@field Ninjutsu combatskill_t
---@field Singing combatskill_t
---@field String combatskill_t
---@field Wind combatskill_t
---@field BlueMagic combatskill_t
---@field Geomancy combatskill_t
---@field Handbell combatskill_t
---@field Unused0009 combatskill_t
---@field Unused0010 combatskill_t
local combatskills_t = {};

--[[
craftskills_t Structure
--]]

---@class craftskills_t
---@field Fishing craftskill_t
---@field Woodworking craftskill_t
---@field Smithing craftskill_t
---@field Goldsmithing craftskill_t
---@field Clothcraft craftskill_t
---@field Leathercraft craftskill_t
---@field Bonecraft craftskill_t
---@field Alchemy craftskill_t
---@field Cooking craftskill_t
---@field Synergy craftskill_t
---@field Riding craftskill_t
---@field Digging craftskill_t
---@field Unused0000 craftskill_t
---@field Unused0001 craftskill_t
---@field Unused0002 craftskill_t
---@field Unused0003 craftskill_t
local craftskills_t = {};

--[[
abilityrecast_t Structure
--]]

---@class abilityrecast_t
---@field Recast number
---@field RecastCalc1 number
---@field TimerId number
---@field RecastCalc2 number
---@field unknown0006 number
local abilityrecast_t = {};

--[[
mountrecast_t Structure
--]]

---@class mountrecast_t
---@field Recast number
---@field TimerId number
local mountrecast_t = {};

--[[
unityinfo_t Structure
--]]

---@class unityinfo_t
---@field Raw number
---@field Bits number
---@field Faction number
---@field Unknown number
---@field Points number
local unityinfo_t = {};

--[[
jobpointentry_t Structure
--]]

---@class jobpointentry_t
---@field CapacityPoints number
---@field Points number
---@field PointsSpent number
local jobpointentry_t = {};

--[[
jobpointsinfo_t Structure
--]]

---@class jobpointsinfo_t
---@field Flags number
---@field unknown0001 table
---@field Jobs jobpointentry_t[]
local jobpointsinfo_t = {};

--[[
statusoffset_t Structure
--]]

---@class statusoffset_t
---@field X number
---@field Z number
---@field Y number
---@field W number
local statusoffset_t = {};

--[[
player_t Structure
--]]

---@class player_t
---@field HPMax number
---@field MPMax number
---@field MainJob number
---@field MainJobLevel number
---@field SubJob number
---@field SubJobLevel number
---@field ExpCurrent number
---@field ExpNeeded number
---@field Stats playerstats_t
---@field StatsModifiers playerstats_t
---@field Attack number
---@field Defense number
---@field Resists playerresists_t
---@field Title number
---@field Rank number
---@field RankPoints number
---@field Homepoint number
---@field MonsterBuster number
---@field Nation number
---@field Residence number
---@field SuLevel number
---@field HighestItemLevel number
---@field ItemLevel number
---@field MainHandItemLevel number
---@field RangedItemLevel number
---@field UnityInfo unityinfo_t
---@field UnityPartialPersonalEvalutionPoints number
---@field UnityPersonalEvaluationPoints number
---@field UnityChatColorFlag number
---@field MasteryJob number
---@field MasteryJobLevel number
---@field MasteryFlags number
---@field MasteryExp number
---@field MasteryExpNeeded number
---@field CombatSkills combatskills_t
---@field CraftSkills craftskills_t
---@field AbilityInfo abilityrecast_t[]
---@field MountRecast mountrecast_t
---@field DataLoadedFlags number
---@field LimitPoints number
---@field MeritPoints number
---@field AssimilationPoints number
---@field IsLimitBreaker boolean
---@field IsExperiencePointsLocked boolean
---@field IsLimitModeEnabled boolean
---@field MeritPointsMax number
---@field unknown01F3 table
---@field JobPoints jobpointsinfo_t
---@field HomepointMasks string
---@field StatusIcons table
---@field StatusTimers table
---@field unknown038C table
---@field IsZoning number
---@field StatusOffset1 statusoffset_t
---@field StatusOffset2 statusoffset_t
---@field StatusOffset3 statusoffset_t
---@field StatusOffset4 statusoffset_t
---@field SubMapNum number
---@field unknown03F4 number
---@field Buffs table
local player_t = {};

--[[
IPlayer Interface
--]]

---@class IPlayer
local IPlayer = {};

---Returns the raw player structure.
---@param self IPlayer
---@return player_t
---@nodiscard
function IPlayer:GetRawStructure() end

---Returns the players max HP.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetHPMax() end

---Returns the players max MP.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMPMax() end

---Returns the players main job.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMainJob() end

---Returns the players main job level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMainJobLevel() end

---Returns the players sub job.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetSubJob() end

---Returns the players sub job level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetSubJobLevel() end

---Returns the players current exp.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetExpCurrent() end

---Returns the players needed exp.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetExpNeeded() end

---Returns the players requested stat.
---@param self IPlayer
---@param index number
---@return number
---@nodiscard
function IPlayer:GetStat(index) end

---Returns the players requested stat modifier.
---@param self IPlayer
---@param index number
---@return number
---@nodiscard
function IPlayer:GetStatModifier(index) end

---Returns the players attack.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetAttack() end

---Returns the players defense.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetDefense() end

---Returns the players requested resist.
---@param self IPlayer
---@param index number
---@return number
---@nodiscard
function IPlayer:GetResist(index) end

---Returns the players title.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetTitle() end

---Returns the players rank.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetRank() end

---Returns the players rank points.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetRankPoints() end

---Returns the players homepoint.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetHomepoint() end

---Returns the players nation.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetNation() end

---Returns the players residence.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetResidence() end

---Returns the players Su level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetSuLevel() end

---Returns the players highest item level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetHighestItemLevel() end

---Returns the players item level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetItemLevel() end

---Returns the players main hand item level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMainHandItemLevel() end

---Returns the players ranged item level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetRangedItemLevel() end

---Returns the players Unity faction.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetUnityFaction() end

---Returns the players Unity points.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetUnityPoints() end

---Returns the players Unity partial personal evalution points.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetUnityPartialPersonalEvalutionPoints() end

---Returns the players Unity personal evalution points.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetUnityPersonalEvaluationPoints() end

---Returns the players Unity chat color flag.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetUnityChatColorFlag() end

---Returns the players mastery job.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMasteryJob() end

---Returns the players mastery job level.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMasteryJobLevel() end

---Returns the players mastery flags.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMasteryFlags() end

---Returns the players mastery exp.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMasteryExp() end

---Returns the players mastery exp needed.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMasteryExpNeeded() end

---Returns the players requested combat skill.
---@param self IPlayer
---@param index number
---@return combatskill_t
---@nodiscard
function IPlayer:GetCombatSkill(index) end

---Returns the players requested craft skill.
---@param self IPlayer
---@param index number
---@return craftskills_t
---@nodiscard
function IPlayer:GetCraftSkill(index) end

---Returns the players requested ability recast.
---@param self IPlayer
---@param index number
---@return number
---@nodiscard
function IPlayer:GetAbilityRecast(index) end

---Returns the players requested ability recast calc 1.
---@param self IPlayer
---@param index number
---@return number
---@nodiscard
function IPlayer:GetAbilityRecastCalc1(index) end

---Returns the players requested ability recast timer id.
---@param self IPlayer
---@param index number
---@return number
---@nodiscard
function IPlayer:GetAbilityRecastTimerId(index) end

---Returns the players requested ability recast calc 2.
---@param self IPlayer
---@param index number
---@return number
---@nodiscard
function IPlayer:GetAbilityRecastCalc2(index) end

---Returns the players mount recast.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMountRecast() end

---Returns the players mount recast timer id.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMountRecastTimerId() end

---Returns the players data loaded flags.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetDataLoadedFlags() end

---Returns the players limit points.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetLimitPoints() end

---Returns the players merit points.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMeritPoints() end

---Returns the players assimilation points.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetAssimilationPoints() end

---Returns the players limit breaker flag.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:GetIsLimitBreaker() end

---Returns the players experience points locked flag.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:GetIsExperiencePointsLocked() end

---Returns the players limit mode enabled flag.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:GetIsLimitModeEnabled() end

---Returns the players merit points max.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetMeritPointsMax() end

---Returns the players homepoint masks.
---@param self IPlayer
---@return string
---@nodiscard
function IPlayer:GetHomepointMasks() end

---Returns the players zoning flag.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetIsZoning() end

---Returns the players status offset X (1).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset1X() end

---Returns the players status offset Z (1).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset1Z() end

---Returns the players status offset Y (1).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset1Y() end

---Returns the players status offset W (1).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset1W() end

---Returns the players status offset X (2).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset2X() end

---Returns the players status offset Z (2).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset2Z() end

---Returns the players status offset Y (2).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset2Y() end

---Returns the players status offset W (2).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset2W() end

---Returns the players status offset X (3).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset3X() end

---Returns the players status offset Z (3).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset3Z() end

---Returns the players status offset Y (3).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset3Y() end

---Returns the players status offset W (3).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset3W() end

---Returns the players status offset X (4).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset4X() end

---Returns the players status offset Z (4).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset4Z() end

---Returns the players status offset Y (4).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset4Y() end

---Returns the players status offset W (4).
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusOffset4W() end

---Returns the players sub map num.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetSubMapNum() end

---Returns the players requested capacity points.
---@param self IPlayer
---@param id number
---@return number
---@nodiscard
function IPlayer:GetCapacityPoints(id) end

---Returns the players requested job points.
---@param self IPlayer
---@param id number
---@return number
---@nodiscard
function IPlayer:GetJobPoints(id) end

---Returns the players requested job points spent.
---@param self IPlayer
---@param id number
---@return number
---@nodiscard
function IPlayer:GetJobPointsSpent(id) end

---Returns the players status icons.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusIcons() end

---Returns the players status timers.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetStatusTimers() end

---Returns the players buffs.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetBuffs() end

---Returns the players pet MP percent.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetPetMPPercent() end

---Returns the players pet TP percent.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetPetTP() end

---Returns the players requested job level.
---@param self IPlayer
---@param id number
---@return number
---@nodiscard
function IPlayer:GetJobLevel(id) end

---Returns the players job master flags.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetJobMasterFlags() end

---Returns the players requested job master level.
---@param self IPlayer
---@param id number
---@return number
---@nodiscard
function IPlayer:GetJobMasterLevel(id) end

---Returns the players login status.
---@param self IPlayer
---@return number
---@nodiscard
function IPlayer:GetLoginStatus() end

---Returns if the player has received ability data.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:HasAbilityData() end

---Returns if the player has received spell data.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:HasSpellData() end

---Returns if the player has the requested ability.
---@param self IPlayer
---@param id number
---@return boolean
---@nodiscard
function IPlayer:HasAbility(id) end

---Returns if the player has the requested pet command.
---@param self IPlayer
---@param id number
---@return boolean
---@nodiscard
function IPlayer:HasPetCommand(id) end

---Returns if the player has the requested spell.
---@param self IPlayer
---@param id number
---@return boolean
---@nodiscard
function IPlayer:HasSpell(id) end

---Returns if the player has the requested trait.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:HasTrait(id) end

---Returns if the player has the requested weapon skill.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:HasWeaponSkill(id) end

---Returns if the player has the requested key item.
---@param self IPlayer
---@return boolean
---@nodiscard
function IPlayer:HasKeyItem(id) end