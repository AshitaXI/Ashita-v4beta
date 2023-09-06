--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of RollTracker nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.
--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL Daniel_H BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
addon.author = 'Daniel_H, sippius(v4), Fel';
addon.name = 'rolltracker';
addon.version = '1.0.2 (v3), 0.3 (v4)';
addon.desc = 'Corsair Rolltracker for Ashita v4' --This version includes support for Phantom Roll+8

last_roll = ""

-- SET THIS TO TRUE IF YOU WANT ALL ROLLS TO SHOW LUCKY AND UNLUCKY NUMBER NEAR ROLL NAME
-- Example: John Doe → Chaos Roll [4 / 6] ⑤ (+10.9% Attack)
EnableLuckyUnluckyDisplay = true

require 'common'

local corsairRollIDs = {
    [98] = 'Fighter\'s Roll',
    [99] = 'Monk\'s Roll',
    [100] = 'Healer\'s Roll',
    [101] = 'Wizard\'s Roll',
    [102] = 'Warlock\'s Roll',
    [103] = 'Rogue\'s Roll',
    [104] = 'Gallant\'s Roll',
    [105] = 'Chaos Roll',
    [106] = 'Beast Roll',
    [107] = 'Choral Roll',
    [108] = 'Hunter\'s Roll',
    [109] = 'Samurai Roll',
    [110] = 'Ninja Roll',
    [111] = 'Drachen Roll',
    [112] = 'Evoker\'s Roll',
    [113] = 'Magus\'s Roll',
    [114] = 'Corsair\'s Roll',
    [115] = 'Puppet Roll',
    [116] = 'Dancer\'s Roll',
    [117] = 'Scholar\'s Roll',
    [118] = 'Bolter\'s Roll',
    [119] = 'Caster\'s Roll',
    [120] = 'Courser\'s Roll',
    [121] = 'Blitzer\'s Roll',
    [122] = 'Tactician\'s Roll',
    [302] = 'Allies\' Roll',
    [303] = 'Miser\'s Roll',
    [304] = 'Companion\'s Roll',
    [305] = 'Avenger\'s Roll',
    [390] = 'Naturalist\'s Roll',
    [391] = 'Runeist\'s Roll',
}

