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

addon.name      = 'stfu';
addon.author    = 'atom0s';
addon.version   = '1.0';
addon.desc      = 'Prevents commonly repeated chat output from the game and prevents calls from making sounds.';
addon.link      = 'https://ashitaxi.com/';

require('common');

-- Stfu Variables
local stfu = T{
    last_msg = nil,
    spam = T{
        'Equipment changed.',
        'Equipment removed.',
        'You were unable to change your equipped items.',
        'You must close the currently open window to use that command.',
        'You cannot use that command at this time.',
        'You cannot use that command while viewing the chat log.',
        'You cannot use that command while charmed.',
        'You cannot use that command while healing.',
        'You cannot use that command while unconscious.',
        'You can only use that command during battle.',
        'You cannot perform that action on the selected sub-target.',
        'You cannot attack that target.',
        'Target out of range.',
    },
};

--[[
* Returns if the given message is considered spam.
*
* @param {string} msg - The message to check for spam.
* @return {boolean} True if spam and should be blocked, false otherwise.
--]]
local function is_spam(msg)
    if (stfu.last_msg ~= nil and (stfu.last_msg == msg or stfu.last_msg:contains(msg))) then
        return true;
    end
    return false;
end

--[[
* event: text_in
* desc : Event called when the addon is processing incoming text.
--]]
ashita.events.register('text_in', 'text_in_cb', function (e)
    -- Find a matching spam entry..
    local k, _ = stfu.spam:find_if(function (v, _)
        local msg = e.message_modified;
        if (is_spam(v) and msg:contains(v)) then
            return true;
        end
        return false;
    end);

    -- Store the current line as the last seen text..
    stfu.last_msg = e.message_modified;

    -- Block the message if it was found as spam..
    if (k ~= nil) then
        e.blocked = true;
        return;
    end

    -- Replace the calls within the message if found..
    local p = '<((c|nc|sc)all|(c|nc|sc)all([0-9]+))>';
    local m = ashita.regex.search(e.message_modified, p);
    if (m ~= nil) then
        e.message_modified = ashita.regex.replace(e.message_modified, p, '($1)');
    end
end);