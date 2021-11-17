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
* This file is created using the information from the various d3dx8 headers of the Direct3D 8 SDK:
*
* d3dx8.h, d3dx8core.h, d3dx8effect.h, d3dx8math.h, d3dx8mesh.h, d3dx8shape.h, d3dx8tex.h, dxerr8.h, dxfile.h
--]]

require('win32types');

local ffi   = require('ffi');
local C     = ffi.C;

ffi.cdef[[
    enum {
        D3DX_DEFAULT = 0xffffffff,
    };

    typedef enum _D3DXIMAGE_FILEFORMAT {
        D3DXIFF_BMP         = 0,
        D3DXIFF_JPG         = 1,
        D3DXIFF_TGA         = 2,
        D3DXIFF_PNG         = 3,
        D3DXIFF_DDS         = 4,
        D3DXIFF_PPM         = 5,
        D3DXIFF_DIB         = 6,
        D3DXIFF_FORCE_DWORD = 0x7fffffff
    } D3DXIMAGE_FILEFORMAT;

    typedef struct _D3DXIMAGE_INFO {
        UINT                    Width;
        UINT                    Height;
        UINT                    Depth;
        UINT                    MipLevels;
        D3DFORMAT               Format;
        D3DRESOURCETYPE         ResourceType;
        D3DXIMAGE_FILEFORMAT    ImageFileFormat;
    } D3DXIMAGE_INFO;

    typedef struct D3DXVECTOR2 {
        float x;
        float y;
    } D3DXVECTOR2, *LPD3DXVECTOR2;

    typedef struct D3DXVECTOR3 {
        float x;
        float y;
        float z;
    } D3DXVECTOR3, *LPD3DXVECTOR3;

    typedef struct D3DXVECTOR4 {
        float x;
        float y;
        float z;
        float w;
    } D3DXVECTOR4, *LPD3DXVECTOR4;

    typedef struct D3DXMATRIX {
        union {
            struct {
                float _11, _12, _13, _14;
                float _21, _22, _23, _24;
                float _31, _32, _33, _34;
                float _41, _42, _43, _44;
            };
            float m[4][4];
        };
    } D3DXMATRIX, *LPD3DXMATRIX;
]];

ffi.cdef[[
    /**
     * Type Forwards
     */
    typedef struct ID3DXBuffer      ID3DXBuffer;
    typedef struct ID3DXFont        ID3DXFont;
    typedef struct ID3DXSprite      ID3DXSprite;

    /**
     * ID3DXBuffer Interface
     */
    typedef struct ID3DXBufferVtbl {
        /*** IUnknown methods ***/
        HRESULT __stdcall (*QueryInterface)(ID3DXBuffer* This, REFIID riid, void** ppvObj);
        ULONG   __stdcall (*AddRef)(ID3DXBuffer* This);
        ULONG   __stdcall (*Release)(ID3DXBuffer* This);

        /*** ID3DXBuffer methods ***/
        LPVOID  __stdcall (*GetBufferPointer)(ID3DXBuffer* This);
        DWORD   __stdcall (*GetBufferSize)(ID3DXBuffer* This);
    } ID3DXBufferVtbl;

    struct ID3DXBuffer
    {
        struct ID3DXBufferVtbl* lpVtbl;
    };

    /**
     * ID3DXFont Interface
     */
    typedef struct ID3DXFontVtbl {
        /*** IUnknown methods ***/
        HRESULT __stdcall (*QueryInterface)(ID3DXFont* This, REFIID riid, void** ppvObj);
        ULONG   __stdcall (*AddRef)(ID3DXFont* This);
        ULONG   __stdcall (*Release)(ID3DXFont* This);

        /*** ID3DXFont methods ***/
        HRESULT __stdcall (*GetDevice)(ID3DXFont* This, IDirect3DDevice8** ppDevice);
        HRESULT __stdcall (*GetLogFont)(ID3DXFont* This, LOGFONTA* pLogFont);
        
        HRESULT __stdcall (*Begin)(ID3DXFont* This);
        INT     __stdcall (*DrawTextA)(ID3DXFont* This, const char* pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color);
        INT     __stdcall (*DrawTextW)(ID3DXFont* This, const wchar_t* pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color);
        HRESULT __stdcall (*End)(ID3DXFont* This);
        
        HRESULT __stdcall (*OnLostDevice)(ID3DXFont* This);
        HRESULT __stdcall (*OnResetDevice)(ID3DXFont* This);
    } ID3DXFontVtbl;

    struct ID3DXFont
    {
        struct ID3DXFontVtbl* lpVtbl;
    };

    /**
     * ID3DXSprite Interface
     */
    typedef struct ID3DXSpriteVtbl {
        /*** IUnknown methods ***/
        HRESULT __stdcall (*QueryInterface)(ID3DXSprite* This, REFIID iid, void** ppvObj);
        ULONG   __stdcall (*AddRef)(ID3DXSprite* This);
        ULONG   __stdcall (*Release)(ID3DXSprite* This);
    
        /*** ID3DXSprite methods ***/
        HRESULT __stdcall (*GetDevice)(ID3DXSprite* This, IDirect3DDevice8** ppDevice);

        HRESULT __stdcall (*Begin)(ID3DXSprite* This);
        HRESULT __stdcall (*Draw)(ID3DXSprite* This, IDirect3DTexture8* pSrcTexture, const RECT* pSrcRect, const D3DXVECTOR2* pScaling, const D3DXVECTOR2* pRotationCenter, FLOAT Rotation, const D3DXVECTOR2* pTranslation, D3DCOLOR Color);
        HRESULT __stdcall (*DrawTransform)(ID3DXSprite* This, IDirect3DTexture8* pSrcTexture, const RECT* pSrcRect, const D3DXMATRIX* pTransform, D3DCOLOR Color);
        HRESULT __stdcall (*End)(ID3DXSprite* This);
    
        HRESULT __stdcall (*OnLostDevice)(ID3DXSprite* This);
        HRESULT __stdcall (*OnResetDevice)(ID3DXSprite* This);
    } ID3DXSpriteVtbl;

    struct ID3DXSprite
    {
        struct ID3DXSpriteVtbl* lpVtbl;
    };
]];

