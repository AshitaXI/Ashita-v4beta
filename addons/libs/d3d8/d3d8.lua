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

local ffi = require('ffi');

ffi.cdef[[
    /**
     * Type Forwards
     */
    typedef struct IUnknown                 IUnknown;
    typedef struct IDirect3D8               IDirect3D8;
    typedef struct IDirect3DDevice8         IDirect3DDevice8;
    typedef struct IDirect3DResource8       IDirect3DResource8;
    typedef struct IDirect3DBaseTexture8    IDirect3DBaseTexture8;
    typedef struct IDirect3DTexture8        IDirect3DTexture8;
    typedef struct IDirect3DVolumeTexture8  IDirect3DVolumeTexture8;
    typedef struct IDirect3DCubeTexture8    IDirect3DCubeTexture8;
    typedef struct IDirect3DVertexBuffer8   IDirect3DVertexBuffer8;
    typedef struct IDirect3DIndexBuffer8    IDirect3DIndexBuffer8;
    typedef struct IDirect3DSurface8        IDirect3DSurface8;
    typedef struct IDirect3DVolume8         IDirect3DVolume8;
    typedef struct IDirect3DSwapChain8      IDirect3DSwapChain8;
]];

-- Require the Win32 type definitions..
require('win32types');

-- Require Direct3D8 type definitions..
require('d3d8.d3d8types');
require('d3d8.d3d8caps');

-- Require Direct3D8 interfaces..
require('d3d8.interfaces.iunknown');
require('d3d8.interfaces.idirect3d8');
require('d3d8.interfaces.idirect3ddevice8');
require('d3d8.interfaces.idirect3dresource8');
require('d3d8.interfaces.idirect3dbasetexture8');
require('d3d8.interfaces.idirect3dtexture8');
require('d3d8.interfaces.idirect3dvolumetexture8');
require('d3d8.interfaces.idirect3dcubetexture8');
require('d3d8.interfaces.idirect3dvertexbuffer8');
require('d3d8.interfaces.idirect3dindexbuffer8');
require('d3d8.interfaces.idirect3dsurface8');
require('d3d8.interfaces.idirect3dvolume8');
require('d3d8.interfaces.idirect3dswapchain8');

-- Require d3dx8 definitions..
require('d3d8.d3dx8');

