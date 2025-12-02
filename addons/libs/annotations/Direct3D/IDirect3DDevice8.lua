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

---@class IDirect3DDevice8
IDirect3DDevice8 = {};

--[[
IUnknown Interface
--]]

---Determines whether the object supports a particular COM interface.
---@param self IDirect3DDevice8
---@param riid ffi.cdata*
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:QueryInterface(riid) end

---Increases the reference count of the object by 1.
---@param self IDirect3DDevice8
---@return number
function IDirect3DDevice8:AddRef() end

---Decreases the reference count of the object by 1.
---@param self IDirect3DDevice8
---@return number
function IDirect3DDevice8:Release() end

--[[
IDirect3DDevice8 Interface
--]]

---Reports the current cooperative-level status of the device for a windowed or full-screen application.
---@param self IDirect3DDevice8
---@return number
function IDirect3DDevice8:TestCooperativeLevel() end

---Returns an estimate of the amount of available texture memory.
---@param self IDirect3DDevice8
---@return number
function IDirect3DDevice8:GetAvailableTextureMem() end

---Invokes the resource manager to free memory.
---@param self IDirect3DDevice8
---@param Bytes number
---@return number
function IDirect3DDevice8:ResourceManagerDiscardBytes(Bytes) end

---Returns an interface to the instance of the Microsoft® Direct3D® object that created the device.
---@param self IDirect3DDevice8
---@return number
---@return IDirect3D8|nil
function IDirect3DDevice8:GetDirect3D() end

---Retrieves the capabilities of the rendering device.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetDeviceCaps() end

---Retrieves the display mode's spatial resolution, color resolution, and refresh frequency.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetDisplayMode() end

---Retrieves the creation parameters of the device.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetCreationParameters() end

---Sets properties for the cursor.
---@param self IDirect3DDevice8
---@param XHotSpot number
---@param YHotSpot number
---@param pCursorBitmap? IDirect3DSurface8
---@return number
function IDirect3DDevice8:SetCursorProperties(XHotSpot, YHotSpot, pCursorBitmap) end

---Sets the cursor position and update options.
---@param self IDirect3DDevice8
---@param X number
---@param Y number
---@param Flags number
function IDirect3DDevice8:SetCursorPosition(X, Y, Flags) end

---Displays or hides the cursor.
---@param self IDirect3DDevice8
---@param bShow boolean
---@return boolean
function IDirect3DDevice8:ShowCursor(bShow) end

---Creates an additional swap chain for rendering multiple views.
---@param self IDirect3DDevice8
---@param pPresentationParameters ffi.cdata*
---@return number
---@return IDirect3DSwapChain8|nil
function IDirect3DDevice8:CreateAdditionalSwapChain(pPresentationParameters) end

---Not implemented.
---
---**WARNING:** DO NOT CALL THIS!
---@param self IDirect3DDevice8
---@deprecated
function IDirect3DDevice8:Reset() end

---Presents the contents of the next in the sequence of back buffers owned by the device.
---@param self IDirect3DDevice8
---@param pSourceRect? ffi.cdata*
---@param pDestRect? ffi.cdata*
---@param hDestWindowOverride? ffi.cdata*
---@param pDirtyRegion? ffi.cdata*
---@return number
function IDirect3DDevice8:Present(pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion) end

---Retrieves a back buffer from the device's swap chain.
---@param self IDirect3DDevice8
---@param BackBuffer number
---@param Type number
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DDevice8:GetBackBuffer(BackBuffer, Type) end

---Returns information describing the raster of the monitor on which the swap chain is presented.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetRasterStatus() end

---Sets the gamma correction ramp for the implicit swap chain.
---@param self IDirect3DDevice8
---@param Flags number
---@param pRamp ffi.cdata*
function IDirect3DDevice8:SetGammaRamp(Flags, pRamp) end

---Retrieves the gamma correction ramp for the swap chain.
---@param self IDirect3DDevice8
---@return ffi.cdata*
function IDirect3DDevice8:GetGammaRamp() end

---Creates a texture resource.
---@param self IDirect3DDevice8
---@param Width number
---@param Height number
---@param Levels number
---@param Usage number
---@param Format number
---@param Pool number
---@return number
---@return IDirect3DTexture8|nil
function IDirect3DDevice8:CreateTexture(Width, Height, Levels, Usage, Format, Pool) end

---Creates a volume texture resource.
---@param self IDirect3DDevice8
---@param Width number
---@param Height number
---@param Depth number
---@param Levels number
---@param Usage number
---@param Format number
---@param Pool number
---@return number
---@return IDirect3DVolumeTexture8|nil
function IDirect3DDevice8:CreateVolumeTexture(Width, Height, Depth, Levels, Usage, Format, Pool) end

