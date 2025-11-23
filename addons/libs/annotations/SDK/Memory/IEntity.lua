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
position_t Structure
--]]

---@class position_t
---@field X number
---@field Z number
---@field Y number
---@field W number
---@field Roll number
---@field Yaw number
---@field Pitch number
---@field unknown001C number
local position_t = {};

--[[
move_t Structure
--]]

---@class move_t
---@field X number
---@field Z number
---@field Y number
---@field W number
---@field DeltaX number
---@field DeltaZ number
---@field DeltaY number
---@field DeltaW number
---@field DeltaRoll number
---@field DeltaYaw number
---@field DeltaPitch number
---@field unknown002C number
local move_t = {};

--[[
movement_t Structure
--]]

---@class movement_t
---@field LocalPosition position_t
---@field LastPosition position_t
---@field Move move_t
local movement_t = {};

--[[
look_t Structure
--]]

---@class look_t
---@field Hair number
---@field Head number
---@field Body number
---@field Hands number
---@field Legs number
---@field Feet number
---@field Main number
---@field Sub number
---@field Ranged number
---@field unknown0012 table
local look_t = {};

--[[
render_t Structure
--]]

---@class render_t
---@field Flags0 number
---@field Flags1 number
---@field Flags2 number
---@field Flags3 number
---@field Flags4 number
---@field Flags5 number
---@field Flags6 number
---@field Flags7 number
---@field Flags8 number
local render_t = {};

--[[
entity_t Structure
--]]

---@class entity_t
---@field VTablePointer number
---@field Movement movement_t
---@field TargetIndex number
---@field ServerId number
---@field Name string
---@field MovementSpeed number
---@field AnimationSpeed number
---@field ActorPointer number
---@field Attachments userdata
---@field EventPointer number
---@field Distance number
---@field TurnSpeed number
---@field TurnSpeedHead number
---@field Heading number
---@field Next number
---@field HPPercent number
---@field unknown00ED number
---@field Type number
---@field Race number
---@field LocalMoveCount number
---@field ActorLockFlag number
---@field ModelUpdateFlags number
---@field unknown00F6 number
---@field DoorId number
---@field Look look_t
---@field ActionTimer1 number
---@field ActionTimer2 number
---@field Render render_t
---@field PopEffect number
---@field UpdateMask number
---@field InteractionTargetIndex number
---@field NpcSpeechFrame number
---@field LookAxisX number
---@field LookAxisY number
---@field MouthCounter number
---@field MouthWaitCounter number
---@field CraftTimerUnknown number
---@field CraftServerId number
---@field CraftAnimationEffect number
---@field CraftAnimationStep number
---@field CraftParam number
---@field MovementSpeed2 number
---@field NpcWalkPosition1 number
---@field NpcWalkPosition2 number
---@field NpcWalkMode number
---@field CostumeId number
---@field Mou4 number
---@field StatusServer number
---@field Status number
---@field StatusEvent number
---@field unknown0178 number
---@field unknown017C number
---@field ModelTime number
---@field ModelStartTime number
---@field ClaimStatus number
---@field ZoneId number
---@field Animations table
---@field AnimationTime number
---@field AnimationStep number
---@field AnimationPlay number
---@field unknown01BD number
---@field EmoteTargetIndex number
---@field EmoteId number
---@field EmoteIdString number
---@field EmoteTargetActorPointer number
---@field unknown01CC number
---@field SpawnFlags number
---@field LinkshellColor number
---@field NameColor number
---@field CampaignNameFlag number
---@field MountId number
---@field FishingUnknown0000 number
---@field FishingUnknown0001 number
---@field FishingActionCountdown number
---@field FishingRodCastTime number
---@field FishingUnknown0002 number
---@field LastActionId number
---@field MogMotionId number
---@field LastActionActorPointer number
---@field TargetedIndex number
---@field PetTargetIndex number
---@field UpdateRequestDelay number
---@field IsDirty number
---@field BallistaFlags number
---@field PankrationEnabled number
---@field PankrationFlagFlip number
---@field unknown0202 number
---@field ModelSize number
---@field ModelHitboxSize number
---@field EnvironmentAreaId number
---@field MonstrosityFlag number
---@field MonstrosityNameId number
---@field MonstrosityName string
---@field MonstrosityNameEnd number
---@field MonstrosityNameAbbr string
---@field MonstrosityNameAbbrEnd number
---@field CustomProperties table
---@field BallistaInfo table
---@field FellowTargetIndex number
---@field WarpTargetIndex number
---@field TrustOwnerTargetIndex number
---@field AreaDisplayTargetIndex number
---@field unknown02A8 number
local entity_t = {};

