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

addon.name      = 'equipmon';
addon.author    = 'atom0s';
addon.version   = '1.2';
addon.desc      = 'Displays the players equipment onscreen at all times.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat      = require('chat');
local d3d       = require('d3d8');
local ffi       = require('ffi');
local fonts     = require('fonts');
local imgui     = require('imgui');
local prims     = require('primitives');
local scaling   = require('scaling');
local settings  = require('settings');

local C = ffi.C;
local d3d8dev = d3d.get_device();

-- Default Settings
local default_settings = T{
    visible = T{ true, },
    opacity = T{ 1.0, },
    padding = T{ 1.0, },
    scale = T{ 1.0, },
    x = T{ 100, },
    y = T{ 100, },

    -- Slot Settings
    slots = T{
        theme = T{ 0, },
        show_bg = T{ true, },
        show_encumbrance = T{ true, },
        show_ammo_count = T{ true, },
    },

    -- Ammo Font Settings
    ammo_font = T{
        visible = true,
        font_family = 'Arial',
        font_height = scaling.scale_f(12),
        color = 0xFFFFFFFF,
        color_outline = 0xFF000000,
        bold = true,
        draw_flags = bit.bor(FontDrawFlags.Outlined, FontDrawFlags.ManualRender),
        background = T{
            visible = false,
        },
    },

    -- Background Primitive Settings
    background = T{
        visible = true,
        color = 0x80000000,
        can_focus = false,
        locked = true,
    },
};

-- EquipMon Variables
local eqmon = T{
    settings = settings.load(default_settings),

    -- Direct3D rendering objects..
    bg = nil,
    sprite = nil,
    rect = ffi.new('RECT', { 0, 0, 32, 32, });
    vec_position = ffi.new('D3DXVECTOR2', { 0, 0, }),
    vec_scale = ffi.new('D3DXVECTOR2', { 1.0, 1.0, }),

    -- Background primitive and ammo font..
    background = nil;
    font = nil,

    -- Encumber variables..
    encumber = T{
        flags = 0,
        texture = nil,
    },

    -- Padding weights per slot..
    padding_weights = T{
        [0x00] = T{ 0, 0, },
        [0x01] = T{ 1, 0, },
        [0x02] = T{ 2, 0, },
        [0x03] = T{ 3, 0, },
        [0x04] = T{ 0, 1, },
        [0x09] = T{ 1, 1, },
        [0x0B] = T{ 2, 1, },
        [0x0C] = T{ 3, 1, },
        [0x05] = T{ 0, 2, },
        [0x06] = T{ 1, 2, },
        [0x0D] = T{ 2, 2, },
        [0x0E] = T{ 3, 2, },
        [0x0F] = T{ 0, 3, },
        [0x0A] = T{ 1, 3, },
        [0x07] = T{ 2, 3, },
        [0x08] = T{ 3, 3, },
    },

    -- Equipment slot entries..
    slots = T{
        T{ slot = 0x00, itemid = 0, texture = nil, x = 0,   y = 0, }, -- Main
        T{ slot = 0x01, itemid = 0, texture = nil, x = 32,  y = 0, }, -- Sub
        T{ slot = 0x02, itemid = 0, texture = nil, x = 64,  y = 0, }, -- Range
        T{ slot = 0x03, itemid = 0, texture = nil, x = 96,  y = 0, }, -- Ammo
        T{ slot = 0x04, itemid = 0, texture = nil, x = 0,   y = 32, }, -- Head
        T{ slot = 0x09, itemid = 0, texture = nil, x = 32,  y = 32, }, -- Neck
        T{ slot = 0x0B, itemid = 0, texture = nil, x = 64,  y = 32, }, -- Ear1
        T{ slot = 0x0C, itemid = 0, texture = nil, x = 96,  y = 32, }, -- Ear2
        T{ slot = 0x05, itemid = 0, texture = nil, x = 0,   y = 64, }, -- Body
        T{ slot = 0x06, itemid = 0, texture = nil, x = 32,  y = 64, }, -- Hands
        T{ slot = 0x0D, itemid = 0, texture = nil, x = 64,  y = 64, }, -- Ring1
        T{ slot = 0x0E, itemid = 0, texture = nil, x = 96,  y = 64, }, -- Ring2
        T{ slot = 0x0F, itemid = 0, texture = nil, x = 0,   y = 96, }, -- Back
        T{ slot = 0x0A, itemid = 0, texture = nil, x = 32,  y = 96, }, -- Waist
        T{ slot = 0x07, itemid = 0, texture = nil, x = 64,  y = 96, }, -- Legs
        T{ slot = 0x08, itemid = 0, texture = nil, x = 96,  y = 96, }, -- Feet
    },

    -- EquipMon movement variables..
    move = T{
        dragging = false,
        drag_x = 0,
        drag_y = 0,
        shift_down = false,
    },

    -- Editor variables..
    editor = T{
        is_open = T{ false, },
    },
};