---Creates a cube texture resource.
---@param self IDirect3DDevice8
---@param EdgeLength number
---@param Levels number
---@param Usage number
---@param Format number
---@param Pool number
---@return number
---@return IDirect3DCubeTexture8|nil
function IDirect3DDevice8:CreateCubeTexture(EdgeLength, Levels, Usage, Format, Pool) end

---Creates a vertex buffer.
---@param self IDirect3DDevice8
---@param Length number
---@param Usage number
---@param FVF number
---@param Pool number
---@return number
---@return IDirect3DVertexBuffer8|nil
function IDirect3DDevice8:CreateVertexBuffer(Length, Usage, FVF, Pool) end

---Creates an index buffer.
---@param self IDirect3DDevice8
---@param Length number
---@param Usage number
---@param Format number
---@param Pool number
---@return number
---@return IDirect3DIndexBuffer8|nil
function IDirect3DDevice8:CreateIndexBuffer(Length, Usage, Format, Pool) end

---Creates a render target surface.
---@param self IDirect3DDevice8
---@param Width number
---@param Height number
---@param Format number
---@param MultiSample number
---@param Lockable boolean
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DDevice8:CreateRenderTarget(Width, Height, Format, MultiSample, Lockable) end

---Creates a depth-stencil resource.
---@param self IDirect3DDevice8
---@param Width number
---@param Height number
---@param Format number
---@param MultiSample number
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DDevice8:CreateDepthStencilSurface(Width, Height, Format, MultiSample) end

---Creates an image surface.
---@param self IDirect3DDevice8
---@param Width number
---@param Height number
---@param Format number
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DDevice8:CreateImageSurface(Width, Height, Format) end

---Copies rectangular subsets of pixels from one surface to another.
---@param self IDirect3DDevice8
---@param pSourceSurface IDirect3DSurface8
---@param pSourceRectsArray? ffi.cdata*
---@param cRects number
---@param pDestinationSurface IDirect3DSurface8
---@param pDestPointsArray? ffi.cdata*
---@return number
function IDirect3DDevice8:CopyRects(pSourceSurface, pSourceRectsArray, cRects, pDestinationSurface, pDestPointsArray) end

---Updates the dirty portions of a texture.
---@param self IDirect3DDevice8
---@param pSourceTexture IDirect3DBaseTexture8
---@param pDestinationTexture IDirect3DBaseTexture8
---@return number
function IDirect3DDevice8:UpdateTexture(pSourceTexture, pDestinationTexture) end

---Generates a copy of the device's front buffer and places that copy in a system memory buffer provided by the application.
---@param self IDirect3DDevice8
---@param pSurface IDirect3DSurface8
---@return number
function IDirect3DDevice8:GetFrontBuffer(pSurface) end

---Sets a new color buffer, depth buffer, or both for the device.
---@param self IDirect3DDevice8
---@param pRenderTarget? IDirect3DSurface8
---@param pNewZStencil? IDirect3DSurface8
---@return number
function IDirect3DDevice8:SetRenderTarget(pRenderTarget, pNewZStencil) end

---Retrieves a pointer to the Microsoft® Direct3D® surface that is being used as a render target.
---@param self IDirect3DDevice8
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DDevice8:GetRenderTarget() end

---Retrieves the depth-stencil surface owned by the Direct3DDevice object.
---@param self IDirect3DDevice8
---@return number
---@return IDirect3DSurface8|nil
function IDirect3DDevice8:GetDepthStencilSurface() end

---Begins a scene.
---@param self IDirect3DDevice8
---@return number
function IDirect3DDevice8:BeginScene() end

---Ends a scene.
---@param self IDirect3DDevice8
---@return number
function IDirect3DDevice8:EndScene() end

---Clears the viewport, or a set of rectangles in the viewport, to a specified RGBA color, clears the depth buffer, and erases the stencil buffer.
---@param self IDirect3DDevice8
---@param Count number
---@param pRects? ffi.cdata*
---@param Flags number
---@param Color number
---@param Z number
---@param Stencil number
---@return number
function IDirect3DDevice8:Clear(Count, pRects, Flags, Color, Z, Stencil) end

---Sets a single device transformation-related state.
---@param self IDirect3DDevice8
---@param State number
---@param pMatrix ffi.cdata*
---@return number
function IDirect3DDevice8:SetTransform(State, pMatrix) end

