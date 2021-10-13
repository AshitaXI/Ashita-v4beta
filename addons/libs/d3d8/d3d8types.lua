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
* This file is created using the information from the d3d8types.h header file of the Direct3D 8 SDK.
--]]

require('win32types');

local ffi = require('ffi');

ffi.cdef[[
    typedef DWORD D3DCOLOR;

    typedef struct _D3DVECTOR {
        float x;
        float y;
        float z;
    } D3DVECTOR;

    typedef struct _D3DCOLORVALUE {
        float r;
        float g;
        float b;
        float a;
    } D3DCOLORVALUE;

    typedef struct _D3DRECT {
        LONG x1;
        LONG y1;
        LONG x2;
        LONG y2;
    } D3DRECT;

    typedef struct _D3DMATRIX {
        union {
            struct {
                float _11, _12, _13, _14;
                float _21, _22, _23, _24;
                float _31, _32, _33, _34;
                float _41, _42, _43, _44;
            };
            float m[4][4];
        };
    } D3DMATRIX;

    typedef struct _D3DVIEWPORT8 {
        DWORD X;
        DWORD Y;
        DWORD Width;
        DWORD Height;
        float MinZ;
        float MaxZ;
    } D3DVIEWPORT8;
    
    enum {
        D3DMAXUSERCLIPPLANES = 32,
        
        D3DCLIPPLANE0 = (1 << 0),
        D3DCLIPPLANE1 = (1 << 1),
        D3DCLIPPLANE2 = (1 << 2),
        D3DCLIPPLANE3 = (1 << 3),
        D3DCLIPPLANE4 = (1 << 4),
        D3DCLIPPLANE5 = (1 << 5),
    };
    
    enum {
        D3DCS_LEFT      = 0x00000001L,
        D3DCS_RIGHT     = 0x00000002L,
        D3DCS_TOP       = 0x00000004L,
        D3DCS_BOTTOM    = 0x00000008L,
        D3DCS_FRONT     = 0x00000010L,
        D3DCS_BACK      = 0x00000020L,
        D3DCS_PLANE0    = 0x00000040L,
        D3DCS_PLANE1    = 0x00000080L,
        D3DCS_PLANE2    = 0x00000100L,
        D3DCS_PLANE3    = 0x00000200L,
        D3DCS_PLANE4    = 0x00000400L,
        D3DCS_PLANE5    = 0x00000800L,
        D3DCS_ALL       = 0x00000FFFL,
    };
    
    typedef struct _D3DCLIPSTATUS8 {
        DWORD ClipUnion;
        DWORD ClipIntersection;
    } D3DCLIPSTATUS8;
    
    typedef struct _D3DMATERIAL8 {
        D3DCOLORVALUE Diffuse;
        D3DCOLORVALUE Ambient;
        D3DCOLORVALUE Specular;
        D3DCOLORVALUE Emissive;
        float         Power;
    } D3DMATERIAL8;

    typedef enum _D3DLIGHTTYPE {
        D3DLIGHT_POINT       = 1,
        D3DLIGHT_SPOT        = 2,
        D3DLIGHT_DIRECTIONAL = 3,
        D3DLIGHT_FORCE_DWORD = 0x7fffffff,
    } D3DLIGHTTYPE;

    typedef struct _D3DLIGHT8 {
        D3DLIGHTTYPE  Type;
        D3DCOLORVALUE Diffuse;
        D3DCOLORVALUE Specular;
        D3DCOLORVALUE Ambient;
        D3DVECTOR     Position;
        D3DVECTOR     Direction;
        float         Range;
        float         Falloff;
        float         Attenuation0;
        float         Attenuation1;
        float         Attenuation2;
        float         Theta;
        float         Phi;
    } D3DLIGHT8;

    enum {
        D3DCLEAR_TARGET  = 0x00000001l,
        D3DCLEAR_ZBUFFER = 0x00000002l,
        D3DCLEAR_STENCIL = 0x00000004l,
    };

    typedef enum _D3DSHADEMODE {
        D3DSHADE_FLAT               = 1,
        D3DSHADE_GOURAUD            = 2,
        D3DSHADE_PHONG              = 3,
        D3DSHADE_FORCE_DWORD        = 0x7fffffff,
    } D3DSHADEMODE;

    typedef enum _D3DFILLMODE {
        D3DFILL_POINT               = 1,
        D3DFILL_WIREFRAME           = 2,
        D3DFILL_SOLID               = 3,
        D3DFILL_FORCE_DWORD         = 0x7fffffff,
    } D3DFILLMODE;

    typedef struct _D3DLINEPATTERN {
        WORD    wRepeatFactor;
        WORD    wLinePattern;
    } D3DLINEPATTERN;

    typedef enum _D3DBLEND {
        D3DBLEND_ZERO               = 1,
        D3DBLEND_ONE                = 2,
        D3DBLEND_SRCCOLOR           = 3,
        D3DBLEND_INVSRCCOLOR        = 4,
        D3DBLEND_SRCALPHA           = 5,
        D3DBLEND_INVSRCALPHA        = 6,
        D3DBLEND_DESTALPHA          = 7,
        D3DBLEND_INVDESTALPHA       = 8,
        D3DBLEND_DESTCOLOR          = 9,
        D3DBLEND_INVDESTCOLOR       = 10,
        D3DBLEND_SRCALPHASAT        = 11,
        D3DBLEND_BOTHSRCALPHA       = 12,
        D3DBLEND_BOTHINVSRCALPHA    = 13,
        D3DBLEND_FORCE_DWORD        = 0x7fffffff,
    } D3DBLEND;

    typedef enum _D3DBLENDOP {
        D3DBLENDOP_ADD              = 1,
        D3DBLENDOP_SUBTRACT         = 2,
        D3DBLENDOP_REVSUBTRACT      = 3,
        D3DBLENDOP_MIN              = 4,
        D3DBLENDOP_MAX              = 5,
        D3DBLENDOP_FORCE_DWORD      = 0x7fffffff,
    } D3DBLENDOP;

    typedef enum _D3DTEXTUREADDRESS {
        D3DTADDRESS_WRAP            = 1,
        D3DTADDRESS_MIRROR          = 2,
        D3DTADDRESS_CLAMP           = 3,
        D3DTADDRESS_BORDER          = 4,
        D3DTADDRESS_MIRRORONCE      = 5,
        D3DTADDRESS_FORCE_DWORD     = 0x7fffffff,
    } D3DTEXTUREADDRESS;

    typedef enum _D3DCULL {
        D3DCULL_NONE                = 1,
        D3DCULL_CW                  = 2,
        D3DCULL_CCW                 = 3,
        D3DCULL_FORCE_DWORD         = 0x7fffffff,
    } D3DCULL;

    typedef enum _D3DCMPFUNC {
        D3DCMP_NEVER                = 1,
        D3DCMP_LESS                 = 2,
        D3DCMP_EQUAL                = 3,
        D3DCMP_LESSEQUAL            = 4,
        D3DCMP_GREATER              = 5,
        D3DCMP_NOTEQUAL             = 6,
        D3DCMP_GREATEREQUAL         = 7,
        D3DCMP_ALWAYS               = 8,
        D3DCMP_FORCE_DWORD          = 0x7fffffff,
    } D3DCMPFUNC;

    typedef enum _D3DSTENCILOP {
        D3DSTENCILOP_KEEP           = 1,
        D3DSTENCILOP_ZERO           = 2,
        D3DSTENCILOP_REPLACE        = 3,
        D3DSTENCILOP_INCRSAT        = 4,
        D3DSTENCILOP_DECRSAT        = 5,
        D3DSTENCILOP_INVERT         = 6,
        D3DSTENCILOP_INCR           = 7,
        D3DSTENCILOP_DECR           = 8,
        D3DSTENCILOP_FORCE_DWORD    = 0x7fffffff,
    } D3DSTENCILOP;

    typedef enum _D3DFOGMODE {
        D3DFOG_NONE                 = 0,
        D3DFOG_EXP                  = 1,
        D3DFOG_EXP2                 = 2,
        D3DFOG_LINEAR               = 3,
        D3DFOG_FORCE_DWORD          = 0x7fffffff,
    } D3DFOGMODE;

    typedef enum _D3DZBUFFERTYPE {
        D3DZB_FALSE                 = 0,
        D3DZB_TRUE                  = 1,
        D3DZB_USEW                  = 2,
        D3DZB_FORCE_DWORD           = 0x7fffffff,
    } D3DZBUFFERTYPE;

    typedef enum _D3DPRIMITIVETYPE {
        D3DPT_POINTLIST             = 1,
        D3DPT_LINELIST              = 2,
        D3DPT_LINESTRIP             = 3,
        D3DPT_TRIANGLELIST          = 4,
        D3DPT_TRIANGLESTRIP         = 5,
        D3DPT_TRIANGLEFAN           = 6,
        D3DPT_FORCE_DWORD           = 0x7fffffff,
    } D3DPRIMITIVETYPE;

    typedef enum _D3DTRANSFORMSTATETYPE {
        D3DTS_VIEW          = 2,
        D3DTS_PROJECTION    = 3,
        D3DTS_TEXTURE0      = 16,
        D3DTS_TEXTURE1      = 17,
        D3DTS_TEXTURE2      = 18,
        D3DTS_TEXTURE3      = 19,
        D3DTS_TEXTURE4      = 20,
        D3DTS_TEXTURE5      = 21,
        D3DTS_TEXTURE6      = 22,
        D3DTS_TEXTURE7      = 23,
        D3DTS_FORCE_DWORD   = 0x7fffffff,
        
        D3DTS_WORLD         = 256, /* #define D3DTS_WORLD  D3DTS_WORLDMATRIX(0) */
        D3DTS_WORLD1        = 257, /* #define D3DTS_WORLD1 D3DTS_WORLDMATRIX(1) */
        D3DTS_WORLD2        = 258, /* #define D3DTS_WORLD2 D3DTS_WORLDMATRIX(2) */
        D3DTS_WORLD3        = 259, /* #define D3DTS_WORLD3 D3DTS_WORLDMATRIX(3) */
    } D3DTRANSFORMSTATETYPE;

    typedef enum _D3DRENDERSTATETYPE {
        D3DRS_ZENABLE                   = 7,
        D3DRS_FILLMODE                  = 8,
        D3DRS_SHADEMODE                 = 9,
        D3DRS_LINEPATTERN               = 10,
        D3DRS_ZWRITEENABLE              = 14,
        D3DRS_ALPHATESTENABLE           = 15,
        D3DRS_LASTPIXEL                 = 16,
        D3DRS_SRCBLEND                  = 19,
        D3DRS_DESTBLEND                 = 20,
        D3DRS_CULLMODE                  = 22,
        D3DRS_ZFUNC                     = 23,
        D3DRS_ALPHAREF                  = 24,
        D3DRS_ALPHAFUNC                 = 25,
        D3DRS_DITHERENABLE              = 26,
        D3DRS_ALPHABLENDENABLE          = 27,
        D3DRS_FOGENABLE                 = 28,
        D3DRS_SPECULARENABLE            = 29,
        D3DRS_ZVISIBLE                  = 30,
        D3DRS_FOGCOLOR                  = 34,
        D3DRS_FOGTABLEMODE              = 35,
        D3DRS_FOGSTART                  = 36,
        D3DRS_FOGEND                    = 37,
        D3DRS_FOGDENSITY                = 38,
        D3DRS_EDGEANTIALIAS             = 40,
        D3DRS_ZBIAS                     = 47,
        D3DRS_RANGEFOGENABLE            = 48,
        D3DRS_STENCILENABLE             = 52,
        D3DRS_STENCILFAIL               = 53,
        D3DRS_STENCILZFAIL              = 54,
        D3DRS_STENCILPASS               = 55,
        D3DRS_STENCILFUNC               = 56,
        D3DRS_STENCILREF                = 57,
        D3DRS_STENCILMASK               = 58,
        D3DRS_STENCILWRITEMASK          = 59,
        D3DRS_TEXTUREFACTOR             = 60,
        D3DRS_WRAP0                     = 128,
        D3DRS_WRAP1                     = 129,
        D3DRS_WRAP2                     = 130,
        D3DRS_WRAP3                     = 131,
        D3DRS_WRAP4                     = 132,
        D3DRS_WRAP5                     = 133,
        D3DRS_WRAP6                     = 134,
        D3DRS_WRAP7                     = 135,
        D3DRS_CLIPPING                  = 136,
        D3DRS_LIGHTING                  = 137,
        D3DRS_AMBIENT                   = 139,
        D3DRS_FOGVERTEXMODE             = 140,
        D3DRS_COLORVERTEX               = 141,
        D3DRS_LOCALVIEWER               = 142,
        D3DRS_NORMALIZENORMALS          = 143,
        D3DRS_DIFFUSEMATERIALSOURCE     = 145,
        D3DRS_SPECULARMATERIALSOURCE    = 146,
        D3DRS_AMBIENTMATERIALSOURCE     = 147,
        D3DRS_EMISSIVEMATERIALSOURCE    = 148,
        D3DRS_VERTEXBLEND               = 151,
        D3DRS_CLIPPLANEENABLE           = 152,
        D3DRS_SOFTWAREVERTEXPROCESSING  = 153,
        D3DRS_POINTSIZE                 = 154,
        D3DRS_POINTSIZE_MIN             = 155,
        D3DRS_POINTSPRITEENABLE         = 156,
        D3DRS_POINTSCALEENABLE          = 157,
        D3DRS_POINTSCALE_A              = 158,
        D3DRS_POINTSCALE_B              = 159,
        D3DRS_POINTSCALE_C              = 160,
        D3DRS_MULTISAMPLEANTIALIAS      = 161,
        D3DRS_MULTISAMPLEMASK           = 162,
        D3DRS_PATCHEDGESTYLE            = 163,
        D3DRS_PATCHSEGMENTS             = 164,
        D3DRS_DEBUGMONITORTOKEN         = 165,
        D3DRS_POINTSIZE_MAX             = 166,
        D3DRS_INDEXEDVERTEXBLENDENABLE  = 167,
        D3DRS_COLORWRITEENABLE          = 168,
        D3DRS_TWEENFACTOR               = 170,
        D3DRS_BLENDOP                   = 171,
        D3DRS_POSITIONORDER             = 172,
        D3DRS_NORMALORDER               = 173,
        D3DRS_FORCE_DWORD               = 0x7fffffff,
    } D3DRENDERSTATETYPE;

    typedef enum _D3DMATERIALCOLORSOURCE {
        D3DMCS_MATERIAL         = 0,
        D3DMCS_COLOR1           = 1,
        D3DMCS_COLOR2           = 2,
        D3DMCS_FORCE_DWORD      = 0x7fffffff,
    } D3DMATERIALCOLORSOURCE;

    enum {
        D3DRENDERSTATE_WRAPBIAS = 128UL,
        
        D3DWRAP_U = 0x00000001L,
        D3DWRAP_V = 0x00000002L,
        D3DWRAP_W = 0x00000004L,
        
        D3DWRAPCOORD_0 = 0x00000001L,
        D3DWRAPCOORD_1 = 0x00000002L,
        D3DWRAPCOORD_2 = 0x00000004L,
        D3DWRAPCOORD_3 = 0x00000008L,
    };
    
    enum {
        D3DCOLORWRITEENABLE_RED   = (1L << 0),
        D3DCOLORWRITEENABLE_GREEN = (1L << 1),
        D3DCOLORWRITEENABLE_BLUE  = (1L << 2),
        D3DCOLORWRITEENABLE_ALPHA = (1L << 3),
    };

    typedef enum _D3DTEXTURESTAGESTATETYPE {
        D3DTSS_COLOROP                  =  1,
        D3DTSS_COLORARG1                =  2,
        D3DTSS_COLORARG2                =  3,
        D3DTSS_ALPHAOP                  =  4,
        D3DTSS_ALPHAARG1                =  5,
        D3DTSS_ALPHAARG2                =  6,
        D3DTSS_BUMPENVMAT00             =  7,
        D3DTSS_BUMPENVMAT01             =  8,
        D3DTSS_BUMPENVMAT10             =  9,
        D3DTSS_BUMPENVMAT11             = 10,
        D3DTSS_TEXCOORDINDEX            = 11,
        D3DTSS_ADDRESSU                 = 13,
        D3DTSS_ADDRESSV                 = 14,
        D3DTSS_BORDERCOLOR              = 15,
        D3DTSS_MAGFILTER                = 16,
        D3DTSS_MINFILTER                = 17,
        D3DTSS_MIPFILTER                = 18,
        D3DTSS_MIPMAPLODBIAS            = 19,
        D3DTSS_MAXMIPLEVEL              = 20,
        D3DTSS_MAXANISOTROPY            = 21,
        D3DTSS_BUMPENVLSCALE            = 22,
        D3DTSS_BUMPENVLOFFSET           = 23,
        D3DTSS_TEXTURETRANSFORMFLAGS    = 24,
        D3DTSS_ADDRESSW                 = 25,
        D3DTSS_COLORARG0                = 26,
        D3DTSS_ALPHAARG0                = 27,
        D3DTSS_RESULTARG                = 28,
        D3DTSS_FORCE_DWORD              = 0x7fffffff,
    } D3DTEXTURESTAGESTATETYPE;

    enum {
        D3DTSS_TCI_PASSTHRU                    = 0x00000000,
        D3DTSS_TCI_CAMERASPACENORMAL           = 0x00010000,
        D3DTSS_TCI_CAMERASPACEPOSITION         = 0x00020000,
        D3DTSS_TCI_CAMERASPACEREFLECTIONVECTOR = 0x00030000,
    };

    typedef enum _D3DTEXTUREOP {
        D3DTOP_DISABLE                      = 1,
        D3DTOP_SELECTARG1                   = 2,
        D3DTOP_SELECTARG2                   = 3,
        D3DTOP_MODULATE                     = 4,
        D3DTOP_MODULATE2X                   = 5,
        D3DTOP_MODULATE4X                   = 6,
        D3DTOP_ADD                          = 7,
        D3DTOP_ADDSIGNED                    = 8,
        D3DTOP_ADDSIGNED2X                  = 9,
        D3DTOP_SUBTRACT                     = 10,
        D3DTOP_ADDSMOOTH                    = 11,
        D3DTOP_BLENDDIFFUSEALPHA            = 12,
        D3DTOP_BLENDTEXTUREALPHA            = 13,
        D3DTOP_BLENDFACTORALPHA             = 14,
        D3DTOP_BLENDTEXTUREALPHAPM          = 15,
        D3DTOP_BLENDCURRENTALPHA            = 16,
        D3DTOP_PREMODULATE                  = 17,
        D3DTOP_MODULATEALPHA_ADDCOLOR       = 18,
        D3DTOP_MODULATECOLOR_ADDALPHA       = 19,
        D3DTOP_MODULATEINVALPHA_ADDCOLOR    = 20,
        D3DTOP_MODULATEINVCOLOR_ADDALPHA    = 21,
        D3DTOP_BUMPENVMAP                   = 22,
        D3DTOP_BUMPENVMAPLUMINANCE          = 23,
        D3DTOP_DOTPRODUCT3                  = 24,
        D3DTOP_MULTIPLYADD                  = 25,
        D3DTOP_LERP                         = 26,
        D3DTOP_FORCE_DWORD                  = 0x7fffffff,
    } D3DTEXTUREOP;

    enum {
        D3DTA_SELECTMASK     = 0x0000000f,
        D3DTA_DIFFUSE        = 0x00000000,
        D3DTA_CURRENT        = 0x00000001,
        D3DTA_TEXTURE        = 0x00000002,
        D3DTA_TFACTOR        = 0x00000003,
        D3DTA_SPECULAR       = 0x00000004,
        D3DTA_TEMP           = 0x00000005,
        D3DTA_COMPLEMENT     = 0x00000010,
        D3DTA_ALPHAREPLICATE = 0x00000020,
    };

    typedef enum _D3DTEXTUREFILTERTYPE {
        D3DTEXF_NONE          = 0,
        D3DTEXF_POINT         = 1,
        D3DTEXF_LINEAR        = 2,
        D3DTEXF_ANISOTROPIC   = 3,
        D3DTEXF_FLATCUBIC     = 4,
        D3DTEXF_GAUSSIANCUBIC = 5,
        D3DTEXF_FORCE_DWORD   = 0x7fffffff,
    } D3DTEXTUREFILTERTYPE;

    enum {
        D3DPV_DONOTCOPYDATA = (1 << 0),
    };

    enum {
        D3DFVF_RESERVED0       = 0x001,
        D3DFVF_POSITION_MASK   = 0x00E,
        D3DFVF_XYZ             = 0x002,
        D3DFVF_XYZRHW          = 0x004,
        D3DFVF_XYZB1           = 0x006,
        D3DFVF_XYZB2           = 0x008,
        D3DFVF_XYZB3           = 0x00a,
        D3DFVF_XYZB4           = 0x00c,
        D3DFVF_XYZB5           = 0x00e,
        D3DFVF_NORMAL          = 0x010,
        D3DFVF_PSIZE           = 0x020,
        D3DFVF_DIFFUSE         = 0x040,
        D3DFVF_SPECULAR        = 0x080,
        D3DFVF_TEXCOUNT_MASK   = 0xf00,
        D3DFVF_TEXCOUNT_SHIFT  = 0x008,
        D3DFVF_TEX0            = 0x000,
        D3DFVF_TEX1            = 0x100,
        D3DFVF_TEX2            = 0x200,
        D3DFVF_TEX3            = 0x300,
        D3DFVF_TEX4            = 0x400,
        D3DFVF_TEX5            = 0x500,
        D3DFVF_TEX6            = 0x600,
        D3DFVF_TEX7            = 0x700,
        D3DFVF_TEX8            = 0x800,
        D3DFVF_LASTBETA_UBYTE4 = 0x1000,
        D3DFVF_RESERVED2       = 0xE000,
    };

    typedef enum _D3DVSD_TOKENTYPE {
        D3DVSD_TOKEN_NOP = 0,
        D3DVSD_TOKEN_STREAM,
        D3DVSD_TOKEN_STREAMDATA,
        D3DVSD_TOKEN_TESSELLATOR,
        D3DVSD_TOKEN_CONSTMEM,
        D3DVSD_TOKEN_EXT,
        D3DVSD_TOKEN_END = 7,
        D3DVSD_FORCE_DWORD = 0x7fffffff,
    } D3DVSD_TOKENTYPE;

    enum {
        D3DVSD_TOKENTYPESHIFT       = 29,
        D3DVSD_TOKENTYPEMASK        = (7 << D3DVSD_TOKENTYPESHIFT),
        D3DVSD_STREAMNUMBERSHIFT    = 0,
        D3DVSD_STREAMNUMBERMASK     = (0xF << D3DVSD_STREAMNUMBERSHIFT),
        D3DVSD_DATALOADTYPESHIFT    = 28,
        D3DVSD_DATALOADTYPEMASK     = (0x1 << D3DVSD_DATALOADTYPESHIFT),
        D3DVSD_DATATYPESHIFT        = 16,
        D3DVSD_DATATYPEMASK         = (0xF << D3DVSD_DATATYPESHIFT),
        D3DVSD_SKIPCOUNTSHIFT       = 16,
        D3DVSD_SKIPCOUNTMASK        = (0xF << D3DVSD_SKIPCOUNTSHIFT),
        D3DVSD_VERTEXREGSHIFT       = 0,
        D3DVSD_VERTEXREGMASK        = (0x1F << D3DVSD_VERTEXREGSHIFT),
        D3DVSD_VERTEXREGINSHIFT     = 20,
        D3DVSD_VERTEXREGINMASK      = (0xF << D3DVSD_VERTEXREGINSHIFT),
        D3DVSD_CONSTCOUNTSHIFT      = 25,
        D3DVSD_CONSTCOUNTMASK       = (0xF << D3DVSD_CONSTCOUNTSHIFT),
        D3DVSD_CONSTADDRESSSHIFT    = 0,
        D3DVSD_CONSTADDRESSMASK     = (0x7F << D3DVSD_CONSTADDRESSSHIFT),
        D3DVSD_CONSTRSSHIFT         = 16,
        D3DVSD_CONSTRSMASK          = (0x1FFF << D3DVSD_CONSTRSSHIFT),
        D3DVSD_EXTCOUNTSHIFT        = 24,
        D3DVSD_EXTCOUNTMASK         = (0x1F << D3DVSD_EXTCOUNTSHIFT),
        D3DVSD_EXTINFOSHIFT         = 0,
        D3DVSD_EXTINFOMASK          = (0xFFFFFF << D3DVSD_EXTINFOSHIFT),
    };
    
    enum {
        D3DVSD_STREAMTESSSHIFT  = 28,
        D3DVSD_STREAMTESSMASK   = (1 << D3DVSD_STREAMTESSSHIFT),
    };
    
    enum {
        D3DVSDT_FLOAT1   = 0x00,
        D3DVSDT_FLOAT2   = 0x01,
        D3DVSDT_FLOAT3   = 0x02,
        D3DVSDT_FLOAT4   = 0x03,
        D3DVSDT_D3DCOLOR = 0x04,
        D3DVSDT_UBYTE4   = 0x05,
        D3DVSDT_SHORT2   = 0x06,
        D3DVSDT_SHORT4   = 0x07,
    };
    
    enum {
        D3DVSDE_POSITION     = 0,
        D3DVSDE_BLENDWEIGHT  = 1,
        D3DVSDE_BLENDINDICES = 2,
        D3DVSDE_NORMAL       = 3,
        D3DVSDE_PSIZE        = 4,
        D3DVSDE_DIFFUSE      = 5,
        D3DVSDE_SPECULAR     = 6,
        D3DVSDE_TEXCOORD0    = 7,
        D3DVSDE_TEXCOORD1    = 8,
        D3DVSDE_TEXCOORD2    = 9,
        D3DVSDE_TEXCOORD3    = 10,
        D3DVSDE_TEXCOORD4    = 11,
        D3DVSDE_TEXCOORD5    = 12,
        D3DVSDE_TEXCOORD6    = 13,
        D3DVSDE_TEXCOORD7    = 14,
        D3DVSDE_POSITION2    = 15,
        D3DVSDE_NORMAL2      = 16,
    };
    
    enum {
        D3DDP_MAXTEXCOORD = 8,
    };
    
    enum {
        D3DSI_OPCODE_MASK = 0x0000FFFF,
    };
    
    typedef enum _D3DSHADER_INSTRUCTION_OPCODE_TYPE {
        D3DSIO_NOP = 0,
        D3DSIO_MOV,
        D3DSIO_ADD,
        D3DSIO_SUB,
        D3DSIO_MAD,
        D3DSIO_MUL,
        D3DSIO_RCP,
        D3DSIO_RSQ,
        D3DSIO_DP3,
        D3DSIO_DP4,
        D3DSIO_MIN,
        D3DSIO_MAX,
        D3DSIO_SLT,
        D3DSIO_SGE,
        D3DSIO_EXP,
        D3DSIO_LOG,
        D3DSIO_LIT,
        D3DSIO_DST,
        D3DSIO_LRP,
        D3DSIO_FRC,
        D3DSIO_M4x4,
        D3DSIO_M4x3,
        D3DSIO_M3x4,
        D3DSIO_M3x3,
        D3DSIO_M3x2,
        D3DSIO_TEXCOORD = 64,
        D3DSIO_TEXKILL,
        D3DSIO_TEX,
        D3DSIO_TEXBEM,
        D3DSIO_TEXBEML,
        D3DSIO_TEXREG2AR,
        D3DSIO_TEXREG2GB,
        D3DSIO_TEXM3x2PAD,
        D3DSIO_TEXM3x2TEX,
        D3DSIO_TEXM3x3PAD,
        D3DSIO_TEXM3x3TEX,
        D3DSIO_TEXM3x3DIFF,
        D3DSIO_TEXM3x3SPEC,
        D3DSIO_TEXM3x3VSPEC,
        D3DSIO_EXPP,
        D3DSIO_LOGP,
        D3DSIO_CND,
        D3DSIO_DEF,
        D3DSIO_TEXREG2RGB,
        D3DSIO_TEXDP3TEX,
        D3DSIO_TEXM3x2DEPTH,
        D3DSIO_TEXDP3,
        D3DSIO_TEXM3x3,
        D3DSIO_TEXDEPTH,
        D3DSIO_CMP,
        D3DSIO_BEM,

        D3DSIO_PHASE   = 0xFFFD,
        D3DSIO_COMMENT = 0xFFFE,
        D3DSIO_END     = 0xFFFF,

        D3DSIO_FORCE_DWORD  = 0x7fffffff,
    } D3DSHADER_INSTRUCTION_OPCODE_TYPE;

    enum {
        D3DSI_COISSUE       = 0x40000000,
        D3DSP_REGNUM_MASK   = 0x00001FFF,
        
        D3DSP_WRITEMASK_0   = 0x00010000,
        D3DSP_WRITEMASK_1   = 0x00020000,
        D3DSP_WRITEMASK_2   = 0x00040000,
        D3DSP_WRITEMASK_3   = 0x00080000,
        D3DSP_WRITEMASK_ALL = 0x000F0000,
        
        D3DSP_DSTMOD_SHIFT  = 20,
        D3DSP_DSTMOD_MASK   = 0x00F00000,
    };
    
    typedef enum _D3DSHADER_PARAM_DSTMOD_TYPE {
        D3DSPDM_NONE        = 0 << D3DSP_DSTMOD_SHIFT,
        D3DSPDM_SATURATE    = 1 << D3DSP_DSTMOD_SHIFT,
        D3DSPDM_FORCE_DWORD = 0x7fffffff,
    } D3DSHADER_PARAM_DSTMOD_TYPE;
    
    enum {
        D3DSP_DSTSHIFT_SHIFT = 24,
        D3DSP_DSTSHIFT_MASK  = 0x0F000000,
        D3DSP_REGTYPE_SHIFT  = 28,
        D3DSP_REGTYPE_MASK   = 0x70000000,
    };
    
    typedef enum _D3DSHADER_PARAM_REGISTER_TYPE {
        D3DSPR_TEMP         = 0 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_INPUT        = 1 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_CONST        = 2 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_ADDR         = 3 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_TEXTURE      = 3 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_RASTOUT      = 4 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_ATTROUT      = 5 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_TEXCRDOUT    = 6 << D3DSP_REGTYPE_SHIFT,
        D3DSPR_FORCE_DWORD  = 0x7fffffff,
    } D3DSHADER_PARAM_REGISTER_TYPE;

    typedef enum _D3DVS_RASTOUT_OFFSETS {
        D3DSRO_POSITION = 0,
        D3DSRO_FOG,
        D3DSRO_POINT_SIZE,
        D3DSRO_FORCE_DWORD  = 0x7fffffff,
    } D3DVS_RASTOUT_OFFSETS;

    enum {
        D3DVS_ADDRESSMODE_SHIFT = 13,
        D3DVS_ADDRESSMODE_MASK  = (1 << D3DVS_ADDRESSMODE_SHIFT),
    };
    
    typedef enum _D3DVS_ADDRESSMODE_TYPE {
        D3DVS_ADDRMODE_ABSOLUTE     = (0 << D3DVS_ADDRESSMODE_SHIFT),
        D3DVS_ADDRMODE_RELATIVE     = (1 << D3DVS_ADDRESSMODE_SHIFT),   // Relative to register A0
        D3DVS_ADDRMODE_FORCE_DWORD  = 0x7fffffff, // force 32-bit size enum
    } D3DVS_ADDRESSMODE_TYPE;
    
    enum {
        D3DVS_SWIZZLE_SHIFT = 16,
        D3DVS_SWIZZLE_MASK  = 0x00FF0000,
        
        D3DVS_X_X = (0 << D3DVS_SWIZZLE_SHIFT),
        D3DVS_X_Y = (1 << D3DVS_SWIZZLE_SHIFT),
        D3DVS_X_Z = (2 << D3DVS_SWIZZLE_SHIFT),
        D3DVS_X_W = (3 << D3DVS_SWIZZLE_SHIFT),

        D3DVS_Y_X = (0 << (D3DVS_SWIZZLE_SHIFT + 2)),
        D3DVS_Y_Y = (1 << (D3DVS_SWIZZLE_SHIFT + 2)),
        D3DVS_Y_Z = (2 << (D3DVS_SWIZZLE_SHIFT + 2)),
        D3DVS_Y_W = (3 << (D3DVS_SWIZZLE_SHIFT + 2)),

        D3DVS_Z_X = (0 << (D3DVS_SWIZZLE_SHIFT + 4)),
        D3DVS_Z_Y = (1 << (D3DVS_SWIZZLE_SHIFT + 4)),
        D3DVS_Z_Z = (2 << (D3DVS_SWIZZLE_SHIFT + 4)),
        D3DVS_Z_W = (3 << (D3DVS_SWIZZLE_SHIFT + 4)),

        D3DVS_W_X = (0 << (D3DVS_SWIZZLE_SHIFT + 6)),
        D3DVS_W_Y = (1 << (D3DVS_SWIZZLE_SHIFT + 6)),
        D3DVS_W_Z = (2 << (D3DVS_SWIZZLE_SHIFT + 6)),
        D3DVS_W_W = (3 << (D3DVS_SWIZZLE_SHIFT + 6)),
        
        D3DVS_NOSWIZZLE = 0x00E40000,
    };
    
    enum {
        D3DSP_SWIZZLE_SHIFT     = 16,
        D3DSP_SWIZZLE_MASK      = 0x00FF0000,
        D3DSP_NOSWIZZLE         = 0x00E40000,
        D3DSP_REPLICATERED      = 0x00000000,
        D3DSP_REPLICATEGREEN    = 0x00550000,
        D3DSP_REPLICATEBLUE     = 0x00AA0000,
        D3DSP_REPLICATEALPHA    = 0x00FF0000,
        D3DSP_SRCMOD_SHIFT      = 24,
        D3DSP_SRCMOD_MASK       = 0x0F000000,
    };
    
    typedef enum _D3DSHADER_PARAM_SRCMOD_TYPE {
        D3DSPSM_NONE    = 0 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_NEG     = 1 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_BIAS    = 2 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_BIASNEG = 3 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_SIGN    = 4 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_SIGNNEG = 5 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_COMP    = 6 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_X2      = 7 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_X2NEG   = 8 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_DZ      = 9 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_DW      = 10 << D3DSP_SRCMOD_SHIFT,
        D3DSPSM_FORCE_DWORD = 0x7fffffff,
    } D3DSHADER_PARAM_SRCMOD_TYPE;
    
    enum {
        D3DSI_COMMENTSIZE_SHIFT = 16,
        D3DSI_COMMENTSIZE_MASK  = 0x7FFF0000,
    };
    
    typedef enum _D3DBASISTYPE {
        D3DBASIS_BEZIER      = 0,
        D3DBASIS_BSPLINE     = 1,
        D3DBASIS_INTERPOLATE = 2,
        D3DBASIS_FORCE_DWORD = 0x7fffffff,
    } D3DBASISTYPE;

    typedef enum _D3DORDERTYPE {
        D3DORDER_LINEAR      = 1,
        D3DORDER_QUADRATIC   = 2,
        D3DORDER_CUBIC       = 3,
        D3DORDER_QUINTIC     = 5,
        D3DORDER_FORCE_DWORD = 0x7fffffff,
    } D3DORDERTYPE;

    typedef enum _D3DPATCHEDGESTYLE {
        D3DPATCHEDGE_DISCRETE    = 0,
        D3DPATCHEDGE_CONTINUOUS  = 1,
        D3DPATCHEDGE_FORCE_DWORD = 0x7fffffff,
    } D3DPATCHEDGESTYLE;

    typedef enum _D3DSTATEBLOCKTYPE {
        D3DSBT_ALL          = 1,
        D3DSBT_PIXELSTATE   = 2,
        D3DSBT_VERTEXSTATE  = 3,
        D3DSBT_FORCE_DWORD  = 0x7fffffff,
    } D3DSTATEBLOCKTYPE;

    typedef enum _D3DVERTEXBLENDFLAGS {
        D3DVBF_DISABLE      = 0,
        D3DVBF_1WEIGHTS     = 1,
        D3DVBF_2WEIGHTS     = 2,
        D3DVBF_3WEIGHTS     = 3,
        D3DVBF_TWEENING     = 255,
        D3DVBF_0WEIGHTS     = 256,
        D3DVBF_FORCE_DWORD  = 0x7fffffff,
    } D3DVERTEXBLENDFLAGS;

    typedef enum _D3DTEXTURETRANSFORMFLAGS {
        D3DTTFF_DISABLE     = 0,
        D3DTTFF_COUNT1      = 1,
        D3DTTFF_COUNT2      = 2,
        D3DTTFF_COUNT3      = 3,
        D3DTTFF_COUNT4      = 4,
        D3DTTFF_PROJECTED   = 256,
        D3DTTFF_FORCE_DWORD = 0x7fffffff,
    } D3DTEXTURETRANSFORMFLAGS;
    
    enum {
        D3DFVF_TEXTUREFORMAT2 = 0,
        D3DFVF_TEXTUREFORMAT1 = 3,
        D3DFVF_TEXTUREFORMAT3 = 1,
        D3DFVF_TEXTUREFORMAT4 = 2,
    };
    
    typedef enum _D3DDEVTYPE
    {
        D3DDEVTYPE_HAL          = 1,
        D3DDEVTYPE_REF          = 2,
        D3DDEVTYPE_SW           = 3,
        D3DDEVTYPE_FORCE_DWORD  = 0x7fffffff,
    } D3DDEVTYPE;
    
    typedef enum _D3DMULTISAMPLE_TYPE {
        D3DMULTISAMPLE_NONE        = 0,
        D3DMULTISAMPLE_2_SAMPLES   = 2,
        D3DMULTISAMPLE_3_SAMPLES   = 3,
        D3DMULTISAMPLE_4_SAMPLES   = 4,
        D3DMULTISAMPLE_5_SAMPLES   = 5,
        D3DMULTISAMPLE_6_SAMPLES   = 6,
        D3DMULTISAMPLE_7_SAMPLES   = 7,
        D3DMULTISAMPLE_8_SAMPLES   = 8,
        D3DMULTISAMPLE_9_SAMPLES   = 9,
        D3DMULTISAMPLE_10_SAMPLES  = 10,
        D3DMULTISAMPLE_11_SAMPLES  = 11,
        D3DMULTISAMPLE_12_SAMPLES  = 12,
        D3DMULTISAMPLE_13_SAMPLES  = 13,
        D3DMULTISAMPLE_14_SAMPLES  = 14,
        D3DMULTISAMPLE_15_SAMPLES  = 15,
        D3DMULTISAMPLE_16_SAMPLES  = 16,
        D3DMULTISAMPLE_FORCE_DWORD = 0x7fffffff,
    } D3DMULTISAMPLE_TYPE;

    typedef enum _D3DFORMAT {
        D3DFMT_UNKNOWN              = 0,
        D3DFMT_R8G8B8               = 20,
        D3DFMT_A8R8G8B8             = 21,
        D3DFMT_X8R8G8B8             = 22,
        D3DFMT_R5G6B5               = 23,
        D3DFMT_X1R5G5B5             = 24,
        D3DFMT_A1R5G5B5             = 25,
        D3DFMT_A4R4G4B4             = 26,
        D3DFMT_R3G3B2               = 27,
        D3DFMT_A8                   = 28,
        D3DFMT_A8R3G3B2             = 29,
        D3DFMT_X4R4G4B4             = 30,
        D3DFMT_A2B10G10R10          = 31,
        D3DFMT_G16R16               = 34,
        D3DFMT_A8P8                 = 40,
        D3DFMT_P8                   = 41,
        D3DFMT_L8                   = 50,
        D3DFMT_A8L8                 = 51,
        D3DFMT_A4L4                 = 52,
        D3DFMT_V8U8                 = 60,
        D3DFMT_L6V5U5               = 61,
        D3DFMT_X8L8V8U8             = 62,
        D3DFMT_Q8W8V8U8             = 63,
        D3DFMT_V16U16               = 64,
        D3DFMT_W11V11U10            = 65,
        D3DFMT_A2W10V10U10          = 67,
        D3DFMT_UYVY                 = 1498831189, /* MAKEFOURCC('U', 'Y', 'V', 'Y') */
        D3DFMT_YUY2                 = 844715353,  /* MAKEFOURCC('Y', 'U', 'Y', '2') */
        D3DFMT_DXT1                 = 827611204,  /* MAKEFOURCC('D', 'X', 'T', '1') */
        D3DFMT_DXT2                 = 844388420,  /* MAKEFOURCC('D', 'X', 'T', '2') */
        D3DFMT_DXT3                 = 861165636,  /* MAKEFOURCC('D', 'X', 'T', '3') */
        D3DFMT_DXT4                 = 877942852,  /* MAKEFOURCC('D', 'X', 'T', '4') */
        D3DFMT_DXT5                 = 894720068,  /* MAKEFOURCC('D', 'X', 'T', '5') */
        D3DFMT_D16_LOCKABLE         = 70,
        D3DFMT_D32                  = 71,
        D3DFMT_D15S1                = 73,
        D3DFMT_D24S8                = 75,
        D3DFMT_D16                  = 80,
        D3DFMT_D24X8                = 77,
        D3DFMT_D24X4S4              = 79,
        D3DFMT_VERTEXDATA           = 100,
        D3DFMT_INDEX16              = 101,
        D3DFMT_INDEX32              = 102,
        D3DFMT_FORCE_DWORD          = 0x7fffffff,
    } D3DFORMAT;
    
    typedef struct _D3DDISPLAYMODE {
        UINT      Width;
        UINT      Height;
        UINT      RefreshRate;
        D3DFORMAT Format;
    } D3DDISPLAYMODE;
    
    typedef struct _D3DDEVICE_CREATION_PARAMETERS {
        UINT       AdapterOrdinal;
        D3DDEVTYPE DeviceType;
        HWND       hFocusWindow;
        DWORD      BehaviorFlags;
    } D3DDEVICE_CREATION_PARAMETERS;
    
    typedef enum _D3DSWAPEFFECT {
        D3DSWAPEFFECT_DISCARD     = 1,
        D3DSWAPEFFECT_FLIP        = 2,
        D3DSWAPEFFECT_COPY        = 3,
        D3DSWAPEFFECT_COPY_VSYNC  = 4,
        D3DSWAPEFFECT_FORCE_DWORD = 0x7fffffff,
    } D3DSWAPEFFECT;
    
    typedef enum _D3DPOOL {
        D3DPOOL_DEFAULT     = 0,
        D3DPOOL_MANAGED     = 1,
        D3DPOOL_SYSTEMMEM   = 2,
        D3DPOOL_SCRATCH     = 3,
        D3DPOOL_FORCE_DWORD = 0x7fffffff,
    } D3DPOOL;
    
    enum {
        D3DPRESENT_RATE_DEFAULT   = 0x00000000,
        D3DPRESENT_RATE_UNLIMITED = 0x7fffffff,
    };
    
    typedef struct _D3DPRESENT_PARAMETERS_ {
        UINT                BackBufferWidth;
        UINT                BackBufferHeight;
        D3DFORMAT           BackBufferFormat;
        UINT                BackBufferCount;
        D3DMULTISAMPLE_TYPE MultiSampleType;
        D3DSWAPEFFECT       SwapEffect;
        HWND                hDeviceWindow;
        BOOL                Windowed;
        BOOL                EnableAutoDepthStencil;
        D3DFORMAT           AutoDepthStencilFormat;
        DWORD               Flags;
        UINT                FullScreen_RefreshRateInHz;
        UINT                FullScreen_PresentationInterval;
    } D3DPRESENT_PARAMETERS;
    
    enum {
        D3DPRESENTFLAG_LOCKABLE_BACKBUFFER = 0x00000001,
    };
    
    typedef struct _D3DGAMMARAMP {
        WORD red  [256];
        WORD green[256];
        WORD blue [256];
    } D3DGAMMARAMP;
    
    typedef enum _D3DBACKBUFFER_TYPE {
        D3DBACKBUFFER_TYPE_MONO        = 0,
        D3DBACKBUFFER_TYPE_LEFT        = 1,
        D3DBACKBUFFER_TYPE_RIGHT       = 2,
        D3DBACKBUFFER_TYPE_FORCE_DWORD = 0x7fffffff,
    } D3DBACKBUFFER_TYPE;
    
    typedef enum _D3DRESOURCETYPE {
        D3DRTYPE_SURFACE       =  1,
        D3DRTYPE_VOLUME        =  2,
        D3DRTYPE_TEXTURE       =  3,
        D3DRTYPE_VOLUMETEXTURE =  4,
        D3DRTYPE_CUBETEXTURE   =  5,
        D3DRTYPE_VERTEXBUFFER  =  6,
        D3DRTYPE_INDEXBUFFER   =  7,
        D3DRTYPE_FORCE_DWORD   = 0x7fffffff,
    } D3DRESOURCETYPE;
    
    enum {
        D3DUSAGE_RENDERTARGET       = (0x00000001L),
        D3DUSAGE_DEPTHSTENCIL       = (0x00000002L),
        D3DUSAGE_WRITEONLY          = (0x00000008L),
        D3DUSAGE_SOFTWAREPROCESSING = (0x00000010L),
        D3DUSAGE_DONOTCLIP          = (0x00000020L),
        D3DUSAGE_POINTS             = (0x00000040L),
        D3DUSAGE_RTPATCHES          = (0x00000080L),
        D3DUSAGE_NPATCHES           = (0x00000100L),
        D3DUSAGE_DYNAMIC            = (0x00000200L),
    };
    
    typedef enum _D3DCUBEMAP_FACES {
        D3DCUBEMAP_FACE_POSITIVE_X  = 0,
        D3DCUBEMAP_FACE_NEGATIVE_X  = 1,
        D3DCUBEMAP_FACE_POSITIVE_Y  = 2,
        D3DCUBEMAP_FACE_NEGATIVE_Y  = 3,
        D3DCUBEMAP_FACE_POSITIVE_Z  = 4,
        D3DCUBEMAP_FACE_NEGATIVE_Z  = 5,
        D3DCUBEMAP_FACE_FORCE_DWORD = 0x7fffffff,
    } D3DCUBEMAP_FACES;
    
    enum {
        D3DLOCK_READONLY        = 0x00000010L,
        D3DLOCK_DISCARD         = 0x00002000L,
        D3DLOCK_NOOVERWRITE     = 0x00001000L,
        D3DLOCK_NOSYSLOCK       = 0x00000800L,
        D3DLOCK_NO_DIRTY_UPDATE = 0x00008000L,
    };
    
    typedef struct _D3DVERTEXBUFFER_DESC {
        D3DFORMAT           Format;
        D3DRESOURCETYPE     Type;
        DWORD               Usage;
        D3DPOOL             Pool;
        UINT                Size;
        DWORD               FVF;
    } D3DVERTEXBUFFER_DESC;
    
    typedef struct _D3DINDEXBUFFER_DESC {
        D3DFORMAT           Format;
        D3DRESOURCETYPE     Type;
        DWORD               Usage;
        D3DPOOL             Pool;
        UINT                Size;
    } D3DINDEXBUFFER_DESC;
    
    typedef struct _D3DSURFACE_DESC {
        D3DFORMAT           Format;
        D3DRESOURCETYPE     Type;
        DWORD               Usage;
        D3DPOOL             Pool;
        UINT                Size;
        D3DMULTISAMPLE_TYPE MultiSampleType;
        UINT                Width;
        UINT                Height;
    } D3DSURFACE_DESC;

    typedef struct _D3DVOLUME_DESC {
        D3DFORMAT           Format;
        D3DRESOURCETYPE     Type;
        DWORD               Usage;
        D3DPOOL             Pool;
        UINT                Size;
        UINT                Width;
        UINT                Height;
        UINT                Depth;
    } D3DVOLUME_DESC;
    
    typedef struct _D3DLOCKED_RECT {
        INT   Pitch;
        void* pBits;
    } D3DLOCKED_RECT;
    
    
    typedef struct _D3DBOX {
        UINT Left;
        UINT Top;
        UINT Right;
        UINT Bottom;
        UINT Front;
        UINT Back;
    } D3DBOX;

    typedef struct _D3DLOCKED_BOX {
        INT   RowPitch;
        INT   SlicePitch;
        void* pBits;
    } D3DLOCKED_BOX;

    typedef struct _D3DRANGE {
        UINT Offset;
        UINT Size;
    } D3DRANGE;

    typedef struct _D3DRECTPATCH_INFO {
        UINT         StartVertexOffsetWidth;
        UINT         StartVertexOffsetHeight;
        UINT         Width;
        UINT         Height;
        UINT         Stride;
        D3DBASISTYPE Basis;
        D3DORDERTYPE Order;
    } D3DRECTPATCH_INFO;

    typedef struct _D3DTRIPATCH_INFO {
        UINT         StartVertexOffset;
        UINT         NumVertices;
        D3DBASISTYPE Basis;
        D3DORDERTYPE Order;
    } D3DTRIPATCH_INFO;

    enum {
        MAX_DEVICE_IDENTIFIER_STRING = 512,
    };

    typedef struct _D3DADAPTER_IDENTIFIER8 {
        char          Driver[MAX_DEVICE_IDENTIFIER_STRING];
        char          Description[MAX_DEVICE_IDENTIFIER_STRING];
        LARGE_INTEGER DriverVersion;
        DWORD         VendorId;
        DWORD         DeviceId;
        DWORD         SubSysId;
        DWORD         Revision;
        GUID          DeviceIdentifier;
        DWORD         WHQLLevel;
    } D3DADAPTER_IDENTIFIER8;

    typedef struct _D3DRASTER_STATUS {
        BOOL InVBlank;
        UINT ScanLine;
    } D3DRASTER_STATUS;

    typedef enum _D3DDEBUGMONITORTOKENS {
        D3DDMT_ENABLE       = 0,
        D3DDMT_DISABLE      = 1,
        D3DDMT_FORCE_DWORD  = 0x7fffffff,
    } D3DDEBUGMONITORTOKENS;

    enum {
        D3DDEVINFOID_RESOURCEMANAGER = 5,
        D3DDEVINFOID_VERTEXSTATS     = 6,
    };

    typedef struct _D3DRESOURCESTATS {
        BOOL  bThrashing;
        DWORD ApproxBytesDownloaded;
        DWORD NumEvicts;
        DWORD NumVidCreates;
        DWORD LastPri;
        DWORD NumUsed;
        DWORD NumUsedInVidMem;
        DWORD WorkingSet;
        DWORD WorkingSetBytes;
        DWORD TotalManaged;
        DWORD TotalBytes;
    } D3DRESOURCESTATS;

    enum {
        D3DRTYPECOUNT = (D3DRTYPE_INDEXBUFFER + 1),
    };

    typedef struct _D3DDEVINFO_RESOURCEMANAGER {
        D3DRESOURCESTATS stats[D3DRTYPECOUNT];
    } D3DDEVINFO_RESOURCEMANAGER, *LPD3DDEVINFO_RESOURCEMANAGER;

    typedef struct _D3DDEVINFO_D3DVERTEXSTATS {
        DWORD NumRenderedTriangles;
        DWORD NumExtraClippingTriangles;
    } D3DDEVINFO_D3DVERTEXSTATS, *LPD3DDEVINFO_D3DVERTEXSTATS;
]];