--[[
* Addons - Copyright (c) 2025 Ashita Development Team
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

---@meta

--[[
Note:   Ashita does not directly use all of ImGui's types to allow it to be compatible with various languages that may
        be used to create plugins. Additionally, Lua does not directly support all of the types used by ImGui directly
        such as pointers, references, direct callbacks, etc. Due to this, some types will be handled differently for
        certain ImGui calls while others will be normalized to a different type altogether.

        Not everything detailed in this file is currently implemented or implemented in a manner that is compatible
        with Lua. If you find something that is broken, incorrect, missing or if you find something that does not work
        that you wish to use, please submit a bug report to have it fixed.

        This file is based on the Ashita SDK ImGui header:
        https://github.com/AshitaXI/Ashita-v4beta/blob/main/plugins/sdk/imgui.h
--]]

--[[
ImGui Shorthand Types
--]]

---@alias ImGuiID number
---@alias ImS8 number
---@alias ImU8 number
---@alias ImS16 number
---@alias ImU16 number
---@alias ImS32 number
---@alias ImU32 number
---@alias ImS64 number
---@alias ImU64 number
---@alias ImWchar32 number
---@alias ImWchar16 number
---@alias ImWchar number

--[[
ImGui Types
--]]

---@alias ImGuiCol number
---@alias ImGuiCond number
---@alias ImGuiDataType number
---@alias ImGuiMouseButton number
---@alias ImGuiMouseCursor number
---@alias ImGuiStyleVar number
---@alias ImGuiTableBgTarget number

---@alias ImGuiSelectionUserData number
---@alias ImTextureID number

--[[
ImGui Enums
--]]

---@alias ImGuiDir number
---@alias ImGuiKey number
---@alias ImGuiMouseSource number
---@alias ImGuiSortDirection number

--[[
ImGui Flags
--]]

---@alias ImDrawFlags number
---@alias ImDrawListFlags number
---@alias ImFontFlags number
---@alias ImFontAtlasFlags number
---@alias ImGuiBackendFlags number
---@alias ImGuiButtonFlags number
---@alias ImGuiChildFlags number
---@alias ImGuiColorEditFlags number
---@alias ImGuiConfigFlags number
---@alias ImGuiComboFlags number
---@alias ImGuiDockNodeFlags number
---@alias ImGuiDragDropFlags number
---@alias ImGuiFocusedFlags number
---@alias ImGuiHoveredFlags number
---@alias ImGuiInputFlags number
---@alias ImGuiInputTextFlags number
---@alias ImGuiItemFlags number
---@alias ImGuiKeyChord number
---@alias ImGuiPopupFlags number
---@alias ImGuiMultiSelectFlags number
---@alias ImGuiSelectableFlags number
---@alias ImGuiSliderFlags number
---@alias ImGuiTabBarFlags number
---@alias ImGuiTabItemFlags number
---@alias ImGuiTableFlags number
---@alias ImGuiTableColumnFlags number
---@alias ImGuiTableRowFlags number
---@alias ImGuiTreeNodeFlags number
---@alias ImGuiViewportFlags number
---@alias ImGuiWindowFlags number

--[[
ImGui Structures
--]]

--[[
ImColor
--]]

---@class ImColor
---@field Value ImVec4
ImColor = {};

--[[
ImVec2
--]]

---@class ImVec2
---@field x number
---@field y number
ImVec2 = {};

--[[
ImVec4
--]]

---@class ImVec4
---@field x number
---@field y number
---@field z number
---@field w number
ImVec4 = {};

--[[
ImDrawChannel
--]]

---@class ImDrawChannel
---@field _CmdBuffer table
---@field _IdxBuffer table
ImDrawChannel = {};

--[[
ImDrawCmd
--]]

---@class ImDrawCmd
---@field ClipRect ImVec4
---@field TexRef ImTextureRef
---@field VtxOffset number
---@field IdxOffset number
---@field ElemCount number
---@field UserCallback ImDrawCallback
---@field UserCallbackData userdata
---@field UserCallbackDataSize number
---@field UserCallbackDataOffset number
ImDrawCmd = {};

---Returns the texture id.
---@param self ImDrawCmd
---@return ImTextureID
---@nodiscard
function ImDrawCmd:GetTexID() end

--[[
ImDrawCmdHeader
--]]

---@class ImDrawCmdHeader
---@field ClipRect ImVec4
---@field TexRef ImTextureRef
---@field VtxOffset number
ImDrawCmdHeader = {};

--[[
ImDrawData
--]]

---@class ImDrawData
---@field Valid boolean
---@field CmdListsCount number
---@field TotalIdxCount number
---@field TotalVtxCount number
---@field CmdLists table
---@field DisplayPos ImVec2
---@field DisplaySize ImVec2
---@field FramebufferScale ImVec2
---@field OwnerViewport ImGuiViewport
---@field Textures table
ImDrawData = {};

---Clears the draw data.
---@param self ImDrawData
function ImDrawData:Clear() end

---Adds a draw list.
---@param self ImDrawData
---@param draw_list ImDrawList
function ImDrawData:AddDrawList(draw_list) end

---Deindexes all buffers.
---@param self ImDrawData
function ImDrawData:DeIndexAllBuffers() end

---Scale the clip rects.
---@param self ImDrawData
---@param fb_scale ImVec2
function ImDrawData:ScaleClipRects(fb_scale) end

--[[
ImDrawListSharedData (Internal)
--]]

---@class ImDrawListSharedData
ImDrawListSharedData = {};

--[[
ImDrawListSplitter
--]]

---@class ImDrawListSplitter
---@field _Current number
---@field _Count number
---@field _Channels table
ImDrawListSplitter = {};

---Clears the splitter.
---@param self ImDrawListSplitter
function ImDrawListSplitter:Clear() end

---Clears free memory.
---@param self ImDrawListSplitter
function ImDrawListSplitter:ClearFreeMemory() end

---Split the draw list.
---@param self ImDrawListSplitter
---@param draw_list ImDrawList
---@param count number
function ImDrawListSplitter:Split(draw_list, count) end

---Merges the draw list.
---@param self ImDrawListSplitter
---@param draw_list ImDrawList
function ImDrawListSplitter:Merge(draw_list) end

---Sets the current channel.
---@param self ImDrawListSplitter
---@param draw_list ImDrawList
---@param channel_idx number
function ImDrawListSplitter:SetCurrentChannel(draw_list, channel_idx) end

--[[
ImDrawVert
--]]

---@class ImDrawVert
---@field pos ImVec2
---@field uv ImVec2
---@field col ImU32
ImDrawVert = {};

--[[
ImFont
--]]

---@class ImFont
---@field LastBaked ImFontBaked
---@field ContainerAtlas ImFontAtlas
---@field Flags ImFontFlags
---@field CurrentRasterizerDensity number
---@field FontId ImGuiID
---@field LegacySize number
---@field Sources table
---@field EllipsisChar ImWchar
---@field FallbackChar ImWchar
---@field Used8kPagesMap ImU8
---@field EllipsisAutoBake boolean
---@field RemapPairs ImGuiStorage
ImFont = {};

---Returns if the given glyph exists in the font.
---@param self ImFont
---@param c number
---@return boolean
---@nodiscard
function ImFont:IsGlyphInFont(c) end

---Returns if the font is loaded.
---@param self ImFont
---@return boolean
---@nodiscard
function ImFont:IsLoaded() end

---Returns the font debug name.
---@param self ImFont
---@return string
---@nodiscard
function ImFont:GetDebugName() end

---Returns the baked font.
---@param self ImFont
---@param font_size number
---@param density? number
---@return ImFontBaked
---@nodiscard
function ImFont:GetFontBaked(font_size, density) end

---Returns the calculated text size.
---@param self ImFont
---@param size number
---@param max_width number
---@param wrap_width number
---@param text_begin string
---@param text_end? string
---@param remaining? string
---@return ImVec2
---@nodiscard
function ImFont:CalcTextSizeA(size, max_width, wrap_width, text_begin, text_end, remaining) end

---Returns the word wrap position.
---@param self ImFont
---@param size number
---@param text string
---@param text_end string
---@param wrap_width number
---@return string
---@nodiscard
function ImFont:CalcWordWrapPosition(size, text, text_end, wrap_width) end

---Renders a character.
---@param self ImFont
---@param draw_list ImDrawList
---@param size number
---@param pos ImVec2
---@param col number
---@param c number
---@param cpu_fine_clip? ImVec4
function ImFont:RenderChar(draw_list, size, pos, col, c, cpu_fine_clip) end

---Renders text.
---@param self ImFont
---@param draw_list ImDrawList
---@param size number
---@param pos ImVec2
---@param col number
---@param clip_rect ImVec4
---@param text_begin string
---@param text_end string
---@param wrap_width? number
---@param cpu_fine_clip? ImVec4
function ImFont:RenderText(draw_list, size, pos, col, clip_rect, text_begin, text_end, wrap_width, cpu_fine_clip) end

---Clears the output data.
---@param self ImFont
function ImFont:ClearOutputData() end

---Adds a remapped char.
---@param self ImFont
---@param from_codepoint ImWchar
---@param to_codepoint ImWchar
function ImFont:AddRemapChar(from_codepoint, to_codepoint) end

---Returns if a glyph range is unused.
---@param self ImFont
---@param c_begin number
---@param c_end number
---@return boolean
---@nodiscard
function ImFont:IsGlyphRangeUnused(c_begin, c_end) end

--[[
ImFontAtlas
--]]

---@class ImFontAtlas
---@field Flags ImFontAtlasFlags
---@field TexDesiredFormat ImTextureFormat
---@field TexGlyphPadding number
---@field TexMinWidth number
---@field TexMinHeight number
---@field TexMaxWidth number
---@field TexMaxHeight number
---@field UserData userdata
---@field TexRef ImTextureRef
---@field TexData ImTextureData
---@field TexList table
---@field Locked boolean
---@field RendererHasTextures boolean
---@field TexIsBuilt boolean
---@field TexPixelsUseColors boolean
---@field TexUvScale ImVec2
---@field TexUvWhitePixel ImVec2
---@field Fonts table
---@field Sources table
---@field TexUvLines table
---@field TexNextUniqueID number
---@field FontNextUniqueID number
---@field DrawListSharedDatas table
---@field Builder ImFontAtlasBuilder*
---@field FontLoader ImFontLoader
---@field FontLoaderName string
---@field FontLoaderData userdata
---@field FontLoaderFlags number
---@field RefCount number
---@field OwnerContext ImGuiContext
ImFontAtlas = {};

---Adds a font.
---@param self ImFontAtlas
---@param font_cfg ImFontConfig
---@return ImFont
function ImFontAtlas:AddFont(font_cfg) end

---Adds a font. (Default)
---@param self ImFontAtlas
---@param font_cfg ImFontConfig
---@return ImFont
function ImFontAtlas:AddFontDefault(font_cfg) end

---Adds a font from file.
---@param self ImFontAtlas
---@param filename string
---@param size_pixels? number
---@param font_cfg? ImFontConfig
---@param glyph_ranges? userdata
---@return ImFont
function ImFontAtlas:AddFontFromFileTTF(filename, size_pixels, font_cfg, glyph_ranges) end

---Adds a font from memory.
---@param self ImFontAtlas
---@param font_data userdata
---@param font_data_size number
---@param size_pixels? number
---@param font_cfg? ImFontConfig
---@param glyph_ranges? userdata
---@return ImFont
function ImFontAtlas:AddFontFromMemoryTTF(font_data, font_data_size, size_pixels, font_cfg, glyph_ranges) end

---Adds a font from compressed memory.
---@param self ImFontAtlas
---@param compressed_font_data userdata
---@param compressed_font_data_size number
---@param size_pixels? number
---@param font_cfg? ImFontConfig
---@param glyph_ranges? userdata
---@return ImFont
function ImFontAtlas:AddFontFromMemoryCompressedTTF(compressed_font_data, compressed_font_data_size, size_pixels, font_cfg, glyph_ranges) end

---Adds a font from compressed base85 memory.
---@param self ImFontAtlas
---@param compressed_font_data_base85 string
---@param size_pixels? number
---@param font_cfg? ImFontConfig
---@param glyph_ranges? userdata
function ImFontAtlas:AddFontFromMemoryCompressedBase85TTF(compressed_font_data_base85, size_pixels, font_cfg, glyph_ranges) end

---Removes a font.
---@param self ImFontAtlas
---@param font ImFont
function ImFontAtlas:RemoveFont(font) end

---Clears the font atlas.
---@param self ImFontAtlas
function ImFontAtlas:Clear() end

---Compacts the font atlas cache.
---@param self ImFontAtlas
function ImFontAtlas:CompactCache() end

---Sets the font loader.
---@param self ImFontAtlas
---@param font_loader ImFontLoader
function ImFontAtlas:SetFontLoader(font_loader) end

---Clears the input data.
---@param self ImFontAtlas
function ImFontAtlas:ClearInputData() end

---Clears the fonts.
---@param self ImFontAtlas
function ImFontAtlas:ClearFonts() end

---Clears the tex data.
---@param self ImFontAtlas
function ImFontAtlas:ClearTexData() end

---Returns the default glyph ranges.
---@param self ImFontAtlas
---@return userdata
---@nodiscard
function ImFontAtlas:GetGlyphRangesDefault() end

---Adds a custom rect.
---@param self ImFontAtlas
---@param width number
---@param height number
---@param out_r? ImFontAtlasRect
---@return ImFontAtlasRectId
function ImFontAtlas:AddCustomRect(width, height, out_r) end

---Removes a custom rect.
---@param self ImFontAtlas
---@param id ImFontAtlasRectId
function ImFontAtlas:RemoveCustomRect(id) end

---Returns a custom rect.
---@param self ImFontAtlas
---@param id ImFontAtlasRectId
---@param out_r ImFontAtlasRect
---@return boolean
---@nodiscard
function ImFontAtlas:GetCustomRect(id, out_r) end

--[[
ImFontAtlasBuilder (Internal)
--]]

---@class ImFontAtlasBuilder
ImFontAtlasBuilder = {};

--[[
ImFontAtlasRect
--]]

---@class ImFontAtlasRect
---@field x number
---@field y number
---@field w number
---@field h number
---@field uv0 ImVec2
---@field uv1 ImVec2
ImFontAtlasRect = {};

--[[
ImFontBaked
--]]

---@class ImFontBaked
---@field IndexAdvanceX table
---@field FallbackAdvanceX number
---@field Size number
---@field RasterizerDensity number
---@field IndexLookup table
---@field Glyphs table
---@field FallbackGlyphIndex number
---@field Ascent number
---@field Descent number
---@field MetricsTotalSurface number
---@field WantDestroy number
---@field LoadNoFallback number
---@field LoadNoRenderOnLayout number
---@field LastUsedFrame number
---@field BakedId ImGuiID
---@field ContainerFont ImFont
---@field FontLoaderDatas userdata
ImFontBaked = {};

---Clears the output data.
---@param self ImFontBaked
function ImFontBaked:ClearOutputData() end

---Returns a glyph for the given character.
---@param self ImFontBaked
---@param c number
---@return ImFontGlyph
---@nodiscard
function ImFontBaked:FindGlyph(c) end

---Returns a glyph for the given character. (No fallback.)
---@param self ImFontBaked
---@param c number
---@return ImFontGlyph
---@nodiscard
function ImFontBaked:FindGlyphNoFallback(c) end

---Returns the given characters advance.
---@param self ImFontBaked
---@param c number
---@return number
---@nodiscard
function ImFontBaked:GetCharAdvance(c) end

---Returns if a glyph is loaded.
---@param self ImFontBaked
---@param c number
---@return boolean
---@nodiscard
function ImFontBaked:IsGlyphLoaded(c) end

--[[
ImFontConfig
--]]

---@class ImFontConfig
---@field Name string
---@field FontData userdata
---@field FontDataSize number
---@field FontDataOwnedByAtlas boolean
---@field MergeMode boolean
---@field PixelSnapH boolean
---@field PixelSnapV boolean
---@field OversampleH ImS8
---@field OversampleV ImS8
---@field EllipsisChar ImWchar
---@field SizePixels number
---@field GlyphRanges userdata
---@field GlyphExcludeRanges userdata
---@field GlyphOffset ImVec2
---@field GlyphMinAdvanceX number
---@field GlyphMaxAdvanceX number
---@field GlyphExtraAdvanceX number
---@field FontNo ImU32
---@field FontLoaderFlags number
---@field RasterizerMultiply number
---@field RasterizerDensity number
---@field Flags ImFontFlags
---@field DstFont ImFont
---@field FontLoader ImFontLoader
---@field FontLoaderData userdata
ImFontConfig = {};

--[[
ImFontGlyph
--]]

---@class ImFontGlyph
---@field Colored number
---@field Visible number
---@field SourceIdx number
---@field Codepoint number
---@field AdvanceX number
---@field X0 number
---@field Y0 number
---@field X1 number
---@field Y1 number
---@field U0 number
---@field V0 number
---@field U1 number
---@field V1 number
---@field PackId number
ImFontGlyph = {};

--[[
ImFontGlyphRangesBuilder
--]]

---@class ImFontGlyphRangesBuilder
---@field UsedChars table
ImFontGlyphRangesBuilder = {};

---Clears the used characters.
---@param self ImFontGlyphRangesBuilder
function ImFontGlyphRangesBuilder:Clear() end

---Returns the requested bit.
---@param self ImFontGlyphRangesBuilder
---@param n number
---@return number
---@nodiscard
function ImFontGlyphRangesBuilder:GetBit(n) end

---Sets the requested bit.
---@param self ImFontGlyphRangesBuilder
---@param n number
function ImFontGlyphRangesBuilder:SetBit(n) end

---Adds a character.
---@param self ImFontGlyphRangesBuilder
---@param c number
function ImFontGlyphRangesBuilder:AddChar(c) end

---Adds text.
---@param self ImFontGlyphRangesBuilder
---@param text string
function ImFontGlyphRangesBuilder:AddText(text) end

---Adds ranges.
---@param self ImFontGlyphRangesBuilder
---@param ranges userdata
function ImFontGlyphRangesBuilder:AddRanges(ranges) end

---Builds the ranges.
---@param self ImFontGlyphRangesBuilder
---@param out_ranges userdata
function ImFontGlyphRangesBuilder:BuildRanges(out_ranges) end

--[[
ImFontLoader (Internal)
--]]

---@class ImFontLoader
ImFontLoader = {};

--[[
ImTextureData
--]]

---@class ImTextureData
---@field UniqueID number
---@field Status ImTextureStatus
---@field BackendUserData userdata
---@field TexID ImTextureID
---@field Format ImTextureFormat
---@field Width number
---@field Height number
---@field BytesPerPixel number
---@field Pixels userdata
---@field UsedRect ImTextureRect
---@field UpdateRect ImTextureRect
---@field Updates table
---@field UnusedFrames number
---@field RefCount number
---@field UseColors boolean
---@field WantDestroyNextFrame boolean
ImTextureData = {};

---Creates the desired texture data.
---@param self ImTextureData
---@param format ImTextureFormat
---@param w number
---@param h number
function ImTextureData:Create(format, w, h) end

---Destroys the texture pixels.
---@param self ImTextureData
function ImTextureData:DestroyPixels() end

---Returns the pixels pointer.
---@param self ImTextureData
---@return userdata
---@nodiscard
function ImTextureData:GetPixels() end

---Returns the pixels pointer at a given point.
---@param self ImTextureData
---@param x number
---@param y number
---@return userdata
---@nodiscard
function ImTextureData:GetPixelsAt(x, y) end

---Returns the size of pixels.
---@param self ImTextureData
---@return number
---@nodiscard
function ImTextureData:GetSizeInBytes() end

---Returns the pitch.
---@param self ImTextureData
---@return number
---@nodiscard
function ImTextureData:GetPitch() end

---Returns the texture reference.
---@param self ImTextureData
---@return ImTextureRef
---@nodiscard
function ImTextureData:GetTexRef() end

---Returns the texture id.
---@param self ImTextureData
---@return number
---@nodiscard
function ImTextureData:GetTexID() end

---Sets the texture id.
---@param self ImTextureData
---@param tex_id number
function ImTextureData:SetTexID(tex_id) end

---Sets the texture status.
---@param self ImTextureData
---@param status ImTextureStatus
function ImTextureData:SetStatus(status) end

--[[
ImTextureRect
--]]

---@class ImTextureRect
---@field x number
---@field y number
---@field w number
---@field h number
ImTextureRect = {};

--[[
ImTextureRef
--]]

---@class ImTextureRef
---@field _TexData userdata
---@field _TexID ImTextureID
ImTextureRef = {};

---Returns the texture id.
---@param self ImTextureRef
---@return ImTextureID
---@nodiscard
function ImTextureRef:GetTexID() end

--[[
ImColor
--]]

---@class ImColor
---@field Value ImVec4
ImColor = {};

--[[
ImGuiContext (Internal)
--]]

---@class ImGuiContext
ImGuiContext = {};

--[[
ImGuiIO
--]]

---@class ImGuiIO
---@field ConfigFlags ImGuiConfigFlags
---@field BackendFlags ImGuiBackendFlags
---@field DisplaySize ImVec2
---@field DisplayFramebufferScale ImVec2
---@field DeltaTime number
---@field IniSavingRate number
---@field IniFilename string
---@field LogFilename string
---@field UserData userdata
---@field Fonts ImFontAtlas
---@field FontDefault ImFont
---@field FontAllowUserScaling boolean
---@field ConfigNavSwapGamepadButtons boolean
---@field ConfigNavMoveSetMousePos boolean
---@field ConfigNavCaptureKeyboard boolean
---@field ConfigNavEscapeClearFocusItem boolean
---@field ConfigNavEscapeClearFocusWindow boolean
---@field ConfigNavCursorVisibleAuto boolean
---@field ConfigNavCursorVisibleAlways boolean
---@field ConfigDockingNoSplit boolean
---@field ConfigDockingWithShift boolean
---@field ConfigDockingAlwaysTabBar boolean
---@field ConfigDockingTransparentPayload boolean
---@field ConfigViewportsNoAutoMerge boolean
---@field ConfigViewportsNoTaskBarIcon boolean
---@field ConfigViewportsNoDecoration boolean
---@field ConfigViewportsNoDefaultParent boolean
---@field ConfigViewportPlatformFocusSetsImGuiFocus boolean
---@field ConfigDpiScaleFonts boolean
---@field ConfigDpiScaleViewports boolean
---@field MouseDrawCursor boolean
---@field ConfigMacOSXBehaviors boolean
---@field ConfigInputTrickleEventQueue boolean
---@field ConfigInputTextCursorBlink boolean
---@field ConfigInputTextEnterKeepActive boolean
---@field ConfigDragClickToInputText boolean
---@field ConfigWindowsResizeFromEdges boolean
---@field ConfigWindowsMoveFromTitleBarOnly boolean
---@field ConfigWindowsCopyContentsWithCtrlC boolean
---@field ConfigScrollbarScrollByPage boolean
---@field ConfigMemoryCompactTimer number
---@field MouseDoubleClickTime number
---@field MouseDoubleClickMaxDist number
---@field MouseDragThreshold number
---@field KeyRepeatDelay number
---@field KeyRepeatRate number
---@field ConfigErrorRecovery boolean
---@field ConfigErrorRecoveryEnableAssert boolean
---@field ConfigErrorRecoveryEnableDebugLog boolean
---@field ConfigErrorRecoveryEnableTooltip boolean
---@field ConfigDebugIsDebuggerPresent boolean
---@field ConfigDebugHighlightIdConflicts boolean
---@field ConfigDebugHighlightIdConflictsShowItemPicker boolean
---@field ConfigDebugBeginReturnValueOnce boolean
---@field ConfigDebugBeginReturnValueLoop boolean
---@field ConfigDebugIgnoreFocusLoss boolean
---@field ConfigDebugIniSettings boolean
---@field BackendPlatformName string
---@field BackendRendererName string
---@field BackendPlatformUserData userdata
---@field BackendRendererUserData userdata
---@field BackendLanguageUserData userdata
---@field WantCaptureMouse boolean
---@field WantCaptureKeyboard boolean
---@field WantTextInput boolean
---@field WantSetMousePos boolean
---@field WantSaveIniSettings boolean
---@field NavActive boolean
---@field NavVisible boolean
---@field Framerate number
---@field MetricsRenderVertices number
---@field MetricsRenderIndices number
---@field MetricsRenderWindows number
---@field MetricsActiveWindows number
---@field MouseDelta ImVec2
---@field Ctx ImGuiContext
---@field MousePos ImVec2
---@field MouseDown table
---@field MouseWheel number
---@field MouseWheelH number
---@field MouseSource ImGuiMouseSource
---@field MouseHoveredViewport ImGuiID
---@field KeyCtrl boolean
---@field KeyShift boolean
---@field KeyAlt boolean
---@field KeySuper boolean
---@field KeyMods ImGuiKeyChord
---@field KeysData table
---@field WantCaptureMouseUnlessPopupClose boolean
---@field MousePosPrev ImVec2
---@field MouseClickedPos table
---@field MouseClickedTime table
---@field MouseClicked table
---@field MouseDoubleClicked table
---@field MouseClickedCount table
---@field MouseClickedLastCount table
---@field MouseReleased table
---@field MouseReleasedTime table
---@field MouseDownOwned table
---@field MouseDownOwnedUnlessPopupClose table
---@field MouseWheelRequestAxisSwap boolean
---@field MouseCtrlLeftAsRightClick boolean
---@field MouseDownDuration number
---@field MouseDownDurationPrev number
---@field MouseDragMaxDistanceAbs ImVec2
---@field MouseDragMaxDistanceSqr number
---@field PenPressure number
---@field AppFocusLost boolean
---@field AppAcceptingEvents boolean
---@field InputQueueSurrogate ImWchar16
---@field InputQueueCharacters table
ImGuiIO = {};

---Adds a key event.
---@param self ImGuiIO
---@param key ImGuiKey
---@param down boolean
function ImGuiIO:AddKeyEvent(key, down) end

---Adds a key analog event.
---@param self ImGuiIO
---@param key ImGuiKey
---@param down boolean
---@param val number
function ImGuiIO:AddKeyAnalogEvent(key, down, val) end

---Adds a mouse pos event.
---@param self ImGuiIO
---@param x number
---@param y number
function ImGuiIO:AddMousePosEvent(x, y) end

---Adds a mouse button event.
---@param self ImGuiIO
---@param button number
---@param down boolean
function ImGuiIO:AddMouseButtonEvent(button, down) end

---Adds a mouse wheel event.
---@param self ImGuiIO
---@param wheel_x number
---@param wheel_y number
function ImGuiIO:AddMouseWheelEvent(wheel_x, wheel_y) end

---Adds a mouse source event.
---@param self ImGuiIO
---@param source ImGuiMouseSource
function ImGuiIO:AddMouseSourceEvent(source) end

---Adds a mouse viewport event.
---@param self ImGuiIO
---@param id number
function ImGuiIO:AddMouseViewportEvent(id) end

---Adds a focus event.
---@param self ImGuiIO
---@param focused boolean
function ImGuiIO:AddFocusEvent(focused) end

---Adds an input character.
---@param self ImGuiIO
---@param ch number
function ImGuiIO:AddInputCharacter(ch) end

---Adds an input character. (UTF16)
---@param self ImGuiIO
---@param ch number
function ImGuiIO:AddInputCharacterUTF16(ch) end

---Adds input characters. (UTF8)
---@param self ImGuiIO
---@param text string
function ImGuiIO:AddInputCharactersUTF8(text) end

---Sets native key event data.
---@param self ImGuiIO
---@param key ImGuiKey
---@param native_keycode number
---@param native_scancode number
---@param native_legacy_index number
function ImGuiIO:SetKeyEventNativeData(key, native_keycode, native_scancode, native_legacy_index) end

---Sets the app accepting events flag.
---@param self ImGuiIO
---@param accepting_events boolean
function ImGuiIO:SetAppAcceptingEvents(accepting_events) end

---Clears the events queue.
---@param self ImGuiIO
function ImGuiIO:ClearEventsQueue() end

---Clears the keyboard inputs.
---@param self ImGuiIO
function ImGuiIO:ClearInputKeys() end

---Clears the mouse inputs.
---@param self ImGuiIO
function ImGuiIO:ClearInputMouse() end

--[[
ImGuiInputTextCallbackData
--]]

---@class ImGuiInputTextCallbackData
---@field Ctx ImGuiContext
---@field EventFlag ImGuiInputTextFlags
---@field Flags ImGuiInputTextFlags
---@field UserData userdata
---@field EventChar ImWchar
---@field EventKey ImGuiKey
---@field Buf userdata
---@field BufTextLen number
---@field BufSize number
---@field BufDirty boolean
---@field CursorPos number
---@field SelectionStart number
---@field SelectionEnd number
ImGuiInputTextCallbackData = {};

---Removes the desired number of characters at the given position.
---@param self ImGuiInputTextCallbackData
---@param pos number
---@param bytes_count number
function ImGuiInputTextCallbackData:DeleteChars(pos, bytes_count) end

---Inserts the given text at the given position.
---@param self ImGuiInputTextCallbackData
---@param pos number
---@param text string
function ImGuiInputTextCallbackData:InsertChars(pos, text) end

---Sets the selection to include all characters.
---@param self ImGuiInputTextCallbackData
function ImGuiInputTextCallbackData:SelectAll() end

---Clears the current selection.
---@param self ImGuiInputTextCallbackData
function ImGuiInputTextCallbackData:ClearSelection() end

---Returns if there are characters currently selected.
---@param self ImGuiInputTextCallbackData
---@return boolean
---@nodiscard
function ImGuiInputTextCallbackData:HasSelection() end

--[[
ImGuiKeyData
--]]

---@class ImGuiKeyData
---@field Down boolean
---@field DownDuration number
---@field DownDurationPrev number
---@field AnalogValue number
ImGuiKeyData = {};

--[[
ImGuiListClipper
--]]

---@class ImGuiListClipper
---@field Ctx ImGuiContext
---@field DisplayStart number
---@field DisplayEnd number
---@field ItemsCount number
---@field ItemsHeight number
---@field StartPosY number
---@field StartSeekOffsetY number
---@field TempData userdata
ImGuiListClipper = {};

---Begins clipping.
---@param self ImGuiListClipper
---@param items_count number
---@param items_height? number
function ImGuiListClipper:Begin(items_count, items_height) end

---Ends the clipping.
---@param self ImGuiListClipper
function ImGuiListClipper:End() end

---Steps the clipper.
---@param self ImGuiListClipper
---@return boolean
---@nodiscard
function ImGuiListClipper:Step() end

---Marks an item to be included in the clipping by its index.
---@param self ImGuiListClipper
---@param item_index number
function ImGuiListClipper:IncludeItemByIndex(item_index) end

---Marks a range of items to be included in the clipping.
---@param self ImGuiListClipper
---@param item_begin number
---@param item_end number
function ImGuiListClipper:IncludeItemsByIndex(item_begin, item_end) end

---Seeks the cursor to the given item index.
---@param self ImGuiListClipper
---@param item_index item_index
function ImGuiListClipper:SeekCursorForItem(item_index) end

--[[
ImGuiMultiSelectIO
--]]

---@class ImGuiMultiSelectIO
---@field Requests table
---@field RangeSrcItem ImGuiSelectionUserData
---@field NavIdItem ImGuiSelectionUserData
---@field NavIdSelected boolean
---@field RangeSrcReset boolean
---@field ItemsCount number
ImGuiMultiSelectIO = {};

--[[
ImGuiOnceUponAFrame
--]]

---@class ImGuiOnceUponAFrame
ImGuiOnceUponAFrame = {};

--[[
ImGuiPayload
--]]

---@class ImGuiPayload
---@field Data userdata
---@field DataSize number
---@field SourceId ImGuiID
---@field SourceParentId ImGuiID
---@field DataFrameCount number
---@field DataType table
---@field Preview boolean
---@field Delivery boolean
ImGuiPayload = {};

---Clears the payload.
---@param self ImGuiPayload
function ImGuiPayload:Clear() end

---Returns if the payload is the given type.
---@param self ImGuiPayload
---@param data_type string
---@return boolean
---@nodiscard
function ImGuiPayload:IsDataType(data_type) end

---Returns the payload preview flag.
---@param self ImGuiPayload
---@return boolean
---@nodiscard
function ImGuiPayload:IsPreview() end

---Returns the payload delivery flag.
---@param self ImGuiPayload
---@return boolean
---@nodiscard
function ImGuiPayload:IsDelivery() end

--[[
ImGuiPlatformIO
--]]

---@class ImGuiPlatformIO
---@field Platform_LocaleDecimalPoint ImWchar
---@field Renderer_TextureMaxWidth number
---@field Renderer_TextureMaxHeight number
---@field Renderer_RenderState userdata
---@field Monitors table
---@field Textures table
---@field Viewports table
ImGuiPlatformIO = {};

--[[
ImGuiPlatformImeData
--]]

---@class ImGuiPlatformImeData
---@field WantVisible boolean
---@field WantTextInput boolean
---@field InputPos ImVec2
---@field InputLineHeight number
---@field ViewportId ImGuiID
ImGuiPlatformImeData = {};

--[[
ImGuiPlatformMonitor
--]]

---@class ImGuiPlatformMonitor
---@field MainPos ImVec2
---@field MainSize ImVec2
---@field WorkPos ImVec2
---@field WorkSize ImVec2
---@field DpiScale number
---@field PlatformHandle userdata
ImGuiPlatformMonitor = {};

--[[
ImGuiSelectionBasicStorage
--]]

---@class ImGuiSelectionBasicStorage
---@field Size number
---@field PreserveOrder boolean
---@field UserData userdata
---@field _SelectionOrder number
---@field _Storage ImGuiStorage
ImGuiSelectionBasicStorage = {};

---Applies requests.
---@param self ImGuiSelectionBasicStorage
---@param ms_io ImGuiMultiSelectIO
function ImGuiSelectionBasicStorage:ApplyRequests(ms_io) end

---Returns if the storage contains the given id.
---@param self ImGuiSelectionBasicStorage
---@param id number
---@return boolean
---@nodiscard
function ImGuiSelectionBasicStorage:Contains(id) end

---Clears the storage.
---@param self ImGuiSelectionBasicStorage
function ImGuiSelectionBasicStorage:Clear() end

---Swaps the storage.
---@param self ImGuiSelectionBasicStorage
---@param r ImGuiSelectionBasicStorage
function ImGuiSelectionBasicStorage:Swap(r) end

---Sets the selected item.
---@param self ImGuiSelectionBasicStorage
---@param id number
---@param selected boolean
function ImGuiSelectionBasicStorage:SetItemSelected(id, selected) end

---Returns the next selected item.
---@param self ImGuiSelectionBasicStorage
---@param opaque_it userdata
---@param out_id userdata
---@return boolean
---@nodiscard
function ImGuiSelectionBasicStorage:GetNextSelectedItem(opaque_it, out_id) end

---Returns the storage id for the given index.
---@param self ImGuiSelectionBasicStorage
---@param idx number
---@return number
---@nodiscard
function ImGuiSelectionBasicStorage:GetStorageIdFromIndex(idx) end

--[[
ImGuiSelectionExternalStorage
--]]

---@class ImGuiSelectionExternalStorage
---@field UserData userdata
ImGuiSelectionExternalStorage = {};

---Applies requests.
---@param self ImGuiSelectionExternalStorage
---@param ms_io ImGuiMultiSelectIO
function ImGuiSelectionExternalStorage:ApplyRequests(ms_io) end

--[[
ImGuiSelectionRequest
--]]

---@class ImGuiSelectionRequest
---@field Type ImGuiSelectionRequestType
---@field Selected boolean
---@field RangeDirection ImS8
---@field RangeFirstItem ImGuiSelectionUserData
---@field RangeLastItem ImGuiSelectionUserData
ImGuiSelectionRequest = {};

--[[
ImGuiSizeCallbackData
--]]

---@class ImGuiSizeCallbackData
---@field UserData userdata
---@field Pos ImVec2
---@field CurrentSize ImVec2
---@field DesiredSize ImVec2
ImGuiSizeCallbackData = {};

--[[
ImGuiStorage
--]]

---@class ImGuiStorage
ImGuiStorage = {};

---Clears the storage data.
function ImGuiStorage:Clear() end

---Returns an int value.
---@param self ImGuiStorage
---@param key number
---@param default_val? number
---@return number
---@nodiscard
function ImGuiStorage:GetInt(key, default_val) end

---Sets an int value.
---@param self ImGuiStorage
---@param key number
---@param val number
function ImGuiStorage:SetInt(key, val) end

---Returns a boolean value.
---@param self ImGuiStorage
---@param key number
---@param default_val? boolean
---@return boolean
---@nodiscard
function ImGuiStorage:GetBool(key, default_val) end

---Sets a boolean value.
---@param self ImGuiStorage
---@param key number
---@param val boolean
function ImGuiStorage:SetBool(key, val) end

---Returns a float value.
---@param self ImGuiStorage
---@param key number
---@param default_val? number
---@return number
---@nodiscard
function ImGuiStorage:GetFloat(key, default_val) end

---Sets a float value.
---@param self ImGuiStorage
---@param key number
---@param val number
function ImGuiStorage:SetFloat(key, val) end

---Gets a pointer value.
---@param self ImGuiStorage
---@return userdata
---@nodiscard
function ImGuiStorage:GetVoidPtr(key) end

---Sets a pointer value.
---@param self ImGuiStorage
---@param key number
---@param val userdata
function ImGuiStorage:SetVoidPtr(key, val) end

---Returns an int ref.
---@param self ImGuiStorage
---@param key number
---@param default_val number
---@return number
---@nodiscard
function ImGuiStorage:GetIntRef(key, default_val) end

---Returns a boolean ref.
---@param self ImGuiStorage
---@param key number
---@param default_val boolean
---@return boolean
---@nodiscard
function ImGuiStorage:GetBoolRef(key, default_val) end

---Returns a float ref.
---@param self ImGuiStorage
---@param key number
---@param default_val number
---@return number
---@nodiscard
function ImGuiStorage:GetFloatRef(key, default_val) end

---Builds and sorts the storage by keys.
---@param self ImGuiStorage
function ImGuiStorage:BuildSortByKey() end

---Sets all values.
---@param self ImGuiStorage
---@param val number
function ImGuiStorage:SetAllInt(val) end

--[[
ImGuiStoragePair
--]]

---@class ImGuiStoragePair
---@field key ImGuiID
ImGuiStoragePair = {};

--[[
ImGuiStyle
--]]

---@class ImGuiStyle
---@field FontSizeBase number
---@field FontScaleMain number
---@field FontScaleDpi number
---@field Alpha number
---@field DisabledAlpha number
---@field WindowPadding ImVec2
---@field WindowRounding number
---@field WindowBorderSize number
---@field WindowBorderHoverPadding number
---@field WindowMinSize ImVec2
---@field WindowTitleAlign ImVec2
---@field WindowMenuButtonPosition ImGuiDir
---@field ChildRounding number
---@field ChildBorderSize number
---@field PopupRounding number
---@field PopupBorderSize number
---@field FramePadding ImVec2
---@field FrameRounding number
---@field FrameBorderSize number
---@field ItemSpacing ImVec2
---@field ItemInnerSpacing ImVec2
---@field CellPadding ImVec2
---@field TouchExtraPadding ImVec2
---@field IndentSpacing number
---@field ColumnsMinSpacing number
---@field ScrollbarSize number
---@field ScrollbarRounding number
---@field ScrollbarPadding number
---@field GrabMinSize number
---@field GrabRounding number
---@field LogSliderDeadzone number
---@field ImageBorderSize number
---@field TabRounding number
---@field TabBorderSize number
---@field TabMinWidthBase number
---@field TabMinWidthShrink number
---@field TabCloseButtonMinWidthSelected number
---@field TabCloseButtonMinWidthUnselected number
---@field TabBarBorderSize number
---@field TabBarOverlineSize number
---@field TableAngledHeadersAngle number
---@field TableAngledHeadersTextAlign ImVec2
---@field TreeLinesFlags ImGuiTreeNodeFlags
---@field TreeLinesSize number
---@field TreeLinesRounding number
---@field ColorButtonPosition ImGuiDir
---@field ButtonTextAlign ImVec2
---@field SelectableTextAlign ImVec2
---@field SeparatorTextBorderSize number
---@field SeparatorTextAlign ImVec2
---@field SeparatorTextPadding ImVec2
---@field DisplayWindowPadding ImVec2
---@field DisplaySafeAreaPadding ImVec2
---@field DockingSeparatorSize number
---@field MouseCursorScale number
---@field AntiAliasedLines boolean
---@field AntiAliasedLinesUseTex boolean
---@field AntiAliasedFill boolean
---@field CurveTessellationTol number
---@field CircleTessellationMaxError number
---@field Colors table
---@field HoverStationaryDelay number
---@field HoverDelayShort number
---@field HoverDelayNormal number
---@field HoverFlagsForTooltipMouse ImGuiHoveredFlags
---@field HoverFlagsForTooltipNav ImGuiHoveredFlags
---@field _MainScale number
---@field _NextFrameFontSizeBase number
ImGuiStyle = {};

---Scales all sizes.
---@param self ImGuiStyle
---@param scale_factor number
function ImGuiStyle:ScaleAllSizes(scale_factor) end

--[[
ImGuiTableSortSpecs
--]]

---@class ImGuiTableSortSpecs
---@field Specs ImGuiTableColumnSortSpecs
---@field SpecsCount number
---@field SpecsDirty boolean
ImGuiTableSortSpecs = {};

--[[
ImGuiTableColumnSortSpecs
--]]

---@class ImGuiTableColumnSortSpecs
---@field ColumnUserID ImGuiID
---@field ColumnIndex ImS16
---@field SortOrder ImS16
---@field SortDirection ImGuiSortDirection
ImGuiTableColumnSortSpecs = {};

--[[
ImGuiTextBuffer
--]]

---@class ImGuiTextBuffer
---@field Buf table
ImGuiTextBuffer = {};

---Returns the start of the buffer.
---@param self ImGuiTextBuffer
---@return string
---@nodiscard
function ImGuiTextBuffer:begin() end

---Returns the end of the buffer.
---@param self ImGuiTextBuffer
---@return string
---@nodiscard
function ImGuiTextBuffer:end() end

---Returns the size of the buffer.
---@param self ImGuiTextBuffer
---@return number
---@nodiscard
function ImGuiTextBuffer:size() end

---Returns if the buffer is empty.
---@param self ImGuiTextBuffer
---@return boolean
---@nodiscard
function ImGuiTextBuffer:empty() end

---Clears the buffer.
---@param self ImGuiTextBuffer
function ImGuiTextBuffer:clear() end

---Resizes the buffer.
---@param self ImGuiTextBuffer
---@param size number
function ImGuiTextBuffer:resize(size) end

---Reserves the needed capacity in the buffer.
---@param self ImGuiTextBuffer
---@param capacity number
function ImGuiTextBuffer:reserve(capacity) end

---Returns the buffer string.
---@param self ImGuiTextBuffer
---@return string
---@nodiscard
function ImGuiTextBuffer:c_str() end

---Appends a string to the buffer.
---@param self ImGuiTextBuffer
---@param text string
function ImGuiTextBuffer:append(text) end

--[[
ImGuiTextFilter
--]]

---@class ImGuiTextFilter
---@field InputBuf table
---@field Filters table
---@field CountGrep number
ImGuiTextFilter = {};

---Draws the text filter.
---@param self ImGuiTextFilter
---@param label? string
---@param width? number
---@return boolean
function ImGuiTextFilter:Draw(label, width) end

---Returns if the given text passes the filter.
---@param self ImGuiTextFilter
---@param label string
---@return boolean
---@nodiscard
function ImGuiTextFilter:PassFilter(text) end

---Builds the filter.
---@param self ImGuiTextFilter
function ImGuiTextFilter:Build() end

---Clears the filter.
---@param self ImGuiTextFilter
function ImGuiTextFilter:Clear() end

---Returns if the filter is active.
---@param self ImGuiTextFilter
---@return boolean
---@nodiscard
function ImGuiTextFilter:IsActive() end

--[[
ImGuiViewport
--]]

---@class ImGuiViewport
---@field ID ImGuiID
---@field Flags ImGuiViewportFlags
---@field Pos ImVec2
---@field Size ImVec2
---@field FramebufferScale ImVec2
---@field WorkPos ImVec2
---@field WorkSize ImVec2
---@field DpiScale number
---@field ParentViewportId ImGuiID
---@field DrawData ImDrawData
---@field RendererUserData userdata
---@field PlatformUserData userdata
---@field PlatformHandle userdata
---@field PlatformHandleRaw userdata
---@field PlatformWindowCreated boolean
---@field PlatformRequestMove boolean
---@field PlatformRequestResize boolean
---@field PlatformRequestClose boolean
ImGuiViewport = {};

---Returns the viewport center.
---@param self ImGuiViewport
---@return ImVec2
---@nodiscard
function ImGuiViewport:GetCenter() end

---Returns the viewport work center.
---@param self ImGuiViewport
---@return ImVec2
---@nodiscard
function ImGuiViewport:GetWorkCenter() end

--[[
ImGuiWindowClass
--]]

---@class ImGuiWindowClass
---@field ClassId ImGuiID
---@field ParentViewportId ImGuiID
---@field FocusRouteParentWindowId ImGuiID
---@field ViewportFlagsOverrideSet ImGuiViewportFlags
---@field ViewportFlagsOverrideClear ImGuiViewportFlags
---@field TabItemFlagsOverrideSet ImGuiTabItemFlags
---@field DockNodeFlagsOverrideSet ImGuiDockNodeFlags
---@field DockingAlwaysTabBar boolean
---@field DockingAllowUnclassed boolean
ImGuiWindowClass = {};

--[[
ImDrawList
--]]

---@class ImDrawList
---@field CmdBuffer table
---@field IdxBuffer table
---@field VtxBuffer table
---@field Flags ImDrawListFlags
---@field _VtxCurrentIdx number
---@field _Data ImDrawListSharedData
---@field _VtxWritePtr ImDrawVert
---@field _IdxWritePtr ImDrawIdx
---@field _Path table
---@field _CmdHeader ImDrawCmdHeader
---@field _Splitter ImDrawListSplitter
---@field _ClipRectStack table
---@field _TextureStack table
---@field _CallbacksDataBuf table
---@field _FringeScale number
---@field _OwnerName string
ImDrawList = {};

---Pushes a clip rect to the draw list.
---@param self ImDrawList
---@param clip_rect_min table
---@param clip_rect_max table
---@param intersect_with_current_clip_rect? boolean
function ImDrawList:PushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect) end

---Pushes a clip rect to the draw list. (Fullscreen)
---@param self ImDrawList
function ImDrawList:PushClipRectFullScreen() end

---Pops a clip rect from the draw list.
---@param self ImDrawList
function ImDrawList:PopClipRect() end

---Pushes a texture to the draw list.
---@param self ImDrawList
---@param texture_ref number
function ImDrawList:PushTexture(texture_ref) end

---Pops a texture from the draw list.
---@param self ImDrawList
function ImDrawList:PopTexture() end

---Returns the draw list minimum clip rect. (Top Left)
---@param self ImDrawList
---@return number x
---@return number y
---@nodiscard
function ImDrawList:GetClipRectMin() end

---Returns the draw list maximum clip rect. (Bottom Right)
---@param self ImDrawList
---@return number x
---@return number y
---@nodiscard
function ImDrawList:GetClipRectMax() end

---Adds a line to the draw list.
---@param self ImDrawList
---@param p1 table
---@param p2 table
---@param col number
---@param thickness? number
function ImDrawList:AddLine(p1, p2, col, thickness) end

---Adds a rect to the draw list.
---@param self ImDrawList
---@param p_min table
---@param p_max table
---@param col number
---@param rounding? number
---@param flags? number
---@param thickness? number
function ImDrawList:AddRect(p_min, p_max, col, rounding, flags, thickness) end

---Adds a filled rect to the draw list.
---@param self ImDrawList
---@param p_min table
---@param p_max table
---@param col number
---@param rounding? number
---@param flags? number
function ImDrawList:AddRectFilled(p_min, p_max, col, rounding, flags) end

---Adds a filled multi color rect to the draw list.
---@param self ImDrawList
---@param p_min table
---@param p_max table
---@param col_upr_left number
---@param col_upr_right number
---@param col_bot_right number
---@param col_bot_left number
function ImDrawList:AddRectFilledMultiColor(p_min, p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left) end

---Adds a quad to the draw list.
---@param self ImDrawList
---@param p1 table
---@param p2 table
---@param p3 table
---@param p4 table
---@param col number
---@param thickness? number
function ImDrawList:AddQuad(p1, p2, p3, p4, col, thickness) end

---Adds a filled quad to the draw list.
---@param self ImDrawList
---@param p1 table
---@param p2 table
---@param p3 table
---@param p4 table
---@param col number
function ImDrawList:AddQuadFilled(p1, p2, p3, p4, col) end

---Adds a triangle to the draw list.
---@param self ImDrawList
---@param p1 table
---@param p2 table
---@param p3 table
---@param col number
---@param thickness? number
function ImDrawList:AddTriangle(p1, p2, p3, col, thickness) end

---Adds a filled triangle to the draw list.
---@param self ImDrawList
---@param p1 table
---@param p2 table
---@param p3 table
---@param col number
function ImDrawList:AddTriangleFilled(p1, p2, p3, col) end

---Adds a circle to the draw list.
---@param self ImDrawList
---@param center table
---@param radius number
---@param col number
---@param num_segments? number
---@param thickness? number
function ImDrawList:AddCircle(center, radius, col, num_segments, thickness) end

---Adds a to the draw list.
---@param self ImDrawList
---@param center table
---@param radius number
---@param col number
---@param num_segments? number
function ImDrawList:AddCircleFilled(center, radius, col, num_segments) end

---Adds an ngon to the draw list.
---@param self ImDrawList
---@param center table
---@param radius number
---@param col number
---@param num_segments number
---@param thickness? number
function ImDrawList:AddNgon(center, radius, col, num_segments, thickness) end

---Adds a filled ngon to the draw list.
---@param self ImDrawList
---@param center table
---@param radius number
---@param col number
---@param num_segments number
function ImDrawList:AddNgonFilled(center, radius, col, num_segments) end

---Adds an ellipse to the draw list.
---@param self ImDrawList
---@param center table
---@param radius table
---@param col number
---@param rot? number
---@param num_segments? number
---@param thickness? number
function ImDrawList:AddEllipse(center, radius, col, rot, num_segments, thickness) end

---Adds a filled ellipse to the draw list.
---@param self ImDrawList
---@param center table
---@param radius table
---@param col number
---@param rot? number
---@param num_segments? number
function ImDrawList:AddEllipseFilled(center, radius, col, rot, num_segments) end

---Adds text to the draw list.
---@param self ImDrawList
---@param pos table
---@param col number
---@param text string
function ImDrawList:AddText(pos, col, text) end

---Adds text to the draw list.
---@param self ImDrawList
---@param font ImFont
---@param font_size number
---@param pos table
---@param col number
---@param text string
---@param wrap_width? number
---@param cpu_fine_clip? table
function ImDrawList:AddText(font, font_size, pos, col, text, wrap_width, cpu_fine_clip) end

---Adds a bezier cubic to the draw list.
---@param self ImDrawList
---@param p1 table
---@param p2 table
---@param p3 table
---@param p4 table
---@param col number
---@param thickness number
---@param num_segments? number
function ImDrawList:AddBezierCubic(p1, p2, p3, p4, col, thickness, num_segments) end

---Adds a bezier quadratic to the draw list.
---@param self ImDrawList
---@param p1 table
---@param p2 table
---@param p3 table
---@param col number
---@param thickness number
---@param num_segments? number
function ImDrawList:AddBezierQuadratic(p1, p2, p3, col, thickness, num_segments) end

---Adds a polyline to the draw list.
---@param self ImDrawList
---@param points table
---@param num_points number
---@param col number
---@param flags number
---@param thickness number
function ImDrawList:AddPolyline(points, num_points, col, flags, thickness) end

---Adds a filled convex poly to the draw list.
---@param self ImDrawList
---@param points table
---@param num_points number
---@param col number
function ImDrawList:AddConvexPolyFilled(points, num_points, col) end

---Adds a filled concave poly to the draw list.
---@param self ImDrawList
---@param points table
---@param num_points number
---@param col number
function ImDrawList:AddConcavePolyFilled(points, num_points, col) end

---Adds an image to the draw list.
---@param self ImDrawList
---@param tex_ref number
---@param p_min table
---@param p_max table
---@param uv_min? table
---@param uv_max? table
---@param col? number
function ImDrawList:AddImage(tex_ref, p_min, p_max, uv_min, uv_max, col) end

---Adds an image quad to the draw list.
---@param self ImDrawList
---@param tex_ref number
---@param p1 table
---@param p2 table
---@param p3 table
---@param p4 table
---@param uv1? table
---@param uv2? table
---@param uv3? table
---@param uv4? table
---@param col? number
function ImDrawList:AddImageQuad(tex_ref, p1, p2, p3, p4, uv1, uv2, uv3, uv4, col) end

---Adds a rounded image to the draw list.
---@param self ImDrawList
---@param tex_ref number
---@param p_min table
---@param p_max table
---@param uv_min table
---@param uv_max table
---@param col number
---@param rounding number
---@param flags? number
function ImDrawList:AddImageRounded(tex_ref, p_min, p_max, uv_min, uv_max, col, rounding, flags) end

---Clears the current path.
---@param self ImDrawList
function ImDrawList:PathClear() end

---Adds a line to the current path.
---@param self ImDrawList
---@param pos table
function ImDrawList:PathLineTo(pos) end

---Adds a line to the current path. (Checks last entry for duplicate.)
---@param self ImDrawList
---@param pos table
function ImDrawList:PathLineToMergeDuplicate(pos) end

---Commits the current path, filling it. (Convex)
---@param self ImDrawList
---@param col number
function ImDrawList:PathFillConvex(col) end

---Commits the current path, filling it. (Concave)
---@param self ImDrawList
---@param col number
function ImDrawList:PathFillConcave(col) end

---Commits the current path. (Stroke)
---@param self ImDrawList
---@param col number
---@param flags? number
---@param thickness? number
function ImDrawList:PathStroke(col, flags, thickness) end

---Adds an arc to the current path.
---@param self ImDrawList
---@param center table
---@param radius number
---@param a_min number
---@param a_max number
---@param num_segments? number
function ImDrawList:PathArcTo(center, radius, a_min, a_max, num_segments) end

---Adds an arc to the current path. (Fast)
---@param self ImDrawList
---@param center table
---@param radius number
---@param a_min_of_12 number
---@param a_max_of_12 number
function ImDrawList:PathArcToFast(center, radius, a_min_of_12, a_max_of_12) end

---Adds an elliptical arc to the current path.
---@param self ImDrawList
---@param center table
---@param radius table
---@param rot number
---@param a_min number
---@param a_max number
---@param num_segments? number
function ImDrawList:PathEllipticalArcTo(center, radius, rot, a_min, a_max, num_segments) end

---Adds a bezier cubic curve to the current path.
---@param self ImDrawList
---@param p2 table
---@param p3 table
---@param p4 table
---@param num_segments? number
function ImDrawList:PathBezierCubicCurveTo(p2, p3, p4, num_segments) end

---Adds a bezier quadratic curve to the current path.
---@param self ImDrawList
---@param p2 table
---@param p3 table
---@param num_segments? number
function ImDrawList:PathBezierQuadraticCurveTo(p2, p3, num_segments) end

---Adds a rect to the current path.
---@param self ImDrawList
---@param rect_min table
---@param rect_max table
---@param rounding? number
---@param flags? number
function ImDrawList:PathRect(rect_min, rect_max, rounding, flags) end

--AddCallback
--AddDrawCmd
--CloneOutput
--ChannelsSplit
--ChannelsMerge
--ChannelsSetCurrent

---Reserves space for the requested indices and vertices.
---@param self ImDrawList
---@param idx_count number
---@param vtx_count number
function ImDrawList:PrimReserve(idx_count, vtx_count) end

---Releases the given number of indices and vertices.
---@param self ImDrawList
---@param idx_count number
---@param vtx_count number
function ImDrawList:PrimUnreserve(idx_count, vtx_count) end

---Adds a rect to the current vertices.
---@param self ImDrawList
---@param a table
---@param b table
---@param col number
function ImDrawList:PrimRect(a, b, col) end

---Adds a textured rect to the current vertices.
---@param self ImDrawList
---@param a table
---@param b table
---@param uv_a table
---@param uv_b table
---@param col number
function ImDrawList:PrimRectUV(a, b, uv_a, uv_b, col) end

---Adds a textured quad to the current vertices.
---@param self ImDrawList
---@param a table
---@param b table
---@param c table
---@param d table
---@param uv_a table
---@param uv_b table
---@param uv_c table
---@param uv_d table
---@param col number
function ImDrawList:PrimQuadUV(a, b, c, d, uv_a, uv_b, uv_c, uv_d, col) end

---Adds a vertex to the current vertices.
---@param self ImDrawList
---@param pos table
---@param uv table
---@param col number
function ImDrawList:PrimWriteVtx(pos, uv, col) end

---Adds an index to the current indices.
---@param self ImDrawList
---@param idx number
function ImDrawList:PrimWriteIdx(idx) end

---Adds a vertex (with a unique index) to the current vertices.
---@param self ImDrawList
---@param pos table
---@param uv table
---@param col number
function ImDrawList:PrimVtx(pos, uv, col) end

--_SetDrawListSharedData
--_ResetForNewFrame
--_ClearFreeMemory
--_PopUnusedDrawCmd
--_TryMergeDrawCmds
--_OnChangedClipRect
--_OnChangedTexture
--_OnChangedVtxOffset
--_SetTexture
--_CalcCircleAutoSegmentCount
--_PathArcToFastEx
--_PathArcToN