---Retrieves a matrix describing a transformation state.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetTransform(State) end

---Multiplies a device's world, view, or projection matrices by a specified matrix.
---@param self IDirect3DDevice8
---@param State number
---@param pMatrix ffi.cdata*
---@return number
function IDirect3DDevice8:MultiplyTransform(State, pMatrix) end

---Sets the viewport parameters for the device.
---@param self IDirect3DDevice8
---@param pViewport ffi.cdata*
---@return number
function IDirect3DDevice8:SetViewport(pViewport) end

---Retrieves the viewport parameters currently set for the device.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetViewport() end

---Sets the material properties for the device.
---@param self IDirect3DDevice8
---@param pMaterial ffi.cdata*
---@return number
function IDirect3DDevice8:SetMaterial(pMaterial) end

---Retrieves the current material properties for the device.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetMaterial() end

---Assigns a set of lighting properties for this device.
---@param self IDirect3DDevice8
---@param Index number
---@param pLight ffi.cdata*
---@return number
function IDirect3DDevice8:SetLight(Index, pLight) end

---Retrieves a set of lighting properties that this device uses.
---@param self IDirect3DDevice8
---@param Index number
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetLight(Index) end

---Enables or disables a set of lighting parameters within a device.
---@param self IDirect3DDevice8
---@param Index number
---@param Enable boolean
---@return number
function IDirect3DDevice8:LightEnable(Index, Enable) end

---Retrieves the activity status—enabled or disabled—for a set of lighting parameters within a device.
---@param self IDirect3DDevice8
---@param Index number
---@return number
---@return boolean
function IDirect3DDevice8:GetLightEnable(Index) end

---Sets the coefficients of a user-defined clipping plane for the device.
---@param self IDirect3DDevice8
---@param Index number
---@param pPlane ffi.cdata*
---@return number
function IDirect3DDevice8:SetClipPlane(Index, pPlane) end

---Retrieves the coefficients of a user-defined clipping plane for the device.
---@param self IDirect3DDevice8
---@param Index number
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetClipPlane(Index) end

---Sets a single device render-state parameter.
---@param self IDirect3DDevice8
---@param State number
---@param Value number
---@return number
function IDirect3DDevice8:SetRenderState(State, Value) end

---Retrieves a render-state value for a device.
---@param self IDirect3DDevice8
---@param State number
---@return number
---@return number|nil
function IDirect3DDevice8:GetRenderState(State) end

---Signals to begin recording a device-state block.
---@param self IDirect3DDevice8
---@return number
function IDirect3DDevice8:BeginStateBlock() end

---Signals to stop recording a device-state block and retrieve a handle to the state block.
---@param self IDirect3DDevice8
---@return number
---@return number|nil
function IDirect3DDevice8:EndStateBlock() end

---Applies an existing device-state block to the rendering device.
---@param self IDirect3DDevice8
---@param Token number
---@return number
function IDirect3DDevice8:ApplyStateBlock(Token) end

---Updates the values within an existing state block to the values set for the device.
---@param self IDirect3DDevice8
---@param Token number
---@return number
function IDirect3DDevice8:CaptureStateBlock(Token) end

---Deletes a previously recorded device-state block.
---@param self IDirect3DDevice8
---@param Token number
---@return number
function IDirect3DDevice8:DeleteStateBlock(Token) end

---Creates a new state block that contains the values for all device states, vertex-related states, or pixel-related states.
---@param self IDirect3DDevice8
---@param Type number
---@return number
---@return number|nil
function IDirect3DDevice8:CreateStateBlock(Type) end

---Sets the clip status.
---@param self IDirect3DDevice8
---@param pClipStatus ffi.cdata*
---@return number
function IDirect3DDevice8:SetClipStatus(pClipStatus) end

---Retrieves the clip status.
---@param self IDirect3DDevice8
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetClipStatus() end

---Retrieves a texture assigned to a stage for a device.
---@param self IDirect3DDevice8
---@param Stage number
---@return number
---@return IDirect3DBaseTexture8|nil
function IDirect3DDevice8:GetTexture(Stage) end

---Assigns a texture to a stage for a device.
---@param self IDirect3DDevice8
---@param Stage number
---@param pTexture? IDirect3DBaseTexture8
---@return number
function IDirect3DDevice8:SetTexture(Stage, pTexture) end

---Retrieves a state value for an assigned texture.
---@param self IDirect3DDevice8
---@param Stage number
---@param Type number
---@return number
---@return number|nil
function IDirect3DDevice8:GetTextureStageState(Stage, Type) end

