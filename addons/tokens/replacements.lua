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

-- String Lookups (Faster than using the ResourceManager.)
local jobnames = T{ 'None', 'Warrior', 'Monk', 'White Mage', 'Black Mage', 'Red Mage', 'Thief', 'Paladin', 'Dark Knight', 'Beastmaster', 'Bard', 'Ranger', 'Samurai', 'Ninja', 'Dragoon', 'Summoner', 'Blue Mage', 'Corsair', 'Puppetmaster', 'Dancer', 'Scholar', 'Geomancer', 'Rune Fencer', }
local jobabbrs = T{ '---', 'WAR', 'MNK', 'WHM', 'BLM', 'RDM', 'THF', 'PLD', 'DRK', 'BST', 'BRD', 'RNG', 'SAM', 'NIN', 'DRG', 'SMN', 'BLU', 'COR', 'PUP', 'DNC', 'SCH', 'GEO', 'RUN', 'MON', };

return {
    --[[
    *
    * Local Player Replacements
    *
    --]]

    -- Name
    pname = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    end,

    -- Server Id
    pid = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0);
    end,

    -- Target Index
    pindex = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0);
    end,

    -- X Position
    px = function ()
        local p = GetPlayerEntity();
        if (p ~= nil) then
            return p.Movement.LocalPosition.X;
        end
        return 0;
    end,

    -- Y Position
    py = function ()
        local p = GetPlayerEntity();
        if (p ~= nil) then
            return p.Movement.LocalPosition.Y;
        end
        return 0;
    end,

    -- Z Position
    pz = function ()
        local p = GetPlayerEntity();
        if (p ~= nil) then
            return p.Movement.LocalPosition.Z;
        end
        return 0;
    end,

    -- Heading Direction (Yaw)
    ph = function ()
        local p = GetPlayerEntity();
        if (p ~= nil) then
            return p.Movement.LocalPosition.Yaw;
        end
        return 0;
    end,

    -- Movement Speed
    pspeed = function ()
        local p = GetPlayerEntity();
        if (p ~= nil) then
            return p.MovementSpeed;
        end
        return 0;
    end,

    -- Health
    php = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberHP(0);
    end,

    -- Mana
    pmp = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberMP(0);
    end,

    -- TP
    ptp = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberTP(0);
    end,

    -- Health Percent
    phpp = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberHPPercent(0);
    end,

    -- Mana Percent
    pmpp = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberMPPercent(0);
    end,

    -- Main Job Name
    pmjob = function ()
        local id = AshitaCore:GetMemoryManager():GetParty():GetMemberMainJob(0);
        return jobnames:haskey(id + 1) and jobnames[id + 1] or 'None';
    end,

    -- Main Job Name Abbreviated
    pmjobabbr = function ()
        local id = AshitaCore:GetMemoryManager():GetParty():GetMemberMainJob(0);
        return jobabbrs:haskey(id + 1) and jobabbrs[id + 1] or '---';
    end,

    -- Main Job Id
    pmjobid = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberMainJob(0);
    end,

    -- Main Job Level
    pmjoblvl = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberMainJobLevel(0);
    end,

    -- Sub Job Name
    psjob = function ()
        local id = AshitaCore:GetMemoryManager():GetParty():GetMemberSubJob(0);
        return jobnames:haskey(id + 1) and jobnames[id + 1] or 'None';
    end,

    -- Sub Job Name Abbreviated
    psjobabbr = function ()
        local id = AshitaCore:GetMemoryManager():GetParty():GetMemberSubJob(0);
        return jobabbrs:haskey(id + 1) and jobabbrs[id + 1] or '---';
    end,

    -- Sub Job Id
    psjobid = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberSubJob(0);
    end,

    -- Sub Job Level
    psjoblvl = function ()
        return AshitaCore:GetMemoryManager():GetParty():GetMemberSubJobLevel(0);
    end,
};