--[[
Global Functions
--]]

---Returns the raw entity at the given index.
---@param index number
---@return entity_t?
---@nodiscard
function GetEntity(index) end

---Returns the raw player entity.
---@return entity_t?
---@nodiscard
function GetPlayerEntity() end

--[[
IEntity Interface
--]]

---@class IEntity
local IEntity = {};

---Returns the raw entity structure for the requested entity.
---@param self IEntity
---@param index number
---@return entity_t?
---@nodiscard
function IEntity:GetRawEntity(index) end

---Returns the entity map size.
---@param self IEntity
---@return number
---@nodiscard
function IEntity:GetEntityMapSize() end

---Returns the entities local X position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalPositionX(index) end

---Returns the entities local Z position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalPositionZ(index) end

---Returns the entities local Y position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalPositionY(index) end

---Returns the entities local W position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalPositionW(index) end

---Returns the entities local roll position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalPositionRoll(index) end

---Returns the entities local yaw position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalPositionYaw(index) end

---Returns the entities local pitch position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalPositionPitch(index) end

---Returns the entities last X position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastPositionX(index) end

---Returns the entities last Z position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastPositionZ(index) end

---Returns the entities last Y position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastPositionY(index) end

---Returns the entities last W position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastPositionW(index) end

---Returns the entities last roll position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastPositionRoll(index) end

---Returns the entities last yaw position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastPositionYaw(index) end

---Returns the entities last pitch position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastPositionPitch(index) end

---Returns the entities move X position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveX(index) end

---Returns the entities move Z position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveZ(index) end

---Returns the entities move Y position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveY(index) end

---Returns the entities move W position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveW(index) end

---Returns the entities move delta X position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveDeltaX(index) end

---Returns the entities move delta Z position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveDeltaZ(index) end

---Returns the entities move delta Y position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveDeltaY(index) end

---Returns the entities move delta W position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveDeltaW(index) end

---Returns the entities move delta roll position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveDeltaRoll(index) end

---Returns the entities move delta yaw position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveDeltaYaw(index) end

---Returns the entities move delta pitch position.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMoveDeltaPitch(index) end

---Returns the entities target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetTargetIndex(index) end

---Returns the entities server id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetServerId(index) end

---Returns the entities name.
---@param self IEntity
---@param index number
---@return string
---@nodiscard
function IEntity:GetName(index) end

---Returns the entities movement speed.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMovementSpeed(index) end

---Returns the entities animation speed.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetAnimationSpeed(index) end

---Returns the entities actor pointer.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetActorPointer(index) end

---Returns the entities attachment.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetAttachment(index) end

---Returns the entities event pointer.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetEventPointer(index) end

---Returns the entities distance.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetDistance(index) end

---Returns the entities turn speed.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetTurnSpeed(index) end

---Returns the entities turn speed head.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetTurnSpeedHead(index) end

---Returns the entities heading.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetHeading(index) end

---Returns the entities next.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetNext(index) end

---Returns the entities HP percent.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetHPPercent(index) end

---Returns the entities type.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetType(index) end

---Returns the entities race.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRace(index) end

