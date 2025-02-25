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

local ffi = require('ffi');
require('common');

-- Set the random seed..
math.randomseed(os.time());

-- Font Library Internal Table
local fontlib = T{ };

-- Font Library Internal Cache
fontlib.cache = T{ };

-- Font Library Default Font Settings
fontlib.defaults = T{
    visible        = true,
    can_focus      = true,
    locked         = false,
    lockedz        = false,
    is_dirty       = true,
    font_file      = nil,
    font_family    = 'Arial',
    font_height    = 10,
    bold           = false,
    italic         = false,
    right_justified= false,
    strike_through = false,
    underlined     = false,
    color          = 0xFFFF0000,
    color_outline  = 0x00000000,
    padding        = 0.1,
    position_x     = 0,
    position_y     = 0,
    auto_resize    = true,
    anchor         = FrameAnchor.TopLeft,
    anchor_parent  = FrameAnchor.TopLeft,
    text           = '',

    -- Font Background Defaults
    background = T{
        texture_offset_x= 0.0,
        texture_offset_y= 0.0,
        border_visible  = false,
        border_color    = 0x00000000,
        border_flags    = FontBorderFlags.None,
        border_sizes    = '0,0,0,0',
        visible         = false,
        position_x      = 0,
        position_y      = 0,
        can_focus       = true,
        locked          = false,
        lockedz         = false,
        scale_x         = 1.0,
        scale_y         = 1.0,
        width           = 0.0,
        height          = 0.0,
        color           = 0xFFFFFFFF,
    };
};

-- Font Library Property Method Fowards
fontlib.methods = T{
    ['alias']           = { 'GetAlias', 'SetAlias' },
    ['visible']         = { 'GetVisible', 'SetVisible' },
    ['can_focus']       = { 'GetCanFocus', 'SetCanFocus' },
    ['locked']          = { 'GetLocked', 'SetLocked' },
    ['lockedz']         = { 'GetLockedZ', 'SetLockedZ' },
    ['is_dirty']        = { 'GetIsDirty', 'SetIsDirty' },
    ['window_width']    = { 'GetWindowWidth', 'SetWindowWidth' },
    ['window_height']   = { 'GetWindowHeight', 'SetWindowHeight' },
    ['font_file']       = { 'GetFontFile', 'SetFontFile' },
    ['font_family']     = { 'GetFontFamily', 'SetFontFamily' },
    ['font_height']     = { 'GetFontHeight', 'SetFontHeight' },
    ['create_flags']    = { 'GetCreateFlags', 'SetCreateFlags' },
    ['draw_flags']      = { 'GetDrawFlags', 'SetDrawFlags' },
    ['bold']            = { 'GetBold', 'SetBold' },
    ['italic']          = { 'GetItalic', 'SetItalic' },
    ['right_justified'] = { 'GetRightJustified', 'SetRightJustified' },
    ['strike_through']  = { 'GetStrikeThrough', 'SetStrikeThrough' },
    ['underlined']      = { 'GetUnderlined', 'SetUnderlined' },
    ['color']           = { 'GetColor', 'SetColor' },
    ['color_outline']   = { 'GetColorOutline', 'SetColorOutline' },
    ['padding']         = { 'GetPadding', 'SetPadding' },
    ['position_x']      = { 'GetPositionX', 'SetPositionX' },
    ['position_y']      = { 'GetPositionY', 'SetPositionY' },
    ['auto_resize']     = { 'GetAutoResize', 'SetAutoResize' },
    ['anchor']          = { 'GetAnchor', 'SetAnchor' },
    ['anchor_parent']   = { 'GetAnchorParent', 'SetAnchorParent' },
    ['text']            = { 'GetText', 'SetText' },

    -- Real Position Forwards
    ['real_x']          = { 'GetRealPositionX', nil },
    ['real_y']          = { 'GetRealPositionY', nil },

    -- Functional Forwards
    ['render'] = { nil, nil,
        function (self)
            self:Render();
        end
    },
    ['get_text_size'] = { nil, nil,
        function (self)
            local size = SIZE.new();
            self:GetTextSize(size);
            return size.cx, size.cy;
        end
    },
    ['hit_test'] = { nil, nil,
        function (self, x, y)
            return self:HitTest(x, y);
        end
    },

    -- Non-wrapped Forwards
    ['background'] = {
        function (self)
            return fontlib.wrapbg(self:GetBackground());
        end,
        function (self, o)
            -- Ignore set attempts, this also allows settings to be merged in for background properties
            -- without erroring out.
        end,
    },
    ['parent'] = {
        function (self)
            local p = self:GetParent();
            if (p == nil) then
                return nil;
            end
            return fontlib.wrap(p);
        end,
        function (self, o)
            local f = o;
            if (o ~= nil and o.obj ~= nil) then
                f = o.obj;
            end
            self:SetParent(f);
        end,
    },
};

