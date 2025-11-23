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
IMemoryManager Interface
--]]

---@class IMemoryManager
local IMemoryManager = {};

---Returns the IAutoFollow memory interface.
---@param self IMemoryManager
---@return IAutoFollow
---@nodiscard
function IMemoryManager:GetAutoFollow() end

---Returns the ICastBar memory interface.
---@param self IMemoryManager
---@return ICastBar
---@nodiscard
function IMemoryManager:GetCastBar() end

---Returns the IEntity memory interface.
---@param self IMemoryManager
---@return IEntity
---@nodiscard
function IMemoryManager:GetEntity() end

---Returns the IInventory memory interface.
---@param self IMemoryManager
---@return IInventory
---@nodiscard
function IMemoryManager:GetInventory() end

---Returns the IParty memory interface.
---@param self IMemoryManager
---@return IParty
---@nodiscard
function IMemoryManager:GetParty() end

---Returns the IPlayer memory interface.
---@param self IMemoryManager
---@return IPlayer
---@nodiscard
function IMemoryManager:GetPlayer() end

---Returns the IRecast memory interface.
---@param self IMemoryManager
---@return IRecast
---@nodiscard
function IMemoryManager:GetRecast() end

---Returns the ITarget memory interface.
---@param self IMemoryManager
---@return ITarget
---@nodiscard
function IMemoryManager:GetTarget() end