---Returns the entities local move count.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLocalMoveCount(index) end

---Returns the entities actor lock flag.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetActorLockFlag(index) end

---Returns the entities model update flags.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetModelUpdateFlags(index) end

---Returns the entities door id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetDoorId(index) end

---Returns the entities look hair.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookHair(index) end

---Returns the entities look head.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookHead(index) end

---Returns the entities look body.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookBody(index) end

---Returns the entities look hands.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookHands(index) end

---Returns the entities look legs.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookLegs(index) end

---Returns the entities look feet.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookFeet(index) end

---Returns the entities look main.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookMain(index) end

---Returns the entities look sub.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookSub(index) end

---Returns the entities look ranged.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookRanged(index) end

---Returns the entities action timer (1).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetActionTimer1(index) end

---Returns the entities action timer (2).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetActionTimer2(index) end

---Returns the entities render flags (0).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags0(index) end

---Returns the entities render flags (1).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags1(index) end

---Returns the entities render flags (2).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags2(index) end

---Returns the entities render flags (3).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags3(index) end

---Returns the entities render flags (4).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags4(index) end

---Returns the entities render flags (5).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags5(index) end

---Returns the entities render flags (6).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags6(index) end

---Returns the entities render flags (7).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags7(index) end

---Returns the entities render flags (8).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetRenderFlags8(index) end

---Returns the entities pop effect.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetPopEffect(index) end

---Returns the entities update mask.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetUpdateMask(index) end

---Returns the entities interaction target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetInteractionTargetIndex(index) end

---Returns the entities NPC speech frame.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetNpcSpeechFrame(index) end

---Returns the entities look axis X.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookAxisX(index) end

---Returns the entities look axis Y.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLookAxisY(index) end

---Returns the entities mouth counter.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMouthCounter(index) end

---Returns the entities mouth wait counter.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMouthWaitCounter(index) end

---Returns the entities craft timer unknown.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCraftTimerUnknown(index) end

---Returns the entities craft server id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCraftServerId(index) end

---Returns the entities craft animation effect.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCraftAnimationEffect(index) end

---Returns the entities craft animation step.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCraftAnimationStep(index) end

---Returns the entities craft param.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCraftParam(index) end

---Returns the entities movement speed (2).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMovementSpeed2(index) end

---Returns the entities NPC walk position (1).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetNpcWalkPosition1(index) end

---Returns the entities NPC walk position (2).
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetNpcWalkPosition2(index) end

---Returns the entities NPC walk mode.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetNpcWalkMode(index) end

---Returns the entities costume id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCostumeId(index) end

---Returns the entities mou4.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMou4(index) end

---Returns the entities status server.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetStatusServer(index) end

---Returns the entities status.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetStatus(index) end

---Returns the entities status event.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetStatusEvent(index) end

---Returns the entities model time.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetModelTime(index) end

---Returns the entities model start time.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetModelStartTime(index) end

---Returns the entities claim status.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetClaimStatus(index) end

---Returns the entities zone id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetZoneId(index) end

---Returns the entities animation.
---@param self IEntity
---@param index number
---@param animation_index number
---@return number
---@nodiscard
function IEntity:GetAnimation(index, animation_index) end

---Returns the entities animation time.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetAnimationTime(index) end

---Returns the entities animation step.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetAnimationStep(index) end

---Returns the entities animation play.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetAnimationPlay(index) end

---Returns the entities emote target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetEmoteTargetIndex(index) end

---Returns the entities emote id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetEmoteId(index) end

---Returns the entities emote id string.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetEmoteIdString(index) end

---Returns the entities emote target actor pointer.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetEmoteTargetActorPointer(index) end

---Returns the entities spawn flags.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetSpawnFlags(index) end

---Returns the entities linkshell color.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLinkshellColor(index) end

---Returns the entities name color.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetNameColor(index) end