-- Font Library Property Method Forwards (Background)
fontlib.methods_bg = T{
    ['alias']               = { 'GetAlias', 'SetAlias' },
    ['texture_offset_x']    = { 'GetTextureOffsetX', 'SetTextureOffsetX' },
    ['texture_offset_y']    = { 'GetTextureOffsetY', 'SetTextureOffsetY' },
    ['border_visible']      = { 'GetBorderVisible', 'SetBorderVisible' },
    ['border_color']        = { 'GetBorderColor', 'SetBorderColor' },
    ['border_flags']        = { 'GetBorderFlags', 'SetBorderFlags' },
    ['visible']             = { 'GetVisible', 'SetVisible' },
    ['position_x']          = { 'GetPositionX', 'SetPositionX' },
    ['position_y']          = { 'GetPositionY', 'SetPositionY' },
    ['can_focus']           = { 'GetCanFocus', 'SetCanFocus' },
    ['locked']              = { 'GetLocked', 'SetLocked' },
    ['lockedz']             = { 'GetLockedZ', 'SetLockedZ' },
    ['scale_x']             = { 'GetScaleX', 'SetScaleX' },
    ['scale_y']             = { 'GetScaleY', 'SetScaleY' },
    ['width']               = { 'GetWidth', 'SetWidth' },
    ['height']              = { 'GetHeight', 'SetHeight' },
    ['color']               = { 'GetColor', 'SetColor' },

    ['border_sizes'] = {
        function (self)
            local sizes = self:GetBorderSizes();
            return sizes.left, sizes.top, sizes.right, sizes.bottom;
        end,
        function (self, v)
            if (type(v) == 'userdata' and RECT.__type.is(v)) then
                self:SetBorderSizes(v);
            else
                local r     = RECT.new();
                local vals  = tostring(v):split(',');
                r.left      = tonumber(vals[1] or 0);
                r.top       = tonumber(vals[2] or 0);
                r.right     = tonumber(vals[3] or 0);
                r.bottom    = tonumber(vals[4] or 0);

                self:SetBorderSizes(r);
            end
        end,
    },
};

-- Font Library Mouse Events
fontlib.mouse_events = T{ };
fontlib.mouse_events[0x200] = 'mouse_move';
fontlib.mouse_events[0x201] = 'left_click_down';
fontlib.mouse_events[0x202] = 'left_click_up';
fontlib.mouse_events[0x204] = 'right_click_down';
fontlib.mouse_events[0x205] = 'right_click_up';
fontlib.mouse_events[0x207] = 'middle_click_down';
fontlib.mouse_events[0x208] = 'middle_click_up';
fontlib.mouse_events[0x20A] = 'mouse_wheel';
fontlib.mouse_events[0x20B] = 'x_click_down';
fontlib.mouse_events[0x20C] = 'x_click_up';
fontlib.mouse_events[0x20E] = 'mouse_hwheel';