--[[
* Loads and returns an asset texture.
*
* @param {number|string} asset - The name (or id) of the asset texture to load.
* @return {object|nil} The Direct3D texture object on success, nil otherwise.
--]]
local function load_asset_texture(asset)
    if (asset == -1) then return nil; end

    local path = ('%s\\addons\\%s\\assets\\'):append(type(asset) == 'number' and '%d' or '%s'):append('.png'):fmt(AshitaCore:GetInstallPath(), 'equipmon', asset);
    if (not ashita.fs.exists(path)) then
        return nil;
    end

    local texture_ptr = ffi.new('IDirect3DTexture8*[1]');
    if (C.D3DXCreateTextureFromFileA(d3d8dev, path, texture_ptr) ~= C.S_OK) then
        return nil;
    end

    return d3d.gc_safe_release(ffi.cast('IDirect3DTexture8*', texture_ptr[0]));
end

--[[
* Loads and returns an item texture by its item id.
*
* @param {number} itemid - The item id to load.
* @return {object|nil} The Direct3D texture object on success, nil otherwise.
--]]
local function load_item_texture(itemid)
    if (T{ nil, 0, -1, 65535 }:hasval(itemid)) then
        return nil;
    end

    local item = AshitaCore:GetResourceManager():GetItemById(itemid);
    if (item == nil) then return nil end;

    local texture_ptr = ffi.new('IDirect3DTexture8*[1]');
    if (C.D3DXCreateTextureFromFileInMemoryEx(d3d8dev, item.Bitmap, item.ImageSize, 0xFFFFFFFF, 0xFFFFFFFF, 1, 0, C.D3DFMT_A8R8G8B8, C.D3DPOOL_MANAGED, C.D3DX_DEFAULT, C.D3DX_DEFAULT, 0xFF000000, nil, nil, texture_ptr) ~= C.S_OK) then
        return nil;
    end

    return d3d.gc_safe_release(ffi.cast('IDirect3DTexture8*', texture_ptr[0]));
end

--[[
* Returns the item id and count of the equipped item for the given slot.
*
* @param {number} slot - The slot id to obtain the item id of.
* @return {number, number|nil} The equipped item id and count on success, nil otherwise.
--]]
local function get_equipped_item(slot)
    local inv = AshitaCore:GetMemoryManager():GetInventory();

    local eitem = inv:GetEquippedItem(slot);
    if (eitem == nil or eitem.Index == 0) then
        return nil;
    end

    local iitem = inv:GetContainerItem(bit.band(eitem.Index, 0xFF00) / 0x0100, eitem.Index % 0x0100);
    if(iitem == nil or T{ nil, 0, -1, 65535 }:hasval(iitem.Id)) then return nil; end

    return iitem.Id, iitem.Count;
end

--[[
* Returns the items max stack count.
*
* @param {number} itemid - The item id to obtain the max stack size of.
* @return {number} The items max stack count.
--]]
local function get_item_max_stack_size(itemid)
    local item = AshitaCore:GetResourceManager():GetItemById(itemid);
    if (item == nil) then
        return 1;
    end
    return item.StackSize;