--[[
* ID3DXBuffer Vtbl Forwarding
--]]
ID3DXBuffer = ffi.metatype('ID3DXBuffer', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- ID3DXBuffer Methods
        GetBufferPointer = function (self)
            return self.lpVtbl.GetBufferPointer(self);
        end,
        GetBufferSize = function (self)
            return self.lpVtbl.GetBufferSize(self);
        end,
    },
});

--[[
* ID3DXFont Vtbl Forwarding
--]]
ID3DXFont = ffi.metatype('ID3DXFont', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- ID3DXFont Methods
        GetDevice = function (self, ppDevice)
            local device_ptr    = ffi.new('IDirect3DDevice8*[1]');
            local res           = self.lpVtbl.GetDevice(self, device_ptr);
            local device        = nil;

            if (res == C.S_OK) then
                device = ffi.cast('IDirect3DDevice8*', device_ptr[0]);
            end

            return res, device;
        end,
        GetLogFont = function (self, pLogFont)
            return self.lpVtbl.GetLogFont(self, pLogFont);
        end,
        Begin = function (self)
            return self.lpVtbl.Begin(self);
        end,
        DrawTextA = function (self, pString, Count, pRect, Format, Color)
            return self.lpVtbl.DrawTextA(self, pString, Count, pRect, Format, Color);
        end,
        DrawTextW = function (self, pString, Count, pRect, Format, Color)
            return self.lpVtbl.DrawTextW(self, pString, Count, pRect, Format, Color);
        end,
        End = function (self)
            return self.lpVtbl.End(self);
        end,
        OnLostDevice = function (self)
            return self.lpVtbl.OnLostDevice(self);
        end,
        OnResetDevice = function (self)
            return self.lpVtbl.OnResetDevice(self);
        end,
    },
});

--[[
* ID3DXSprite Vtbl Forwarding
--]]
ID3DXSprite = ffi.metatype('ID3DXSprite', {
    __index = {
        -- IUnknown Methods
        QueryInterface  = IUnknown.QueryInterface,
        AddRef          = IUnknown.AddRef,
        Release         = IUnknown.Release,

        -- ID3DXSprite Methods
        GetDevice = function (self, ppDevice)
            local device_ptr    = ffi.new('IDirect3DDevice8*[1]');
            local res           = self.lpVtbl.GetDevice(self, device_ptr);
            local device        = nil;

            if (res == C.S_OK) then
                device = ffi.cast('IDirect3DDevice8*', device_ptr[0]);
            end

            return res, device;
        end,
        Begin = function (self)
            return self.lpVtbl.Begin(self);
        end,
        Draw = function (self, pSrcTexture, pSrcRect, pScaling, pRotationCenter, Rotation, pTranslation, Color)
            return self.lpVtbl.Draw(self, pSrcTexture, pSrcRect, pScaling, pRotationCenter, Rotation, pTranslation, Color);
        end,
        DrawTransform = function (self, pSrcTexture, pSrcRect, pTransform, Color)
            return self.lpVtbl.DrawTransform(self, pSrcTexture, pSrcRect, pTransform, Color);
        end,
        End = function (self)
            return self.lpVtbl.End(self);
        end,
        OnLostDevice = function (self)
            return self.lpVtbl.OnLostDevice(self);
        end,
        OnResetDevice = function (self)
            return self.lpVtbl.OnResetDevice(self);
        end,
    },
});