--[[
* Font Object Wrapper Metatable Overrides
*
* Overrides the default metatable of a wrapped font object.
* Metatable overrides:
*
*   __index     = Custom indexing. [Method forwards -> fontobj_mt -> self.]
*   __newindex  = Custom indexing. [Method forwards -> fontobj_mt -> self.]
--]]
fontlib.fontobj_mt = {
    __index = function (self, k)
        -- Look for known method name forwards..
        if (fontlib.methods:containskey(k)) then
            local f = fontlib.methods[k][1];
            if (type(f) == 'string') then
                if (self.obj[f] ~= nil) then
                    return self.obj[f](self.obj);
                end
            elseif (type(f) == 'function') then
                return f(self.obj);
            end

            -- Handle call forwards..
            f = fontlib.methods[k][3];
            if (type(f) == 'function') then
                return f;
            end
            return nil;
        end

        -- Look for fontlib custom helpers..
        local ret = rawget(fontlib.fontobj_mt, k);
        if (ret ~= nil) then
            return ret;
        end

        -- Look for owner-metatable function calls..
        local fn = rawget(getmetatable(self.obj), k);
        if (fn ~= nil and type(fn) == 'function') then
            return fn:skip(1, self.obj);
        end

        -- Use self-indexing otherwise..
        return rawget(self, k);
    end,
    __newindex = function (self, k, v)
        -- Look for known method name forwards..
        if (fontlib.methods:containskey(k)) then
            local f = fontlib.methods[k][2];
            if (type(f) == 'string') then
                self.obj[f](self.obj, v);
            elseif (type(f) == 'function') then
                f(self.obj, v);
            end
            return;
        end

        -- Look for owner-metatable function calls..
        local fn = rawget(getmetatable(self.obj), k);
        if (fn ~= nil and type(fn) == 'function') then
            fn:skip(1, self.obj, v);
            return;
        end

        -- Use self-indexing otherwise..
        rawset(self, k, v);
    end,
};

--[[
* Font Object Background Wrapper Metatable Overrides
*
* Overrides the default metatable of a wrapped font objects background.
* Metatable overrides:
*
*   __index     = Custom indexing. [Method forwards -> fontobj_bg_mt -> self.]
*   __newindex  = Custom indexing. [Method forwards -> fontobj_bg_mt -> self.]
--]]
fontlib.fontobj_bg_mt = {
    __index = function (self, k)
        -- Look for known method name forwards..
        if (fontlib.methods_bg:containskey(k)) then
            local f = fontlib.methods_bg[k][1];
            if (type(f) == 'string') then
                if (self.obj[f] ~= nil) then
                    return self.obj[f](self.obj);
                end
            elseif (type(f) == 'function') then
                return f(self.obj);
            end

            return nil;
        end

        -- Look for fontlib custom helpers..
        local ret = rawget(fontlib.fontobj_bg_mt, k);
        if (ret ~= nil) then
            return ret;
        end

        -- Look for owner-metatable function calls..
        local fn = rawget(getmetatable(self.obj), k);
        if (fn ~= nil and type(fn) == 'function') then
            return fn:skip(1, self.obj);
        end

        -- Use self-indexing otherwise..
        return rawget(self, k);
    end,
    __newindex = function (self, k, v)
        -- Look for known method name forwards..
        if (fontlib.methods_bg:containskey(k)) then
            local f = fontlib.methods_bg[k][2];
            if (type(f) == 'string') then
                self.obj[f](self.obj, v);
            elseif (type(f) == 'function') then
                f(self.obj, v);
            end
            return;
        end

        -- Look for owner-metatable function calls..
        local fn = rawget(getmetatable(self.obj), k);
        if (fn ~= nil and type(fn) == 'function') then
            fn:skip(1, self.obj, v);
            return;
        end

        -- Use self-indexing otherwise..
        rawset(self, k, v);
    end,
};

-- Function forwards..
local raise_event = nil;

do
    --[[
    * Raises an event to all cached font objects that have registered to it.
    *
    * @param {string} eventName - The name of the event to raise.
    * @param {...} ... - The arguments to pass to the event, if any.
    --]]
    raise_event = function (eventName, ...)
        local args = {...};
        fontlib.cache:each(function (v)
            local events = v.events[eventName:lower()];
            if (events ~= nil) then
                events:each(function (vv) vv.callback(unpack(args)); end);
            end
        end);
    end

    --[[
    * event: mouse
    * desc : Event called when the addon is processing mouse input. (WNDPROC)
    --]]
    ashita.events.register('mouse', '__fontlib_mouse_cb', function (e)
        local eventName = fontlib.mouse_events[e.message];
        if (eventName == nil) then
            return;
        end
        raise_event(eventName, e);
    end);
end