---Returns the entities Campaign name flag.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCampaignNameFlag(index) end

---Returns the entities mount id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMountId(index) end

---Returns the entities fishing unknown0000.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetFishingUnknown0000(index) end

---Returns the entities fishing unknown0001.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetFishingUnknown0001(index) end

---Returns the entities fishing action countdown.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetFishingActionCountdown(index) end

---Returns the entities fishing rod cast time.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetFishingRodCastTime(index) end

---Returns the entities fishing unknown0002.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetFishingUnknown0002(index) end

---Returns the entities last action id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastActionId(index) end

---Returns the entities mog motion id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMogMotionId(index) end

---Returns the entities last action actor pointer.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetLastActionActorPointer(index) end

---Returns the entities targeted index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetTargetedIndex(index) end

---Returns the entities pet target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetPetTargetIndex(index) end

---Returns the entities update request delay.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetUpdateRequestDelay(index) end

---Returns the entities is dirty flag.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetIsDirty(index) end

---Returns the entities Ballista flags.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetBallistaFlags(index) end

---Returns the entities Pankration enabled flag.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetPankrationEnabled(index) end

---Returns the entities Pankration flag flip.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetPankrationFlagFlip(index) end

---Returns the entities model size.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetModelSize(index) end

---Returns the entities model hitbox size.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetModelHitboxSize(index) end

---Returns the entities environment area id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetEnvironmentAreaId(index) end

---Returns the entities Monstrosity flag.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMonstrosityFlag(index) end

---Returns the entities Monstrosity name id.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMonstrosityNameId(index) end

---Returns the entities Monstrosity name.
---@param self IEntity
---@param index number
---@return string
---@nodiscard
function IEntity:GetMonstrosityName(index) end

---Returns the entities Monstrosity name end.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMonstrosityNameEnd(index) end

---Returns the entities Monstrosity name abbr.
---@param self IEntity
---@param index number
---@return string
---@nodiscard
function IEntity:GetMonstrosityNameAbbr(index) end

---Returns the entities Monstrosity name abbr end.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetMonstrosityNameAbbrEnd(index) end

---Returns the entities custom properties.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetCustomProperties(index) end

---Returns the entities Ballista info.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetBallistaInfo(index) end

---Returns the entities fellow target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetFellowTargetIndex(index) end

---Returns the entities warp target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetWarpTargetIndex(index) end

---Returns the entities Trust owner target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetTrustOwnerTargetIndex(index) end

---Returns the entities area display target index.
---@param self IEntity
---@param index number
---@return number
---@nodiscard
function IEntity:GetAreaDisplayTargetIndex(index) end

---Sets the entities local X position.
---@param self IEntity
---@param index number
---@param x number
function IEntity:SetLocalPositionX(index, x) end

---Sets the entities local Z position.
---@param self IEntity
---@param index number
---@param z number
function IEntity:SetLocalPositionZ(index, z) end

---Sets the entities local Y position.
---@param self IEntity
---@param index number
---@param y number
function IEntity:SetLocalPositionY(index, y) end

---Sets the entities local W position.
---@param self IEntity
---@param index number
---@param w number
function IEntity:SetLocalPositionW(index, w) end

---Sets the entities local roll position.
---@param self IEntity
---@param index number
---@param roll number
function IEntity:SetLocalPositionRoll(index, roll) end

---Sets the entities local yaw position.
---@param self IEntity
---@param index number
---@param yaw number
function IEntity:SetLocalPositionYaw(index, yaw) end

---Sets the entities local pitch position.
---@param self IEntity
---@param index number
---@param pitch number
function IEntity:SetLocalPositionPitch(index, pitch) end

---Sets the entities last X position.
---@param self IEntity
---@param index number
---@param x number
function IEntity:SetLastPositionX(index, x) end

---Sets the entities last Z position.
---@param self IEntity
---@param index number
---@param z number
function IEntity:SetLastPositionZ(index, z) end

