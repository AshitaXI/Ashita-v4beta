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

---@enum ChatInputOpenStatus
ChatInputOpenStatus = {
    Closed              = 0x00, -- Casted to bool-like type. (Low bits used for open/closed state.)
    Opened              = 0x01, -- Casted to bool-like type. (Low bits used for open/closed state.)
    OpenedChat          = 0x11, -- Flag set if input is open. (Chat)
    OpenedOther         = 0x21, -- Flag set if input is open. (Bazaar Comment, Search Comment, etc.)
};

---@enum CommandMode
CommandMode = {
    AshitaForceHandle   = -3,       -- Tells Ashita to force-handle the command.
    AshitaScript        = -2,       -- Tells Ashita to assume the command is from a script.
    AshitaParse         = -1,       -- Tells Ashita to parse the command.
    Menu                = 0x00,     -- Tells Ashita to forward the command as if a game menu invoked it.
    Typed               = 0x01,     -- Tells Ashita to forward the command as if a player typed it.
    Macro               = 0x02,     -- Tells Ashita to forward the command as if a macro invoked it.
    SubTargetST         = 0x03,     -- (Internal) Used when reprocessing a command if a <st> tag was found.
    SubTargetSTPC       = 0x04,     -- (Internal) Used when reprocessing a command if a <stpc> tag was found.
    SubTargetSTNPC      = 0x05,     -- (Internal) Used when reprocessing a command if a <stnpc> tag was found.
    SubTargetSTPT       = 0x06,     -- (Internal) Used when reprocessing a command if a <stpt> tag was found.
    SubTargetSTAL       = 0x07,     -- (Internal) Used when reprocessing a command if a <stal> tag was found.
};

---@enum FontBorderFlags
FontBorderFlags = {
    None                = 0x00,     -- None.
    Top                 = 0x01,     -- Font will have a top border.
    Bottom              = 0x02,     -- Font will have a bottom border.
    Left                = 0x04,     -- Font will have a left border.
    Right               = 0x08,     -- Font will have a right border.
    All                 = 0x0F,     -- Font will have all borders.
};

---@enum FontCreateFlags
FontCreateFlags = {
    None                = 0x00,     -- None.
    Bold                = 0x01,     -- Font will be bold.
    Italic              = 0x02,     -- Font will be italic.
    StrikeThrough       = 0x04,     -- Font will be strikethrough.
    Underlined          = 0x08,     -- Font will be underlined.
    CustomFile          = 0x10,     -- Font will be loaded from a custom file.
    ClearType           = 0x20,     -- Font will be created with an alpha channel texture supporting ClearType.
};

---@enum FontDrawFlags
FontDrawFlags = {
    None                = 0x00,     -- None.
    Filtered            = 0x01,     -- Font will be drawn filtered.
    CenterX             = 0x02,     -- Font will be drawn centered. (X)
    CenterY             = 0x04,     -- Font will be drawn centered. (Y)
    RightJustified      = 0x08,     -- Font will be drawn right-justified.
    Outlined            = 0x10,     -- Font will be drawn with a colored outline.
    ManualRender        = 0x20,     -- Font will be drawn manually by the owner.
};

---@enum FrameAnchor
FrameAnchor = {
    TopLeft             = 0x00,
    TopRight            = 0x01,
    BottomLeft          = 0x02,
    BottomRight         = 0x03,
    Right               = 0x01,
    Bottom              = 0x02,
};

---@enum LogLevel
LogLevel = {
    None                = 0x00,     -- Logging will output: None
    Critical            = 0x01,     -- Logging will output: Critical
    Error               = 0x02,     -- Logging will output: Critical, Error
    Warn                = 0x03,     -- Logging will output: Critical, Error, Warn
    Info                = 0x04,     -- Logging will output: Critical, Error, Warn, Info
    Debug               = 0x05,     -- Logging will output: Critical, Error, Warn, Info, Debug
};

---@enum KeyboardEvent
KeyboardEvent = {
    Down                = 0x00,     -- Key state down.
    Up                  = 0x01,     -- Key state up.
};

---@enum MouseEvent
MouseEvent = {
    ClickLeft           = 0x00,     -- Mouse left click.
    ClickRight          = 0x01,     -- Mouse right click.
    ClickMiddle         = 0x02,     -- Mouse middle click.
    ClickX1             = 0x03,     -- Mouse X1 click.
    ClickX2             = 0x04,     -- Mouse X2 click.
    WheelUp             = 0x05,     -- Mouse wheel scroll up.
    WheelDown           = 0x06,     -- Mouse wheel scroll down.
    Move                = 0x07,     -- Mouse move.
};

---@enum PluginFlags
PluginFlags = {
    None                = 0x00,     -- None.
    UseCommands         = 0x01,     -- The plugin will make use of the command related events.
    UseText             = 0x02,     -- The plugin will make use of the text related events.
    UsePackets          = 0x04,     -- The plugin will make use of the packet related events.
    UseDirect3D         = 0x08,     -- The plugin will make use of the Direct3D related events.
    UsePluginEvents     = 0x10,     -- The plugin will make use of plugin inter-communication events.

    Legacy              = 0x07,     -- Plugin flags that match the original Ashita v3 setup.
    LegacyDirect3D      = 0x15,     -- Plugin flags that match the original Ashita v3 setup, with Direct3D.
    All                 = 0x1F,     -- The plugin will make use of all available events.
};

---@enum PrimitiveDrawFlags
PrimitiveDrawFlags = {
    None                = 0x00,     -- None.
    ManualRender        = 0x01,     -- Primitive will be drawn manually by the owner.
};