--[[
* The following functions are from the Direct3D 8 SDK 'd3dx8.lib' file. Addons.dll exports these functions as forwards to allow addons
* to make use of them easily without needing to load/import any other special files. If there is a function below that you feel you need
* or want to make use of, feel free to contact the Ashita development team for help with getting any of the additional requirements added
* to allow the commented out function to work.
*
* Please note, some of the functions and features below should not be used. There are better things that can be used/done instead.
* For example, you should not use the ID3DXFont object or its D3DX functions. Instead, you should use the built-in font system within
* Ashita, or make use of ImGui instead.
--]]

ffi.cdef[[
    // d3dx8core.h
    HRESULT __stdcall D3DXCreateFont(IDirect3DDevice8* pDevice, HFONT hFont, ID3DXFont** ppFont);
    HRESULT __stdcall D3DXCreateFontIndirect(IDirect3DDevice8* pDevice, const LOGFONTA* pLogFont, ID3DXFont** ppFont);
    HRESULT __stdcall D3DXCreateSprite(IDirect3DDevice8* pDevice, ID3DXSprite** ppSprite);
    //HRESULT __stdcall D3DXCreateRenderToSurface(IDirect3DDevice8* pDevice, UINT Width, UINT Height, D3DFORMAT Format, BOOL DepthStencil, D3DFORMAT DepthStencilFormat, LPD3DXRENDERTOSURFACE* ppRenderToSurface);
    //HRESULT __stdcall D3DXCreateRenderToEnvMap(IDirect3DDevice8* pDevice, UINT Size, D3DFORMAT Format, BOOL DepthStencil, D3DFORMAT DepthStencilFormat, LPD3DXRenderToEnvMap* ppRenderToEnvMap);
    HRESULT __stdcall D3DXAssembleShaderFromFileA(const char* pSrcFile, DWORD Flags, ID3DXBuffer** ppConstants, ID3DXBuffer** ppCompiledShader, ID3DXBuffer** ppCompilationErrors);
    HRESULT __stdcall D3DXAssembleShaderFromFileW(const wchar_t* pSrcFile, DWORD Flags, ID3DXBuffer** ppConstants, ID3DXBuffer** ppCompiledShader, ID3DXBuffer** ppCompilationErrors);
    HRESULT __stdcall D3DXAssembleShaderFromResourceA(HMODULE hSrcModule, const char* pSrcResource, DWORD Flags, ID3DXBuffer** ppConstants, ID3DXBuffer** ppCompiledShader, ID3DXBuffer** ppCompilationErrors);
    HRESULT __stdcall D3DXAssembleShaderFromResourceW(HMODULE hSrcModule, const wchar_t* pSrcResource, DWORD Flags, ID3DXBuffer** ppConstants, ID3DXBuffer** ppCompiledShader, ID3DXBuffer** ppCompilationErrors);
    HRESULT __stdcall D3DXAssembleShader(LPCVOID pSrcData, UINT SrcDataLen, DWORD Flags, ID3DXBuffer** ppConstants, ID3DXBuffer** ppCompiledShader, ID3DXBuffer** ppCompilationErrors);
    HRESULT __stdcall D3DXGetErrorStringA(HRESULT hr, char* pBuffer, UINT BufferLen);
    HRESULT __stdcall D3DXGetErrorStringW(HRESULT hr, wchar_t* pBuffer, UINT BufferLen);

    // d3dx8effect.h
    //HRESULT __stdcall D3DXCreateEffectFromFileA(IDirect3DDevice8* pDevice, LPCSTR pSrcFile, LPD3DXEFFECT* ppEffect, LPD3DXBUFFER* ppCompilationErrors);
    //HRESULT __stdcall D3DXCreateEffectFromFileW(IDirect3DDevice8* pDevice, LPCWSTR pSrcFile, LPD3DXEFFECT* ppEffect, LPD3DXBUFFER* ppCompilationErrors);
    //HRESULT __stdcall D3DXCreateEffectFromResourceA(IDirect3DDevice8* pDevice, HMODULE hSrcModule, LPCSTR pSrcResource, LPD3DXEFFECT* ppEffect, LPD3DXBUFFER* ppCompilationErrors);
    //HRESULT __stdcall D3DXCreateEffectFromResourceW(IDirect3DDevice8* pDevice, HMODULE hSrcModule, LPCWSTR pSrcResource, LPD3DXEFFECT* ppEffect, LPD3DXBUFFER* ppCompilationErrors);
    //HRESULT __stdcall D3DXCreateEffect(IDirect3DDevice8* pDevice, LPCVOID pSrcData, UINT SrcDataSize, LPD3DXEFFECT* ppEffect, LPD3DXBUFFER* ppCompilationErrors);

    // d3dx8math.h
    //HRESULT __stdcall D3DXCreateMatrixStack(DWORD Flags, LPD3DXMATRIXSTACK* ppStack);

    // d3dx8mesh.h
    //HRESULT __stdcall D3DXCreateMesh(DWORD NumFaces, DWORD NumVertices, DWORD Options, CONST DWORD *pDeclaration, IDirect3DDevice8* pD3D, LPD3DXMESH* ppMesh);
    //HRESULT __stdcall D3DXCreateMeshFVF(DWORD NumFaces, DWORD NumVertices, DWORD Options, DWORD FVF, IDirect3DDevice8* pD3D, LPD3DXMESH* ppMesh);
    //HRESULT __stdcall D3DXCreateSPMesh(LPD3DXMESH pMesh, CONST DWORD* pAdjacency, CONST LPD3DXATTRIBUTEWEIGHTS pVertexAttributeWeights, CONST FLOAT *pVertexWeights, LPD3DXSPMESH* ppSMesh);
    //HRESULT __stdcall D3DXCleanMesh(LPD3DXMESH pMeshIn, CONST DWORD* pAdjacencyIn, LPD3DXMESH* ppMeshOut, DWORD* pAdjacencyOut, LPD3DXBUFFER* ppErrorsAndWarnings);
    //HRESULT __stdcall D3DXValidMesh(LPD3DXMESH pMeshIn, CONST DWORD* pAdjacency, LPD3DXBUFFER* ppErrorsAndWarnings);
    //HRESULT __stdcall D3DXGeneratePMesh(LPD3DXMESH pMesh, CONST DWORD* pAdjacency, CONST LPD3DXATTRIBUTEWEIGHTS pVertexAttributeWeights, CONST FLOAT *pVertexWeights, DWORD MinValue, DWORD Options, LPD3DXPMESH* ppPMesh);
    //HRESULT __stdcall D3DXSimplifyMesh(LPD3DXMESH pMesh, CONST DWORD* pAdjacency, CONST LPD3DXATTRIBUTEWEIGHTS pVertexAttributeWeights, CONST FLOAT *pVertexWeights, DWORD MinValue, DWORD Options, LPD3DXMESH* ppMesh);
    //HRESULT __stdcall D3DXComputeBoundingSphere(PVOID pPointsFVF, DWORD NumVertices, DWORD FVF, D3DXVECTOR3 *pCenter, FLOAT *pRadius);
    //HRESULT __stdcall D3DXComputeBoundingBox(PVOID pPointsFVF, DWORD NumVertices, DWORD FVF, D3DXVECTOR3 *pMin, D3DXVECTOR3 *pMax);
    //HRESULT __stdcall D3DXComputeNormals(LPD3DXBASEMESH pMesh, CONST DWORD *pAdjacency);
    //HRESULT __stdcall D3DXCreateBuffer(DWORD NumBytes, LPD3DXBUFFER *ppBuffer);
    //HRESULT __stdcall D3DXLoadMeshFromX(LPSTR pFilename, DWORD Options, IDirect3DDevice8* pD3D, LPD3DXBUFFER *ppAdjacency, LPD3DXBUFFER *ppMaterials, DWORD *pNumMaterials, LPD3DXMESH *ppMesh);
    //HRESULT __stdcall D3DXLoadMeshFromXInMemory(PBYTE Memory, DWORD SizeOfMemory, DWORD Options, IDirect3DDevice8* pD3D, LPD3DXBUFFER *ppAdjacency, LPD3DXBUFFER *ppMaterials, DWORD *pNumMaterials, LPD3DXMESH *ppMesh);
    //HRESULT __stdcall D3DXLoadMeshFromXResource(HMODULE Module, LPCTSTR Name, LPCTSTR Type, DWORD Options, IDirect3DDevice8* pD3D, LPD3DXBUFFER *ppAdjacency, LPD3DXBUFFER *ppMaterials, DWORD *pNumMaterials, LPD3DXMESH *ppMesh);
    //HRESULT __stdcall D3DXSaveMeshToX(LPSTR pFilename, LPD3DXMESH pMesh, CONST DWORD* pAdjacency, CONST LPD3DXMATERIAL pMaterials, DWORD NumMaterials, DWORD Format);
    //HRESULT __stdcall D3DXCreatePMeshFromStream(IStream *pStream, DWORD Options, IDirect3DDevice8* pD3DDevice, LPD3DXBUFFER *ppMaterials, DWORD* pNumMaterials, LPD3DXPMESH *ppPMesh);
    //HRESULT __stdcall D3DXCreateSkinMesh(DWORD NumFaces, DWORD NumVertices, DWORD NumBones, DWORD Options, CONST DWORD *pDeclaration, IDirect3DDevice8* pD3D, LPD3DXSKINMESH* ppSkinMesh);
    //HRESULT __stdcall D3DXCreateSkinMeshFVF(DWORD NumFaces, DWORD NumVertices, DWORD NumBones, DWORD Options, DWORD FVF, IDirect3DDevice8* pD3D, LPD3DXSKINMESH* ppSkinMesh);
    //HRESULT __stdcall D3DXCreateSkinMeshFromMesh(LPD3DXMESH pMesh, DWORD numBones, LPD3DXSKINMESH* ppSkinMesh);
    //HRESULT __stdcall D3DXLoadMeshFromXof(LPDIRECTXFILEDATA pXofObjMesh, DWORD Options, IDirect3DDevice8* pD3DDevice, LPD3DXBUFFER *ppAdjacency, LPD3DXBUFFER *ppMaterials, DWORD *pNumMaterials, LPD3DXMESH *ppMesh);
    //HRESULT __stdcall D3DXLoadSkinMeshFromXof(LPDIRECTXFILEDATA pxofobjMesh, DWORD Options, IDirect3DDevice8* pD3D, LPD3DXBUFFER* ppAdjacency, LPD3DXBUFFER* ppMaterials, DWORD *pMatOut, LPD3DXBUFFER* ppBoneNames, LPD3DXBUFFER* ppBoneTransforms, LPD3DXSKINMESH* ppMesh);
    //HRESULT __stdcall D3DXTessellateNPatches(LPD3DXMESH pMeshIn, CONST DWORD* pAdjacencyIn, FLOAT NumSegs, BOOL QuadraticInterpNormals, LPD3DXMESH *ppMeshOut, LPD3DXBUFFER *ppAdjacencyOut);
    //UINT __stdcall D3DXGetFVFVertexSize(DWORD FVF);
    //HRESULT __stdcall D3DXDeclaratorFromFVF(DWORD FVF, DWORD Declaration[MAX_FVF_DECL_SIZE]);
    //HRESULT __stdcall D3DXFVFFromDeclarator(CONST DWORD *pDeclarator, DWORD *pFVF);
    //HRESULT __stdcall D3DXWeldVertices(CONST LPD3DXMESH pMesh, LPD3DXWELDEPSILONS pEpsilons, CONST DWORD *pAdjacencyIn, DWORD *pAdjacencyOut, DWORD* pFaceRemap, LPD3DXBUFFER *ppVertexRemap);
    //HRESULT __stdcall D3DXIntersect(LPD3DXBASEMESH pMesh, CONST D3DXVECTOR3 *pRayPos, CONST D3DXVECTOR3 *pRayDir, BOOL *pHit, DWORD *pFaceIndex, FLOAT *pU, FLOAT *pV, FLOAT *pDist, LPD3DXBUFFER *ppAllHits, DWORD *pCountOfHits);
    //HRESULT __stdcall D3DXIntersectSubset(LPD3DXBASEMESH pMesh, DWORD AttribId, CONST D3DXVECTOR3 *pRayPos, CONST D3DXVECTOR3 *pRayDir, BOOL *pHit, DWORD *pFaceIndex, FLOAT *pU, FLOAT *pV, FLOAT *pDist, LPD3DXBUFFER *ppAllHits, DWORD *pCountOfHits);
    //HRESULT __stdcall D3DXSplitMesh(CONST LPD3DXMESH pMeshIn, CONST DWORD *pAdjacencyIn, CONST DWORD MaxSize, CONST DWORD Options, DWORD *pMeshesOut, LPD3DXBUFFER *ppMeshArrayOut, LPD3DXBUFFER *ppAdjacencyArrayOut, LPD3DXBUFFER *ppFaceRemapArrayOut, LPD3DXBUFFER *ppVertRemapArrayOut);
    //BOOL __stdcall D3DXIntersectTri(CONST D3DXVECTOR3 *p0, CONST D3DXVECTOR3 *p1, CONST D3DXVECTOR3 *p2, CONST D3DXVECTOR3 *pRayPos, CONST D3DXVECTOR3 *pRayDir, FLOAT *pU, FLOAT *pV, FLOAT *pDist);
    //BOOL __stdcall D3DXSphereBoundProbe(CONST D3DXVECTOR3 *pCenter, FLOAT Radius, CONST D3DXVECTOR3 *pRayPosition, CONST D3DXVECTOR3 *pRayDirection);
    //BOOL __stdcall D3DXBoxBoundProbe(CONST D3DXVECTOR3 *pMin, CONST D3DXVECTOR3 *pMax, CONST D3DXVECTOR3 *pRayPosition, CONST D3DXVECTOR3 *pRayDirection);
    //HRESULT __stdcall D3DXComputeTangent(LPD3DXMESH InMesh, DWORD TexStage, LPD3DXMESH OutMesh, DWORD TexStageUVec, DWORD TexStageVVec, DWORD Wrap, DWORD *Adjacency);
    //HRESULT __stdcall D3DXConvertMeshSubsetToSingleStrip(LPD3DXBASEMESH MeshIn, DWORD AttribId, DWORD IBOptions, LPDIRECT3DINDEXBUFFER8 *ppIndexBuffer, DWORD *pNumIndices);
    //HRESULT __stdcall D3DXConvertMeshSubsetToStrips(LPD3DXBASEMESH MeshIn, DWORD AttribId, DWORD IBOptions, LPDIRECT3DINDEXBUFFER8 *ppIndexBuffer, DWORD *pNumIndices, LPD3DXBUFFER *ppStripLengths, DWORD *pNumStrips);

    // d3dx8shape.h
    //HRESULT __stdcall D3DXCreatePolygon(IDirect3DDevice8* pDevice, FLOAT Length, UINT Sides, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency);
    //HRESULT __stdcall D3DXCreateBox(IDirect3DDevice8* pDevice, FLOAT Width, FLOAT Height, FLOAT Depth, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency);
    //HRESULT __stdcall D3DXCreateCylinder(IDirect3DDevice8* pDevice, FLOAT Radius1, FLOAT Radius2, FLOAT Length, UINT Slices, UINT Stacks, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency);
    //HRESULT __stdcall D3DXCreateSphere(IDirect3DDevice8* pDevice, FLOAT Radius, UINT Slices, UINT Stacks, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency);
    //HRESULT __stdcall D3DXCreateTorus(IDirect3DDevice8* pDevice, FLOAT InnerRadius, FLOAT OuterRadius, UINT Sides, UINT Rings, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency);
    //HRESULT __stdcall D3DXCreateTeapot(IDirect3DDevice8* pDevice, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency);
    //HRESULT __stdcall D3DXCreateTextA(IDirect3DDevice8* pDevice, HDC hDC, LPCSTR pText, FLOAT Deviation, FLOAT Extrusion, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency, LPGLYPHMETRICSFLOAT pGlyphMetrics);
    //HRESULT __stdcall D3DXCreateTextW(IDirect3DDevice8* pDevice, HDC hDC, LPCWSTR pText, FLOAT Deviation, FLOAT Extrusion, LPD3DXMESH* ppMesh, LPD3DXBUFFER* ppAdjacency, LPGLYPHMETRICSFLOAT pGlyphMetrics);

    // d3dx8tex.h
    HRESULT __stdcall D3DXGetImageInfoFromFileA(const char* pSrcFile, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXGetImageInfoFromFileW(const wchar_t* pSrcFile, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXGetImageInfoFromResourceA(HMODULE hSrcModule, const char* pSrcResource, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXGetImageInfoFromResourceW(HMODULE hSrcModule, const wchar_t* pSrcResource, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXGetImageInfoFromFileInMemory(LPCVOID pSrcData, UINT SrcDataSize, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadSurfaceFromFileA(IDirect3DSurface8* pDestSurface, const PALETTEENTRY* pDestPalette, const RECT* pDestRect, const char* pSrcFile, const RECT* pSrcRect, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadSurfaceFromFileW(IDirect3DSurface8* pDestSurface, const PALETTEENTRY* pDestPalette, const RECT* pDestRect, const wchar_t* pSrcFile, const RECT* pSrcRect, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadSurfaceFromResourceA(IDirect3DSurface8* pDestSurface, const PALETTEENTRY* pDestPalette, const RECT* pDestRect, HMODULE hSrcModule, const char* pSrcResource, const RECT* pSrcRect, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadSurfaceFromResourceW(IDirect3DSurface8* pDestSurface, const PALETTEENTRY* pDestPalette, const RECT* pDestRect, HMODULE hSrcModule, const wchar_t* pSrcResource, const RECT* pSrcRect, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadSurfaceFromFileInMemory(IDirect3DSurface8* pDestSurface, const PALETTEENTRY* pDestPalette, const RECT* pDestRect, LPCVOID pSrcData, UINT SrcDataSize, const RECT* pSrcRect, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadSurfaceFromSurface(IDirect3DSurface8* pDestSurface, const PALETTEENTRY* pDestPalette, const RECT* pDestRect, IDirect3DSurface8* pSrcSurface, const PALETTEENTRY* pSrcPalette, const RECT* pSrcRect, DWORD Filter, D3DCOLOR ColorKey);
    HRESULT __stdcall D3DXLoadSurfaceFromMemory(IDirect3DSurface8* pDestSurface, const PALETTEENTRY* pDestPalette, const RECT* pDestRect, LPCVOID pSrcMemory, D3DFORMAT SrcFormat, UINT SrcPitch, const PALETTEENTRY* pSrcPalette, const RECT* pSrcRect, DWORD Filter, D3DCOLOR ColorKey);
    HRESULT __stdcall D3DXSaveSurfaceToFileA(const char* pDestFile, D3DXIMAGE_FILEFORMAT DestFormat, IDirect3DSurface8* pSrcSurface, const PALETTEENTRY* pSrcPalette, const RECT* pSrcRect);
    HRESULT __stdcall D3DXSaveSurfaceToFileW(const wchar_t* pDestFile, D3DXIMAGE_FILEFORMAT DestFormat, IDirect3DSurface8* pSrcSurface, const PALETTEENTRY* pSrcPalette, const RECT* pSrcRect);
    HRESULT __stdcall D3DXLoadVolumeFromFileA(IDirect3DVolume8* pDestVolume, const PALETTEENTRY* pDestPalette, const D3DBOX* pDestBox, const char* pSrcFile, const D3DBOX* pSrcBox, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadVolumeFromFileW(IDirect3DVolume8* pDestVolume, const PALETTEENTRY* pDestPalette, const D3DBOX* pDestBox, const wchar_t* pSrcFile, const D3DBOX* pSrcBox, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadVolumeFromResourceA(IDirect3DVolume8* pDestVolume, const PALETTEENTRY* pDestPalette, const D3DBOX* pDestBox, HMODULE hSrcModule, const char* pSrcResource, const D3DBOX* pSrcBox, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadVolumeFromResourceW(IDirect3DVolume8* pDestVolume, const PALETTEENTRY* pDestPalette, const D3DBOX* pDestBox, HMODULE hSrcModule, const wchar_t* pSrcResource, const D3DBOX* pSrcBox, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadVolumeFromFileInMemory(IDirect3DVolume8* pDestVolume, const PALETTEENTRY* pDestPalette, const D3DBOX* pDestBox, LPCVOID pSrcData, UINT SrcDataSize, const D3DBOX* pSrcBox, DWORD Filter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo);
    HRESULT __stdcall D3DXLoadVolumeFromVolume(IDirect3DVolume8* pDestVolume, const PALETTEENTRY* pDestPalette, const D3DBOX* pDestBox, IDirect3DVolume8* pSrcVolume, const PALETTEENTRY* pSrcPalette, const D3DBOX* pSrcBox, DWORD Filter, D3DCOLOR ColorKey);
    HRESULT __stdcall D3DXLoadVolumeFromMemory(IDirect3DVolume8* pDestVolume, const PALETTEENTRY* pDestPalette, const D3DBOX* pDestBox, LPCVOID pSrcMemory, D3DFORMAT SrcFormat, UINT SrcRowPitch, UINT SrcSlicePitch, const PALETTEENTRY* pSrcPalette, const D3DBOX* pSrcBox, DWORD Filter, D3DCOLOR ColorKey);
    HRESULT __stdcall D3DXSaveVolumeToFileA(const char* pDestFile, D3DXIMAGE_FILEFORMAT DestFormat, IDirect3DVolume8* pSrcVolume, const PALETTEENTRY* pSrcPalette, const D3DBOX* pSrcBox);
    HRESULT __stdcall D3DXSaveVolumeToFileW(const wchar_t* pDestFile, D3DXIMAGE_FILEFORMAT DestFormat, IDirect3DVolume8* pSrcVolume, const PALETTEENTRY* pSrcPalette, const D3DBOX* pSrcBox);
    HRESULT __stdcall D3DXCheckTextureRequirements(IDirect3DDevice8* pDevice, UINT* pWidth, UINT* pHeight, UINT* pNumMipLevels, DWORD Usage, D3DFORMAT* pFormat, D3DPOOL Pool);
    HRESULT __stdcall D3DXCheckCubeTextureRequirements(IDirect3DDevice8* pDevice, UINT* pSize, UINT* pNumMipLevels, DWORD Usage, D3DFORMAT* pFormat, D3DPOOL Pool);
    HRESULT __stdcall D3DXCheckVolumeTextureRequirements(IDirect3DDevice8* pDevice, UINT* pWidth, UINT* pHeight, UINT* pDepth, UINT* pNumMipLevels, DWORD Usage, D3DFORMAT* pFormat, D3DPOOL Pool);
    HRESULT __stdcall D3DXCreateTexture(IDirect3DDevice8* pDevice, UINT Width, UINT Height, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateCubeTexture(IDirect3DDevice8* pDevice, UINT Size, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateVolumeTexture(IDirect3DDevice8* pDevice, UINT Width, UINT Height, UINT Depth, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateTextureFromFileA(IDirect3DDevice8* pDevice, const char* pSrcFile, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateTextureFromFileA(IDirect3DDevice8* pDevice, const char* pSrcFile, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromFileA(IDirect3DDevice8* pDevice, const char* pSrcFile, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromFileW(IDirect3DDevice8* pDevice, const wchar_t* pSrcFile, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromFileA(IDirect3DDevice8* pDevice, const char* pSrcFile, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromFileW(IDirect3DDevice8* pDevice, const wchar_t* pSrcFile, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateTextureFromResourceA(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const char* pSrcResource, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateTextureFromResourceW(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const wchar_t* pSrcResource, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromResourceA(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const char* pSrcResource, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromResourceW(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const wchar_t* pSrcResource, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromResourceA(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const char* pSrcResource, IDirect3DVolumeTexture8* ppVolumeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromResourceW(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const wchar_t* pSrcResource, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateTextureFromFileExA(IDirect3DDevice8* pDevice, const char* pSrcFile, UINT Width, UINT Height, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateTextureFromFileExW(IDirect3DDevice8* pDevice, const wchar_t* pSrcFile, UINT Width, UINT Height, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromFileExA(IDirect3DDevice8* pDevice, const char* pSrcFile, UINT Size, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromFileExW(IDirect3DDevice8* pDevice, const wchar_t* pSrcFile, UINT Size, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromFileExA(IDirect3DDevice8* pDevice, const char* pSrcFile, UINT Width, UINT Height, UINT Depth, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromFileExW(IDirect3DDevice8* pDevice, const wchar_t* pSrcFile, UINT Width, UINT Height, UINT Depth, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateTextureFromResourceExA(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const char* pSrcResource, UINT Width, UINT Height, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateTextureFromResourceExW(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const wchar_t* pSrcResource, UINT Width, UINT Height, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromResourceExA(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const char* pSrcResource, UINT Size, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromResourceExW(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const wchar_t* pSrcResource, UINT Size, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromResourceExA(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const char* pSrcResource, UINT Width, UINT Height, UINT Depth, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromResourceExW(IDirect3DDevice8* pDevice, HMODULE hSrcModule, const wchar_t* pSrcResource, UINT Width, UINT Height, UINT Depth, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateTextureFromFileInMemory(IDirect3DDevice8* pDevice, LPCVOID pSrcData, UINT SrcDataSize, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromFileInMemory(IDirect3DDevice8* pDevice, LPCVOID pSrcData, UINT SrcDataSize, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromFileInMemory(IDirect3DDevice8* pDevice, LPCVOID pSrcData, UINT SrcDataSize, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXCreateTextureFromFileInMemoryEx(IDirect3DDevice8* pDevice, LPCVOID pSrcData, UINT SrcDataSize, UINT Width, UINT Height, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DTexture8** ppTexture);
    HRESULT __stdcall D3DXCreateCubeTextureFromFileInMemoryEx(IDirect3DDevice8* pDevice, LPCVOID pSrcData, UINT SrcDataSize, UINT Size, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DCubeTexture8** ppCubeTexture);
    HRESULT __stdcall D3DXCreateVolumeTextureFromFileInMemoryEx(IDirect3DDevice8* pDevice, LPCVOID pSrcData, UINT SrcDataSize, UINT Width, UINT Height, UINT Depth, UINT MipLevels, DWORD Usage, D3DFORMAT Format, D3DPOOL Pool, DWORD Filter, DWORD MipFilter, D3DCOLOR ColorKey, D3DXIMAGE_INFO* pSrcInfo, PALETTEENTRY* pPalette, IDirect3DVolumeTexture8** ppVolumeTexture);
    HRESULT __stdcall D3DXSaveTextureToFileA(const char* pDestFile, D3DXIMAGE_FILEFORMAT DestFormat, IDirect3DBaseTexture8* pSrcTexture, const PALETTEENTRY* pSrcPalette);
    HRESULT __stdcall D3DXSaveTextureToFileW(const wchar_t* pDestFile, D3DXIMAGE_FILEFORMAT DestFormat, IDirect3DBaseTexture8* pSrcTexture, const PALETTEENTRY* pSrcPalette);
    HRESULT __stdcall D3DXFilterTexture(IDirect3DBaseTexture8* pBaseTexture, const PALETTEENTRY* pPalette, UINT SrcLevel, DWORD Filter);
    //HRESULT __stdcall D3DXFillTexture(IDirect3DTexture8* pTexture, LPD3DXFILL2D pFunction, LPVOID pData);
    //HRESULT __stdcall D3DXFillCubeTexture(IDirect3DCubeTexture8* pCubeTexture, LPD3DXFILL3D pFunction, LPVOID pData);
    //HRESULT __stdcall D3DXFillVolumeTexture(IDirect3DVolumeTexture8* pVolumeTexture, LPD3DXFILL3D pFunction, LPVOID pData);
    //HRESULT __stdcall D3DXComputeNormalMap(IDirect3DTexture8* pTexture, IDirect3DTexture8* pSrcTexture, const PALETTEENTRY* pSrcPalette, DWORD Flags, DWORD Channel, FLOAT Amplitude);

    // dxerr8.h
    //const char* __stdcall DXGetErrorString8A(HRESULT hr);
    //const WCHAR* __stdcall DXGetErrorString8W(HRESULT hr);
    //const char* __stdcall DXGetErrorDescription8A(HRESULT hr);
    //const WCHAR* __stdcall DXGetErrorDescription8W(HRESULT hr);
    //HRESULT __stdcall DXTraceA(const char* strFile, DWORD dwLine, HRESULT hr, const char* strMsg, BOOL bPopMsgBox);
    //HRESULT __stdcall DXTraceW(const char* strFile, DWORD dwLine, HRESULT hr, const WCHAR* strMsg, BOOL bPopMsgBox);

    // dxfile.h
    //HRESULT __stdcall DirectXFileCreate(LPDIRECTXFILE *lplpDirectXFile);
]];