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

require 'common';
require 'win32types';

local chat  = require 'chat';
local ffi   = require 'ffi';

ffi.cdef[[
    typedef bool        (__thiscall*    FsMacroController_canUseMacro_f)(uint32_t);
    typedef bool        (__thiscall*    FsMacroContainer_clearMacro_f)(uint32_t, uint32_t);
    typedef const char* (__thiscall*    FsMacroContainer_getName_f)(uint32_t, uint32_t);
    typedef const char* (__thiscall*    FsMacroContainer_getLine_f)(uint32_t, uint32_t, uint32_t);
    typedef void        (__thiscall*    FsMacroContainer_runMacro_f)(uint32_t, uint8_t, uint8_t);
    typedef int32_t     (__thiscall*    FsMacroContainer_setBook_f)(uint32_t, uint32_t);
    typedef int32_t     (__thiscall*    FsMacroContainer_setPage_f)(uint32_t, uint32_t);
    typedef void        (__cdecl*       FsMacroContainer_setMacro_f)(uint32_t, const char*, const char*);
    typedef void        (__thiscall*    FsMacroContainer_stopMacro_f)(uint32_t);
]];

local macrolib = T{
    ptrs = T{
        -- Macro Objects
        macro       = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????E8????????8B4424105EC38B15????????68', 2, 0),  -- g_pFsMacro
        controller  = ashita.memory.find('FFXiMain.dll', 0, 'A3????????EB??891D????????6A50E8', 1, 0),                  -- g_pFsMacroController

        -- Macro Functions
        can_use     = ashita.memory.find('FFXiMain.dll', 0, '66A1????????5633F66685C074??0FBFC08B3485????????8B0D', 0, 0),                                      -- FsMacroController::canUseMacro
        clear       = ashita.memory.find('FFXiMain.dll', 0, '8B44240485C07C??83F8147D??8D1440C1E2052BD08D4C9104E8????????B001', 0, 0),                          -- FsMacroContainer::clearMacro
        get_name    = ashita.memory.find('FFXiMain.dll', 0, '8B44240485C07C??83F8147D??8D1440C1E2052BD08D4C9104E8????????85C0', 0, 0),                          -- FsMacroContainer::getName
        get_line    = ashita.memory.find('FFXiMain.dll', 0, '8B44240485C07C??83F8147D??8B542408528D1440C1E2052BD08D4C9104E8????????C2080033C0C20800', 0, 0),    -- FsMacroContainer::getLine
        run         = ashita.memory.find('FFXiMain.dll', 0, '8A44240453563C018BF175??8A5C24108B4E040FBEC350E8', 0, 0),                                          -- FsMacroContainer::runMacro
        set_book    = ashita.memory.find('FFXiMain.dll', 0, '8B442404568BF18B8EC01D00003BC875??8BC15EC20400', 0, 0),                                            -- FsMacroContainer::setBook
        set_page    = ashita.memory.find('FFXiMain.dll', 0, '568BF1578B7C240C8B86C01D00008D04', 0, 0),                                                          -- FsMacroContainer::setPage
        set         = ashita.memory.find('FFXiMain.dll', 0, '8B442408538B5C24085657508BCBE8????????85C07C??8B', 0, 0),                                          -- FsMacroContainer::setMacro
        stop        = ashita.memory.find('FFXiMain.dll', 0, 'C781????????FFFFFFFFC3', 0, 0),                                                                    -- FsMacroContainer::stopMacro
    },
};

if (not macrolib.ptrs:all(function (v) return v ~= nil and v ~= 0; end)) then
    error(chat.header(addon.name):append(chat.error('[lib.macros] Error: Failed to locate required pointer(s).')));
    return;
end

--[[
* Returns the current g_pFsMacro object.
*
* @return {number} The current g_pFsMacro object.
--]]
macrolib.get_fsmacro = function ()
    local addr = ashita.memory.read_uint32(macrolib.ptrs.macro);
    if (addr == 0) then return 0; end
    return ashita.memory.read_uint32(addr);
end

--[[
* Returns the current g_pFsMacroController object.
*
* @return {number} The current g_pFsMacroController object.
--]]
macrolib.get_fscontroller = function ()
    local addr = ashita.memory.read_uint32(macrolib.ptrs.controller);
    if (addr == 0) then return 0; end
    return ashita.memory.read_uint32(addr);
end

--[[
* Returns if a macro can currently be used.
*
* @return {boolean} True if a macro can run, false otherwise.
--]]
macrolib.can_use = function ()
    local obj = macrolib.get_fscontroller();
    if (obj == nil) then return false; end

    return ffi.cast('FsMacroController_canUseMacro_f', macrolib.ptrs.can_use)(obj);
