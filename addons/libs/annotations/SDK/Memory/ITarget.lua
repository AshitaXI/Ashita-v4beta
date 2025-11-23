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
arrowposition_t Structure
--]]

---@class arrowposition_t
---@field X number
---@field Z number
---@field Y number
---@field W number
local arrowposition_t = {};

--[[
targetentry_t Structure
--]]

---@class targetentry_t
---@field Index number
---@field ServerId number
---@field EntityPointer number
---@field ActorPointer number
---@field ArrowPosition arrowposition_t
---@field IsActive number
---@field IsModelActor number
---@field IsArrowActive number
---@field unknown0023 number
---@field Checksum number
---@field unknown0026 number
local targetentry_t = {};

--[[
target_t Structure
--]]

---@class target_t
---@field Targets targetentry_t[]
---@field IsWalk number
---@field IsAutoNotice number
---@field IsSubTargetActive number
---@field DeactivateTarget number
---@field ModeChangeLock number
---@field IsMouseRequestStack number
---@field IsMouseRequestCancel number
---@field IsPlayerMoving number
---@field unknown0058 number
---@field unknown0059 number
---@field unknown005A number
---@field unknown005B number
---@field LockedOnFlags number
---@field SubTargetFlags number
---@field OldNotice number
---@field DefaultMode number
---@field MenuTargetLock number
---@field ActionTargetActive number
---@field ActionTargetMaxYalms number
---@field unknown006E number
---@field unknown006F number
---@field unknown0070 number
---@field unknown0071 number
---@field unknown0072 number
---@field unknown0073 number
---@field IsMenuOpen number
---@field IsActionAoe number
---@field ActionType number
---@field ActionAoeRange number
---@field ActionId number
---@field ActionTargetServerId number
---@field unknown0080 number
---@field unknown0082 number
---@field unknown0083 number
---@field FocusTargetIndex number
---@field FocusTargetServerId number
---@field TargetPosF table
---@field LastTargetName string
---@field LastTargetIndex number
---@field LastTargetServerId number
---@field LastTargetChecksum number
---@field ActionCallback number
---@field CancelCallback number
---@field MyroomCallback number
---@field ActionAoeCallback number
local target_t = {};

--[[
targetwindow_t Structure
--]]

---@class targetwindow_t
---@field VTablePointer number
---@field m_BaseObj number
---@field m_pParentMCD number
---@field m_InputEnable number
---@field unknown000D number
---@field m_SaveCursol number
---@field m_Reposition number
---@field unknown0011 table
---@field Name string
---@field EntityPointer number
---@field FrameChildrenOffsetX number
---@field FrameChildrenOffsetY number
---@field IconPositionX number
---@field IconPositionY number
---@field FrameOffsetX number
---@field FrameOffsetY number
---@field unknown0058 number
---@field LockShape number
---@field ServerId number
---@field HPPercent number
---@field DeathFlag number
---@field ReraiseFlag number
---@field DeathNameColor number
---@field IsWindowLoaded number
---@field HelpString number
---@field HelpTitle number
---@field m_pAnkShape table
---@field m_Sub number
---@field unknown00B9 number
---@field m_AnkNum number
---@field unknown00BB number
---@field m_AnkX number
---@field m_AnkY number
---@field m_SubAnkX number
---@field m_SubAnkY number
local targetwindow_t = {};

--[[
ITarget Interface
--]]

---@class ITarget
local ITarget = {};

---Returns the raw target structure.
---@param self ITarget
---@return target_t
---@nodiscard
function ITarget:GetRawStructure() end

---Returns the raw target window structure.
---@param self ITarget
---@return targetwindow_t
---@nodiscard
function ITarget:GetRawStructureWindow() end

---Returns the requested targets index.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetTargetIndex(index) end

---Returns the requested targets server id.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetServerId(index) end

---Returns the requested targets entity pointer.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetEntityPointer(index) end

---Returns the requested targets actor pointer.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetActorPointer(index) end

---Returns the requested targets arrow X position.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetArrowPositionX(index) end

---Returns the requested targets arrow Z position.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetArrowPositionZ(index) end

