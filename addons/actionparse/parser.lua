--[[
* Addons - Copyright (c) 2023 Ashita Development Team
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

require('common');
local breader = require('bitreader');

-- Action parser table..
local parser = T{};

--[[
* Locates and returns the name of the actor of the given server id.
*
* @param {number} id - The server id of the actor to locate.
* @return {string} The actor name.
--]]
local function get_actor_name(id)
    local ret = 'Unknown';
    for x = 0, 2302 do
        local e = GetEntity(x);
        if (e and e.ServerId == id) then
            return e.Name;
        end
    end
    return ret;
end

--[[
* Parses the given action packet.
*
* @param {string} packet - The packet string to parse.
* @return {table} The parsed action packet.
--]]
parser.parse = function (packet)
    local reader = breader:new();
    reader:set_data(packet);
    reader:set_pos(5);

    local action        = T{};
    action.m_uID        = reader:read(32);
    action.caster_name  = get_actor_name(action.m_uID);
    action.trg_sum      = reader:read(6);
    action.res_sum      = reader:read(4);
    action.cmd_no       = reader:read(4);
    action.cmd_arg      = reader:read(32);
    action.info         = reader:read(32);
    action.target       = T{};

    for _ = 0, action.trg_sum - 1 do
        local target        = T{};
        target.m_uID        = reader:read(32);
        target.target_name  = get_actor_name(target.m_uID);
        target.result_sum   = reader:read(4);
        target.result       = T{};

        for _ = 0, target.result_sum - 1 do
            local result    = T{};
            result.miss     = reader:read(3);
            result.kind     = reader:read(2);
            result.sub_kind = reader:read(12);
            result.info     = reader:read(5);
            result.scale    = reader:read(5);
            result.value    = reader:read(17);
            result.message  = reader:read(10);
            result.bit      = reader:read(31);

            if (reader:read(1) > 0) then
                result.has_proc     = true;
                result.proc_kind    = reader:read(6);
                result.proc_info    = reader:read(4);
                result.proc_value   = reader:read(17);
                result.proc_message = reader:read(10);
            else
                result.has_proc     = false;
                result.proc_kind    = 0;
                result.proc_info    = 0;
                result.proc_value   = 0;
                result.proc_message = 0;
            end

            if (reader:read(1) > 0) then
                result.has_react    = true;
                result.react_kind   = reader:read(6);
                result.react_info   = reader:read(4);
                result.react_value  = reader:read(14);
                result.react_message= reader:read(10);
            else
                result.has_react    = false;
                result.react_kind   = 0;
                result.react_info   = 0;
                result.react_value  = 0;
                result.react_message= 0;
            end

            table.insert(target.result, result);
        end

        table.insert(action.target, target);
    end

    return action;
end

--[[
* Returns the name of the given action command number.
*
* @param {number} cmd_no - The action command number.
* @return {string} The command name.
*--]]
parser.get_action_name = function (cmd_no)
    return switch(cmd_no, T{
        [ 0] = function () return 'None';               end, -- None.
        [ 1] = function () return 'Attack';             end, -- Basic Attack
        [ 2] = function () return 'R.Attack (F)';       end, -- Finish: Ranged Attack
        [ 3] = function () return 'WeaponSkill (F)';    end, -- Finish: Player Weapon Skills (Some job abilities use this such as Mug.)
        [ 4] = function () return 'Magic (F)';          end, -- Finish: Player and Monster Magic Casts
        [ 5] = function () return 'Item (F)';           end, -- Finish: Item Use
        [ 6] = function () return 'JobAbility (F)';     end, -- Finish: Player Job Abilities, DNC Reverse Flourish
        [ 7] = function () return 'Mon/WepSkill (S)';   end, -- Start: Monster Skill, Weapon Skill
        [ 8] = function () return 'Magic (S)';          end, -- Start: Player and Monster Magic Casts
        [ 9] = function () return 'Item (S)';           end, -- Start: Item Use
        [10] = function () return 'JobAbility (S)';     end, -- Start: Job Ability
        [11] = function () return 'MonSkill (F)';       end, -- Finish: Monster Skill
        [12] = function () return 'R.Attack (S)';       end, -- Start: Ranged Attack
        [14] = function () return 'Dancer';             end, -- Dancer Flourish, Samba, Step, Waltz
        [15] = function () return 'RuneFencer';         end, -- Rune Fencer Effusion, Ward
        [switch.default] = function()
            return ('%d:Unknown'):fmt(cmd_no);
        end,
    });
end

--[[
* Returns the name of the given miss id.
*
* @param {number} id - The miss id.
* @return {string} The miss name.
*--]]
parser.get_miss_name = function (id)
    return switch(id, T{
        [0] = function () return 'hit';     end, -- Hit
        [1] = function () return 'miss';    end, -- Miss
        [2] = function () return 'guard';   end, -- Guard
        [3] = function () return 'parry';   end, -- Parry
        [4] = function () return 'block';   end, -- Block
        [9] = function () return 'evade';   end, -- Evade
        [switch.default] = function()
            return ('%d:unknown'):fmt(id);
        end,
    });
end

-- Return the action parser table..
return parser;