---Sets the state value for the currently assigned texture.
---@param self IDirect3DDevice8
---@param Stage number
---@param Type number
---@param Value number
---@return number
function IDirect3DDevice8:SetTextureStageState(Stage, Type, Value) end

---Reports the device's ability to render the current texture-blending operations and arguments in a single pass.
---@param self IDirect3DDevice8
---@return number
---@return number|nil
function IDirect3DDevice8:ValidateDevice() end

---Not implemented.
---@param self IDirect3DDevice8
---@deprecated
function IDirect3DDevice8:GetInfo() end

---Sets palette entries.
---@param self IDirect3DDevice8
---@param PaletteNumber number
---@param pEntries ffi.cdata*
---@return number
function IDirect3DDevice8:SetPaletteEntries(PaletteNumber, pEntries) end

---Retrieves palette entries.
---@param self IDirect3DDevice8
---@param PaletteNumber number
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetPaletteEntries(PaletteNumber) end

---Sets the current texture palette.
---@param self IDirect3DDevice8
---@param PaletteNumber number
---@return number
function IDirect3DDevice8:SetCurrentTexturePalette(PaletteNumber) end

---Retrieves the current texture palette.
---@param self IDirect3DDevice8
---@return number
---@return number|nil
function IDirect3DDevice8:GetCurrentTexturePalette() end

---Renders a sequence of nonindexed, geometric primitives of the specified type from the current set of data input streams.
---@param self IDirect3DDevice8
---@param PrimitiveType number
---@param StartVertex number
---@param PrimitiveCount number
---@return number
function IDirect3DDevice8:DrawPrimitive(PrimitiveType, StartVertex, PrimitiveCount) end

---Renders the indexed geometric primitive into an array of vertices.
---@param self IDirect3DDevice8
---@param PrimitiveType number
---@param minIndex number
---@param NumVertices number
---@param startIndex number
---@param primCount number
---@return number
function IDirect3DDevice8:DrawIndexedPrimitive(PrimitiveType, minIndex, NumVertices, startIndex, primCount) end

---Renders data specified by a user memory pointer as a sequence of geometric primitives of the specified type.
---@param self IDirect3DDevice8
---@param PrimitiveType number
---@param PrimitiveCount number
---@param pVertexStreamZeroData ffi.cdata*
---@param VertexStreamZeroStride number
---@return number
function IDirect3DDevice8:DrawPrimitiveUP(PrimitiveType, PrimitiveCount, pVertexStreamZeroData, VertexStreamZeroStride) end

---Renders the specified geometric primitive with data specified by a user memory pointer.
---@param self IDirect3DDevice8
---@param PrimitiveType number
---@param MinVertexIndex number
---@param NumVertexIndices number
---@param PrimitiveCount number
---@param pIndexData ffi.cdata*
---@param IndexDataFormat number
---@param pVertexStreamZeroData ffi.cdata*
---@param VertexStreamZeroStride number
---@return number
function IDirect3DDevice8:DrawIndexedPrimitiveUP(PrimitiveType, MinVertexIndex, NumVertexIndices, PrimitiveCount, pIndexData, IndexDataFormat, pVertexStreamZeroData, VertexStreamZeroStride) end

---Applies the vertex processing defined by the vertex shader to the set of input data streams, generating a single stream of interleaved vertex data to the destination vertex buffer.
---@param self IDirect3DDevice8
---@param SrcStartIndex number
---@param DestIndex number
---@param VertexCount number
---@param pDestBuffer IDirect3DVertexBuffer8
---@param Flags number
---@return number
function IDirect3DDevice8:ProcessVertices(SrcStartIndex, DestIndex, VertexCount, pDestBuffer, Flags) end

---Creates a vertex shader.
---@param self IDirect3DDevice8
---@param pDeclaration ffi.cdata*
---@param pFunction ffi.cdata*
---@param Usage number
---@return number
---@return number|nil
function IDirect3DDevice8:CreateVertexShader(pDeclaration, pFunction, Usage) end

---Sets values in the vertex constant array.
---@param self IDirect3DDevice8
---@param Handle number
---@return number
function IDirect3DDevice8:SetVertexShader(Handle) end

---Retrieves the currently set vertex shader.
---@param self IDirect3DDevice8
---@return number
---@return number|nil
function IDirect3DDevice8:GetVertexShader() end

---Deletes the vertex shader referred to by the specified handle and frees up the associated resources.
---@param self IDirect3DDevice8
---@param Handle number
---@return number
function IDirect3DDevice8:DeleteVertexShader(Handle) end