--[[
* Creates and returns a new font object.
*
* @param {table} settings - The [optional] settings overrides to apply to the font after creating it.
* @return {table} The font object wrapped in a custom table.
--]]
function fontlib.new(settings)
    -- Create a unique alias for the font object..
    local n = ('%s_********_********'):fmt(addon.name):gsub('[\\*]', function ()
        return ('%x'):fmt(math.random(0x00, 0x0F));
    end):replace(' ', '_');

    -- Create the font object..
    local o = AshitaCore:GetFontManager():Create(n);
    if (o == nil) then
        error('Failed to create a font object.');
    end

    -- Create a wrapper for this font object..
    local f     = T{ };
    f.events    = T{ };
    f.obj       = o;

    -- Override the metatable for the wrapper..
    local fobj = setmetatable(f, fontlib.fontobj_mt);

    -- Apply the font settings..
    fobj:apply(settings);

    -- Cache the font object..
    if (not fontlib.cache:contains(fobj)) then
        fontlib.cache:insert(1, fobj);
    end

    return fobj;
end

--[[
* Wraps an existing font object.
*
* @param {userdata} o - The font object to wrap.
* @return {table} The font object wrapped in a custom table.
--]]
function fontlib.wrap(o)
    -- Create a wrapper for this font object..
    local f     = T{ };
    f.events    = T{ };
    f.obj       = o;

    -- Override the metatable for the wrapper..
    local fobj = setmetatable(f, fontlib.fontobj_mt);

    -- Cache the font object..
    if (not fontlib.cache:contains(fobj)) then
        fontlib.cache:insert(1, fobj);
    end

    return fobj;
end

--[[
* Wraps an existing font object background primitive.
*
* @param {userdata} o - The font object background primitive to wrap.
* @return {table} The font objects background wrapped in a custom table.
--]]
function fontlib.wrapbg(o)
    -- Create a wrapper for this font object background..
    local f = T{ };
    f.obj   = o;

    -- Override and return the metatable for the wrapper..
    return setmetatable(f, fontlib.fontobj_bg_mt);
end

--[[
* Return a table of font settings from a loaded configuration block.
*
* @param {string} alias - The configuration alias.
* @param {string} key - The configuration key to find the values within.
* @return {table} Table of font object settings.
*
* @note
*   This is a helper that will try and load settings from the given configuration block.
*   If a setting value exists, it will be used, otherwise the defaults table data is used instead.
--]]
function fontlib.load_settings(alias, key)
    -- Prepare the configurations..
    local settings = T{ };
    settings.background = T{ };

    -- Helper function to read a configuration value and convert it as needed.
    local function read_cfg(cfgAlias, cfgKey, cfgVal, def)
        local ret = nil;
        local cfg = AshitaCore:GetConfigurationManager();

        switch(type(def), {
            ['boolean'] = function ()
                ret = cfg:GetBool(cfgAlias, cfgKey, cfgVal, def);
            end,
            ['number'] = function ()
                ret = cfg:GetDouble(cfgAlias, cfgKey, cfgVal, def);
            end,
            ['string'] = function ()
                ret = cfg:GetString(cfgAlias, cfgKey, cfgVal) or def;
            end,
            ['userdata'] = function ()
                -- Type: RECT
                if (RECT.__type.is(def)) then
                    local vals = cfg:GetString(cfgAlias, cfgKey, cfgVal);
                    if (vals ~= nil and not vals:empty()) then
                        ret = RECT.new();

                        local v     = vals:split(',');
                        ret.left    = tonumber(v[1] or def.left);
                        ret.top     = tonumber(v[2] or def.top);
                        ret.right   = tonumber(v[3] or def.right);
                        ret.bottom  = tonumber(v[4] or def.bottom);
                    else
                        ret = def;
                    end
                end
            end,
            [switch.default] = function ()
                error('Invalid settings type; cannot convert: ' .. type(def));
            end,
        });

        return ret or def;
    end

    -- Process the default values table for keys..
    local keys = fontlib.defaults:keys();
    keys:each(function (v)
        if (v == 'background') then
            local keysbg = fontlib.defaults.background:keys();
            keysbg:each(function (vv)
                settings.background[vv] = read_cfg(alias, key, 'background.' .. vv, fontlib.defaults.background[vv]);
            end);
        else
            settings[v] = read_cfg(alias, key, v, fontlib.defaults[v]);
        end
    end);

    return settings;
end