---Sets the entities last Y position.
---@param self IEntity
---@param index number
---@param y number
function IEntity:SetLastPositionY(index, y) end

---Sets the entities last W position.
---@param self IEntity
---@param index number
---@param w number
function IEntity:SetLastPositionW(index, w) end

---Sets the entities last roll position.
---@param self IEntity
---@param index number
---@param roll number
function IEntity:SetLastPositionRoll(index, roll) end

---Sets the entities last yaw position.
---@param self IEntity
---@param index number
---@param yaw number
function IEntity:SetLastPositionYaw(index, yaw) end

---Sets the entities last pitch position.
---@param self IEntity
---@param index number
---@param pitch number
function IEntity:SetLastPositionPitch(index, pitch) end

---Sets the entities move X.
---@param self IEntity
---@param index number
---@param x number
function IEntity:SetMoveX(index, x) end

---Sets the entities move Z.
---@param self IEntity
---@param index number
---@param z number
function IEntity:SetMoveZ(index, z) end

---Sets the entities move Y.
---@param self IEntity
---@param index number
---@param y number
function IEntity:SetMoveY(index, y) end

---Sets the entities move W.
---@param self IEntity
---@param index number
---@param w number
function IEntity:SetMoveW(index, w) end

---Sets the entities move delta X.
---@param self IEntity
---@param index number
---@param x number
function IEntity:SetMoveDeltaX(index, x) end

---Sets the entities move delta Z.
---@param self IEntity
---@param index number
---@param z number
function IEntity:SetMoveDeltaZ(index, z) end

---Sets the entities move delta Y.
---@param self IEntity
---@param index number
---@param y number
function IEntity:SetMoveDeltaY(index, y) end

---Sets the entities move delta W.
---@param self IEntity
---@param index number
---@param w number
function IEntity:SetMoveDeltaW(index, w) end

---Sets the entities move delta roll.
---@param self IEntity
---@param index number
---@param roll number
function IEntity:SetMoveDeltaRoll(index, roll) end

---Sets the entities move delta yaw.
---@param self IEntity
---@param index number
---@param yaw number
function IEntity:SetMoveDeltaYaw(index, yaw) end

---Sets the entities move delta pitch.
---@param self IEntity
---@param index number
---@param pitch number
function IEntity:SetMoveDeltaPitch(index, pitch) end

---Sets the entities target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetTargetIndex(index, target_index) end

---Sets the entities server id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetServerId(index, id) end

---Sets the entities name.
---@param self IEntity
---@param index number
---@param name string
function IEntity:SetName(index, name) end

---Sets the entities movement speed.
---@param self IEntity
---@param index number
---@param speed number
function IEntity:SetMovementSpeed(index, speed) end

---Sets the entities animation speed.
---@param self IEntity
---@param index number
---@param speed number
function IEntity:SetAnimationSpeed(index, speed) end

---Sets the entities actor pointer.
---@param self IEntity
---@param index number
---@param ptr number
function IEntity:SetActorPointer(index, ptr) end

---Sets the entities attachment.
---@param self IEntity
---@param index number
---@param attachment_index number
---@param attachment number
function IEntity:SetAttachment(index, attachment_index, attachment) end

---Sets the entities event pointer.
---@param self IEntity
---@param index number
---@param ptr number
function IEntity:SetEventPointer(index, ptr) end

---Sets the entities distance.
---@param self IEntity
---@param index number
---@param dist number
function IEntity:SetDistance(index, dist) end

---Sets the entities turn speed.
---@param self IEntity
---@param index number
---@param speed number
function IEntity:SetTurnSpeed(index, speed) end

---Sets the entities turn speed head.
---@param self IEntity
---@param index number
---@param speed number
function IEntity:SetTurnSpeedHead(index, speed) end

---Sets the entities heading.
---@param self IEntity
---@param index number
---@param heading number
function IEntity:SetHeading(index, heading) end

