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

--[[
* This file is created using the information from the d3d8.h header file of the Direct3D 8 SDK.
--]]

require('win32types');

local ffi   = require('ffi');
local C     = ffi.C;

ffi.cdef[[
    typedef struct IDirect3DDevice8Vtbl {
        /*** IUnknown methods ***/
        HRESULT     __stdcall (*QueryInterface)(IDirect3DDevice8* This, REFIID riid, void** ppvObj);
        ULONG       __stdcall (*AddRef)(IDirect3DDevice8* This);
        ULONG       __stdcall (*Release)(IDirect3DDevice8* This);
        
        
        /*** IDirect3DDevice8 methods ***/
        HRESULT     __stdcall (*TestCooperativeLevel)(IDirect3DDevice8* This);
        UINT        __stdcall (*GetAvailableTextureMem)(IDirect3DDevice8* This);
        HRESULT     __stdcall (*ResourceManagerDiscardBytes)(IDirect3DDevice8* This, DWORD Bytes);
        HRESULT     __stdcall (*GetDirect3D)(IDirect3DDevice8* This, IDirect3D8** ppD3D8);
        HRESULT     __stdcall (*GetDeviceCaps)(IDirect3DDevice8* This, D3DCAPS8* pCaps);
        HRESULT     __stdcall (*GetDisplayMode)(IDirect3DDevice8* This, D3DDISPLAYMODE* pMode);
        HRESULT     __stdcall (*GetCreationParameters)(IDirect3DDevice8* This, D3DDEVICE_CREATION_PARAMETERS *pParameters);
        HRESULT     __stdcall (*SetCursorProperties)(IDirect3DDevice8* This, UINT XHotSpot, UINT YHotSpot, IDirect3DSurface8* pCursorBitmap);
        void        __stdcall (*SetCursorPosition)(IDirect3DDevice8* This, int X, int Y, DWORD Flags);
        BOOL        __stdcall (*ShowCursor)(IDirect3DDevice8* This, BOOL bShow);
        HRESULT     __stdcall (*CreateAdditionalSwapChain)(IDirect3DDevice8* This, D3DPRESENT_PARAMETERS* pPresentationParameters, IDirect3DSwapChain8** pSwapChain);
        HRESULT     __stdcall (*Reset)(IDirect3DDevice8* This, D3DPRESENT_PARAMETERS* pPresentationParameters);
        HRESULT     __stdcall (*Present)(IDirect3DDevice8* This, const RECT* pSourceRect, const RECT* pDestRect, HWND hDestWindowOverride, const RGNDATA* pDirtyRegion);
        HRESULT     __stdcall (*GetBackBuffer)(IDirect3DDevice8* This, UINT BackBuffer, D3DBACKBUFFER_TYPE Type, IDirect3DSurface8** ppBackBuffer);
        HRESULT     __stdcall (*GetRasterStatus)(IDirect3DDevice8* This, D3DRASTER_STATUS* pRasterStatus);
        void        __stdcall (*SetGammaRamp)(IDirect3DDevice8* This, DWORD Flags, const D3DGAMMARAMP* pRamp);
        void        __stdcall (*GetGammaRamp)(IDirect3DDevice8* This, D3DGAMMARAMP* pRamp);
        HRESULT     __stdcall (*CreateTexture)(IDirect3DDevice8* This, UINT Width, UINT Height, UINT Levels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, IDirect3DTexture8** ppTexture);
        HRESULT     __stdcall (*CreateVolumeTexture)(IDirect3DDevice8* This, UINT Width, UINT Height, UINT Depth, UINT Levels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, IDirect3DVolumeTexture8** ppVolumeTexture);
        HRESULT     __stdcall (*CreateCubeTexture)(IDirect3DDevice8* This, UINT EdgeLength, UINT Levels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, IDirect3DCubeTexture8** ppCubeTexture);
        HRESULT     __stdcall (*CreateVertexBuffer)(IDirect3DDevice8* This, UINT Length, DWORD Usage, DWORD FVF, D3DPOOL Pool, IDirect3DVertexBuffer8** ppVertexBuffer);
        HRESULT     __stdcall (*CreateIndexBuffer)(IDirect3DDevice8* This, UINT Length, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, IDirect3DIndexBuffer8** ppIndexBuffer);
        HRESULT     __stdcall (*CreateRenderTarget)(IDirect3DDevice8* This, UINT Width, UINT Height, D3DFORMAT Format, D3DMULTISAMPLE_TYPE MultiSample, BOOL Lockable, IDirect3DSurface8** ppSurface);
        HRESULT     __stdcall (*CreateDepthStencilSurface)(IDirect3DDevice8* This, UINT Width, UINT Height, D3DFORMAT Format, D3DMULTISAMPLE_TYPE MultiSample, IDirect3DSurface8** ppSurface);
        HRESULT     __stdcall (*CreateImageSurface)(IDirect3DDevice8* This, UINT Width, UINT Height, D3DFORMAT Format, IDirect3DSurface8** ppSurface);
        HRESULT     __stdcall (*CopyRects)(IDirect3DDevice8* This, IDirect3DSurface8* pSourceSurface, const RECT* pSourceRectsArray, UINT cRects, IDirect3DSurface8* pDestinationSurface, const POINT* pDestPointsArray);
        HRESULT     __stdcall (*UpdateTexture)(IDirect3DDevice8* This, void* pSourceTexture, void* pDestinationTexture);
        HRESULT     __stdcall (*GetFrontBuffer)(IDirect3DDevice8* This, IDirect3DSurface8* pDestSurface);
        HRESULT     __stdcall (*SetRenderTarget)(IDirect3DDevice8* This, IDirect3DSurface8* pRenderTarget, IDirect3DSurface8* pNewZStencil);
        HRESULT     __stdcall (*GetRenderTarget)(IDirect3DDevice8* This, IDirect3DSurface8** ppRenderTarget);
        HRESULT     __stdcall (*GetDepthStencilSurface)(IDirect3DDevice8* This, IDirect3DSurface8** ppZStencilSurface);
        HRESULT     __stdcall (*BeginScene)(IDirect3DDevice8* This);
        HRESULT     __stdcall (*EndScene)(IDirect3DDevice8* This);
        HRESULT     __stdcall (*Clear)(IDirect3DDevice8* This, DWORD Count, const D3DRECT* pRects, DWORD Flags, D3DCOLOR Color, float Z, DWORD Stencil);
        HRESULT     __stdcall (*SetTransform)(IDirect3DDevice8* This, D3DTRANSFORMSTATETYPE State, const D3DMATRIX* pMatrix);
        HRESULT     __stdcall (*GetTransform)(IDirect3DDevice8* This, D3DTRANSFORMSTATETYPE State, D3DMATRIX* pMatrix);
        HRESULT     __stdcall (*MultiplyTransform)(IDirect3DDevice8* This, D3DTRANSFORMSTATETYPE State, const D3DMATRIX* pMatrix);
        HRESULT     __stdcall (*SetViewport)(IDirect3DDevice8* This, const D3DVIEWPORT8* pViewport);
        HRESULT     __stdcall (*GetViewport)(IDirect3DDevice8* This, D3DVIEWPORT8* pViewport);
        HRESULT     __stdcall (*SetMaterial)(IDirect3DDevice8* This, const D3DMATERIAL8* pMaterial);
        HRESULT     __stdcall (*GetMaterial)(IDirect3DDevice8* This, D3DMATERIAL8* pMaterial);
        HRESULT     __stdcall (*SetLight)(IDirect3DDevice8* This, DWORD Index, const D3DLIGHT8* pLight);
        HRESULT     __stdcall (*GetLight)(IDirect3DDevice8* This, DWORD Index, D3DLIGHT8* pLight);
        HRESULT     __stdcall (*LightEnable)(IDirect3DDevice8* This, DWORD Index, BOOL Enable);
        HRESULT     __stdcall (*GetLightEnable)(IDirect3DDevice8* This, DWORD Index, BOOL* pEnable);
        HRESULT     __stdcall (*SetClipPlane)(IDirect3DDevice8* This, DWORD Index, const float* pPlane);
        HRESULT     __stdcall (*GetClipPlane)(IDirect3DDevice8* This, DWORD Index, float* pPlane);
        HRESULT     __stdcall (*SetRenderState)(IDirect3DDevice8* This, D3DRENDERSTATETYPE State, DWORD Value);
        HRESULT     __stdcall (*GetRenderState)(IDirect3DDevice8* This, D3DRENDERSTATETYPE State, DWORD* pValue);
        HRESULT     __stdcall (*BeginStateBlock)(IDirect3DDevice8* This);
        HRESULT     __stdcall (*EndStateBlock)(IDirect3DDevice8* This, DWORD* pToken);
        HRESULT     __stdcall (*ApplyStateBlock)(IDirect3DDevice8* This, DWORD Token);
        HRESULT     __stdcall (*CaptureStateBlock)(IDirect3DDevice8* This, DWORD Token);
        HRESULT     __stdcall (*DeleteStateBlock)(IDirect3DDevice8* This, DWORD Token);
        HRESULT     __stdcall (*CreateStateBlock)(IDirect3DDevice8* This, D3DSTATEBLOCKTYPE Type, DWORD* pToken);
        HRESULT     __stdcall (*SetClipStatus)(IDirect3DDevice8* This, const D3DCLIPSTATUS8* pClipStatus);
        HRESULT     __stdcall (*GetClipStatus)(IDirect3DDevice8* This, D3DCLIPSTATUS8* pClipStatus);
        HRESULT     __stdcall (*GetTexture)(IDirect3DDevice8* This, DWORD Stage, IDirect3DBaseTexture8** ppTexture);
        HRESULT     __stdcall (*SetTexture)(IDirect3DDevice8* This, DWORD Stage, IDirect3DBaseTexture8* pTexture);
        HRESULT     __stdcall (*GetTextureStageState)(IDirect3DDevice8* This, DWORD Stage, D3DTEXTURESTAGESTATETYPE Type, DWORD* pValue);
        HRESULT     __stdcall (*SetTextureStageState)(IDirect3DDevice8* This, DWORD Stage, D3DTEXTURESTAGESTATETYPE Type, DWORD Value);
        HRESULT     __stdcall (*ValidateDevice)(IDirect3DDevice8* This, DWORD* pNumPasses);
        HRESULT     __stdcall (*GetInfo)(IDirect3DDevice8* This, DWORD DevInfoID, void* pDevInfoStruct, DWORD DevInfoStructSize);
        HRESULT     __stdcall (*SetPaletteEntries)(IDirect3DDevice8* This, UINT PaletteNumber, const PALETTEENTRY* pEntries);
        HRESULT     __stdcall (*GetPaletteEntries)(IDirect3DDevice8* This, UINT PaletteNumber, PALETTEENTRY* pEntries);
        HRESULT     __stdcall (*SetCurrentTexturePalette)(IDirect3DDevice8* This, UINT PaletteNumber);
        HRESULT     __stdcall (*GetCurrentTexturePalette)(IDirect3DDevice8* This, UINT *PaletteNumber);
        HRESULT     __stdcall (*DrawPrimitive)(IDirect3DDevice8* This, D3DPRIMITIVETYPE PrimitiveType, UINT StartVertex, UINT PrimitiveCount);
        HRESULT     __stdcall (*DrawIndexedPrimitive)(IDirect3DDevice8* This, D3DPRIMITIVETYPE PrimitiveType, UINT minIndex, UINT NumVertices, UINT startIndex, UINT primCount);
        HRESULT     __stdcall (*DrawPrimitiveUP)(IDirect3DDevice8* This, D3DPRIMITIVETYPE PrimitiveType, UINT PrimitiveCount, const void* pVertexStreamZeroData, UINT VertexStreamZeroStride);
        HRESULT     __stdcall (*DrawIndexedPrimitiveUP)(IDirect3DDevice8* This, D3DPRIMITIVETYPE PrimitiveType, UINT MinVertexIndex, UINT NumVertexIndices, UINT PrimitiveCount, const void* pIndexData, D3DFORMAT IndexDataFormat, const void* pVertexStreamZeroData, UINT VertexStreamZeroStride);
        HRESULT     __stdcall (*ProcessVertices)(IDirect3DDevice8* This, UINT SrcStartIndex, UINT DestIndex, UINT VertexCount, IDirect3DVertexBuffer8* pDestBuffer, DWORD Flags);
        HRESULT     __stdcall (*CreateVertexShader)(IDirect3DDevice8* This, const DWORD* pDeclaration, const DWORD* pFunction, DWORD* pHandle, DWORD Usage);
        HRESULT     __stdcall (*SetVertexShader)(IDirect3DDevice8* This, DWORD Handle);
        HRESULT     __stdcall (*GetVertexShader)(IDirect3DDevice8* This, DWORD* pHandle);
        HRESULT     __stdcall (*DeleteVertexShader)(IDirect3DDevice8* This, DWORD Handle);
        HRESULT     __stdcall (*SetVertexShaderConstant)(IDirect3DDevice8* This, DWORD Register, const void* pConstantData, DWORD ConstantCount);
        HRESULT     __stdcall (*GetVertexShaderConstant)(IDirect3DDevice8* This, DWORD Register, void* pConstantData, DWORD ConstantCount);
        HRESULT     __stdcall (*GetVertexShaderDeclaration)(IDirect3DDevice8* This, DWORD Handle, void* pData, DWORD* pSizeOfData);
        HRESULT     __stdcall (*GetVertexShaderFunction)(IDirect3DDevice8* This, DWORD Handle, void* pData, DWORD* pSizeOfData);
        HRESULT     __stdcall (*SetStreamSource)(IDirect3DDevice8* This, UINT StreamNumber, IDirect3DVertexBuffer8* pStreamData, UINT Stride);
        HRESULT     __stdcall (*GetStreamSource)(IDirect3DDevice8* This, UINT StreamNumber, IDirect3DVertexBuffer8** ppStreamData, UINT* pStride);
        HRESULT     __stdcall (*SetIndices)(IDirect3DDevice8* This, IDirect3DIndexBuffer8* pIndexData, UINT BaseVertexIndex);
        HRESULT     __stdcall (*GetIndices)(IDirect3DDevice8* This, IDirect3DIndexBuffer8** ppIndexData, UINT* pBaseVertexIndex);
        HRESULT     __stdcall (*CreatePixelShader)(IDirect3DDevice8* This, const DWORD* pFunction, DWORD* pHandle);
        HRESULT     __stdcall (*SetPixelShader)(IDirect3DDevice8* This, DWORD Handle);
        HRESULT     __stdcall (*GetPixelShader)(IDirect3DDevice8* This, DWORD* pHandle);
        HRESULT     __stdcall (*DeletePixelShader)(IDirect3DDevice8* This, DWORD Handle);
        HRESULT     __stdcall (*SetPixelShaderConstant)(IDirect3DDevice8* This, DWORD Register, const void* pConstantData, DWORD ConstantCount);
        HRESULT     __stdcall (*GetPixelShaderConstant)(IDirect3DDevice8* This, DWORD Register, void* pConstantData, DWORD ConstantCount);
        HRESULT     __stdcall (*GetPixelShaderFunction)(IDirect3DDevice8* This, DWORD Handle, void* pData, DWORD* pSizeOfData);
        HRESULT     __stdcall (*DrawRectPatch)(IDirect3DDevice8* This, UINT Handle, const float* pNumSegs, const D3DRECTPATCH_INFO* pRectPatchInfo);
        HRESULT     __stdcall (*DrawTriPatch)(IDirect3DDevice8* This, UINT Handle, const float* pNumSegs, const D3DTRIPATCH_INFO* pTriPatchInfo);
        HRESULT     __stdcall (*DeletePatch)(IDirect3DDevice8* This, UINT Handle);
    } IDirect3DDevice8Vtbl;

    struct IDirect3DDevice8
    {
        struct IDirect3DDevice8Vtbl* lpVtbl;
    };
]];

