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
IPacketManager Interface
--]]

---@class IPacketManager
local IPacketManager = {};

---Injects an incoming packet.
---@param self IPacketManager
---@param id number
---@param packet table
function IPacketManager:AddIncomingPacket(id, packet) end

---Injects an outgoing packet.
---@param self IPacketManager
---@param id number
---@param packet table
function IPacketManager:AddOutgoingPacket(id, packet) end

---Queues an outgoing packet through the games packet functions, as if the client sent it normally.
---@param self IPacketManager
---@param id number
---@param len number
---@param align number
---@param pparam1 number
---@param pparam2 number
---@param callback function
function IPacketManager:QueuePacket(id, len, align, pparam1, pparam2, callback) end