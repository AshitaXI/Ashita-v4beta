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
Font Library and Objects
--]]

---@class fontlib
---@field private cache table
---@field private cache_gc any
---@field private defaults table
---@field private fontobj_mt table
---@field private fontobj_bg_mt table
---@field private methods table
---@field private methods_bg table
---@field private mouse_events table
fontlib = {};

---@class LuaFontObject
---@field alias string
---@field visible boolean
---@field can_focus boolean
---@field locked boolean
---@field lockedz boolean
---@field is_dirty boolean
---@field window_width number
---@field window_height number
---@field font_file string
---@field font_family string
---@field font_height number
---@field create_flags FontCreateFlags
---@field draw_flags FontDrawFlags
---@field bold boolean
---@field italic boolean
---@field right_justified boolean
---@field strike_through boolean
---@field underlined boolean
---@field color number
---@field color_outline number
---@field padding number
---@field position_x number
---@field position_y number
---@field auto_resize boolean
---@field anchor FrameAnchor
---@field anchor_parent FrameAnchor
---@field text string
---@field real_x number
---@field real_y number
---@field background LuaPrimitiveObject
---@field parent LuaFontObject
LuaFontObject = {};

---Applies the given settings to the font object.
---@param self LuaFontObject
---@param settings table
function LuaFontObject:apply(settings) end

---Finds and returns the index of a registered event for the given font.
---@param self LuaFontObject
---@param event_name string
---@param event_alias string
---@return number|nil
---@nodiscard
function LuaFontObject:find_event(event_name, event_alias) end

---Returns the text size of the font object.
---@param self LuaFontObject
---@return number
---@return number
---@nodiscard
function LuaFontObject:get_text_size() end

---Performs a hit test against the font object.
---@param self LuaFontObject
---@param x number
---@param y number
---@return boolean
---@nodiscard
function LuaFontObject:hit_test(x, y) end

---Registers an event callback for the given event.
---@param self LuaFontObject
---@param event_name string
---@param event_alias string
---@param callback function
function LuaFontObject:register(event_name, event_alias, callback) end

---Renders the font object. (Used when manual rendering is enabled.)
---@param self LuaFontObject
function LuaFontObject:render() end

---Unregisters an event callback for the given event.
---@param self LuaFontObject
---@param event_name string
---@param event_alias string
function LuaFontObject:unregister(event_name, event_alias) end

--[[
Primitive Library and Objects
--]]

---@class primlib
---@field private cache table
---@field private cache_gc any
---@field private defaults table
---@field private primobj_mt table
---@field private methods table
---@field private mouse_events table
primlib = {};

---@class LuaPrimitiveObject
---@field alias string
---@field texture string
---@field texture_offset_x number
---@field texture_offset_y number
---@field border_visible boolean
---@field border_color number
---@field border_flags FontBorderFlags
---@field visible boolean
---@field position_x number
---@field position_y number
---@field can_focus boolean
---@field locked boolean
---@field lockedz boolean
---@field scale_x number
---@field scale_y number
---@field width number
---@field height number
---@field color number
---@field border_sizes number
LuaPrimitiveObject = {};

---Applies the given settings to the primitive object.
---@param self LuaPrimitiveObject
---@param settings table
function LuaPrimitiveObject:apply(settings) end

---Destroys the primitive object.
---@param self LuaPrimitiveObject
function LuaPrimitiveObject:destroy() end

---Finds and returns the index of a registered event for the given primitive.
---@param self LuaPrimitiveObject
---@param event_name string
---@param event_alias string
---@return number|nil
---@nodiscard
function LuaPrimitiveObject:find_event(event_name, event_alias) end

---Registers an event callback for the given event.
---@param self LuaPrimitiveObject
---@param event_name string
---@param event_alias string
---@param callback function
function LuaPrimitiveObject:register(event_name, event_alias, callback) end

---Unregisters an event callback for the given event.
---@param self LuaPrimitiveObject
---@param event_name string
---@param event_alias string
function LuaPrimitiveObject:unregister(event_name, event_alias) end