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
* This file is created using the information from the d3d8caps.h header file of the Direct3D 8 SDK.
--]]

require('win32types');

local ffi = require('ffi');

ffi.cdef[[
    typedef struct _D3DCAPS8 {
        D3DDEVTYPE  DeviceType;
        UINT  AdapterOrdinal;
        DWORD Caps;
        DWORD Caps2;
        DWORD Caps3;
        DWORD PresentationIntervals;
        DWORD CursorCaps;
        DWORD DevCaps;
        DWORD PrimitiveMiscCaps;
        DWORD RasterCaps;
        DWORD ZCmpCaps;
        DWORD SrcBlendCaps;
        DWORD DestBlendCaps;
        DWORD AlphaCmpCaps;
        DWORD ShadeCaps;
        DWORD TextureCaps;
        DWORD TextureFilterCaps;
        DWORD CubeTextureFilterCaps;
        DWORD VolumeTextureFilterCaps;
        DWORD TextureAddressCaps;
        DWORD VolumeTextureAddressCaps;
        DWORD LineCaps;
        DWORD MaxTextureWidth, MaxTextureHeight;
        DWORD MaxVolumeExtent;
        DWORD MaxTextureRepeat;
        DWORD MaxTextureAspectRatio;
        DWORD MaxAnisotropy;
        float MaxVertexW;
        float GuardBandLeft;
        float GuardBandTop;
        float GuardBandRight;
        float GuardBandBottom;
        float ExtentsAdjust;
        DWORD StencilCaps;
        DWORD FVFCaps;
        DWORD TextureOpCaps;
        DWORD MaxTextureBlendStages;
        DWORD MaxSimultaneousTextures;
        DWORD VertexProcessingCaps;
        DWORD MaxActiveLights;
        DWORD MaxUserClipPlanes;
        DWORD MaxVertexBlendMatrices;
        DWORD MaxVertexBlendMatrixIndex;
        float MaxPointSize;
        DWORD MaxPrimitiveCount;
        DWORD MaxVertexIndex;
        DWORD MaxStreams;
        DWORD MaxStreamStride;
        DWORD VertexShaderVersion;
        DWORD MaxVertexShaderConst;
        DWORD PixelShaderVersion;
        float MaxPixelShaderValue;
    } D3DCAPS8;

    enum {
        D3DCAPS_READ_SCANLINE                       = 0x00020000L,
        D3DCAPS2_NO2DDURING3DSCENE                  = 0x00000002L,
        D3DCAPS2_FULLSCREENGAMMA                    = 0x00020000L,
        D3DCAPS2_CANRENDERWINDOWED                  = 0x00080000L,
        D3DCAPS2_CANCALIBRATEGAMMA                  = 0x00100000L,
        D3DCAPS2_RESERVED                           = 0x02000000L,
        D3DCAPS2_CANMANAGERESOURCE                  = 0x10000000L,
        D3DCAPS2_DYNAMICTEXTURES                    = 0x20000000L,
        D3DCAPS3_RESERVED                           = 0x8000001fL,
        D3DCAPS3_ALPHA_FULLSCREEN_FLIP_OR_DISCARD   = 0x00000020L,
    };
    
    enum {
        D3DPRESENT_INTERVAL_DEFAULT                 = 0x00000000L,
        D3DPRESENT_INTERVAL_ONE                     = 0x00000001L,
        D3DPRESENT_INTERVAL_TWO                     = 0x00000002L,
        D3DPRESENT_INTERVAL_THREE                   = 0x00000004L,
        D3DPRESENT_INTERVAL_FOUR                    = 0x00000008L,
        D3DPRESENT_INTERVAL_IMMEDIATE               = 0x80000000L,
    };
    
    enum {
        D3DCURSORCAPS_COLOR                         = 0x00000001L,
        D3DCURSORCAPS_LOWRES                        = 0x00000002L,
    };
    
    enum {
        D3DDEVCAPS_EXECUTESYSTEMMEMORY              = 0x00000010L,
        D3DDEVCAPS_EXECUTEVIDEOMEMORY               = 0x00000020L,
        D3DDEVCAPS_TLVERTEXSYSTEMMEMORY             = 0x00000040L,
        D3DDEVCAPS_TLVERTEXVIDEOMEMORY              = 0x00000080L,
        D3DDEVCAPS_TEXTURESYSTEMMEMORY              = 0x00000100L,
        D3DDEVCAPS_TEXTUREVIDEOMEMORY               = 0x00000200L,
        D3DDEVCAPS_DRAWPRIMTLVERTEX                 = 0x00000400L,
        D3DDEVCAPS_CANRENDERAFTERFLIP               = 0x00000800L,
        D3DDEVCAPS_TEXTURENONLOCALVIDMEM            = 0x00001000L,
        D3DDEVCAPS_DRAWPRIMITIVES2                  = 0x00002000L,
        D3DDEVCAPS_SEPARATETEXTUREMEMORIES          = 0x00004000L,
        D3DDEVCAPS_DRAWPRIMITIVES2EX                = 0x00008000L,
        D3DDEVCAPS_HWTRANSFORMANDLIGHT              = 0x00010000L,
        D3DDEVCAPS_CANBLTSYSTONONLOCAL              = 0x00020000L,
        D3DDEVCAPS_HWRASTERIZATION                  = 0x00080000L,
        D3DDEVCAPS_PUREDEVICE                       = 0x00100000L,
        D3DDEVCAPS_QUINTICRTPATCHES                 = 0x00200000L,
        D3DDEVCAPS_RTPATCHES                        = 0x00400000L,
        D3DDEVCAPS_RTPATCHHANDLEZERO                = 0x00800000L,
        D3DDEVCAPS_NPATCHES                         = 0x01000000L,
    };

    enum {
        D3DPMISCCAPS_MASKZ                          = 0x00000002L,
        D3DPMISCCAPS_LINEPATTERNREP                 = 0x00000004L,
        D3DPMISCCAPS_CULLNONE                       = 0x00000010L,
        D3DPMISCCAPS_CULLCW                         = 0x00000020L,
        D3DPMISCCAPS_CULLCCW                        = 0x00000040L,
        D3DPMISCCAPS_COLORWRITEENABLE               = 0x00000080L,
        D3DPMISCCAPS_CLIPPLANESCALEDPOINTS          = 0x00000100L,
        D3DPMISCCAPS_CLIPTLVERTS                    = 0x00000200L,
        D3DPMISCCAPS_TSSARGTEMP                     = 0x00000400L,
        D3DPMISCCAPS_BLENDOP                        = 0x00000800L,
        D3DPMISCCAPS_NULLREFERENCE                  = 0x00001000L,
    };

    enum {
        D3DLINECAPS_TEXTURE                         = 0x00000001L,
        D3DLINECAPS_ZTEST                           = 0x00000002L,
        D3DLINECAPS_BLEND                           = 0x00000004L,
        D3DLINECAPS_ALPHACMP                        = 0x00000008L,
        D3DLINECAPS_FOG                             = 0x00000010L,
    };

    enum {
        D3DPRASTERCAPS_DITHER                       = 0x00000001L,
        D3DPRASTERCAPS_PAT                          = 0x00000008L,
        D3DPRASTERCAPS_ZTEST                        = 0x00000010L,
        D3DPRASTERCAPS_FOGVERTEX                    = 0x00000080L,
        D3DPRASTERCAPS_FOGTABLE                     = 0x00000100L,
        D3DPRASTERCAPS_ANTIALIASEDGES               = 0x00001000L,
        D3DPRASTERCAPS_MIPMAPLODBIAS                = 0x00002000L,
        D3DPRASTERCAPS_ZBIAS                        = 0x00004000L,
        D3DPRASTERCAPS_ZBUFFERLESSHSR               = 0x00008000L,
        D3DPRASTERCAPS_FOGRANGE                     = 0x00010000L,
        D3DPRASTERCAPS_ANISOTROPY                   = 0x00020000L,
        D3DPRASTERCAPS_WBUFFER                      = 0x00040000L,
        D3DPRASTERCAPS_WFOG                         = 0x00100000L,
        D3DPRASTERCAPS_ZFOG                         = 0x00200000L,
        D3DPRASTERCAPS_COLORPERSPECTIVE             = 0x00400000L,
        D3DPRASTERCAPS_STRETCHBLTMULTISAMPLE        = 0x00800000L,
    };

    enum {
        D3DPCMPCAPS_NEVER                           = 0x00000001L,
        D3DPCMPCAPS_LESS                            = 0x00000002L,
        D3DPCMPCAPS_EQUAL                           = 0x00000004L,
        D3DPCMPCAPS_LESSEQUAL                       = 0x00000008L,
        D3DPCMPCAPS_GREATER                         = 0x00000010L,
        D3DPCMPCAPS_NOTEQUAL                        = 0x00000020L,
        D3DPCMPCAPS_GREATEREQUAL                    = 0x00000040L,
        D3DPCMPCAPS_ALWAYS                          = 0x00000080L,
    };

    enum {
        D3DPBLENDCAPS_ZERO                          = 0x00000001L,
        D3DPBLENDCAPS_ONE                           = 0x00000002L,
        D3DPBLENDCAPS_SRCCOLOR                      = 0x00000004L,
        D3DPBLENDCAPS_INVSRCCOLOR                   = 0x00000008L,
        D3DPBLENDCAPS_SRCALPHA                      = 0x00000010L,
        D3DPBLENDCAPS_INVSRCALPHA                   = 0x00000020L,
        D3DPBLENDCAPS_DESTALPHA                     = 0x00000040L,
        D3DPBLENDCAPS_INVDESTALPHA                  = 0x00000080L,
        D3DPBLENDCAPS_DESTCOLOR                     = 0x00000100L,
        D3DPBLENDCAPS_INVDESTCOLOR                  = 0x00000200L,
        D3DPBLENDCAPS_SRCALPHASAT                   = 0x00000400L,
        D3DPBLENDCAPS_BOTHSRCALPHA                  = 0x00000800L,
        D3DPBLENDCAPS_BOTHINVSRCALPHA               = 0x00001000L,
    };

    enum {
        D3DPSHADECAPS_COLORGOURAUDRGB               = 0x00000008L,
        D3DPSHADECAPS_SPECULARGOURAUDRGB            = 0x00000200L,
        D3DPSHADECAPS_ALPHAGOURAUDBLEND             = 0x00004000L,
        D3DPSHADECAPS_FOGGOURAUD                    = 0x00080000L,
    };

    enum {
        D3DPTEXTURECAPS_PERSPECTIVE                 = 0x00000001L,
        D3DPTEXTURECAPS_POW2                        = 0x00000002L,
        D3DPTEXTURECAPS_ALPHA                       = 0x00000004L,
        D3DPTEXTURECAPS_SQUAREONLY                  = 0x00000020L,
        D3DPTEXTURECAPS_TEXREPEATNOTSCALEDBYSIZE    = 0x00000040L,
        D3DPTEXTURECAPS_ALPHAPALETTE                = 0x00000080L,
    };

    enum {
        D3DPTEXTURECAPS_NONPOW2CONDITIONAL          = 0x00000100L,
        D3DPTEXTURECAPS_PROJECTED                   = 0x00000400L,
        D3DPTEXTURECAPS_CUBEMAP                     = 0x00000800L,
        D3DPTEXTURECAPS_VOLUMEMAP                   = 0x00002000L,
        D3DPTEXTURECAPS_MIPMAP                      = 0x00004000L,
        D3DPTEXTURECAPS_MIPVOLUMEMAP                = 0x00008000L,
        D3DPTEXTURECAPS_MIPCUBEMAP                  = 0x00010000L,
        D3DPTEXTURECAPS_CUBEMAP_POW2                = 0x00020000L,
        D3DPTEXTURECAPS_VOLUMEMAP_POW2              = 0x00040000L,
    };

    enum {
        D3DPTFILTERCAPS_MINFPOINT                   = 0x00000100L,
        D3DPTFILTERCAPS_MINFLINEAR                  = 0x00000200L,
        D3DPTFILTERCAPS_MINFANISOTROPIC             = 0x00000400L,
        D3DPTFILTERCAPS_MIPFPOINT                   = 0x00010000L,
        D3DPTFILTERCAPS_MIPFLINEAR                  = 0x00020000L,
        D3DPTFILTERCAPS_MAGFPOINT                   = 0x01000000L,
        D3DPTFILTERCAPS_MAGFLINEAR                  = 0x02000000L,
        D3DPTFILTERCAPS_MAGFANISOTROPIC             = 0x04000000L,
        D3DPTFILTERCAPS_MAGFAFLATCUBIC              = 0x08000000L,
        D3DPTFILTERCAPS_MAGFGAUSSIANCUBIC           = 0x10000000L,
    };

    enum {
        D3DPTADDRESSCAPS_WRAP                       = 0x00000001L,
        D3DPTADDRESSCAPS_MIRROR                     = 0x00000002L,
        D3DPTADDRESSCAPS_CLAMP                      = 0x00000004L,
        D3DPTADDRESSCAPS_BORDER                     = 0x00000008L,
        D3DPTADDRESSCAPS_INDEPENDENTUV              = 0x00000010L,
        D3DPTADDRESSCAPS_MIRRORONCE                 = 0x00000020L,
    };

    enum {
        D3DSTENCILCAPS_KEEP                         = 0x00000001L,
        D3DSTENCILCAPS_ZERO                         = 0x00000002L,
        D3DSTENCILCAPS_REPLACE                      = 0x00000004L,
        D3DSTENCILCAPS_INCRSAT                      = 0x00000008L,
        D3DSTENCILCAPS_DECRSAT                      = 0x00000010L,
        D3DSTENCILCAPS_INVERT                       = 0x00000020L,
        D3DSTENCILCAPS_INCR                         = 0x00000040L,
        D3DSTENCILCAPS_DECR                         = 0x00000080L,
    };

    enum {
        D3DTEXOPCAPS_DISABLE                        = 0x00000001L,
        D3DTEXOPCAPS_SELECTARG1                     = 0x00000002L,
        D3DTEXOPCAPS_SELECTARG2                     = 0x00000004L,
        D3DTEXOPCAPS_MODULATE                       = 0x00000008L,
        D3DTEXOPCAPS_MODULATE2X                     = 0x00000010L,
        D3DTEXOPCAPS_MODULATE4X                     = 0x00000020L,
        D3DTEXOPCAPS_ADD                            = 0x00000040L,
        D3DTEXOPCAPS_ADDSIGNED                      = 0x00000080L,
        D3DTEXOPCAPS_ADDSIGNED2X                    = 0x00000100L,
        D3DTEXOPCAPS_SUBTRACT                       = 0x00000200L,
        D3DTEXOPCAPS_ADDSMOOTH                      = 0x00000400L,
        D3DTEXOPCAPS_BLENDDIFFUSEALPHA              = 0x00000800L,
        D3DTEXOPCAPS_BLENDTEXTUREALPHA              = 0x00001000L,
        D3DTEXOPCAPS_BLENDFACTORALPHA               = 0x00002000L,
        D3DTEXOPCAPS_BLENDTEXTUREALPHAPM            = 0x00004000L,
        D3DTEXOPCAPS_BLENDCURRENTALPHA              = 0x00008000L,
        D3DTEXOPCAPS_PREMODULATE                    = 0x00010000L,
        D3DTEXOPCAPS_MODULATEALPHA_ADDCOLOR         = 0x00020000L,
        D3DTEXOPCAPS_MODULATECOLOR_ADDALPHA         = 0x00040000L,
        D3DTEXOPCAPS_MODULATEINVALPHA_ADDCOLOR      = 0x00080000L,
        D3DTEXOPCAPS_MODULATEINVCOLOR_ADDALPHA      = 0x00100000L,
        D3DTEXOPCAPS_BUMPENVMAP                     = 0x00200000L,
        D3DTEXOPCAPS_BUMPENVMAPLUMINANCE            = 0x00400000L,
        D3DTEXOPCAPS_DOTPRODUCT3                    = 0x00800000L,
        D3DTEXOPCAPS_MULTIPLYADD                    = 0x01000000L,
        D3DTEXOPCAPS_LERP                           = 0x02000000L,
    };
    
    enum {
        D3DFVFCAPS_TEXCOORDCOUNTMASK                = 0x0000ffffL,
        D3DFVFCAPS_DONOTSTRIPELEMENTS               = 0x00080000L,
        D3DFVFCAPS_PSIZE                            = 0x00100000L,
    };
    
    enum {
        D3DVTXPCAPS_TEXGEN                          = 0x00000001L,
        D3DVTXPCAPS_MATERIALSOURCE7                 = 0x00000002L,
        D3DVTXPCAPS_DIRECTIONALLIGHTS               = 0x00000008L,
        D3DVTXPCAPS_POSITIONALLIGHTS                = 0x00000010L,
        D3DVTXPCAPS_LOCALVIEWER                     = 0x00000020L,
        D3DVTXPCAPS_TWEENING                        = 0x00000040L,
        D3DVTXPCAPS_NO_VSDT_UBYTE4                  = 0x00000080L,
    };
]];