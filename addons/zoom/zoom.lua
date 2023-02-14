--[[
* Ashita - Copyright (c) 2014 - 2017 atom0s [atom0s@live.com]
*
* This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
* Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*
* By using Ashita, you agree to the above license and its terms.
*
*      Attribution - You must give appropriate credit, provide a link to the license and indicate if changes were
*                    made. You must do so in any reasonable manner, but not in any way that suggests the licensor
*                    endorses you or your use.
*
*   Non-Commercial - You may not use the material (Ashita) for commercial purposes.
*
*   No-Derivatives - If you remix, transform, or build upon the material (Ashita), you may not distribute the
*                    modified material. You are, however, allowed to submit the modified works back to the original
*                    Ashita project in attempt to have it added to the original project.
*
* You may not apply legal terms or technological measures that legally restrict others
* from doing anything the license permits.
*
* No warranties are given.
]]--

_addon.author   = 'atom0s';
_addon.name     = 'zoom';
_addon.version  = '1.0.0';

require 'common'

----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local zoom = { };
zoom.pointer1 = 0;
zoom.pointer2 = 0;
zoom.backup1 = 0;
zoom.backup2 = 0;

----------------------------------------------------------------------------------------------------
-- func: print_help
-- desc: Displays a help block for proper command usage.
----------------------------------------------------------------------------------------------------
local function print_help(cmd, help)
    -- Print the invalid format header..
    print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Invalid format for command:\30\02 ' .. cmd .. '\30\01'); 

    -- Loop and print the help commands..
    for k, v in pairs(help) do
        print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Syntax:\30\02 ' .. v[1] .. '\30\71 ' .. v[2]);
    end
end

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
    -- Locate the needed patterns..
    local pointer1 = ashita.memory.findpattern('FFXiMain.dll', 0, 'D81D????????DFE0F6C4057A??C7442410????????E8????????8B4C', 0, 0);
    local pointer2 = ashita.memory.findpattern('FFXiMain.dll', 0, '25????????75??C7442410????????E8????????8B', 0, 0);

    -- Ensure the pointers are valid..
    if (pointer1 == 0 or pointer2 == 0) then
        print('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\68Failed to find the required pointers.\30\01');
    end
    
    -- Store the pointers..
    zoom.pointer1 = pointer1;
    zoom.pointer2 = pointer2;
    
    -- Read the original values to restore later..
    zoom.backup1 = ashita.memory.read_float(zoom.pointer1 + 0x11);
    zoom.backup2 = ashita.memory.read_float(zoom.pointer2 + 0x0B);
    
    -- Display the default values..
    print(string.format('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\07Default zoom out max:\30\02 %f\30\01', zoom.backup1));
    print(string.format('\31\200[\31\05' .. _addon.name .. '\31\200]\30\01 ' .. '\30\07Default zoom in max:\30\02 %f\30\01', zoom.backup2));
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unload.
----------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
    -- Restore the default values..
    if (zoom.pointer1 ~= 0) then
        ashita.memory.write_float(zoom.pointer1 + 0x11, zoom.backup1);
    end
    if (zoom.pointer2 ~= 0) then
        ashita.memory.write_float(zoom.pointer2 + 0x0B, zoom.backup2);
    end
end);

----------------------------------------------------------------------------------------------------
-- func: command
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.register_event('command', function(command, ntype)
    -- Get the arguments of the command..
    local args = command:args();
    if (args[1] ~= '/zoom') then
        return false;
    end
    
    -- Set the zoom out distance..
    if (#args >= 3 and args[2] == 'setout') then
        ashita.memory.unprotect(zoom.pointer1 + 0x11, 4);
        ashita.memory.write_float(zoom.pointer1 + 0x11, tonumber(args[3]));
        return true;
    end
    
    -- Set the zoom in distance..
    if (#args >= 3 and args[2] == 'setin') then
        ashita.memory.unprotect(zoom.pointer2 + 0x0B, 4);
        ashita.memory.write_float(zoom.pointer2 + 0x0B, tonumber(args[3]));
        return true;
    end
    
    -- Prints the addon help..
    print_help('/zoom', {
        { '/zoom setout [num]', '- Sets the distance the camera can zoom out to (using the mouse wheel). (Default: 242)' },
        { '/zoom setin [num]',  '- Sets the distance the camera can zoom into (using the mouse wheel). (Default: 900)' }
    });
    return true;
end);