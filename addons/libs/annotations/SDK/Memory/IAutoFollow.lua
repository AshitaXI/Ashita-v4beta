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
autofollow_t Structure
--]]

---@class autofollow_t
---@field VTablePointer number
---@field TargetIndex number
---@field TargetServerId number
---@field FollowDeltaX number
---@field FollowDeltaZ number
---@field FollowDeltaY number
---@field FollowDeltaW number
---@field VTablePointer2 number
---@field FollowTargetIndex number
---@field FollowTargetServerId number
---@field IsFirstPersonCamera number
---@field IsAutoRunning number
---@field unknown002C number
---@field IsCameraLocked number
---@field IsCameraLockedOn number
local autofollow_t = {};

--[[
IAutoFollow Interface
--]]

---@class IAutoFollow
local IAutoFollow = {};

---Returns the raw auto-follow structure.
---@param self IAutoFollow
---@return autofollow_t
---@nodiscard
function IAutoFollow:GetRawStructure() end

---Returns the auto-follow target index.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetTargetIndex() end

---Returns the auto-follow target server id.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetTargetServerId() end

---Returns the auto-follow delta X.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetFollowDeltaX() end

---Returns the auto-follow delta Z.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetFollowDeltaZ() end

---Returns the auto-follow delta Y.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetFollowDeltaY() end

---Returns the auto-follow delta W.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetFollowDeltaW() end

---Returns the auto-follow follow target index.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetFollowTargetIndex() end

---Returns the auto-follow follow target server id.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetFollowTargetServerId() end

---Returns the auto-follow first person camera flag.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetIsFirstPersonCamera() end

---Returns the auto-follow auto-running flag.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetIsAutoRunning() end

---Returns the auto-follow camera locked flag.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetIsCameraLocked() end

---Returns the auto-follow camera locked on flag.
---@param self IAutoFollow
---@return number
---@nodiscard
function IAutoFollow:GetIsCameraLockedOn() end

---Sets the auto-follow target index.
---@param self IAutoFollow
---@param index number
function IAutoFollow:SetTargetIndex(index) end

---Sets the auto-follow target server id.
---@param self IAutoFollow
---@param id number
function IAutoFollow:SetTargetServerId(id) end

---Sets the auto-follow delta X.
---@param self IAutoFollow
---@param x number
function IAutoFollow:SetFollowDeltaX(x) end

---Sets the auto-follow delta Z.
---@param self IAutoFollow
---@param z number
function IAutoFollow:SetFollowDeltaZ(z) end

---Sets the auto-follow delta Y.
---@param self IAutoFollow
---@param y number
function IAutoFollow:SetFollowDeltaY(y) end

---Sets the auto-follow delta W.
---@param self IAutoFollow
---@param w number
function IAutoFollow:SetFollowDeltaW(w) end

---Sets the auto-follow follow target index.
---@param self IAutoFollow
---@param index number
function IAutoFollow:SetFollowTargetIndex(index) end

---Sets the auto-follow follow target server id.
---@param self IAutoFollow
---@param id number
function IAutoFollow:SetFollowTargetServerId(id) end

---Sets the auto-follow first person camera flag.
---@param self IAutoFollow
---@param flag number
function IAutoFollow:SetIsFirstPersonCamera(flag) end

---Sets the auto-follow auto-running flag.
---@param self IAutoFollow
---@param flag number
function IAutoFollow:SetIsAutoRunning(flag) end

---Sets the auto-follow camera locked flag.
---@param self IAutoFollow
---@param flag number
function IAutoFollow:SetIsCameraLocked(flag) end

---Sets the auto-follow camera locked on flag.
---@param self IAutoFollow
---@param flag number
function IAutoFollow:SetIsCameraLockedOn(flag) end