---Returns the requested targets arrow Y position.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetArrowPositionY(index) end

---Returns the requested targets arrow W position.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetArrowPositionW(index) end

---Returns the requested targets active flag.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetIsActive(index) end

---Returns the requested targets model actor flag.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetIsModelActor(index) end

---Returns the requested targets arrow active flag.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetIsArrowActive(index) end

---Returns the requested targets checksum.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetChecksum(index) end

---Returns the target walk flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsWalk() end

---Returns the target auto notice flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsAutoNotice() end

---Returns the target sub target active flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsSubTargetActive() end

---Returns the target deactivate target flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetDeactivateTarget() end

---Returns the target mode change lock flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetModeChangeLock() end

---Returns the target mouse request stack flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsMouseRequestStack() end

---Returns the target mouse request cancel flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsMouseRequestCancel() end

---Returns the target player moving flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsPlayerMoving() end

---Returns the target locked on flags.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetLockedOnFlags() end

---Returns the target sub target flags.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetSubTargetFlags() end

---Returns the target old notice.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetOldNotice() end

---Returns the target default mode.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetDefaultMode() end

---Returns the target menu target lock.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetMenuTargetLock() end

---Returns the target action target active.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionTargetActive() end

---Returns the target action target max yalms.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionTargetMaxYalms() end

---Returns the target menu open flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsMenuOpen() end

---Returns the target action aoe flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetIsActionAoe() end

---Returns the target action type.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionType() end

---Returns the target action aoe range.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionAoeRange() end

---Returns the target action id.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionId() end

---Returns the target action target server id.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionTargetServerId() end

---Returns the target focus target index.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetFocusTargetIndex() end

---Returns the target focus target server id.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetFocusTargetServerId() end

---Returns the target pos F.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetTargetPosF() end

---Returns the target last target name.
---@param self ITarget
---@return string
---@nodiscard
function ITarget:GetLastTargetName() end

---Returns the target last target index.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetLastTargetIndex() end

---Returns the target last target server id.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetLastTargetServerId() end

---Returns the target last target checksum.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetLastTargetChecksum() end

---Returns the target action callback.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionCallback() end

---Returns the target cancel callback.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetCancelCallback() end

---Returns the target myroom callback.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetMyroomCallback() end

---Returns the target action aoe callback.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetActionAoeCallback() end

---Returns the target window name.
---@param self ITarget
---@return string
---@nodiscard
function ITarget:GetWindowName() end

---Returns the target window entity pointer.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowEntityPointer() end

---Returns the target window frame children X offset.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowFrameChildrenOffsetX() end

---Returns the target window frame children Y offset.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowFrameChildrenOffsetY() end

---Returns the target window icon X position.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowIconPositionX() end

---Returns the target window icon Y position.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowIconPositionY() end

---Returns the target window frame X offset.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowFrameOffsetX() end

---Returns the target window frame Y offset.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowFrameOffsetY() end

---Returns the target window lock shape.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowLockShape() end

---Returns the target window server id.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowServerId() end

---Returns the target window HP percent.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowHPPercent() end

---Returns the target window death flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowDeathFlag() end

---Returns the target window reraise flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowReraiseFlag() end

---Returns the target window death name color.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowDeathNameColor() end

---Returns the target window loaded flag.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowIsWindowLoaded() end

---Returns the target window help string.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowHelpString() end

---Returns the target window help title.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowHelpTitle() end

---Returns the target window ank shape.
---@param self ITarget
---@param index number
---@return number
---@nodiscard
function ITarget:GetWindowAnkShape(index) end

---Returns the target window sub.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowSub() end

---Returns the target window ank num.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowAnkNum() end

---Returns the target window ank X.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowAnkX() end

---Returns the target window ank Y.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowAnkY() end

---Returns the target window sub ank X.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowSubAnkX() end

---Returns the target window sub ank Y.
---@param self ITarget
---@return number
---@nodiscard
function ITarget:GetWindowSubAnkY() end

---Sets the current target.
---@param self ITarget
---@param index number
---@param force boolean
function ITarget:SetTarget(index, force) end