local corsairRoll_Data = {
    ['Corsair\'s Roll'] = {
        ['lucky'] = 5,
        ['unlucky'] = 9,
        ['rolls'] = {10, 11, 11, 12, 20, 13, 15, 16, 8, 17, 24},
        ['effect'] = 2,
        ['bust'] = 6,
        ['desc'] = 'Experience / Capacity Points'
    },
    ['Ninja Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {4, 6, 8, 25, 10, 12, 14, 2, 17, 20, 30},
        ['effect'] = 2,
        ['bust'] = 10,
        ['desc'] = 'Evasion'
    },
    ['Hunter\'s Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {10, 13, 15, 40, 18, 20, 25, 5, 27, 30, 50},
        ['effect'] = 5,
        ['bust'] = 15,
        ['desc'] = 'Accuracy'
    },
    ['Chaos Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {6.3, 7.8, 9.4, 25, 10.9, 12.5, 15.6, 3.1, 17.2, 18.8, 31.2},
        ['effect'] = 3,
        ['bust'] = 10,
        ['desc'] = 'Attack'
    },
    ['Magus\'s Roll'] = {
        ['lucky'] = 2,
        ['unlucky'] = 6,
        ['rolls'] = {5, 20, 6, 8, 9, 3, 10, 13, 14, 15, 25},
        ['effect'] = 2,
        ['bust'] = 8,
        ['desc'] = 'Magic Defense Bonus'
    },
    ['Healer\'s Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 7,
        ['rolls'] = {3, 4, 12, 5, 6, 7, 1, 8, 9, 10, 16},
        ['effect'] = 3,
        ['bust'] = 4,
        ['desc'] = 'Cure Potency'
    },
    ['Drachen Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {10, 13, 15, 40, 18, 20, 25, 5, 28, 30, 50},
        ['effect'] = 5,
        ['bust'] = 15,
        ['desc'] = 'Pet: Accuracy / Ranged Accuracy'
    },
    ['Choral Roll'] = {
        ['lucky'] = 2,
        ['unlucky'] = 6,
        ['rolls'] = {8, 42, 11, 15, 19, 4, 23, 27, 31, 35, 50},
        ['effect'] = 4,
        ['bust'] = 25,
        ['desc'] = 'Spell Interruption Rate down'
    },
    ['Monk\'s Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 7,
        ['rolls'] = {8, 10, 32, 12, 14, 16, 4, 20, 22, 24, 40},
        ['effect'] = 5,
        ['bust'] = 10,
        ['desc'] = 'Subtle Blow'
    },
    ['Beast Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {6, 8, 9, 25, 11, 13, 16, 3, 17, 19, 31},
        ['effect'] = 3,
        ['bust'] = 10,
        ['desc'] = 'Pet: Attack / Ranged Attack'
    },
    ['Samurai Roll'] = {
        ['lucky'] = 2,
        ['unlucky'] = 6,
        ['rolls'] = {8, 32, 10, 12, 14, 4, 16, 20, 22, 24, 40},
        ['effect'] = 4,
        ['bust'] = 10,
        ['desc'] = 'Store TP'
    },
    ['Evoker\'s Roll'] = {
        ['lucky'] = 5,
        ['unlucky'] = 9,
        ['rolls'] = {1, 1, 1, 1, 3, 2, 2, 2, 1, 3, 4},
        ['effect'] = 1,
        ['bust'] = 'Unknown',
        ['desc'] = 'Refresh'
    },
    ['Rogue\'s Roll'] = {
        ['lucky'] = 5,
        ['unlucky'] = 9,
        ['rolls'] = {1, 2, 3, 4, 10, 5, 6, 7, 1, 8, 14},
        ['effect'] = 1,
        ['bust'] = 5,
        ['desc'] = 'Critical Hite Rate'
    },
    ['Warlock\'s Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {2, 3, 4, 12, 5, 6, 7, 1, 8, 9, 15},
        ['effect'] = 1,
        ['bust'] = 5,
        ['desc'] = 'Magic Accuracy'
    },
    ['Fighter\'s Roll'] = {
        ['lucky'] = 5,
        ['unlucky'] = 9,
        ['rolls'] = {1, 2, 3, 4, 10, 5, 6, 6, 1, 7, 15},
        ['effect'] = 1,
        ['bust'] = 'Unknown',
        ['desc'] = 'Double Attack'
    },
    ['Puppet Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 7,
        ['rolls'] = {5, 8, 35, 11, 14, 18, 2, 22, 26, 30, 40},
        ['effect'] = 3,
        ['bust'] = 12,
        ['desc'] = 'Pet: Magic Accuracy / Magic Attack Bonus'
    },
    ['Gallant\'s Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 7,
        ['rolls'] = {4.69, 5.86, 19.53, 7.03, 8.59, 10.16, 3.13, 11.72, 13.67, 15.63, 23.44},
        ['effect'] = 2.34,
        ['bust'] = '-11.72',
        ['desc'] = 'Defense'
    },
    ['Wizard\'s Roll'] = {
        ['lucky'] = 5,
        ['unlucky'] = 9,
        ['rolls'] = {4, 6, 8, 10, 25, 12, 14, 17, 2, 20, 30},
        ['effect'] = 2,
        ['bust'] = 10,
        ['desc'] = 'Magic Attack Bonus'
    },
    ['Dancer\'s Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 7,
        ['rolls'] = {3, 4, 12, 5, 6, 7, 1, 8, 9, 10, 16},
        ['effect'] = 2,
        ['bust'] = 4,
        ['desc'] = 'Regen'
    },
    ['Scholar\'s Roll'] = {
        ['lucky'] = 2,
        ['unlucky'] = 6,
        ['rolls'] = {2, 10, 3, 4, 4, 1, 5, 6, 7, 7, 12},
        ['effect'] = 'Unknown',
        ['bust'] = 3,
        ['desc'] = 'Conserve MP'
    },
    ['Naturalist\'s Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 7,
        ['rolls'] = {6, 7, 15, 8, 9, 10, 5, 11, 12, 13, 20},
        ['effect'] = 1,
        ['bust'] = 5,
        ['desc'] = 'Enhancing Magic Duration'
    },
    ['Runeist\'s Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {4, 6, 8, 25, 10, 12, 14, 2, 17, 20, 30},
        ['effect'] = 2,
        ['bust'] = 10,
        ['desc'] = 'Magic Evasion'
    },
    ['Bolter\'s Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 9,
        ['rolls'] = {6, 6, 16, 8, 8, 10, 10, 12, 4, 14, 20},
        ['effect'] = 4,
        ['bust'] = 0,
        ['desc'] = 'Movement Speed'
    },
    ['Caster\'s Roll'] = {
        ['lucky'] = 2,
        ['unlucky'] = 7,
        ['rolls'] = {6, 15, 7, 8, 9, 10, 5, 11, 12, 13, 20},
        ['effect'] = 3,
        ['bust'] = 10,
        ['desc'] = 'Fast Cast'
    },
    ['Courser\'s Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 9,
        ['rolls'] = {'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown'},
        ['effect'] = 'Unknown',
        ['bust'] = 'Unknown',
        ['desc'] = 'Snapshot'
    },
    ['Blitzer\'s Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 9,
        ['rolls'] = {2, 3, 4, 11, 5, 6, 7, 8, 1, 10, 12},
        ['effect'] = 1,
        ['bust'] = 'Unknown',
        ['desc'] = 'Haste'
    },
    ['Tactician\'s Roll'] = {
        ['lucky'] = 5,
        ['unlucky'] = 8,
        ['rolls'] = {10, 10, 10, 10, 30, 10, 10, 0, 20, 20, 40},
        ['effect'] = 2,
        ['bust'] = 10,
        ['desc'] = 'Regain'
    },
    ['Allies\' Roll'] = {
        ['lucky'] = 3,
        ['unlucky'] = 10,
        ['rolls'] = {2, 3, 20, 5, 7, 9, 11, 13, 15, 1, 25},
        ['effect'] = 1,
        ['bust'] = 5,
        ['desc'] = 'Skillchan Damage / Accuracy'
    },
    ['Miser\'s Roll'] = {
        ['lucky'] = 5,
        ['unlucky'] = 7,
        ['rolls'] = {30, 50, 70, 90, 200, 110, 20, 130, 150, 170, 250},
        ['effect'] = 15,
        ['bust'] = 0,
        ['desc'] = 'Save TP'
    },
    ['Avenger\'s Roll'] = {
        ['lucky'] = 4,
        ['unlucky'] = 8,
        ['rolls'] = {'Unknown', 'Unknown', 'Unknown', 14, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 16},
        ['effect'] = 'Unknown',
        ['bust'] = 'Unknown',
        ['desc'] = 'Counter Rate'
    },
    ['Companion\'s Roll'] = {
        ['lucky'] = 2,
        ['unlucky'] = 10,
        ['rolls'] = {'20,4', '50,20', '20,6', '20,8', '30,10', '30,12', '30,14', '40,16', '40,18', '10,3', '60,25'},
        ['effect'] = '5,2',
        ['bust'] = '0,0',
        ['desc'] = 'Pet: Regain / Regen'
    },
}

