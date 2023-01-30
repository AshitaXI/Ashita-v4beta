--[[
* Addons - Copyright (c) 2021 Ashita Development Team
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

addon.name      = 'config';
addon.author    = 'atom0s';
addon.version   = '1.1';
addon.desc      = 'Enables slash commands to force-set game settings directly.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- FFI Prototypes
ffi.cdef[[
    typedef int32_t (__cdecl* get_config_value_t)(int32_t);
    typedef int32_t (__cdecl* set_config_value_t)(int32_t, int32_t);
    typedef int32_t (__fastcall* get_config_entry_t)(int32_t, int32_t, int32_t);

    // Configuration Value Entry Definition
    typedef struct FsConfigSubject {
        uintptr_t   VTable;         /* The configuration entry VTable pointer. */
        uint32_t    m_configKey;    /* The configuration entry key. */
        int32_t     m_configValue;  /* The configuration entry value. */
        uint32_t    m_configType;   /* The configuration entry type. */
        char        m_polName[8];   /* The configuration entry PlayOnline name. */
        int32_t     m_minVal;       /* The configuration entry minimum value.  */
        int32_t     m_maxVal;       /* The configuration entry maximum value. (-1 if not used.) */
        int32_t     m_defVal;       /* The configuration entry default value. (Used when not able to clamp a value within min/max.) */
        uintptr_t   m_callbackList; /* The configuration entry callback linked list object. */
        int32_t     m_configProc;   /* The configuration entry flags. (0x01 means the value will force-update even if the value already matches.) */
    } FsConfigSubject;
]];

-- Config Variables
local config = T{
    get     = nil,
    set     = nil,
    this    = nil,
    info    = nil,
};

--[[
* Prints the addon help information.
*
* @param {boolean} isError - Flag if this function was invoked due to an error.
--]]
local function print_help(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/config help', 'Displays the addons help information.' },
        { '/config get <id>', 'Prints the configurations current value.' },
        { '/config set <id> <value>', 'Sets the configuration value.' },
        { '/config info <id>', 'Prints the configuration entries information.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Obtain the needed function pointers..
    local ptr = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????85C974??8B44240450E8????????C383C8FFC3', 0, 0);
    config.get = ffi.cast('get_config_value_t', ptr);
    config.set = ffi.cast('set_config_value_t', ashita.memory.find('FFXiMain.dll', 0, '85C974??8B4424088B5424045052E8????????C383C8FFC3', -6, 0));
    config.info = ffi.cast('get_config_entry_t', ashita.memory.find('FFXiMain.dll', 0, '8B490485C974108B4424048D14808D04508D0481C2040033C0C20400', 0, 0));

    -- Obtain the 'this' pointer for the configuration data..
    config.this = ffi.cast('uint32_t**', ptr + 2)[0][0];

    -- Ensure all pointers are valid..
    assert(config.get ~= nil, chat.header('config'):append(chat.error('Error: Failed to locate required \'get\' function pointer.')));
    assert(config.set ~= nil, chat.header('config'):append(chat.error('Error: Failed to locate required \'set\' function pointer.')));
    assert(config.info ~= nil, chat.header('config'):append(chat.error('Error: Failed to locate required \'info\' function pointer.')));
    assert(config.this ~= 0, chat.header('config'):append(chat.error('Error: Failed to locate required \'this\' object pointer.')));
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/config')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /config help - Shows the addon help.
    if (#args == 2 and args[2]:any('help')) then
        print_help(false);
        return;
    end

    -- Handle: /config get <id> - Prints the configurations current value.
    if (#args >= 3 and args[2]:any('get')) then
        local id = args[3]:num_or(0);
        if (id == 0 or id > 207) then
            print(chat.header('config')
                :append(chat.critical('Error! '))
                :append(chat.error('Invalid configuration id: '))
                :append(chat.success(id)));

            return;
        end

        print(chat.header('config'):append(chat.message('Value for configuration id \''))
                                   :append(chat.success(id))
                                   :append(chat.message('\' is: '))
                                   :append(chat.success(tostring(config.get(id)))));
        return;
    end

    -- Handle: /config set <id> <value> - Sets the configuration value.
    if (#args >= 4 and args[2]:any('set')) then
        local id = args[3]:num_or(0);
        if (id == 0 or id > 207) then
            print(chat.header('config')
                :append(chat.critical('Error! '))
                :append(chat.error('Invalid configuration id: '))
                :append(chat.success(id)));
            return;
        end

        local val = args[4]:num_or(nil);
        if (val == nil) then
            print(chat.header('config')
                :append(chat.critical('Error! '))
                :append(chat.error('Invalid configuration value.')));
            return;
        end

        local cur = config.get(id);
        local ret = config.set(id, val);
        if (ret == -1 and (cur ~= val)) then
            print(chat.header('config')
                :append(chat.error('Error: Failed to set configuration value.')));
        end

        print(chat.header('config'):append(chat.message('Set configuration id \''))
                                   :append(chat.success(id))
                                   :append(chat.message('\' to: '))
                                   :append(chat.success(tostring(val))));
        return;
    end

    -- Handle: /config info <id> - Gets the configuration entry and prints information about it.
    if (#args >= 3 and args[2]:any('info')) then
        local id = args[3]:num_or(0);
        if (id == 0 or id > 207) then
            print(chat.header('config')
                :append(chat.critical('Error! '))
                :append(chat.error('Invalid configuration id: '))
                :append(chat.success(id)));
            return;
        end

        local cfg = ffi.cast('FsConfigSubject*', config.info(config.this, 0, id));
        if (cfg == nil) then
            print(chat.header('config')
                :append(chat.critical('Error! '))
                :append(chat.error('Failed to find configuration entry for configuration id: '))
                :append(chat.success(id)));
            return;
        end

        print(chat.header('config')
            :append(chat.message('Configuration Info: '))
            :append(chat.success(cfg.m_configKey))
            :append(chat.message(' -- Value: '))
            :append(chat.success(cfg.m_configValue))
            :append(chat.message(' -- Type: '))
            :append(chat.success(cfg.m_configType))
            :append(chat.message(', Min: '))
            :append(chat.success(cfg.m_minVal))
            :append(chat.message(', Max: '))
            :append(chat.success(cfg.m_maxVal))
            :append(chat.message(', Default: '))
            :append(chat.success(cfg.m_defVal))
            :append(chat.message(', Flags: '))
            :append(chat.success(cfg.m_configProc)));
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);