ffi.cdef[[
    enum {
        D3DSPD_IUNKNOWN                         = 0x00000001L,
        D3DCURRENT_DISPLAY_MODE                 = 0x00EFFFFFL,
        D3DCREATE_FPU_PRESERVE                  = 0x00000002L,
        D3DCREATE_MULTITHREADED                 = 0x00000004L,
        D3DCREATE_PUREDEVICE                    = 0x00000010L,
        D3DCREATE_SOFTWARE_VERTEXPROCESSING     = 0x00000020L,
        D3DCREATE_HARDWARE_VERTEXPROCESSING     = 0x00000040L,
        D3DCREATE_MIXED_VERTEXPROCESSING        = 0x00000080L,
        D3DCREATE_DISABLE_DRIVER_MANAGEMENT     = 0x00000100L,
        D3DADAPTER_DEFAULT                      = 0,
        D3DENUM_NO_WHQL_LEVEL                   = 0x00000002L,
        D3DPRESENT_BACK_BUFFERS_MAX             = 3L,
        D3DSGR_NO_CALIBRATION                   = 0x00000000L,
        D3DSGR_CALIBRATE                        = 0x00000001L,
        D3DCURSOR_IMMEDIATE_UPDATE              = 0x00000001L,
    };

    enum {
        /* Direct3D (d3d8.h) */
        D3D_OK                                  = S_OK,
        D3DERR_BADMAJORVERSION                  = 0x887602BC,
        D3DERR_BADMINORVERSION                  = 0x887602BD,
        D3DERR_COLORKEYATTACHED                 = 0x88760802,
        D3DERR_CONFLICTINGRENDERSTATE           = 0x88760821,
        D3DERR_CONFLICTINGTEXTUREFILTER         = 0x8876081E,
        D3DERR_CONFLICTINGTEXTUREPALETTE        = 0x88760826,
        D3DERR_DEVICEAGGREGATED                 = 0x887602C3,
        D3DERR_DEVICELOST                       = 0x88760868,
        D3DERR_DEVICENOTRESET                   = 0x88760869,
        D3DERR_DRIVERINTERNALERROR              = 0x88760827,
        D3DERR_DRIVERINVALIDCALL                = 0x8876086D,
        D3DERR_EXECUTE_CLIPPED_FAILED           = 0x887602CD,
        D3DERR_EXECUTE_CREATE_FAILED            = 0x887602C6,
        D3DERR_EXECUTE_DESTROY_FAILED           = 0x887602C7,
        D3DERR_EXECUTE_FAILED                   = 0x887602CC,
        D3DERR_EXECUTE_LOCKED                   = 0x887602CA,
        D3DERR_EXECUTE_LOCK_FAILED              = 0x887602C8,
        D3DERR_EXECUTE_NOT_LOCKED               = 0x887602CB,
        D3DERR_EXECUTE_UNLOCK_FAILED            = 0x887602C9,
        D3DERR_INBEGIN                          = 0x88760302,
        D3DERR_INBEGINSTATEBLOCK                = 0x88760835,
        D3DERR_INITFAILED                       = 0x887602C2,
        D3DERR_INVALIDCALL                      = 0x8876086C,
        D3DERR_INVALIDCURRENTVIEWPORT           = 0x887602DF,
        D3DERR_INVALIDDEVICE                    = 0x8876086B,
        D3DERR_INVALIDMATRIX                    = 0x88760824,
        D3DERR_INVALIDPALETTE                   = 0x887602E8,
        D3DERR_INVALIDPRIMITIVETYPE             = 0x887602E0,
        D3DERR_INVALIDRAMPTEXTURE               = 0x887602E3,
        D3DERR_INVALIDSTATEBLOCK                = 0x88760834,
        D3DERR_INVALIDVERTEXFORMAT              = 0x88760800,
        D3DERR_INVALIDVERTEXTYPE                = 0x887602E1,
        D3DERR_INVALID_DEVICE                   = 0x887602C1,
        D3DERR_LIGHTHASVIEWPORT                 = 0x887602EF,
        D3DERR_LIGHTNOTINTHISVIEWPORT           = 0x887602F0,
        D3DERR_LIGHT_SET_FAILED                 = 0x887602EE,
        D3DERR_MATERIAL_CREATE_FAILED           = 0x887602E4,
        D3DERR_MATERIAL_DESTROY_FAILED          = 0x887602E5,
        D3DERR_MATERIAL_GETDATA_FAILED          = 0x887602E7,
        D3DERR_MATERIAL_SETDATA_FAILED          = 0x887602E6,
        D3DERR_MATRIX_CREATE_FAILED             = 0x887602DA,
        D3DERR_MATRIX_DESTROY_FAILED            = 0x887602DB,
        D3DERR_MATRIX_GETDATA_FAILED            = 0x887602DD,
        D3DERR_MATRIX_SETDATA_FAILED            = 0x887602DC,
        D3DERR_MOREDATA                         = 0x88760867,
        D3DERR_NOCURRENTVIEWPORT                = 0x88760307,
        D3DERR_NOTAVAILABLE                     = 0x8876086A,
        D3DERR_NOTFOUND                         = 0x88760866,
        D3DERR_NOTINBEGIN                       = 0x88760303,
        D3DERR_NOTINBEGINSTATEBLOCK             = 0x88760836,
        D3DERR_NOVIEWPORTS                      = 0x88760304,
        D3DERR_OUTOFVIDEOMEMORY                 = 0x8876017C,
        D3DERR_SCENE_BEGIN_FAILED               = 0x887602FA,
        D3DERR_SCENE_END_FAILED                 = 0x887602FB,
        D3DERR_SCENE_IN_SCENE                   = 0x887602F8,
        D3DERR_SCENE_NOT_IN_SCENE               = 0x887602F9,
        D3DERR_SETVIEWPORTDATA_FAILED           = 0x887602DE,
        D3DERR_STENCILBUFFER_NOTPRESENT         = 0x88760817,
        D3DERR_SURFACENOTINVIDMEM               = 0x887602EB,
        D3DERR_TEXTURE_BADSIZE                  = 0x887602E2,
        D3DERR_TEXTURE_CREATE_FAILED            = 0x887602D1,
        D3DERR_TEXTURE_DESTROY_FAILED           = 0x887602D2,
        D3DERR_TEXTURE_GETSURF_FAILED           = 0x887602D9,
        D3DERR_TEXTURE_LOAD_FAILED              = 0x887602D5,
        D3DERR_TEXTURE_LOCKED                   = 0x887602D7,
        D3DERR_TEXTURE_LOCK_FAILED              = 0x887602D3,
        D3DERR_TEXTURE_NOT_LOCKED               = 0x887602D8,
        D3DERR_TEXTURE_NO_SUPPORT               = 0x887602D0,
        D3DERR_TEXTURE_SWAP_FAILED              = 0x887602D6,
        D3DERR_TEXTURE_UNLOCK_FAILED            = 0x887602D4,
        D3DERR_TOOMANYOPERATIONS                = 0x8876081D,
        D3DERR_TOOMANYPRIMITIVES                = 0x88760823,
        D3DERR_TOOMANYVERTICES                  = 0x88760825,
        D3DERR_UNSUPPORTEDALPHAARG              = 0x8876081C,
        D3DERR_UNSUPPORTEDALPHAOPERATION        = 0x8876081B,
        D3DERR_UNSUPPORTEDCOLORARG              = 0x8876081A,
        D3DERR_UNSUPPORTEDCOLOROPERATION        = 0x88760819,
        D3DERR_UNSUPPORTEDFACTORVALUE           = 0x8876081F,
        D3DERR_UNSUPPORTEDTEXTUREFILTER         = 0x88760822,
        D3DERR_VBUF_CREATE_FAILED               = 0x8876080D,
        D3DERR_VERTEXBUFFERLOCKED               = 0x8876080E,
        D3DERR_VERTEXBUFFEROPTIMIZED            = 0x8876080C,
        D3DERR_VERTEXBUFFERUNLOCKFAILED         = 0x8876080F,
        D3DERR_VIEWPORTDATANOTSET               = 0x88760305,
        D3DERR_VIEWPORTHASNODEVICE              = 0x88760306,
        D3DERR_WRONGTEXTUREFORMAT               = 0x88760818,
        D3DERR_ZBUFFER_NOTPRESENT               = 0x88760816,
        D3DERR_ZBUFF_NEEDS_SYSTEMMEMORY         = 0x887602E9,
        D3DERR_ZBUFF_NEEDS_VIDEOMEMORY          = 0x887602EA,
        D3DERR_WASSTILLDRAWING                  = 0x8876021c,

        /* DirectInput (dinput.h) */
        DIERR_OLDDIRECTINPUTVERSION             = 0x8007047E,
        DIERR_BETADIRECTINPUTVERSION            = 0x80070481,
        DIERR_BADDRIVERVER                      = 0x80070077,
        DIERR_DEVICENOTREG                      = REGDB_E_CLASSNOTREG,
        DIERR_NOTFOUND                          = 0x80070002,
        DIERR_OBJECTNOTFOUND                    = 0x80070002,
        DIERR_INVALIDPARAM                      = E_INVALIDARG,
        DIERR_NOINTERFACE                       = E_NOINTERFACE,
        DIERR_GENERIC                           = E_FAIL,
        DIERR_OUTOFMEMORY                       = E_OUTOFMEMORY,
        DIERR_UNSUPPORTED                       = E_NOTIMPL,
        DIERR_NOTINITIALIZED                    = 0x80070015,
        DIERR_ALREADYINITIALIZED                = 0x800704DF,
        DIERR_NOAGGREGATION                     = CLASS_E_NOAGGREGATION,
        DIERR_OTHERAPPHASPRIO                   = E_ACCESSDENIED,
        DIERR_INPUTLOST                         = 0x8007001E,
        DIERR_ACQUIRED                          = 0x800700AA,
        DIERR_NOTACQUIRED                       = 0x8007000C,
        DIERR_NOMOREITEMS                       = 0x80070103L,
        DIERR_READONLY                          = E_ACCESSDENIED,
        DIERR_HANDLEEXISTS                      = E_ACCESSDENIED,
        DIERR_INSUFFICIENTPRIVS                 = 0x80040200L,
        DIERR_DEVICEFULL                        = 0x80040201L,
        DIERR_MOREDATA                          = 0x80040202L,
        DIERR_NOTDOWNLOADED                     = 0x80040203L,
        DIERR_HASEFFECTS                        = 0x80040204L,
        DIERR_NOTEXCLUSIVEACQUIRED              = 0x80040205L,
        DIERR_INCOMPLETEEFFECT                  = 0x80040206L,
        DIERR_NOTBUFFERED                       = 0x80040207L,
        DIERR_EFFECTPLAYING                     = 0x80040208L,
        DIERR_UNPLUGGED                         = 0x80040209L,
        DIERR_REPORTFULL                        = 0x8004020AL,
        DIERR_MAPFILEFAIL                       = 0x8004020BL,
        DIERR_DRIVERFIRST                       = 0x80040300L,
        DIERR_DRIVERLAST                        = 0x800403FFL,
        DIERR_INVALIDCLASSINSTALLER             = 0x80040400L,
        DIERR_CANCELLED                         = 0x80040401L,
        DIERR_BADINF                            = 0x80040402L,

        /* Direct3D X File (DXFile.h) */
        DXFILEERR_BADOBJECT                     = 0x88760352,
        DXFILEERR_BADVALUE                      = 0x88760353,
        DXFILEERR_BADTYPE                       = 0x88760354,
        DXFILEERR_BADSTREAMHANDLE               = 0x88760355,
        DXFILEERR_BADALLOC                      = 0x88760356,
        DXFILEERR_NOTFOUND                      = 0x88760357,
        DXFILEERR_NOTDONEYET                    = 0x88760358,
        DXFILEERR_FILENOTFOUND                  = 0x88760359,
        DXFILEERR_RESOURCENOTFOUND              = 0x8876035A,
        DXFILEERR_URLNOTFOUND                   = 0x8876035B,
        DXFILEERR_BADRESOURCE                   = 0x8876035C,
        DXFILEERR_BADFILETYPE                   = 0x8876035D,
        DXFILEERR_BADFILEVERSION                = 0x8876035E,
        DXFILEERR_BADFILEFLOATSIZE              = 0x8876035F,
        DXFILEERR_BADFILECOMPRESSIONTYPE        = 0x88760360,
        DXFILEERR_BADFILE                       = 0x88760361,
        DXFILEERR_PARSEERROR                    = 0x88760362,
        DXFILEERR_NOTEMPLATE                    = 0x88760363,
        DXFILEERR_BADARRAYSIZE                  = 0x88760364,
        DXFILEERR_BADDATAREFERENCE              = 0x88760365,
        DXFILEERR_INTERNALERROR                 = 0x88760366,
        DXFILEERR_NOMOREOBJECTS                 = 0x88760367,
        DXFILEERR_BADINTRINSICS                 = 0x88760368,
        DXFILEERR_NOMORESTREAMHANDLES           = 0x88760369,
        DXFILEERR_NOMOREDATA                    = 0x8876036A,
        DXFILEERR_BADCACHEFILE                  = 0x8876036B,
        DXFILEERR_NOINTERNET                    = 0x8876036C,
    };
]];
