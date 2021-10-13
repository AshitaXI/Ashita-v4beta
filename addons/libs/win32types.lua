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
* This file is created using the information from the Windows SDK header files.
* Files used:
*   - intsafe.h
*   - minwindef.h
*   - windef.h
*   - winerror.h
*   - wingdi.h
*   - winnt.h
--]]

local ffi = require('ffi');

ffi.cdef[[
    typedef signed char         INT8, *PINT8;
    typedef char                CHAR;
    typedef unsigned char       BYTE, *PBYTE, *LPBYTE, UCHAR, *PUCHAR, UINT8, *PUINT8;
    typedef wchar_t             WCHAR, *PWCHAR;
    typedef signed short        INT16, *PINT16;
    typedef short               SHORT;
    typedef unsigned short      WORD, *PWORD, *LPWORD, USHORT, *PUSHORT, UINT16, *PUINT16;
    typedef int                 INT, *PINT, *LPINT;
    typedef int                 BOOL, *PBOOL, *LPBOOL;
    typedef signed int          INT32, *PINT32, LONG32, *PLONG32;
    typedef unsigned int        UINT, *PUINT, UINT32, *PUINT32, DWORD32, *PDWORD32, ULONG32, *PULONG32, UINT_PTR;
    typedef long                LONG, *LPLONG, LONG_PTR;
    typedef unsigned long       DWORD, *PDWORD, *LPDWORD, ULONG, *PULONG;
    typedef signed __int64      INT64, *PINT64;
    typedef __int64             LONG64, *PLONG64;
    typedef __int64             LONGLONG;
    typedef unsigned __int64    UINT64, *PUINT64, DWORD64, *PDWORD64, ULONG64, *PULONG64, ULONGLONG;
    typedef float               FLOAT, *PFLOAT;

    typedef void                *LPVOID;
    typedef const void          *LPCVOID;

    typedef short               HALF_PTR, *PHALF_PTR;
    typedef unsigned short      UHALF_PTR, *PUHALF_PTR;
    typedef int                 INT_PTR, *PINT_PTR;
    typedef unsigned int        UINT_PTR, *PUINT_PTR;
    typedef long                LONG_PTR, *PLONG_PTR;
    typedef long                SHANDLE_PTR;
    typedef unsigned long       ULONG_PTR, *PULONG_PTR;
    typedef unsigned long       HANDLE_PTR;
    typedef unsigned long       POINTER_64_INT;

    typedef LONG_PTR            SSIZE_T, *PSSIZE_T;    
    typedef ULONG_PTR           SIZE_T, *PSIZE_T;
    typedef ULONG_PTR           DWORD_PTR, *PDWORD_PTR;    
    
    typedef ULONG_PTR           KAFFINITY;
    typedef KAFFINITY           *PKAFFINITY;
    
    typedef UINT_PTR            WPARAM;
    typedef LONG_PTR            LPARAM;
    typedef LONG_PTR            LRESULT;
    
    typedef void                *HANDLE;
    typedef HANDLE              *SPHANDLE;
    typedef HANDLE              *LPHANDLE;
    typedef HANDLE              HGLOBAL;
    typedef HANDLE              HLOCAL;
    typedef HANDLE              GLOBALHANDLE;
    typedef HANDLE              LOCALHANDLE;
	typedef HANDLE              HWND;
	typedef HANDLE              HMONITOR;
	typedef HANDLE              HICON;
	typedef HICON               HCURSOR;
	typedef HANDLE              HINSTANCE;
	typedef HANDLE              HBRUSH;
	typedef HANDLE              HMENU;
	typedef HANDLE              HDC;
	typedef HANDLE              HGLRC;
	typedef HANDLE              HFONT;
	typedef HANDLE              HMODULE;
    typedef uint32_t            HRESULT;
    
    typedef union _LARGE_INTEGER {
        struct {
            DWORD LowPart;
            LONG HighPart;
        } DUMMYSTRUCTNAME;
        struct {
            DWORD LowPart;
            LONG HighPart;
        } u;
        LONGLONG QuadPart;
    } LARGE_INTEGER;

    typedef struct _GUID {
        unsigned long  Data1;
        unsigned short Data2;
        unsigned short Data3;
        unsigned char  Data4[8];
    } GUID;
    
    typedef GUID            IID;
    typedef const IID&      REFIID;
    typedef const GUID &    REFGUID;
    
    typedef struct tagRECT {
        LONG left;
        LONG top;
        LONG right;
        LONG bottom;
    } RECT, *LPRECT;
    
    typedef struct tagPOINT {
        LONG  x;
        LONG  y;
    } POINT, *LPPOINT;

    typedef struct tagSIZE {
        LONG cx;
        LONG cy;
    } SIZE, *LPSIZE;
    
    typedef struct _RGNDATAHEADER {
        DWORD dwSize;
        DWORD iType;
        DWORD nCount;
        DWORD nRgnSize;
        RECT  rcBound;
    } RGNDATAHEADER, *PRGNDATAHEADER;

    typedef struct _RGNDATA {
        RGNDATAHEADER   rdh;
        char            Buffer[1];
    } RGNDATA, *LPRGNDATA;
    
    typedef struct tagPALETTEENTRY {
        BYTE peRed;
        BYTE peGreen;
        BYTE peBlue;
        BYTE peFlags;
    } PALETTEENTRY, *LPPALETTEENTRY;

    typedef struct tagLOGFONTA {
        LONG lfHeight;
        LONG lfWidth;
        LONG lfEscapement;
        LONG lfOrientation;
        LONG lfWeight;
        BYTE lfItalic;
        BYTE lfUnderline;
        BYTE lfStrikeOut;
        BYTE lfCharSet;
        BYTE lfOutPrecision;
        BYTE lfClipPrecision;
        BYTE lfQuality;
        BYTE lfPitchAndFamily;
        CHAR lfFaceName[32];
    } LOGFONTA, *PLOGFONTA, *NPLOGFONTA, *LPLOGFONTA;
]];

ffi.cdef[[
    enum {
        S_OK                        = 0,
        S_FALSE                     = 1,
        E_UNEXPECTED                = 0x8000FFFFL,
        E_NOTIMPL                   = 0x80004001L,
        E_OUTOFMEMORY               = 0x8007000EL,
        E_INVALIDARG                = 0x80070057L,
        E_NOINTERFACE               = 0x80004002L,
        E_POINTER                   = 0x80004003L,
        E_HANDLE                    = 0x80070006L,
        E_ABORT                     = 0x80004004L,
        E_FAIL                      = 0x80004005L,
        E_ACCESSDENIED              = 0x80070005L,
        E_PENDING                   = 0x8000000AL,
        REGDB_E_CLASSNOTREG         = 0x80040154L,
        CLASS_E_NOAGGREGATION       = 0x80040110L,
        CO_E_NOTINITIALIZED         = 0x800401F0L,
        CO_E_ALREADYINITIALIZED     = 0x800401F1L,
    };
]];