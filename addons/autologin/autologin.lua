--[[
* Addons - Copyright (c) 2024 Ashita Development Team
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

addon.name      = 'autologin';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Automatically logs into a desired character slot.';
addon.link      = 'https://ashitaxi.com/';

require 'common';
require 'win32types';

local chat  = require 'chat';
local ffi   = require 'ffi';

ffi.cdef[[

    // CTkObject
    typedef struct CTkObject {
        int16_t             m_RecKind;
        int16_t             m_RecSub1;
    } CTkObject;

    // CTkMenuPrimitive
    typedef struct CTkMenuPrimitive {
        void*               vtbl;
        CTkObject           m_BaseObj;
        void*               m_pParentMCD;
        uint8_t             m_InputEnable;
        uint8_t             unknown000D;
        uint16_t            m_SaveCursol;
        uint8_t             m_Reposition;
        uint8_t             unknown0011[3];
    } CTkMenuPrimitive;

    // IwLicenceMenu
    typedef struct IwLicenceMenu {
        CTkMenuPrimitive    prim;
        int32_t             m_msg;
        int32_t             m_select;
        int32_t             m_IsEnd;
    } IwLicenceMenu;

    // IwLobbyMenu
    typedef struct IwLobbyMenu {
        CTkMenuPrimitive    prim;
        int32_t             m_firstf;
        int32_t             m_select;
        int32_t             m_IsEnd;
    } IwLobbyMenu;

    // IwSelectMenu
    typedef struct IwSelectMenu {
        CTkMenuPrimitive    prim;
        int32_t             m_select;
        int32_t             m_oldselect;
        int32_t             m_IsEnd;
    } IwSelectMenu;

    // IwYesNoMenu
    typedef struct IwYesNoMenu {
        CTkMenuPrimitive    prim;
        int32_t             m_select;
        int32_t             m_msg;
        int32_t             m_errcode;
        char                m_string[16];
        int32_t             m_IsEnd;
    } IwYesNoMenu;

]];

local autologin = T{
    enabled = false,
    slot = 0,
    ptrs = T{
        license     = 0,
        lobby       = 0,
        select      = 0,
        selectidx   = 0,
        yesno       = 0,
    },
};

--[[
* Returns a casted menu type from a base pointer.
*
* @param {number} ptr   - The base pointer of the menu object.
* @param {string} t     - The menu object type.
* @return {userdata|nil} The casted pointer on success, nil otherwise.
--]]
local function get_menu_obj(ptr, t)
    if (ptr == 0) then return nil; end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    return ffi.cast(t:append('*'), ashita.memory.read_uint32(ptr));
end

--[[
* Returns the name of the current opened and focused menu.
*
* @return {string|nil} The name of the menu if open, nil otherwise.
--]]
local function get_menu_name()
    local ptr = AshitaCore:GetPointerManager():Get('menu');
    if (ptr == 0) then return nil; end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    ptr = ashita.memory.read_uint32(ptr);
    if (ptr == 0) then return nil; end
    ptr = ashita.memory.read_uint32(ptr + 0x04);
    if (ptr == 0) then return nil; end
    return ashita.memory.read_string(ptr + 0x46, 16);
end

--[[
* Prints the addon help information.
*
* @param {boolean} is_err - Flag if this function was invoked due to an error.
--]]
local function print_help(is_err)
    -- Print the help header..
    if (is_err) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/autologin help',    'Displays the addons help information.' },
        { '/autologin <slot>',  'Enables the auto login feature for the given character slot.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Automates the login process.
--]]
local function do_login()
    local function step()
        local menu_names = T{
            'menu    ptc8lice',
            'menu    loby2win',
            'menu    dbnamese',
            'menu    ptc6yesn',
        };

        local name = get_menu_name();
        if (name == nil) then
            return;
        end
        name = name:trim();

        if (not menu_names:contains(name)) then
            return;
        end

        -- Handle the license agreement window..
        if (name:eq('menu    ptc8lice', true)) then
            g_pIwLicenceMenu = get_menu_obj(autologin.ptrs.license, 'IwLicenceMenu');
            if (g_pIwLicenceMenu ~= nil) then
                g_pIwLicenceMenu.m_select   = 0;
                g_pIwLicenceMenu.m_IsEnd    = 1;
            end
        end

        -- Handle the main menu..
        if (name:eq('menu    loby2win', true)) then
            g_pIwLobbyMenu = get_menu_obj(autologin.ptrs.lobby, 'IwLobbyMenu');
            if (g_pIwLobbyMenu ~= nil) then
                g_pIwLobbyMenu.m_select = 0;
                g_pIwLobbyMenu.m_IsEnd  = 1;
            end
        end

        -- Handle the character selection list..
        if (name:eq('menu    dbnamese', true)) then
            g_pIwSelectMenu = get_menu_obj(autologin.ptrs.select, 'IwSelectMenu');
            if (g_pIwSelectMenu ~= nil) then
                local ptr = ashita.memory.read_uint32(autologin.ptrs.selectidx);
                if (ptr) then
                    ashita.memory.write_uint32(ptr, autologin.slot);
                end
                g_pIwSelectMenu.m_select    = autologin.slot;
                g_pIwSelectMenu.m_oldselect = autologin.slot;
                g_pIwSelectMenu.m_IsEnd     = 1;
            end
        end

        -- Handle the character selection confirmation window..
        if (name:eq('menu    ptc6yesn', true)) then
            g_pIwYesNoMenu = get_menu_obj(autologin.ptrs.yesno, 'IwYesNoMenu');
            if (g_pIwYesNoMenu ~= nil) then
                g_pIwYesNoMenu.m_select = 0;
                g_pIwYesNoMenu.m_IsEnd  = 1;

                autologin.enabled = false;
            end
        end
    end

    while (autologin.enabled) do
        coroutine.yield();
        step();
    end

    autologin.enabled = false;
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function (e)
    autologin.ptrs.license  = ashita.memory.find('FFXiMain.dll', 0, '895E1C895E14896E1889??????????EB??89??????????68', 0x0B, 0);
    autologin.ptrs.lobby    = ashita.memory.find('FFXiMain.dll', 0, '89412C8B15????????897C2410894230A1', 0x5, 0);
    autologin.ptrs.select   = ashita.memory.find('FFXiMain.dll', 0, '89412C8B15????????897C2410894230A1', 0x11, 0);
    autologin.ptrs.selectidx= ashita.memory.find('FFXiMain.dll', 0, 'A1????????8B5108406689424C8B4908668B414C50E8', 0x01, 0);
    autologin.ptrs.yesno    = ashita.memory.find('FFXiMain.dll', 0, '895E1C895E14896E1889??????????EB??89??????????68', 0x47, 0);

    if (not autologin.ptrs:all(function (v) return v ~= nil; end)) then
        error(chat.header(addon.name):append(chat.error('Error: Failed to locate required menu object pointer(s).')));
        return;
    end

    if (not e) then return; end

    local args = e:args();
    if (#args < 4 or not args[4]:isdigit()) then
        return;
    end

    autologin.slot = args[4]:num_or(0);
    if (autologin.slot > 16) then
        autologin.slot = 0;
    end

    autologin.enabled = true;
    do_login();
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    autologin.enabled = false;
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/autologin') then
        return;
    end

    e.blocked = true;

    -- Handle: /autologin help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /autologin <slot> - Enables the auto login feature for the given character slot.
    if (#args == 2 and args[2]:isdigit()) then
        autologin.enabled = false;
        coroutine.sleepf(2);

        autologin.slot = args[2]:num_or(0);
        if (autologin.slot > 16) then
            autologin.slot = 0;
        end

        print(chat.header(addon.name):append(chat.message('Automatically logging into character in slot: ')):append(chat.success(autologin.slot:str())));

        autologin.enabled = true;
        do_login();
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);
