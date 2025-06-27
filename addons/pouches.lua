--[[
Copyright © 2016, Omnys of Valefor
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    * Neither the name of Pouches nor the
    names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL OMNYS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

addon.name      = 'pouches';
addon.author    = 'Omnys@Valefor - Ashita4 version by Palmer';
addon.version   = '1.0';
addon.desc      = 'Automatically uses pouches and similar self-targetable items repeatedly.';
addon.link      = 'https://github.com/Palmer-ashita4/pouches';

require('common');
local chat = require('chat');

-- Pouches Variables
local pouches = T{
    inverted = T{ },
    item = T{
        name = '',
        id = 0,
        count = 0,
        delay = 0,
    },
};

--[[
* Loads the items resource data on addon load.
--]]
ashita.events.register('load', 'load_cb', function ()
    local resMgr = AshitaCore:GetResourceManager();
    
    -- Build inverted item lookup table..
    for k = 1, 65535 do
        local item = resMgr:GetItemById(k);
        if (item ~= nil and item.Name[1] ~= nil and item.Name[1]:len() > 0) then
            pouches.inverted[item.Name[1]:lower()] = T{
                id = k,
                targets = item.Targets,
                cast = item.CastDelay,
            };
        end
    end
end);

--[[
* Uses the selected item on the player.
--]]
local function use_item()
    AshitaCore:GetChatManager():QueueCommand(1, ('/item "%s" <me>'):fmt(pouches.item.name));
    pouches.item.count = pouches.item.count - 1;
    
    if (pouches.item.count > 0) then
        local player = GetPlayerEntity();
        if (player ~= nil and player.StatusServer == 0) then
            ashita.tasks.once(pouches.item.delay, use_item);
        end
    end
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/pouches') then
        return;
    end
    
    -- Block all related commands..
    e.blocked = true;
    
    -- Get the inventory manager..
    local inv = AshitaCore:GetMemoryManager():GetInventory();
    
    -- Process the item name from command arguments..
    local itemName = AshitaCore:GetChatManager():ParseAutoTranslate(e.command:sub(9):trim(), true):lower();
    pouches.item.name = itemName;
    pouches.item.count = 0;
    
    -- Check if the item exists..
    if (pouches.inverted[itemName] == nil) then
        print(chat.header(addon.name):append(chat.error('Item "'):append(itemName):append('" does not exist.')));
        return;
    end
    
    pouches.item.id = pouches.inverted[itemName].id;
    
    -- Search inventory for the item..
    for i = 1, inv:GetContainerCountMax(0) do
        local item = inv:GetContainerItem(0, i);
        if (item ~= nil and item.Id == pouches.item.id) then
            -- Check if the item can target self (check if targets bitfield allows self-targeting)
            -- In Ashita, if bit 0x01 is set, the item can target self
            local targets = pouches.inverted[itemName].targets or 0;
            if (bit.band(targets, 0x01) ~= 0) then
                pouches.item.count = pouches.item.count + item.Count;
                pouches.item.delay = (pouches.inverted[itemName].cast / 1000) + 2;
            end
        end
    end
    
    -- Start using the item if found..
    if (pouches.item.count > 0) then
        print(chat.header(addon.name):append(chat.message('Found '):append(pouches.item.count):append(' '):append(itemName):append('. Commencing use.')));
        print(chat.header(addon.name):append(chat.message('You may simply type /heal to stop.')));
        use_item();
    else
        print(chat.header(addon.name):append(chat.error('Item "'):append(itemName):append('" not found in main inventory, or is not the type of item that can be used.')));
    end
end);