---Sets the entities next.
---@param self IEntity
---@param index number
---@param next number
function IEntity:SetNext(index, next) end

---Sets the entities HP percent.
---@param self IEntity
---@param index number
---@param hpp number
function IEntity:SetHPPercent(index, hpp) end

---Sets the entities type.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetType(index, val) end

---Sets the entities race.
---@param self IEntity
---@param index number
---@param race number
function IEntity:SetRace(index, race) end

---Sets the entities local move count.
---@param self IEntity
---@param index number
---@param count number
function IEntity:SetLocalMoveCount(index, count) end

---Sets the entities actor lock flag.
---@param self IEntity
---@param index number
---@param flag number
function IEntity:SetActorLockFlag(index, flag) end

---Sets the entities model update flags.
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetModelUpdateFlags(index, flags) end

---Sets the entities door id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetDoorId(index, id) end

---Sets the entities look hair.
---@param self IEntity
---@param index number
---@param hair number
function IEntity:SetLookHair(index, hair) end

---Sets the entities look head.
---@param self IEntity
---@param index number
---@param head number
function IEntity:SetLookHead(index, head) end

---Sets the entities look body.
---@param self IEntity
---@param index number
---@param body number
function IEntity:SetLookBody(index, body) end

---Sets the entities look hands.
---@param self IEntity
---@param index number
---@param hands number
function IEntity:SetLookHands(index, hands) end

---Sets the entities look legs.
---@param self IEntity
---@param index number
---@param legs number
function IEntity:SetLookLegs(index, legs) end

---Sets the entities look feet.
---@param self IEntity
---@param index number
---@param feet number
function IEntity:SetLookFeet(index, feet) end

---Sets the entities look main.
---@param self IEntity
---@param index number
---@param main number
function IEntity:SetLookMain(index, main) end

---Sets the entities look sub.
---@param self IEntity
---@param index number
---@param sub number
function IEntity:SetLookSub(index, sub) end

---Sets the entities look ranged.
---@param self IEntity
---@param index number
---@param ranged number
function IEntity:SetLookRanged(index, ranged) end

---Sets the entities action timer (1).
---@param self IEntity
---@param index number
---@param timer number
function IEntity:SetActionTimer1(index, timer) end

---Sets the entities action timer (2).
---@param self IEntity
---@param index number
---@param timer number
function IEntity:SetActionTimer2(index, timer) end

---Sets the entities render flags (0).
---@param self IEntity
---@param index number
function IEntity:SetRenderFlags0(index, flags) end

---Sets the entities render flags (1).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags1(index, flags) end

---Sets the entities render flags (2).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags2(index, flags) end

---Sets the entities render flags (3).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags3(index, flags) end

---Sets the entities render flags (4).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags4(index, flags) end

---Sets the entities render flags (5).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags5(index, flags) end

---Sets the entities render flags (6).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags6(index, flags) end

---Sets the entities render flags (7).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags7(index, flags) end

---Sets the entities render flags (8).
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetRenderFlags8(index, flags) end

---Sets the entities pop effect.
---@param self IEntity
---@param index number
---@param effect number
function IEntity:SetPopEffect(index, effect) end

---Sets the entities update mask.
---@param self IEntity
---@param index number
---@param mask number
function IEntity:SetUpdateMask(index, mask) end

---Sets the entities interaction target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetInteractionTargetIndex(index, target_index) end

---Sets the entities NPC speech frame.
---@param self IEntity
---@param index number
---@param frame number
function IEntity:SetNpcSpeechFrame(index, frame) end

---Sets the entities look axis X.
---@param self IEntity
---@param index number
---@param x number
function IEntity:SetLookAxisX(index, x) end

---Sets the entities look axis Y.
---@param self IEntity
---@param index number
---@param y number
function IEntity:SetLookAxisY(index, y) end