end

--[[
* Clears a macro, removing its name and lines.
*
* @param {number} idx - The index of the macro to clear.
* @return {boolean} True if the macro is cleared, false otherwise.
--]]
macrolib.clear = function (idx)
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return false; end

    if (idx >= 20) then
        return false;
    end

    return ffi.cast('FsMacroContainer_clearMacro_f', macrolib.ptrs.clear)(obj, idx);
end

--[[
* Returns the name of a macro.
*
* @param {number} idx - The index of the macro.
* @return {string} The name of the macro.
--]]
macrolib.get_name = function (idx)
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return ''; end

    if (idx >= 20) then
        return '';
    end

    local str = ffi.cast('FsMacroContainer_getName_f', macrolib.ptrs.get_name)(obj, idx);
    if (str == nil) then
        return '';
    end
    str = ffi.string(str);
    if (str == nil) then
        return '';
    end

    return str;
end

--[[
* Returns the requested line of a macro.
*
* @param {number} idx - The index of the macro.
* @param {number} line - The index of the macro line.
* @return {string} The macro line.
--]]
macrolib.get_line = function (idx, line)
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return ''; end

    if (idx >= 20 or line >= 6) then
        return '';
    end

    local str = ffi.cast('FsMacroContainer_getLine_f', macrolib.ptrs.get_line)(obj, idx, line);
    if (str == nil) then
        return '';
    end
    str = ffi.string(str);
    if (str == nil) then
        return '';
    end

    return str;
end

--[[
* Returns if a macro is currently running.
*
* @return {boolean} True if running, false otherwise.
--]]
macrolib.is_running = function ()
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return false; end

    return ashita.memory.read_uint32(obj + ashita.memory.read_uint32(macrolib.ptrs.stop + 2)) ~= 0xFFFFFFFF;
end

--[[
* Runs a macro.
*
* @param {number} mod - The modifier key state of the macro. (1 = Control, 2 = Alt)
* @param {number} idx - The index of the macro.
--]]
macrolib.run = function (mod, idx)
    local obj = macrolib.get_fscontroller();
    if (obj == nil) then return; end

    if ((mod ~= 1 and mod ~= 2) or idx >= 20) then
        return;
    end

    ffi.cast('FsMacroContainer_runMacro_f', macrolib.ptrs.run)(obj, mod, idx);
end

--[[
* Sets the current macro book.
*
* @param {number} idx - The index of the macro book to set.
* @return {number} Unused return value.
--]]
macrolib.set_book = function (idx)
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return 0; end

    if (idx >= 40) then
        return 0;
    end

    return ffi.cast('FsMacroContainer_setBook_f', macrolib.ptrs.set_book)(obj, idx);
end

--[[
* Sets the current macro page.
*
* @param {number} idx - The index of the macro page to set.
* @return {number} Unused return value.
--]]
macrolib.set_page = function (idx)
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return 0; end

    if (idx >= 10) then
        return 0;
    end

    return ffi.cast('FsMacroContainer_setPage_f', macrolib.ptrs.set_page)(obj, 2 * (idx + 1) - 2);
end

--[[
* Sets a macro.
*
* @param {number} idx - The index of the macro to set.
* @param {string} title - The new title of the macro.
* @param {table} lines - The new lines of the macro.
--]]
macrolib.set = function (idx, title, lines)
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return; end

    if (idx >= 20) then
        return;
    end
    if (title == nil or type(title) ~= 'string' or title:len() > 8) then
        return;
    end
    if (lines == nil or type(lines) ~= 'table' or lines:len() > 6) then
        return;
    end

    --[[
    Note:   The lines that make up the macro are stored in a single block, separated by null characters. Each line
            is 61 characters long and needs to be padded out in order to function properly. The macro system does
            not clear empty lines or previous lines stored in a macro either, thus the macro needs to be cleared
            first in order to be properly set.
    --]]

    macrolib.clear(idx);

    local str = '';
    lines:each(function (v)
        if (v:len() > 60) then
            str = str .. v:sub(1, 59) .. '\0';
        else
            str = str .. v .. ('\0'):rep(61 - v:len());
        end
    end);

    ffi.cast('FsMacroContainer_setMacro_f', macrolib.ptrs.set)(obj + 380 * idx + 4, title, str);
end

--[[
* Stops the current running macro.
--]]
macrolib.stop = function ()
    local obj = macrolib.get_fsmacro();
    if (obj == nil) then return; end

    ffi.cast('FsMacroContainer_stopMacro_f', macrolib.ptrs.stop)(obj);
end

return macrolib;