--[[
* Destroys the font object.
*
* @param {table} self - The font object wrapper to destroy.
--]]
function fontlib.fontobj_mt.destroy(self)
    -- Remove the object from the cache..
    local k, _ = fontlib.cache:find_if(function (v)
        return v.alias:lower() == self.alias:lower();
    end);
    if (k ~= nil) then
        fontlib.cache:remove(k);
    end

    -- Delete the font..
    AshitaCore:GetFontManager():Delete(self.alias);
end

--[[
* Applies the given settings to the font object.
*
* @param {table} self - The font object wrapper.
* @param {table} settings - The settings to apply to the font object.
--]]
function fontlib.fontobj_mt.apply(self, settings)
    -- Prepare the font settings using the defaults and merging in any overrides..
    local s = fontlib.defaults:copy(true):merge(settings or {}, true);
    s.background = fontlib.defaults.background:copy(true):merge(settings.background or {}, true);

    -- Apply the font settings..
    s:each(function (v, k)
        -- Handle background settings..
        if (k:lower() == 'background') then
            local bg = self.background;
            if (type(v) == 'table') then
                T(v):each(function (vv, kk)
                    bg[kk] = vv;
                end);
            end
        else
            self[k] = v;
        end
    end);
end

--[[
* Finds and returns the index of a registered event for the given font.
*
* @param {table} self - The font object wrapper.
* @param {string} eventName - The name of the event.
* @param {string} eventAlias - The alias of the event.
* @return {number|nil} The index if found, nil otherwise.
--]]
function fontlib.fontobj_mt.find_event(self, eventName, eventAlias)
    -- Obtain the events table for the given event name..
    local events = self.events[eventName:lower()];
    if (events == nil) then
        return nil;
    end

    -- Find the matching event by its alias..
    local k, _ = events:find_if(function (v)
        return v.alias:lower() == eventAlias:lower();
    end);

    return k;
end

--[[
* Registers an event callback for the given event.
*
* @param {table} self - The font object wrapper.
* @param {string} eventName - The name of the event.
* @param {string} eventAlias - The alias of the event.
* @param {function} callback - The function to invoke when the event is fired.
--]]
function fontlib.fontobj_mt.register(self, eventName, eventAlias, callback)
    assert(type(eventName) == 'string', 'Invalid event name; expected a string.');
    assert(type(eventAlias) == 'string', 'Invalid event alias; expected a string.');
    assert(type(callback) == 'function', 'Invalid event callback; expected a function.');

    local n = eventName:lower();
    local a = eventAlias:lower();

    -- Create the event table if it doesn't exist for the given event..
    if (self.events[n] == nil) then
        self.events[n] = T{ };
    end

    -- Look for an existing event..
    local idx = self:find_event(n, a);

    -- Update the existing callback entry..
    if (idx ~= nil) then
        self.events[n][idx].callback = callback;
    else
        -- Insert a new callback entry..
        self.events[n]:insert(#self.events[n] + 1, T{
            ['alias']       = a,
            ['callback']    = callback,
        });
    end
end

--[[
* Unregisters an event callback for the given event.
*
* @param {table} self - The font object wrapper.
* @param {string} eventName - The name of the event.
* @param {string} eventAlias - The alias of the event.
--]]
function fontlib.fontobj_mt.unregister(self, eventName, eventAlias)
    assert(type(eventName) == 'string', 'Invalid event name; expected a string.');
    assert(type(eventAlias) == 'string', 'Invalid event alias; expected a string.');

    local n = eventName:lower();
    local a = eventAlias:lower();

    -- Validate the event table exists for the given event..
    if (self.events[n] == nil) then
        return;
    end

    -- Look for an existing event..
    local idx = self:find_event(n, a);
    if (idx == nil) then
        return;
    end

    -- Remove the event callback..
    self.events[n]:remove(idx);
end

--[[
* Font cache automatic cleanup.
*
* @note
*   To prevent fonts from being left on-screen if an addon crashes, we abuse FFI's gc handling to help ensure things
*   created by the fontlib are cleaned up. (Ashita does not invoke unload events on addons that error out.)
--]]
fontlib.cache_gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (fontlib == nil or fontlib.cache == nil) then
        return;
    end

    -- Cleanup the cached fonts..
    fontlib.cache:each(function (v) AshitaCore:GetFontManager():Delete(v.alias); end);
    fontlib.cache:clear();
end);

-- Return the library table..
return fontlib;