---Sets the entities mouth counter.
---@param self IEntity
---@param index number
---@param counter number
function IEntity:SetMouthCounter(index, counter) end

---Sets the entities mouth wait counter.
---@param self IEntity
---@param index number
---@param counter number
function IEntity:SetMouthWaitCounter(index, counter) end

---Sets the entities craft timer unknown.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetCraftTimerUnknown(index, val) end

---Sets the entities craft server id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetCraftServerId(index, id) end

---Sets the entities craft animation effect.
---@param self IEntity
---@param index number
---@param effect number
function IEntity:SetCraftAnimationEffect(index, effect) end

---Sets the entities craft animation step.
---@param self IEntity
---@param index number
---@param step number
function IEntity:SetCraftAnimationStep(index, step) end

---Sets the entities craft param.
---@param self IEntity
---@param index number
---@param param number
function IEntity:SetCraftParam(index, param) end

---Sets the entities movement speed (2).
---@param self IEntity
---@param index number
---@param speed number
function IEntity:SetMovementSpeed2(index, speed) end

---Sets the entities NPC walk position (1).
---@param self IEntity
---@param index number
---@param pos number
function IEntity:SetNpcWalkPosition1(index, pos) end

---Sets the entities NPC walk position (2).
---@param self IEntity
---@param index number
---@param pos number
function IEntity:SetNpcWalkPosition2(index, pos) end

---Sets the entities NPC walk mode.
---@param self IEntity
---@param index number
---@param mode number
function IEntity:SetNpcWalkMode(index, mode) end

---Sets the entities custome id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetCostumeId(index, id) end

---Sets the entities mou4.
---@param self IEntity
---@param index number
---@param mou4 number
function IEntity:SetMou4(index, mou4) end

---Sets the entities status server.
---@param self IEntity
---@param index number
---@param status number
function IEntity:SetStatusServer(index, status) end

---Sets the entities status.
---@param self IEntity
---@param index number
---@param status number
function IEntity:SetStatus(index, status) end

---Sets the entities status event.
---@param self IEntity
---@param index number
---@param status number
function IEntity:SetStatusEvent(index, status) end

---Sets the entities model time.
---@param self IEntity
---@param index number
---@param time number
function IEntity:SetModelTime(index, time) end

---Sets the entities model start time.
---@param self IEntity
---@param index number
---@param time number
function IEntity:SetModelStartTime(index, time) end

---Sets the entities claim status.
---@param self IEntity
---@param index number
---@param status number
function IEntity:SetClaimStatus(index, status) end

---Sets the entities zone id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetZoneId(index, id) end

---Sets the entities animation.
---@param self IEntity
---@param index number
---@param animation_index number
---@param animation number
function IEntity:SetAnimation(index, animation_index, animation) end

---Sets the entities animation time.
---@param self IEntity
---@param index number
---@param time number
function IEntity:SetAnimationTime(index, time) end

---Sets the entities animation step.
---@param self IEntity
---@param index number
---@param step number
function IEntity:SetAnimationStep(index, step) end

---Sets the entities animation play.
---@param self IEntity
---@param index number
---@param play number
function IEntity:SetAnimationPlay(index, play) end

---Sets the entities emote target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetEmoteTargetIndex(index, target_index) end

---Sets the entities emote id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetEmoteId(index, id) end

---Sets the entities emote id string.
---@param self IEntity
---@param index number
---@param str number
function IEntity:SetEmoteIdString(index, str) end

---Sets the entities emote target actor pointer.
---@param self IEntity
---@param index number
---@param ptr number
function IEntity:SetEmoteTargetActorPointer(index, ptr) end

---Sets the entities spawn flags.
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetSpawnFlags(index, flags) end

---Sets the entities linkshell color.
---@param self IEntity
---@param index number
---@param color number
function IEntity:SetLinkshellColor(index, color) end