end

--[[
* Updates the current equipment textures.
--]]
local function update_equipment_textures()
    eqmon.slots:each(function (v)
        local id, count = get_equipped_item(v.slot);
        if (id == nil) then
            v.itemid = 0;
            v.texture = nil;
        else
            if (v.texture == nil or v.itemid == 0 or v.itemid ~= id) then
                v.itemid = id;
                v.texture = load_item_texture(id);
            end
        end
    end);
end

--[[
* Renders the EquipMon settings editor.
--]]
local function render_editor()
    if (not eqmon.editor.is_open[1]) then
        return;
    end

    imgui.SetNextWindowSize({ 500, 650, });
    imgui.SetNextWindowSizeConstraints({ 500, 650, }, { FLT_MAX, FLT_MAX, });
    if (imgui.Begin('EquipMon', eqmon.editor.is_open, ImGuiWindowFlags_NoResize)) then
        imgui.BeginGroup();
            imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Main Settings');
            imgui.BeginChild('settings_main', { 0, 135, }, true);

                if (imgui.Checkbox('Visible', eqmon.settings.visible)) then
                    settings.save();
                end
                imgui.ShowHelp('Toggles if EquipMon is visible or not.');
                if (imgui.SliderFloat('Opacity', eqmon.settings.opacity, 0.125, 1.0, '%.3f')) then
                    settings.save();
                end
                imgui.ShowHelp('The opacity of the equipment slots and icons.');
                if (imgui.DragFloat('Padding', eqmon.settings.padding, 0.1, 0.0, 200.0, '%.2f')) then
                    settings.save();
                end
                imgui.ShowHelp('The padding between equipment slots.\n\nClick and drag to change the value.\nOr double-click to edit directly.');
                if (imgui.DragFloat('Scale', eqmon.settings.scale, 0.1, 0.1, 5.0, '%.2f')) then
                    settings.save();
                end
                imgui.ShowHelp('The scaling of the EquipMon object.\n\nClick and drag to change the value.\nOr double-click to edit directly.');

                local pos = { eqmon.settings.x[1], eqmon.settings.y[1] };
                if (imgui.InputInt2('Position', pos)) then
                    eqmon.settings.x[1] = pos[1];
                    eqmon.settings.y[1] = pos[2];
                    settings.save();
                end
                imgui.ShowHelp('The position of EquipMon on screen.');

            imgui.EndChild();
        imgui.EndGroup();

        imgui.BeginGroup();
            imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Slot Settings');
            imgui.BeginChild('settings_slots', { 0, 110, }, true);

                if (imgui.InputInt('Theme', eqmon.settings.slots.theme)) then
                    eqmon.bg = load_asset_texture(eqmon.settings.slots.theme[1]);
                end
                imgui.ShowHelp('Sets the background asset texture to load.\n\nThe number matches the assets texture file name without the extension.\n-1 will prevent a texture from loading.');
                imgui.Checkbox('Slot Background Visible', eqmon.settings.slots.show_bg);
                imgui.ShowHelp('Toggles if the slot background is visible or not.');
                imgui.Checkbox('Show Encumbrance Status', eqmon.settings.slots.show_encumbrance);
                imgui.ShowHelp('Toggles if embrance X\'s will be displayed on unavailable slots.');
                imgui.Checkbox('Show Ammo Count', eqmon.settings.slots.show_ammo_count);
                imgui.ShowHelp('Toggles if ammo counts will be displayed over the ammo slot.');

            imgui.EndChild();
        imgui.EndGroup();

        imgui.BeginGroup();
            imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Background Settings');
            imgui.BeginChild('settings_bg', { 0, 65, }, true);

                -- Flips the R and B values of a color for translation between ImGui and D3D.
                local function cflip(c)
                    local r, b = c[3], c[1];
                    c[1] = r;
                    c[3] = b;
                    return c;
                end

                if (imgui.Checkbox('Background Visible', { eqmon.settings.background.visible })) then
                    eqmon.settings.background.visible = not eqmon.settings.background.visible;
                    settings.save();
                end
                imgui.ShowHelp('Toggles if the overall background is visible or not.');

                local c = cflip({ imgui.ColorConvertU32ToFloat4(eqmon.settings.background.color) });
                if (imgui.ColorEdit4('Color', c)) then
                    c = cflip(c);

                    eqmon.settings.background.color = imgui.ColorConvertFloat4ToU32(c);
                    if (eqmon.background ~= nil) then
                        eqmon.background.color = eqmon.settings.background.color;
                    end

                    settings.save();
                end
                imgui.ShowHelp('The color of the overall background behind the EquipMon object.');

            imgui.EndChild();
        imgui.EndGroup();

        imgui.BeginGroup();
            imgui.TextColored({ 1.0, 0.65, 0.26, 1.0 }, 'Ammo Font Settings');
            imgui.BeginChild('settings_ammo_font', { 0, 185, }, true);

                local need_font_update = false;

                local h = { eqmon.settings.ammo_font.font_height };
                if (imgui.InputInt('Height', h)) then
                    eqmon.settings.ammo_font.font_height = h[1];
                    need_font_update = true;
                end
                imgui.ShowHelp('The font size of the ammo count text.');

                c = cflip({ imgui.ColorConvertU32ToFloat4(eqmon.settings.ammo_font.color) });
                if (imgui.ColorEdit4('Color', c)) then
                    c = cflip(c);

                    eqmon.settings.ammo_font.color = imgui.ColorConvertFloat4ToU32(c);
                    need_font_update = true;
                end
                imgui.ShowHelp('The color of the ammo count text.');

                c = cflip({ imgui.ColorConvertU32ToFloat4(eqmon.settings.ammo_font.color_outline) });
                if (imgui.ColorEdit4('Color Outline', c)) then
                    c = cflip(c);

                    eqmon.settings.ammo_font.color_outline = imgui.ColorConvertFloat4ToU32(c);
                    need_font_update = true;
                end
                imgui.ShowHelp('The outline color of the ammo count text.');

                if (imgui.Checkbox('Bold?', { eqmon.settings.ammo_font.bold })) then
                    eqmon.settings.ammo_font.bold = not eqmon.settings.ammo_font.bold;
                    need_font_update = true;
                end
                imgui.ShowHelp('Toggles if the ammo count text is bold or not.');
                if (imgui.Checkbox('Italic?', { eqmon.settings.ammo_font.italic })) then
                    eqmon.settings.ammo_font.italic = not eqmon.settings.ammo_font.italic;
                    need_font_update = true;
                end
                imgui.ShowHelp('Toggles if the ammo count text is italic or not.');

                if (imgui.Checkbox('Background Visible', { eqmon.settings.ammo_font.background.visible })) then
                    eqmon.settings.ammo_font.background.visible = not eqmon.settings.ammo_font.background.visible;
                    need_font_update = true;
                end
                imgui.ShowHelp('Toggles if the overall background is visible or not.');

                c = cflip({ imgui.ColorConvertU32ToFloat4(eqmon.font.background.color) });
                if (imgui.ColorEdit4('Background Color', c)) then
                    c = cflip(c);

                    eqmon.settings.ammo_font.background.color = imgui.ColorConvertFloat4ToU32(c);
                    need_font_update = true;
                end
                imgui.ShowHelp('The color of the ammo count text background.');

                -- Apply any font changes..
                if (need_font_update and eqmon.font ~= nil) then
                    eqmon.font:apply(eqmon.settings.ammo_font);
                    settings.save();
                end

            imgui.EndChild();
        imgui.EndGroup();
    end
    imgui.End();
