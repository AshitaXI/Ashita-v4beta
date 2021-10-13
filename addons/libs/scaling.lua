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

require('common');

--[[
* Scaling Helper Library
*
* This library is used to help calculate positions and font sizes based on the users window
* and menu resolutions. This can be helpful for having your addon scale automatically to a users
* configurations without having to custom-code in specifics per-resolution.
--]]

local scaling = {
    menu = {
        w = 0,
        h = 0,
        s = 0,
    },
    window = {
        w = 0,
        h = 0,
        s = 0,
    },
    scaled = {
        w = 0,
        h = 0,
    },
};

do
    -- Store the users configuration information for calculations..
    scaling.window.w    = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0001', 1024);
    scaling.window.h    = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0002', 768);
    scaling.menu.w      = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0037', 1024);
    scaling.menu.h      = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0038', 768);

    -- Store the pre-calculated scaled values..
    scaling.scaled.w = scaling.window.w / scaling.menu.w;
    scaling.scaled.h = scaling.window.h / scaling.menu.h;
end

--[[
* Scales a font size based on the users configurations.
*
* @param {number} height - The default font size to be scaled.
* @return {number} The scaled height, floored to the nearest integer.
--]]
scaling.scale_font = function (height)
    return math.floor(height * scaling.scaled.h);
end

scaling.scale_f = scaling.scale_font;

--[[
* Scales a width based on the users configurations.
*
* @param {number} width - The width to be scaled.
* @return {number} The scaled width.
--]]
scaling.scale_width = function (width)
    return width * scaling.scaled.w;
end

scaling.scale_w = scaling.scale_width;

--[[
* Scales a height based on the users configurations.
*
* @param {number} height - The height to be scaled.
* @return {number} The scaled height.
--]]
scaling.scale_height = function (height)
    return height * scaling.scaled.h;
end

scaling.scale_h = scaling.scale_height;

-- Return the library table..
return scaling;