---Sets the entities name color.
---@param self IEntity
---@param index number
---@param color number
function IEntity:SetNameColor(index, color) end

---Sets the entities Campaign name flag.
---@param self IEntity
---@param index number
---@param flag number
function IEntity:SetCampaignNameFlag(index, flag) end

---Sets the entities mount id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetMountId(index, id) end

---Sets the entities fishing unknown0000.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetFishingUnknown0000(index, val) end

---Sets the entities fishing unknown0001.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetFishingUnknown0001(index, val) end

---Sets the entities fishing action countdown.
---@param self IEntity
---@param index number
---@param countdown number
function IEntity:SetFishingActionCountdown(index, countdown) end

---Sets the entities fishing rod cast time.
---@param self IEntity
---@param index number
---@param time number
function IEntity:SetFishingRodCastTime(index, time) end

---Sets the entities fishing unknown0002.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetFishingUnknown0002(index, val) end

---Sets the entities last action id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetLastActionId(index, id) end

---Sets the entities mog motion id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetMogMotionId(index, id) end

---Sets the entities last action actor pointer.
---@param self IEntity
---@param index number
---@param ptr number
function IEntity:SetLastActionActorPointer(index, ptr) end

---Sets the entities targeted index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetTargetedIndex(index, target_index) end

---Sets the entities pet target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetPetTargetIndex(index, target_index) end

---Sets the entities update request delay.
---@param self IEntity
---@param index number
---@param delay number
function IEntity:SetUpdateRequestDelay(index, delay) end

---Sets the entities dirty flag.
---@param self IEntity
---@param index number
---@param flag number
function IEntity:SetIsDirty(index, flag) end

---Sets the entities Ballista flags.
---@param self IEntity
---@param index number
---@param flags number
function IEntity:SetBallistaFlags(index, flags) end

---Sets the entities Pankration enabled flag.
---@param self IEntity
---@param index number
---@param flag number
function IEntity:SetPankrationEnabled(index, flag) end

---Sets the entities Pankration flag flip.
---@param self IEntity
---@param index number
---@param flag number
function IEntity:SetPankrationFlagFlip(index, flag) end

---Sets the entities model size.
---@param self IEntity
---@param index number
---@param size number
function IEntity:SetModelSize(index, size) end

---Sets the entities model hitbox size.
---@param self IEntity
---@param index number
---@param size number
function IEntity:SetModelHitboxSize(index, size) end

---Sets the entities environment area id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetEnvironmentAreaId(index, id) end

---Sets the entities Monstrosity flag.
---@param self IEntity
---@param index number
---@param flag number
function IEntity:SetMonstrosityFlag(index, flag) end

---Sets the entities Monstrosity name id.
---@param self IEntity
---@param index number
---@param id number
function IEntity:SetMonstrosityNameId(index, id) end

---Sets the entities Monstrosity name.
---@param self IEntity
---@param index number
---@param name string
function IEntity:SetMonstrosityName(index, name) end

---Sets the entities Monstrosity name end.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetMonstrosityNameEnd(index, val) end

---Sets the entities Monstrosity name abbr.
---@param self IEntity
---@param index number
---@param name string
function IEntity:SetMonstrosityNameAbbr(index, name) end

---Sets the entities Monstrosity name abbr end.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetMonstrosityNameAbbrEnd(index, val) end

---Sets the entities custom properties.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetCustomProperties(index, val) end

---Sets the entities Ballista info.
---@param self IEntity
---@param index number
---@param val number
function IEntity:SetBallistaInfo(index, val) end

---Sets the entities fellow target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetFellowTargetIndex(index, target_index) end

---Sets the entities warp target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetWarpTargetIndex(index, target_index) end

---Sets the entities Trust owner target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetTrustOwnerTargetIndex(index, target_index) end

---Sets the entities area display target index.
---@param self IEntity
---@param index number
---@param target_index number
function IEntity:SetAreaDisplayTargetIndex(index, target_index) end