function GetEquipped(slot)
    local inventoryManager = AshitaCore:GetMemoryManager():GetInventory();
    local equippedItem = inventoryManager:GetEquippedItem(slot);
    local index = bit.band(equippedItem.Index, 0x00FF);

    local eqEntry = {};
    if (index == 0 or index == nil) then
        eqEntry.Container = 0;
        eqEntry.Item = nil;
    else
        eqEntry.Container = bit.band(equippedItem.Index, 0xFF00) / 256;
        eqEntry.Item = inventoryManager:GetContainerItem(eqEntry.Container, index);
        if (eqEntry.Item.Id == 0) or (eqEntry.Item.Count == 0) then
            eqEntry.Item = nil;
        end
    end

    if (type(eqEntry) == 'table') and (eqEntry.Item ~= nil) then
        return eqEntry.Item.Id
    else
        return 0;
    end
end

function generate_corsair_print(Number, ID, PTMembers, effected_Members)
    if corsairRollIDs[ID] ~= nil then
        rollName = corsairRollIDs[ID]
        rollDataTable = corsairRoll_Data[corsairRollIDs[ID]]
        messagetoshow = ''
        effectTargets = "" effectTargets_I = 0;
        for _, v in pairs(PTMembers) do
            if effectTargets_I == 0 then
                effectTargets = effectTargets .. '\31\205'
            elseif effectTargets_I == 2 then
                effectTargets = effectTargets .. '\31\008'
            elseif effectTargets_I == 3 then
                effectTargets = effectTargets .. '\31\013'
            elseif effectTargets_I == 4 then
                effectTargets = effectTargets .. '\31\007'
            elseif effectTargets_I == 5 then
                effectTargets = effectTargets .. '\31\160'
            else
                effectTargets = effectTargets .. '\31\215'
            end

            if effectTargets_I == effected_Members - 1 then
                effectTargets = effectTargets .. v .. ' \31\190'
            else
                effectTargets = effectTargets .. v .. '\31\190, '
            end

            effectTargets_I = effectTargets_I + 1
        end

        circledNumber = string.empty
        if Number == 1 then
            circledNumber = string.char(0x87, 0x40)
        elseif Number == 2 then
            circledNumber = string.char(0x87, 0x41)
        elseif Number == 3 then
            circledNumber = string.char(0x87, 0x42)
        elseif Number == 4 then
            circledNumber = string.char(0x87, 0x43)
        elseif Number == 5 then
            circledNumber = string.char(0x87, 0x44)
        elseif Number == 6 then
            circledNumber = string.char(0x87, 0x45)
        elseif Number == 7 then
            circledNumber = string.char(0x87, 0x46)
        elseif Number == 8 then
            circledNumber = string.char(0x87, 0x47)
        elseif Number == 9 then
            circledNumber = string.char(0x87, 0x48)
        elseif Number == 10 then
            circledNumber = string.char(0x87, 0x49)
        elseif Number == 11 then
            circledNumber = string.char(0x87, 0x4A)
        elseif Number == 12 then
            circledNumber = string.char(0x87, 0x4B)
        end

        if EnableLuckyUnluckyDisplay == true then
            messagetoshow = '[' .. effected_Members .. '] ' .. effectTargets .. string.char(0x81, 0xC3) .. ' ' .. rollName .. ' [\31\204' .. rollDataTable['lucky'] .. ' \31\190/ \31\002' .. rollDataTable['unlucky'] .. '\31\190] ' .. circledNumber .. ' '
        else
            messagetoshow = '[' .. effected_Members .. '] ' .. effectTargets .. string.char(0x81, 0xC3) .. ' ' .. rollName .. ' ' .. circledNumber .. ' '
        end



        if Number > 11 then
            messagetoshow = messagetoshow .. '\31\039(Bust!) '
        elseif Number == rollDataTable['lucky'] or Number == 11 then
            messagetoshow = messagetoshow .. '\31\204(Lucky!) '
        elseif Number == rollDataTable['unlucky'] then
            messagetoshow = messagetoshow .. '\31\002(Unlucky!) '
        else
            messagetoshow = messagetoshow .. '\31\205'
        end
        if Number > 11 then
            messagetoshow = messagetoshow .. '(-'
            bonus = rollDataTable['bust']
        else
            messagetoshow = messagetoshow .. '(+'
            bonus = rollDataTable['rolls'][Number]
        end
        main = GetEquipped(0)
        ring1 = GetEquipped(13)
        ring2 = GetEquipped(14)
        neck = GetEquipped(9)
        if Number < 12 then
            EffectBonus = rollDataTable['effect']

            if EffectBonus ~= "Unknown" and rollName ~= "Companion's Roll" then
                if main == 21581 then -- 8
                    mathedEffect = EffectBonus * 8
                    bonus = bonus + mathedEffect
                elseif neck == 26038 then -- 7
                    mathedEffect = EffectBonus * 7
                    bonus = bonus + mathedEffect
                elseif ring1 == 28548 or ring2 == 28548 then -- 5
                    mathedEffect = EffectBonus * 5
                    bonus = bonus + mathedEffect
                elseif ring1 == 28547 or ring2 == 28547 then --3
                    mathedEffect = EffectBonus * 3
                    bonus = bonus + mathedEffect
                end
            else if rollName == "Companion's Roll" then

                    i = 0
                    for number in string.gmatch(rollDataTable['effect'], '([^,]+)') do
                        if i == 0 then
                            Effect_1 = number
                        elseif i == 1 then
                            Effect_2 = number
                        end
                        i = i + 1
                    end

                    i = 0
                    for number in string.gmatch(bonus, '([^,]+)') do
                        if i == 0 then
                            Companion_1 = number
                            if main == 21581 then -- 8
                                mathedEffect = Effect_1 * 8
                                Companion_1 = Companion_1 + mathedEffect
                            elseif neck == 26038 then -- 7
                                mathedEffect = Effect_1 * 7
                                Companion_1 = Companion_1 + mathedEffect
                            elseif ring1 == 28548 or ring2 == 28548 then -- 5
                                mathedEffect = Effect_1 * 5
                                Companion_1 = Companion_1 + mathedEffect
                            elseif ring1 == 28547 or ring2 == 28547 then --3
                                mathedEffect = Effect_1 * 3
                                Companion_1 = Companion_1 + mathedEffect
                            end
                        elseif i == 1 then
                            Companion_2 = number
                            if main == 21581 then -- 8
                                mathedEffect = Effect_2 * 8
                                Companion_2 = Companion_2 + mathedEffect
                            elseif neck == 26038 then -- 7
                                mathedEffect = Effect_2 * 7
                                Companion_2 = Companion_2 + mathedEffect
                            elseif ring1 == 28548 or ring2 == 28548 then -- 5
                                mathedEffect = Effect_2 * 5
                                Companion_2 = Companion_2 + mathedEffect
                            elseif ring1 == 28547 or ring2 == 28547 then --3
                                mathedEffect = Effect_2 * 3
                                Companion_2 = Companion_2 + mathedEffect
                            end
                        end
                        i = i + 1
                    end
            else
                bonus = "Unknown"
            end
            end
        end
        percentageRolls = {'Chaos Roll', 'Corsair\'s Roll', 'Healer\'s Roll', 'Choral Roll', 'Beast Roll', 'Rogue\'s Roll', 'Fighter\'s Roll',
            'Gallant\'s Roll', 'Scholar\'s Roll', 'Naturalist\'s Roll', 'Bolter\'s Roll', 'Caster\'s Roll', 'Courser\'s Roll', 'Blitzer\'s Roll',
            'Allies\' Roll', 'Avenger\'s Roll'}

        if table.contains(percentageRolls, rollName) then
            messagetoshow = messagetoshow .. bonus .. '% ' .. rollDataTable['desc'] .. ')'
        elseif rollName == 'Companion\'s Roll' then
            messagetoshow = messagetoshow .. Companion_1 .. ' Regain / ' .. Companion_2 .. ' Regen)'
        else
            messagetoshow = messagetoshow .. bonus .. ' ' .. rollDataTable['desc'] .. ')'
        end


        if messagetoshow ~= last_roll then

            print('\31\200[\31\05Roll Tracker\31\200]\31\190 ' .. messagetoshow)

        end

        last_roll = messagetoshow
    end