end

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
        { '/equipmon', 'Toggles the EquipMon editor.' },
        { '/equipmon editor', 'Toggles the EquipMon editor.' },
        { '/equipmon save', 'Saves ' },
        { '/equipmon reload', 'Reloads the current settings from disk.the current settings.' },
        { '/equipmon reset', 'Resets the current settings.' },
        { '/equipmon show', 'Shows the EquipMon object.' },
        { '/equipmon hide', 'Hides the EquipMon object.' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        print(chat.header(addon.name):append(chat.error('Usage: ')):append(chat.message(v[1]):append(' - ')):append(chat.color1(6, v[2])));
    end);
end

--[[
* Registers a callback for the settings to monitor for character switches.
--]]
settings.register('settings', 'settings_update', function (s)
    if (s ~= nil) then
        eqmon.settings = s;
    end

    -- Update the background texture..
    eqmon.bg = load_asset_texture(eqmon.settings.slots.theme[1]);

    -- Update the font and primitive objects..
    if (eqmon.font ~= nil) then
        eqmon.font:apply(eqmon.settings.ammo_font);
    end
    if (eqmon.background ~= nil) then
        eqmon.background:apply(eqmon.settings.background);
    end

    -- Save the current settings..
    settings.save();
end);

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Create the sprite object..
    local sprite_ptr = ffi.new('ID3DXSprite*[1]');
    if (C.D3DXCreateSprite(d3d8dev, sprite_ptr) ~= C.S_OK) then
        error('failed to make sprite obj');
    end
    eqmon.sprite = d3d.gc_safe_release(ffi.cast('ID3DXSprite*', sprite_ptr[0]));

    -- Prepare the other main texture assets..
    eqmon.bg = load_asset_texture(eqmon.settings.slots.theme[1]);
    eqmon.encumber.texture = load_asset_texture('encumber');

    -- Prepare the background primitive and ammo count font object..
    eqmon.background = prims.new(eqmon.settings.background);
    eqmon.font = fonts.new(eqmon.settings.ammo_font);

    -- Update the equipment textures..
    update_equipment_textures();
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    -- Cleanup the various asset textures and objects..
    eqmon.bg = nil;
    eqmon.sprite = nil;
    eqmon.encumber.texture = nil;
    eqmon.slots:each(function (v)
        v.texture = nil;
    end);

    -- Cleanup the font and primitive objects..
    if (eqmon.background ~= nil) then
        eqmon.background:destroy();
        eqmon.background = nil;
    end
    if (eqmon.font ~= nil) then
        eqmon.font:destroy();
        eqmon.font = nil;
    end

    -- Save the current settings..
    settings.save();
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/equipmon')) then
        return;
    end

    -- Block all related commands..
    e.blocked = true;

    -- Handle: /equipmon - Toggles the EquipMon editor.
    -- Handle: /equipmon editor - Toggles the EquipMon editor.
    if (#args == 1 or (#args >= 2 and args[2]:any('editor'))) then
        eqmon.editor.is_open[1] = not eqmon.editor.is_open[1];
        return;
    end

    -- Handle: /equipmon save - Saves the current settings.
    if (#args >= 2 and args[2]:any('save')) then
        settings.save();
        print(chat.header(addon.name):append(chat.message('Settings saved.')));
        return;
    end

    -- Handle: /equipmon reload - Reloads the current settings from disk.
    if (#args >= 2 and args[2]:any('reload')) then
        settings.reload();
        print(chat.header(addon.name):append(chat.message('Settings reloaded.')));
        return;
    end

    -- Handle: /equipmon reset - Resets the current settings.
    if (#args >= 2 and args[2]:any('reset')) then
        settings.reset();
        print(chat.header(addon.name):append(chat.message('Settings reset to defaults.')));
        return;
    end

    -- Handle: /equipmon show - Shows the EquipMon object.
    if (#args >= 2 and args[2]:any('show')) then
        eqmon.settings.visible[1] = true;
        settings.save();
        return;
    end

    -- Handle: /equipmon hide - Hides the EquipMon object.
    if (#args >= 2 and args[2]:any('hide')) then
        eqmon.settings.visible[1] = false;
        settings.save();
        return;
    end

    -- Unhandled: Print help information..
    print_help(true);
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Update the equipment textures on item related packet updates..
    if (T{ 0x001D, 0x001F, 0x0037, 0x0050, 0x0051, 0x0116, 0x0117 }:hasval(e.id)) then
        ashita.tasks.oncef(1, update_equipment_textures);
        return;
    end

    -- Packet: Jobs Update
    if (e.id == 0x001B) then
        eqmon.encumber.flags = struct.unpack('L', e.data_modified, 0x60 + 1);
        return;
    end
end);

--[[
* event: packet_out
* desc : Event called when the addon is processing outgoing packets.
--]]
ashita.events.register('packet_out', 'packet_out_cb', function (e)
    -- Update the equipment textures on item related packet updates..
    if (T{ 0x001A, 0x0050, 0x0051, 0x0052, 0x0053, 0x0061, 0x0102, 0x0111 }:hasval(e.id)) then
        ashita.tasks.oncef(1, update_equipment_textures);
        return;
    end
end);

--[[
* event: d3d_beginscene
* desc : Event called when the Direct3D device is beginning a scene.
--]]
ashita.events.register('d3d_beginscene', 'beginscene_cb', function (isRenderingBackBuffer)
    if (not isRenderingBackBuffer) then return; end

    -- Update the background object..
    if (eqmon.background ~= nil) then
        if (not eqmon.settings.visible[1] or not eqmon.settings.background.visible) then
            eqmon.background.visible = false;
            return;
        end

        eqmon.background.visible = true;
        eqmon.background.position_x = eqmon.settings.x[1];
        eqmon.background.position_y = eqmon.settings.y[1];
        eqmon.background.width = ((32 * eqmon.settings.scale[1]) * 4)  + (eqmon.settings.padding[1] * 3);
        eqmon.background.height = ((32 * eqmon.settings.scale[1]) * 4)  + (eqmon.settings.padding[1] * 3);
    end
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    render_editor();

    if (eqmon.sprite == nil) then return; end

    -- Hide the equipmon object if not visible..
    if (not eqmon.settings.visible[1]) then
        return;
    end

    -- Hide the equipmon object if Ashita is currently hiding font objects..
    if (not AshitaCore:GetFontManager():GetVisible()) then
        return;
    end

    -- Prepare the opacity color..
    eqmon.settings.opacity[1] = math.clamp(eqmon.settings.opacity[1], 0.125, 1);
    local color = d3d.D3DCOLOR_ARGB(eqmon.settings.opacity[1] * 255, 255, 255, 255);

    -- Prepare the scaling vector..
    eqmon.vec_scale.x = eqmon.settings.scale[1];
    eqmon.vec_scale.y = eqmon.settings.scale[1];

    -- Render the equipment slots..
    eqmon.sprite:Begin();
    eqmon.slots:each(function (v)
        -- Calculate the current slot drawing position..
        eqmon.vec_position.x = (eqmon.settings.x[1] + v.x * eqmon.vec_scale.x + (eqmon.padding_weights[v.slot][1] * eqmon.settings.padding[1]));
        eqmon.vec_position.y = (eqmon.settings.y[1] + v.y * eqmon.vec_scale.y + (eqmon.padding_weights[v.slot][2] * eqmon.settings.padding[1]));

        -- Draw the slot background texture..
        if (eqmon.bg ~= nil and eqmon.settings.slots.show_bg[1]) then
            eqmon.sprite:Draw(eqmon.bg, eqmon.rect, eqmon.vec_scale, nil, 0.0, eqmon.vec_position, color);
        end

        -- Draw the slot item texture..
        if (v.texture ~= nil) then
            eqmon.sprite:Draw(v.texture, eqmon.rect, eqmon.vec_scale, nil, 0.0, eqmon.vec_position, color);
        end

        -- Draw the slot encumber status texture..
        if (eqmon.settings.slots.show_encumbrance[1] and bit.band(eqmon.encumber.flags, bit.lshift(1, v.slot)) > 0 and eqmon.encumber.texture ~= nil) then
            eqmon.sprite:Draw(eqmon.encumber.texture, eqmon.rect, eqmon.vec_scale, nil, 0.0, eqmon.vec_position, d3d.D3DCOLOR_ARGB(128, 255, 255, 255));
        end

        -- Update and render the slots ammo count..
        if (eqmon.settings.slots.show_ammo_count[1] and v.slot == 3) then
            local id, cnt = get_equipped_item(3);
            if (id ~= nil and cnt ~= nil and get_item_max_stack_size(id) > 1) then
                eqmon.font.text = cnt:str();

                -- Align the text to the bottom right corner of the object..
                local w, h = eqmon.font:get_text_size();
                eqmon.font.position_x = eqmon.vec_position.x + (32 * eqmon.vec_scale.x) - w - 1;
                eqmon.font.position_y = eqmon.vec_position.y + (32 * eqmon.vec_scale.y) - h + 2;
                eqmon.font:render();
            end
        end
    end);
    eqmon.sprite:End();
end);

--[[
* event: key
* desc : Event called when the addon is processing keyboard input. (WNDPROC)
--]]
ashita.events.register('key', 'key_callback', function (e)
    -- Key: VK_SHIFT
    if (e.wparam == 0x10) then
        eqmon.move.shift_down = not (bit.band(e.lparam, bit.lshift(0x8000, 0x10)) == bit.lshift(0x8000, 0x10));
        return;
    end
end);

--[[
* event: mouse
* desc : Event called when the addon is processing mouse input. (WNDPROC)
--]]
ashita.events.register('mouse', 'mouse_cb', function (e)
    -- Tests if the given coords are within the equipmon area.
    local function hit_test(x, y)
        local e_x = eqmon.settings.x[1];
        local e_y = eqmon.settings.y[1];
        local e_w = ((32 * eqmon.settings.scale[1]) * 4) + eqmon.settings.padding[1] * 3;
        local e_h = ((32 * eqmon.settings.scale[1]) * 4) + eqmon.settings.padding[1] * 3;

        return ((e_x <= x) and (e_x + e_w) >= x) and ((e_y <= y) and (e_y + e_h) >= y);
    end

    -- Returns if the equipmon object is being dragged.
    local function is_dragging() return eqmon.move.dragging; end

    -- Handle the various mouse messages..
    switch(e.message, {
        -- Event: Mouse Move
        [512] = (function ()
            eqmon.settings.x[1] = e.x - eqmon.move.drag_x;
            eqmon.settings.y[1] = e.y - eqmon.move.drag_y;

            e.blocked = true;
        end):cond(is_dragging),

        -- Event: Mouse Left Button Down
        [513] = (function ()
            if (eqmon.move.shift_down) then
                eqmon.move.dragging = true;
                eqmon.move.drag_x = e.x - eqmon.settings.x[1];
                eqmon.move.drag_y = e.y - eqmon.settings.y[1];

                e.blocked = true;
            end
        end):cond(hit_test:bindn(e.x, e.y)),

        -- Event: Mouse Left Button Up
        [514] = (function ()
            if (eqmon.move.dragging) then
                eqmon.move.dragging = false;

                settings.save();

                e.blocked = true;
            end
        end):cond(is_dragging),

        -- Event: Mouse Right Button Down
        [516] = (function ()
            eqmon.settings.slots.show_bg[1] = not eqmon.settings.slots.show_bg[1];

            settings.save();

            e.blocked = true;
        end):cond(hit_test:bindn(e.x, e.y)),

        -- Event: Mouse Right Button Up
        [517] = (function ()
            e.blocked = true;
        end):cond(hit_test:bindn(e.x, e.y)),

        -- Event: Mouse Wheel Scroll
        [522] = (function ()
            if (e.delta < 0) then
                eqmon.settings.opacity[1] = eqmon.settings.opacity[1] - 0.125;
            else
                eqmon.settings.opacity[1] = eqmon.settings.opacity[1] + 0.125;
            end
            eqmon.settings.opacity[1] = eqmon.settings.opacity[1]:clamp(0.125, 1);

            settings.save();

            e.blocked = true;
        end):cond(hit_test:bindn(e.x, e.y)),
    });
end);