---Sets values in the vertex constant array.
---@param self IDirect3DDevice8
---@param Register number
---@param pConstantData ffi.cdata*
---@param ConstantCount number
function IDirect3DDevice8:SetVertexShaderConstant(Register, pConstantData, ConstantCount) end

---Retrieves the values in the vertex constant array.
---@param self IDirect3DDevice8
---@param Register number
---@param ConstantCount number
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetVertexShaderConstant(Register, ConstantCount) end

---Retrieves the vertex shader declaration token array.
---@param self IDirect3DDevice8
---@param Handle number
---@param pData ffi.cdata*
---@param pSizeOfData ffi.cdata*
---@return number
function IDirect3DDevice8:GetVertexShaderDeclaration(Handle, pData, pSizeOfData) end

---Retrieves the vertex shader function.
---@param self IDirect3DDevice8
---@param Handle number
---@param pData ffi.cdata*
---@param pSizeOfData ffi.cdata*
---@return number
function IDirect3DDevice8:GetVertexShaderFunction(Handle, pData, pSizeOfData) end

---Binds a vertex buffer to a device data stream.
---@param self IDirect3DDevice8
---@param StreamNumber number
---@param pStreamData? IDirect3DVertexBuffer8
---@param Stride number
---@return number
function IDirect3DDevice8:SetStreamSource(StreamNumber, pStreamData, Stride) end

---Retrieves a vertex buffer bound to the specified data stream.
---@param self IDirect3DDevice8
---@param StreamNumber number
---@return number
---@return IDirect3DVertexBuffer8|nil
---@return number|nil
function IDirect3DDevice8:GetStreamSource(StreamNumber) end

---Sets index data.
---@param self IDirect3DDevice8
---@param pIndexData? IDirect3DIndexBuffer8
---@param BaseVertexIndex number
---@return number
function IDirect3DDevice8:SetIndices(pIndexData, BaseVertexIndex) end

---Retrieves index data.
---@param self IDirect3DDevice8
---@return number
---@return IDirect3DIndexBuffer8|nil
---@return number|nil
function IDirect3DDevice8:GetIndices() end

---Creates a pixel shader.
---@param self IDirect3DDevice8
---@param pFunction ffi.cdata*
---@return number
---@return number|nil
function IDirect3DDevice8:CreatePixelShader(pFunction) end

---Sets the current pixel shader to a previously created pixel shader.
---@param self IDirect3DDevice8
---@param Handle number
---@return number
function IDirect3DDevice8:SetPixelShader(Handle) end

---Retrieves the currently set pixel shader.
---@param self IDirect3DDevice8
---@return number
---@return number|nil
function IDirect3DDevice8:GetPixelShader() end

---Deletes the pixel shader referred to by the specified handle.
---@param self IDirect3DDevice8
---@param Handle number
---@return number
function IDirect3DDevice8:DeletePixelShader(Handle) end

---Sets the values in the pixel constant array.
---@param self IDirect3DDevice8
---@param Register number
---@param pConstantData ffi.cdata*
---@param ConstantCount number
---@return number
function IDirect3DDevice8:SetPixelShaderConstant(Register, pConstantData, ConstantCount) end

---Retrieves the values in the pixel constant array.
---@param self IDirect3DDevice8
---@param Register number
---@param ConstantCount number
---@return number
---@return ffi.cdata*|nil
function IDirect3DDevice8:GetPixelShaderConstant(Register, ConstantCount) end

---Retrieves the pixel shader function.
---@param self IDirect3DDevice8
---@param Handle number
---@param pData ffi.cdata*
---@param pSizeOfData ffi.cdata*
---@return number
function IDirect3DDevice8:GetPixelShaderFunction(Handle, pData, pSizeOfData) end

---Draws a rectangular high-order patch using the currently set streams.
---@param self IDirect3DDevice8
---@param Handle number
---@param pNumSegs ffi.cdata*
---@param pRectPatchInfo ffi.cdata*
---@return number
function IDirect3DDevice8:DrawRectPatch(Handle, pNumSegs, pRectPatchInfo) end

---Draws a triangular high-order patch using the currently set streams.
---@param self IDirect3DDevice8
---@param Handle number
---@param pNumSegs ffi.cdata*
---@param pTriPatchInfo ffi.cdata*
---@return number
function IDirect3DDevice8:DrawTriPatch(Handle, pNumSegs, pTriPatchInfo) end

---Frees a cached high-order patch.
---@param self IDirect3DDevice8
---@param Handle number
---@return number
function IDirect3DDevice8:DeletePatch(Handle) end