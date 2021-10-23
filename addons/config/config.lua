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
addon.version   = '1.0';
addon.desc      = 'Enables slash commands to force-set game settings directly.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

-- FFI Prototypes
ffi.cdef[[
    typedef int (__cdecl* get_config_value_t)(int);
    typedef int (__cdecl* set_config_value_t)(int, int);
    typedef int (__fastcall* get_config_entry_t)(int, int, int);

    // Configuration Value Entry Definition
    typedef struct configentry_t {
        uint32_t VTable;        /* The configuration entry VTable pointer. */
        uint32_t Id;            /* The configuration entry id. */
        int32_t Value;          /* The configuration entry value. */
        uint32_t Type;          /* The configuration entry type. */
        char Unknown0000[8];    /* Unknown (String based flag used for specific configurations like POL related things.) */
        int32_t MinValue;       /* The configuration entry minimum value.  */
        int32_t MaxValue;       /* The configuration entry maximum value. (-1 if not used.) */
        int32_t DefaultValue;   /* The configuration entry default value. (Used when not able to clamp a value within min/max.) */
        uint32_t VTableCaller;  /* The configuration entry callback helper VTable pointer. Holds a callback pointer and parameter (if one is set). */
        uint8_t Flags;          /* The configuration entry flags. (0x01 means the value will force-update even if the value already matches.) */
        uint8_t Unknown0001[3]; /* Padding. (For alignment.) */
    } configentry_t;
]];

-- Config Variables
local config = T{
    get = nil,
    set = nil,
    this = nil,
    info = nil,
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
    -- Find the function to get configuration values..
    local ptr = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????85C974??8B44240450E8????????C383C8FFC3', 0, 0);
    config.get = ffi.cast('get_config_value_t', ptr);

    -- Find the function to set configuration values..
    config.set = ffi.cast('set_config_value_t', ashita.memory.find('FFXiMain.dll', 0, '8B0D????????85C974??8B4424088B5424045052E8????????C383C8FFC3', 0, 0));

    -- Find the function to get configuration value entries..
    config.info = ffi.cast('get_config_entry_t', ashita.memory.find('FFXiMain.dll', 0, '8B490485C974108B4424048D14808D04508D0481C2040033C0C20400', 0, 0));

    -- Obtain the 'this' pointer for the configuration data..
    config.this = ffi.cast('uint32_t**', ptr + 2)[0][0];
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
            print(chat.header('config'):append(chat.error('Error: Invalid configuration id.')));
            return;
        end

        local val = config.get(id);
        print(chat.header('config'):append(chat.message('Value for configuration id \''))
                                   :append(chat.success(id))
                                   :append(chat.message('\' is: '))
                                   :append(chat.success(tostring(val))));
        return;
    end

    -- Handle: /config set <id> <value> - Sets the configuration value.
    if (#args >= 4 and args[2]:any('set')) then
        local id = args[3]:num_or(0);
        if (id == 0 or id > 207) then
            print(chat.header('config'):append(chat.error('Error: Invalid configuration id.')));
            return;
        end

        local val = args[4]:num_or(nil);
        if (val == nil) then
            print(chat.header('config'):append(chat.error('Error: Invalid configuration value.')));
            return;
        end

        --[[
        The client silently fails attempting to set a configuration value if the value matches what is being set.
        Because of this, we will self-test this case and ignore trying to set the value if it already matches.
        --]]
        if (config.get(id) == val) then
            return;
        end

        -- Set the configuration value..
        local ret = config.set(id, val);
        if (ret == -1) then
            print(chat.header('config'):append(chat.error('Error: Failed to set configuration value.')));
        end

        --[[
        Because of how the configuration setter works; we are not going to print a success message as the configuration
        value table holds a min/max/default value range. If a user passes an invalid value, the game will adjust it as needed
        such as clamping between the min/max or just using the default. Rather than tell the user their input was successful when
        it may not have been, we will just not print anything.
        --]]

        return;
    end

    -- Handle: /config info <id> - Gets the configuration entry and prints information about it.
    if (#args >= 3 and args[2]:any('info')) then
        local id = args[3]:num_or(0);
        if (id == 0 or id > 207) then
            print(chat.header('config'):append(chat.error('Error: Invalid configuration id.')));
            return;
        end

        local cfg = ffi.cast('configentry_t*', config.info(config.this, 0, id));
        if (cfg == nil) then
            print(chat.header('config'):append(chat.error('Error: Failed to find configuration entry for the given id.')));
        end

        print(chat.header('config'):append(chat.message('Configuration information for configuration id: ')):append(chat.success(id)));
        print(chat.header('config')
            :append(chat.message('Value: '))
            :append(chat.success(cfg.Value))
            :append(chat.message(' [Type: '))
            :append(chat.success(cfg.Type))
            :append(chat.message(', Min: '))
            :append(chat.success(cfg.MinValue))
            :append(chat.message(', Max: '))
            :append(chat.success(cfg.MaxValue))
            :append(chat.message(', Default: '))
            :append(chat.success(cfg.DefaultValue))
            :append(chat.message(', Flags: '))
            :append(chat.success(cfg.Flags))
            :append(chat.message(']')));

        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);