end



ashita.events.register('packet_in', 'packet_in_cb', function(e)
    local party = AshitaCore:GetMemoryManager():GetParty()
    if e.id == 0xB then
        zoning_bool = true
    elseif e.id == 0xA and zoning_bool then
        zoning_bool = false
    end
    if not zoning_bool then
        if e.id == 0x28 then
            local actor = struct.unpack('I', e.data, 6);
            local category = ashita.bits.unpack_be(e.data_raw, 82, 4);
            local rollNumber = ashita.bits.unpack_be(e.data_raw, 213, 17);

            if category == 6 then
                roll_id = ashita.bits.unpack_be(e.data_raw, 86, 10);
                if rollNumber and actor == AshitaCore:GetMemoryManager():GetParty():GetMemberServerId(0) then
                    PTMembers = {}
                    local target_count = struct.unpack('b', e.data, 0x09 + 1);
                    targets = {}
                    local offset = 150
                    for x = 1, target_count do
                        CharID = ashita.bits.unpack_be(e.data_raw, offset, 32)
                        offset = offset + 123
                        for i = 0, 6 do
                            if party:GetMemberName(i) ~= nil and party:GetMemberServerId(i) == CharID then
                                PTMembers[CharID] = party:GetMemberName(i)
                            end
                        end
                    end
                    generate_corsair_print(rollNumber, roll_id, PTMembers, target_count)
                end
            end
        end
    end
    return false;
end);

ashita.events.register('text_in', 'text_in_cb', function(e)
    if e.message ~= nil then
        messageLowercase = e.message:lower();
        if messageLowercase:find('receives the effect of .* roll.') or messageLowercase:find('loses the effect of .* roll.') then
            return true
        end
        return false
    end
end);

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end