--[[
* IDirect3DDevice8 Vtbl Forwarding
--]]
IDirect3DDevice8 = ffi.metatype('IDirect3DDevice8', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- IDirect3DDevice8 Methods
        TestCooperativeLevel = function (self)
            return self.lpVtbl.TestCooperativeLevel(self);
        end,
        GetAvailableTextureMem = function (self)
            return self.lpVtbl.GetAvailableTextureMem(self);
        end,
        ResourceManagerDiscardBytes = function (self, Bytes)
            return self.lpVtbl.ResourceManagerDiscardBytes(self, Bytes);
        end,
        GetDirect3D = function (self)
            local d3d8_ptr  = ffi.new('IDirect3D8*[1]');
            local res       = self.lpVtbl.GetDirect3D(self, d3d8_ptr);
            local d3d8      = nil;

            if (res == C.S_OK) then
                d3d8 = ffi.cast('IDirect3D8*', d3d8_ptr[0]);
            end

            return res, d3d8;
        end,
        GetDeviceCaps = function (self)
            local caps  = ffi.new('D3DCAPS8[1]');
            local res   = self.lpVtbl.GetDeviceCaps(self, caps);

            return res, res == C.S_OK and caps[0] or nil;
        end,
        GetDisplayMode = function (self)
            local mode  = ffi.new('D3DDISPLAYMODE[1]');
            local res   =  self.lpVtbl.GetDisplayMode(self, mode);

            return res, res == C.S_OK and mode[0] or nil;
        end,
        GetCreationParameters = function (self)
            local params    = ffi.new('D3DDEVICE_CREATION_PARAMETERS[1]');
            local res       = self.lpVtbl.GetCreationParameters(self, params);

            return res, res == C.S_OK and params[0] or nil;
        end,
        SetCursorProperties = function (self, XHotSpot, YHotSpot, pCursorBitmap)
            return self.lpVtbl.SetCursorProperties(self, XHotSpot, YHotSpot, pCursorBitmap);
        end,
        SetCursorPosition = function (self, X, Y, Flags)
            self.lpVtbl.SetCursorPosition(self, X, Y, Flags);
        end,
        ShowCursor = function (self, bShow)
            return self.lpVtbl.ShowCursor(self, bShow);
        end,
        CreateAdditionalSwapChain = function (self, pPresentationParameters)
            local swap_ptr  = ffi.new('IDirect3DSwapChain8*[1]');
            local res       = self.lpVtbl.CreateAdditionalSwapChain(self, pPresentationParameters, swap_ptr);
            local swap      = nil;

            if (res == C.S_OK) then
                swap = ffi.cast('IDirect3DSwapChain8*', swap_ptr[0]);
            end

            return res, swap;
        end,
        Reset = function (self, pPresentationParameters)
            -- Note: Reset calls are not valid for FFXI.
            error('Not implemented.');
        end,
        Present = function (self, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion)
            return self.lpVtbl.Present(self, pSourceRect, pDestRect, hDestWindowOverride, pDirtyRegion);
        end,
        GetBackBuffer = function (self, BackBuffer, Type)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.GetBackBuffer(self, BackBuffer, Type, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
        GetRasterStatus = function (self)
            local status    = ffi.new('D3DRASTER_STATUS[1]');
            local res       = self.lpVtbl.GetRasterStatus(self, status);

            return res, res == C.S_OK and status[0] or nil;
        end,
        SetGammaRamp = function (self, Flags, pRamp)
            return self.lpVtbl.SetGammaRamp(self, Flags, pRamp);
        end,
        GetGammaRamp = function (self)
            local gamma = ffi.new('D3DGAMMARAMP[1]');
            self.lpVtbl.GetGammaRamp(self, gamma);

            return gamma[0];
        end,
        CreateTexture = function (self, Width, Height, Levels, Usage, Format, Pool)
            local texture_ptr   = ffi.new('IDirect3DTexture8*[1]');
            local res           = self.lpVtbl.CreateTexture(self, Width, Height, Levels, Usage, Format, Pool, texture_ptr);
            local texture       = nil;

            if (res == C.S_OK) then
                texture = ffi.cast('IDirect3DTexture8*', texture_ptr[0]);
            end

            return res, texture;
        end,
        CreateVolumeTexture = function (self, Width, Height, Depth, Levels, Usage, Format, Pool)
            local texture_ptr   = ffi.new('IDirect3DVolumeTexture8*[1]');
            local res           = self.lpVtbl.CreateVolumeTexture(self, Width, Height, Depth, Levels, Usage, Format, Pool, texture_ptr);
            local texture       = nil;

            if (res == C.S_OK) then
                texture = ffi.cast('IDirect3DVolumeTexture8*', texture_ptr[0]);
            end

            return res, texture;
        end,
        CreateCubeTexture = function (self, EdgeLength, Levels, Usage, Format, Pool)
            local texture_ptr   = ffi.new('IDirect3DCubeTexture8*[1]');
            local res           = self.lpVtbl.CreateCubeTexture(self, EdgeLength, Levels, Usage, Format, Pool, texture_ptr);
            local texture       = nil;

            if (res == C.S_OK) then
                texture = ffi.cast('IDirect3DCubeTexture8*', texture_ptr[0]);
            end

            return res, texture;
        end,
        CreateVertexBuffer = function (self, Length, Usage, FVF, Pool)
            local buffer_ptr    = ffi.new('IDirect3DVertexBuffer8*[1]');
            local res           = self.lpVtbl.CreateVertexBuffer(self, Length, Usage, FVF, Pool, buffer_ptr);
            local buffer        = nil;

            if (res == C.S_OK) then
                buffer = ffi.cast('IDirect3DVertexBuffer8*', buffer_ptr[0]);
            end

            return res, buffer;
        end,
        CreateIndexBuffer = function (self, Length, Usage, Format, Pool)
            local buffer_ptr    = ffi.new('IDirect3DIndexBuffer8*[1]');
            local res           = self.lpVtbl.CreateIndexBuffer(self, Length, Usage, Format, Pool, buffer_ptr);
            local buffer        = nil;

            if (res == C.S_OK) then
                buffer = ffi.cast('IDirect3DIndexBuffer8*', buffer_ptr[0]);
            end

            return res, buffer;
        end,
        CreateRenderTarget = function (self, Width, Height, Format, MultiSample, Lockable)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.CreateRenderTarget(self, Width, Height, Format, MultiSample, Lockable, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
        CreateDepthStencilSurface = function (self, Width, Height, Format, MultiSample)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.CreateDepthStencilSurface(self, Width, Height, Format, MultiSample, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
        CreateImageSurface = function (self, Width, Height, Format)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.CreateImageSurface(self, Width, Height, Format, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
        CopyRects = function (self, pSourceSurface, pSourceRectsArray, cRects, pDestinationSurface, pDestPointsArray)
            return self.lpVtbl.CopyRects(self, pSourceSurface, pSourceRectsArray, cRects, pDestinationSurface, pDestPointsArray);
        end,
        UpdateTexture = function (self, pSourceTexture, pDestinationTexture)
            return self.lpVtbl.UpdateTexture(self, pSourceTexture, pDestinationTexture);
        end,
        GetFrontBuffer = function (self, pSurface)
            return self.lpVtbl.GetFrontBuffer(self, pSurface);
        end,
        SetRenderTarget = function (self, pRenderTarget, pNewZStencil)
            return self.lpVtbl.SetRenderTarget(self, pRenderTarget, pNewZStencil);
        end,
        GetRenderTarget = function (self)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.GetRenderTarget(self, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
        GetDepthStencilSurface = function (self)
            local surface_ptr   = ffi.new('IDirect3DSurface8*[1]');
            local res           = self.lpVtbl.GetDepthStencilSurface(self, surface_ptr);
            local surface       = nil;

            if (res == C.S_OK) then
                surface = ffi.cast('IDirect3DSurface8*', surface_ptr[0]);
            end

            return res, surface;
        end,
        BeginScene = function (self)
            return self.lpVtbl.BeginScene(self);
        end,
        EndScene = function (self)
            return self.lpVtbl.EndScene(self);
        end,
        Clear = function (self, Count, pRects, Flags, Color, Z, Stencil)
            return self.lpVtbl.Clear(self, Count, pRects, Flags, Color, Z, Stencil);
        end,
        SetTransform = function (self, State, pMatrix)
            return self.lpVtbl.SetTransform(self, State, pMatrix);
        end,
        GetTransform = function (self, State)
            local mat = ffi.new('D3DMATRIX[1]');
            local res = self.lpVtbl.GetTransform(self, State, mat);

            return res, res == C.S_OK and mat[0] or nil;
        end,
        MultiplyTransform = function (self, State, pMatrix)
            return self.lpVtbl.MultiplyTransform(self, State, pMatrix);
        end,
        SetViewport = function (self, pViewport)
            return self.lpVtbl.SetViewport(self, pViewport);
        end,
        GetViewport = function (self)
            local view  = ffi.new('D3DVIEWPORT8[1]');
            local res   = self.lpVtbl.GetViewport(self, view);

            return res, res == C.S_OK and view[0] or nil;
        end,
        SetMaterial = function (self, pMaterial)
            return self.lpVtbl.SetMaterial(self, pMaterial);
        end,
        GetMaterial = function (self)
            local mat = ffi.new('D3DMATERIAL8[1]');
            local res = self.lpVtbl.GetMaterial(self, mat);

            return res, res == C.S_OK and mat[0] or nil;
        end,
        SetLight = function (self, Index, pLight)
            return self.lpVtbl.SetLight(self, Index, pLight);
        end,
        GetLight = function (self, Index)
            local light = ffi.new('D3DLIGHT8[1]');
            local res   = self.lpVtbl.GetLight(self, Index, light);

            return res, res == C.S_OK and light[0] or nil;
        end,
        LightEnable = function (self, Index, Enable)
            return self.lpVtbl.LightEnable(self, Index, Enable);
        end,
        GetLightEnable = function (self, Index)
            local enabled   = ffi.new('BOOL[1]');
            local res       = self.lpVtbl.GetLightEnable(self, Index, enabled);

            return res, res == C.S_OK and enabled[0] or nil;
        end,
        SetClipPlane = function (self, Index, pPlane)
            return self.lpVtbl.SetClipPlane(self, Index, pPlane);
        end,
        GetClipPlane = function (self, Index)
            local plane = ffi.new('float[4]');
            local res   = self.lpVtbl.GetClipPlane(self, Index, plane);

            return res, res == C.S_OK and plane or nil;
        end,
        SetRenderState = function (self, State, Value)
            return self.lpVtbl.SetRenderState(self, State, Value);
        end,
        GetRenderState = function (self, State)
            local val = ffi.new('DWORD[1]');
            local res = self.lpVtbl.GetRenderState(self, State, val);

            return res, res == C.S_OK and val[0] or nil;
        end,
        BeginStateBlock = function (self)
            return self.lpVtbl.BeginStateBlock(self);
        end,
        EndStateBlock = function (self)
            local token = ffi.new('DWORD[1]');
            local res   = self.lpVtbl.EndStateBlock(self, token);

            return res, res == C.S_OK and token[0] or nil;
        end,
        ApplyStateBlock = function (self, Token)
            return self.lpVtbl.ApplyStateBlock(self, Token);
        end,
        CaptureStateBlock = function (self, Token)
            return self.lpVtbl.CaptureStateBlock(self, Token);
        end,
        DeleteStateBlock = function (self, Token)
            return self.lpVtbl.DeleteStateBlock(self, Token);
        end,
        CreateStateBlock = function (self, Type)
            local token = ffi.new('DWORD[1]');
            local res   = self.lpVtbl.CreateStateBlock(self, Type, token);

            return res, res == C.S_OK and token[0] or nil;
        end,
        SetClipStatus = function (self, pClipStatus)
            return self.lpVtbl.SetClipStatus(self, pClipStatus);
        end,
        GetClipStatus = function (self)
            local clip  = ffi.new('D3DCLIPSTATUS8[1]');
            local res   = self.lpVtbl.GetClipStatus(self, clip);

            return res, res == C.S_OK and clip[0] or nil;
        end,
        GetTexture = function (self, Stage)
            local texture_ptr   = ffi.new('IDirect3DBaseTexture8*[1]');
            local res           = self.lpVtbl.GetTexture(self, Stage, texture_ptr);
            local texture       = nil;

            if (res == C.S_OK) then
                texture = ffi.cast('IDirect3DBaseTexture8*', texture_ptr[0]);
            end

            return res, texture;
        end,
        SetTexture = function (self, Stage, pTexture)
            return self.lpVtbl.SetTexture(self, Stage, pTexture);
        end,
        GetTextureStageState = function (self, Stage, Type)
            local state = ffi.new('DWORD[1]');
            local res   = self.lpVtbl.GetTextureStageState(self, Stage, Type, state);

            return res, res == C.S_OK and state[0] or nil;
        end,
        SetTextureStageState = function (self, Stage, Type, Value)
            return self.lpVtbl.SetTextureStageState(self, Stage, Type, Value);
        end,
        ValidateDevice = function (self)
            local passes    = ffi.new('DWORD[1]');
            local res       = self.lpVtbl.ValidateDevice(self, passes);

            return res, res == C.S_OK and passes[0] or nil;
        end,
        GetInfo = function (self, DevInfoID, pDevInfoStruct, DevInfoStructSize)
            error('Not implemented.');
        end,
        SetPaletteEntries = function (self, PaletteNumber, pEntries)
            return self.lpVtbl.SetPaletteEntries(self, PaletteNumber, pEntries);
        end,
        GetPaletteEntries = function (self, PaletteNumber)
            local palette   = ffi.new('PALETTEENTRY[256]');
            local res       = self.lpVtbl.GetPaletteEntries(self, PaletteNumber, palette);

            return res, res == C.S_OK and palette or nil;
        end,
        SetCurrentTexturePalette = function (self, PaletteNumber)
            return self.lpVtbl.SetCurrentTexturePalette(self, PaletteNumber);
        end,
        GetCurrentTexturePalette = function (self)
            local palette   = ffi.new('UINT[1]');
            local res       = self.lpVtbl.GetCurrentTexturePalette(self, palette);

            return res, res == C.S_OK and palette[0] or nil;
        end,
        DrawPrimitive = function (self, PrimitiveType, StartVertex, PrimitiveCount)
            return self.lpVtbl.DrawPrimitive(self, PrimitiveType, StartVertex, PrimitiveCount);
        end,
        DrawIndexedPrimitive = function (self, PrimitiveType, minIndex, NumVertices, startIndex, primCount)
            return self.lpVtbl.DrawIndexedPrimitive(self, PrimitiveType, minIndex, NumVertices, startIndex, primCount);
        end,
        DrawPrimitiveUP = function (self, PrimitiveType, PrimitiveCount, pVertexStreamZeroData, VertexStreamZeroStride)
            return self.lpVtbl.DrawPrimitiveUP(self, PrimitiveType, PrimitiveCount, pVertexStreamZeroData, VertexStreamZeroStride);
        end,
        DrawIndexedPrimitiveUP = function (self, PrimitiveType, MinVertexIndex, NumVertexIndices, PrimitiveCount, pIndexData, IndexDataFormat, pVertexStreamZeroData, VertexStreamZeroStride)
            return self.lpVtbl.DrawIndexedPrimitiveUP(self, PrimitiveType, MinVertexIndex, NumVertexIndices, PrimitiveCount, pIndexData, IndexDataFormat, pVertexStreamZeroData, VertexStreamZeroStride);
        end,
        ProcessVertices = function (self, SrcStartIndex, DestIndex, VertexCount, pDestBuffer, Flags)
            return self.lpVtbl.ProcessVertices(self, SrcStartIndex, DestIndex, VertexCount, pDestBuffer, Flags);
        end,
        CreateVertexShader = function (self, pDeclaration, pFunction, Usage)
            local handle    = ffi.new('DWORD[1]');
            local res       = self.lpVtbl.CreateVertexShader(self, pDeclaration, pFunction, handle, Usage);

            return res, res == C.S_OK and handle[0] or nil;
        end,
        SetVertexShader = function (self, Handle)
            return self.lpVtbl.SetVertexShader(self, Handle);
        end,
        GetVertexShader = function (self)
            local handle    = ffi.new('DWORD[1]');
            local res       = self.lpVtbl.GetVertexShader(self, handle);

            return res, res == C.S_OK and handle[0] or nil;
        end,
        DeleteVertexShader = function (self, Handle)
            return self.lpVtbl.DeleteVertexShader(self, Handle);
        end,
        SetVertexShaderConstant = function (self, Register, pConstantData, ConstantCount)
            return self.lpVtbl.SetVertexShaderConstant(self, Register, pConstantData, ConstantCount);
        end,
        GetVertexShaderConstant = function (self, Register, ConstantCount)
            local data  = ffi.new('float[?]', ConstantCount * 4);
            local res   = self.lpVtbl.GetVertexShaderConstant(self, Register, data, ConstantCount);

            return res, res == C.S_OK and data or nil;
        end,
        GetVertexShaderDeclaration = function (self, Handle, pData, pSizeOfData)
            return self.lpVtbl.GetVertexShaderDeclaration(self, Handle, pData, pSizeOfData);
        end,
        GetVertexShaderFunction = function (self, Handle, pData, pSizeOfData)
            return self.lpVtbl.GetVertexShaderfunction (self, Handle, pData, pSizeOfData);
        end,
        SetStreamSource = function (self, StreamNumber, pStreamData, Stride)
            return self.lpVtbl.SetStreamSource(self, StreamNumber, pStreamData, Stride);
        end,
        GetStreamSource = function (self, StreamNumber)
            local buffer_ptr    = ffi.new('IDirect3DVertexBuffer8*[1]');
            local stride        = ffi.new('UINT[1]');
            local res           = self.lpVtbl.GetStreamSource(self, StreamNumber, buffer_ptr, stride);
            local buffer        = nil;

            if (res == C.S_OK) then
                buffer = ffi.cast('IDirect3DVertexBuffer8*', buffer_ptr[0]);
            end

            return res, buffer, res == C.S_OK and stride[0] or nil;
        end,
        SetIndices = function (self, pIndexData, BaseVertexIndex)
            return self.lpVtbl.SetIndices(self, pIndexData, BaseVertexIndex);
        end,
        GetIndices = function (self)
            local buffer_ptr    = ffi.new('IDirect3DIndexBuffer8*[1]');
            local index         = ffi.new('UINT[1]');
            local res           = self.lpVtbl.GetIndices(self, buffer_ptr, index);
            local buffer        = nil;

            if (res == C.S_OK) then
                buffer = ffi.cast('IDirect3DIndexBuffer8*', buffer_ptr[0]);
            end

            return res, buffer, res == C.S_OK and index[0] or nil;
        end,
        CreatePixelShader = function (self, pFunction)
            local handle    = ffi.new('DWORD[1]');
            local res       = self.lpVtbl.CreatePixelShader(self, pFunction, handle);

            return res, res == C.S_OK and handle[0] or nil;
        end,
        SetPixelShader = function (self, Handle)
            return self.lpVtbl.SetPixelShader(self, Handle);
        end,
        GetPixelShader = function (self)
            local handle    = ffi.new('DWORD[1]');
            local res       = self.lpVtbl.GetPixelShader(self, handle);

            return res, res == C.S_OK and handle[0] or nil;
        end,
        DeletePixelShader = function (self, Handle)
            return self.lpVtbl.DeletePixelShader(self, Handle);
        end,
        SetPixelShaderConstant = function (self, Register, pConstantData, ConstantCount)
            return self.lpVtbl.SetPixelShaderConstant(self, Register, pConstantData, ConstantCount);
        end,
        GetPixelShaderConstant = function (self, Register, ConstantCount)
            local data  = ffi.new('float[?]', ConstantCount * 4);
            local res   = self.lpVtbl.GetPixelShaderConstant(self, Register, data, ConstantCount);

            return res, res == C.S_OK and data or nil;
        end,
        GetPixelShaderFunction = function (self, Handle, pData, pSizeOfData)
            return self.lpVtbl.GetPixelShaderfunction (self, Handle, pData, pSizeOfData);
        end,
        DrawRectPatch = function (self, Handle, pNumSegs, pRectPatchInfo)
            return self.lpVtbl.DrawRectPatch(self, Handle, pNumSegs, pRectPatchInfo);
        end,
        DrawTriPatch = function (self, Handle, pNumSegs, pTriPatchInfo)
            return self.lpVtbl.DrawTriPatch(self, Handle, pNumSegs, pTriPatchInfo);
        end,
        DeletePatch = function (self, Handle)
            return self.lpVtbl.DeletePatch(self, Handle);
        end,
    },
});