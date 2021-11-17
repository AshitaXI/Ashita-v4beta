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

local ffi   = require('ffi');
local C     = ffi.C;

require('d3d8.d3d8');

--[[
* Returns the main IDirect3DDevice8 object prepared for FFI usage.
*
* @return {IDirect3DDevice8*} The FFI-casted IDirect3DDevice8 object.
--]]
local function get_device()
    return ffi.cast('IDirect3DDevice8*', AshitaCore:GetDirect3DDevice());
end

--[[
* Garbage collection helper for COM interface objects that will automatically call 'Release' for you when the object is no longer in use.
*
* @param {any} o - The COM object with a valid 'Release' call to wrap.
* @return {any} o - Returns the passed 'o' object, unaltered.
*
* Note:
*   This can have unwanted side effects or cause crashes if used incorrectly!
*   Types that you use such as textures and surfaces should not use this.
*   Manage them fully yourself.
--]]
local function gc_safe_release(o)
    if (o == nil) then
        error('Invalid object for safe_release!');
    end

    return ffi.gc(o, function (v)
        v:Release();
    end);
end

--[[
* Converts an IID string to an FFI GUID object.
*
* @param {string} str - The IID string to convert.
* @return {GUID} The converted GUID on success.
*
* @note
*   This helper supports both IID and GUIDs.
*
* Valid formats:
*
*   This helper supports IIDs that have the following:
*       - (Optional) Braces surrounding the IID.
*       - (Optional) Dashes separating the groups in the IID.
*
* Valid IUnknown IID Examples:
*
*   {00000000-0000-0000-C000-000000000046}  - With braces, with dashes.
*   00000000-0000-0000-C000-000000000046    - Without braces, with dashes.
*   {0000000000000000C000000000000046}      - With braces, without dashes.
*   0000000000000000C000000000000046        - Without braces, without dashes.
--]]
local function iid_from_str(str)
    local d1, d2, d3, d4_1, d4_2, d4_3, d4_4, d4_5, d4_6, d4_7, d4_8 = string.match(str, '^{?(%x%x%x%x%x%x%x%x)%-?(%x%x%x%x)%-?(%x%x%x%x)%-?(%x%x)(%x%x)%-?(%x%x)(%x%x)(%x%x)(%x%x)(%x%x)(%x%x)}?$');

    if (d1 == nil) then
        error('Invalid IID string; cannot convert.');
    end

    return ffi.new('GUID', {
        tonumber(d1, 16), tonumber(d2, 16), tonumber(d3, 16), {
        tonumber(d4_1, 16), tonumber(d4_2, 16), tonumber(d4_3, 16), tonumber(d4_4, 16), tonumber(d4_5, 16), tonumber(d4_6, 16), tonumber(d4_7, 16), tonumber(d4_8, 16)
    }});
end

--[[
* Converts an HRESULT to it's actual error name, if known.
*
* @param {HRESULT} hres - The HRESULT to obtain the name of.
* @return {string} The result name if known, UNKNOWN_ERROR otherwise.
--]]
local function get_error(hres)
    -- Win32 Error Codes
        if (hres == C.S_OK) then return "S_OK";
    elseif (hres == C.S_FALSE) then return "S_FALSE";
    elseif (hres == C.E_UNEXPECTED) then return "E_UNEXPECTED";
    elseif (hres == C.E_NOTIMPL) then return "E_NOTIMPL";
    elseif (hres == C.E_OUTOFMEMORY) then return "E_OUTOFMEMORY";
    elseif (hres == C.E_INVALIDARG) then return "E_INVALIDARG";
    elseif (hres == C.E_NOINTERFACE) then return "E_NOINTERFACE";
    elseif (hres == C.E_POINTER) then return "E_POINTER";
    elseif (hres == C.E_HANDLE) then return "E_HANDLE";
    elseif (hres == C.E_ABORT) then return "E_ABORT";
    elseif (hres == C.E_FAIL) then return "E_FAIL";
    elseif (hres == C.E_ACCESSDENIED) then return "E_ACCESSDENIED";
    elseif (hres == C.E_PENDING) then return "E_PENDING";
    elseif (hres == C.REGDB_E_CLASSNOTREG) then return "REGDB_E_CLASSNOTREG";
    elseif (hres == C.CO_E_NOTINITIALIZED) then return "CO_E_NOTINITIALIZED";
    elseif (hres == C.CO_E_ALREADYINITIALIZED) then return "CO_E_ALREADYINITIALIZED";

    -- Direct Input Error Codes
    elseif (hres == C.DIERR_GENERIC) then return "E_FAIL";
    elseif (hres == C.DIERR_NOAGGREGATION) then return "E_NOAGGREGATION";
    elseif (hres == C.DIERR_INSUFFICIENTPRIVS) then return "DIERR_INSUFFICIENTPRIVS";
    elseif (hres == C.DIERR_DEVICEFULL) then return "DIERR_DEVICEFULL";
    elseif (hres == C.DIERR_MOREDATA) then return "DIERR_MOREDATA";
    elseif (hres == C.DIERR_NOTDOWNLOADED) then return "DIERR_NOTDOWNLOADED";
    elseif (hres == C.DIERR_HASEFFECTS) then return "DIERR_HASEFFECTS";
    elseif (hres == C.DIERR_NOTEXCLUSIVEACQUIRED) then return "DIERR_NOTEXCLUSIVEACQUIRED";
    elseif (hres == C.DIERR_INCOMPLETEEFFECT) then return "DIERR_INCOMPLETEEFFECT";
    elseif (hres == C.DIERR_NOTBUFFERED) then return "DIERR_NOTBUFFERED";
    elseif (hres == C.DIERR_EFFECTPLAYING) then return "DIERR_EFFECTPLAYING";
    elseif (hres == C.DIERR_UNPLUGGED) then return "DIERR_UNPLUGGED";
    elseif (hres == C.DIERR_REPORTFULL) then return "DIERR_REPORTFULL";
    elseif (hres == C.DIERR_DRIVERFIRST) then return "DIERR_DRIVERFIRST";
    elseif (hres == C.DIERR_DRIVERLAST) then return "DIERR_DRIVERLAST";
    elseif (hres == C.DIERR_INVALIDCLASSINSTALLER) then return "DIERR_INVALIDCLASSINSTALLER";
    elseif (hres == C.DIERR_CANCELLED) then return "DIERR_CANCELLED";
    elseif (hres == C.DIERR_BADINF) then return "DIERR_BADINF";
    elseif (hres == C.DIERR_NOTFOUND) then return "DIERR_NOTFOUND or DIERR_NOTFOUND";
    elseif (hres == C.DIERR_READONLY) then return "DIERR_READONLY or DIERR_OTHERAPPHASPRIO or DIERR_HANDLEEXISTS or DSERR_ACCESSDENIED";
    elseif (hres == C.DIERR_NOTACQUIRED) then return "DIERR_NOTACQUIRED";
    elseif (hres == C.DIERR_OUTOFMEMORY) then return "E_OUTOFMEMORY";
    elseif (hres == C.DIERR_NOTINITIALIZED) then return "DIERR_NOTINITIALIZED";
    elseif (hres == C.DIERR_INPUTLOST) then return "DIERR_INPUTLOST";
    elseif (hres == C.DIERR_BADDRIVERVER) then return "DIERR_BADDRIVERVER";
    elseif (hres == C.DIERR_ACQUIRED) then return "DIERR_ACQUIRED";
    elseif (hres == C.DIERR_NOMOREITEMS) then return "DIERR_NOMOREITEMS";
    elseif (hres == C.DIERR_OLDDIRECTINPUTVERSION) then return "DIERR_OLDDIRECTINPUTVERSION";
    elseif (hres == C.DIERR_BETADIRECTINPUTVERSION) then return "DIERR_BETADIRECTINPUTVERSION";
    elseif (hres == C.DIERR_ALREADYINITIALIZED) then return "DIERR_ALREADYINITIALIZED";

    -- Direct Play Voice Error Codes
    --elseif (hres == C.DVERR_BUFFERTOOSMALL) then return "DVERR_BUFFERTOOSMALL";
    --elseif (hres == C.DVERR_EXCEPTION) then return "DVERR_EXCEPTION";
    --elseif (hres == C.DVERR_INVALIDFLAGS) then return "DVERR_INVALIDFLAGS";
    --elseif (hres == C.DVERR_INVALIDOBJECT) then return "DVERR_INVALIDOBJECT";
    --elseif (hres == C.DVERR_INVALIDPLAYER) then return "DVERR_INVALIDPLAYER";
    --elseif (hres == C.DVERR_INVALIDGROUP) then return "DVERR_INVALIDGROUP";
    --elseif (hres == C.DVERR_INVALIDHANDLE) then return "DVERR_INVALIDHANDLE";
    --elseif (hres == C.DVERR_SESSIONLOST) then return "DVERR_SESSIONLOST";
    --elseif (hres == C.DVERR_NOVOICESESSION) then return "DVERR_NOVOICESESSION";
    --elseif (hres == C.DVERR_CONNECTIONLOST) then return "DVERR_CONNECTIONLOST";
    --elseif (hres == C.DVERR_NOTINITIALIZED) then return "DVERR_NOTINITIALIZED";
    --elseif (hres == C.DVERR_CONNECTED) then return "DVERR_CONNECTED";
    --elseif (hres == C.DVERR_NOTCONNECTED) then return "DVERR_NOTCONNECTED";
    --elseif (hres == C.DVERR_CONNECTABORTING) then return "DVERR_CONNECTABORTING";
    --elseif (hres == C.DVERR_NOTALLOWED) then return "DVERR_NOTALLOWED";
    --elseif (hres == C.DVERR_INVALIDTARGET) then return "DVERR_INVALIDTARGET";
    --elseif (hres == C.DVERR_TRANSPORTNOTHOST) then return "DVERR_TRANSPORTNOTHOST";
    --elseif (hres == C.DVERR_COMPRESSIONNOTSUPPORTED) then return "DVERR_COMPRESSIONNOTSUPPORTED";
    --elseif (hres == C.DVERR_ALREADYPENDING) then return "DVERR_ALREADYPENDING";
    --elseif (hres == C.DVERR_SOUNDINITFAILURE) then return "DVERR_SOUNDINITFAILURE";
    --elseif (hres == C.DVERR_TIMEOUT) then return "DVERR_TIMEOUT";
    --elseif (hres == C.DVERR_CONNECTABORTED) then return "DVERR_CONNECTABORTED";
    --elseif (hres == C.DVERR_NO3DSOUND) then return "DVERR_NO3DSOUND";
    --elseif (hres == C.DVERR_ALREADYBUFFERED) then return "DVERR_ALREADYBUFFERED";
    --elseif (hres == C.DVERR_NOTBUFFERED) then return "DVERR_NOTBUFFERED";
    --elseif (hres == C.DVERR_HOSTING) then return "DVERR_HOSTING";
    --elseif (hres == C.DVERR_NOTHOSTING) then return "DVERR_NOTHOSTING";
    --elseif (hres == C.DVERR_INVALIDDEVICE) then return "DVERR_INVALIDDEVICE";
    --elseif (hres == C.DVERR_RECORDSYSTEMERROR) then return "DVERR_RECORDSYSTEMERROR";
    --elseif (hres == C.DVERR_PLAYBACKSYSTEMERROR) then return "DVERR_PLAYBACKSYSTEMERROR";
    --elseif (hres == C.DVERR_SENDERROR) then return "DVERR_SENDERROR";
    --elseif (hres == C.DVERR_USERCANCEL) then return "DVERR_USERCANCEL";
    --elseif (hres == C.DVERR_RUNSETUP) then return "DVERR_RUNSETUP";
    --elseif (hres == C.DVERR_INCOMPATIBLEVERSION) then return "DVERR_INCOMPATIBLEVERSION";
    --elseif (hres == C.DVERR_INITIALIZED) then return "DVERR_INITIALIZED";
    --elseif (hres == C.DVERR_NOTRANSPORT) then return "DVERR_NOTRANSPORT";
    --elseif (hres == C.DVERR_NOCALLBACK) then return "DVERR_NOCALLBACK";
    --elseif (hres == C.DVERR_TRANSPORTNOTINIT) then return "DVERR_TRANSPORTNOTINIT";
    --elseif (hres == C.DVERR_TRANSPORTNOSESSION) then return "DVERR_TRANSPORTNOSESSION";
    --elseif (hres == C.DVERR_TRANSPORTNOPLAYER) then return "DVERR_TRANSPORTNOPLAYER";
    --elseif (hres == C.DVERR_USERBACK) then return "DVERR_USERBACK";
    --elseif (hres == C.DVERR_NORECVOLAVAILABLE) then return "DVERR_NORECVOLAVAILABLE";

    -- Direct Play Error Codes
    --elseif (hres == C.DPNERR_ABORTED) then return "DPNERR_ABORTED";
    --elseif (hres == C.DPNERR_ADDRESSING) then return "DPNERR_ADDRESSING";
    --elseif (hres == C.DPNERR_ALREADYCONNECTED) then return "DPNERR_ALREADYCONNECTED";
    --elseif (hres == C.DPNERR_ALREADYDISCONNECTING) then return "DPNERR_ALREADYDISCONNECTING";
    --elseif (hres == C.DPNERR_ALREADYINITIALIZED) then return "DPNERR_ALREADYINITIALIZED";
    --elseif (hres == C.DPNERR_ALREADYREGISTERED) then return "DPNERR_ALREADYREGISTERED";
    --elseif (hres == C.DPNERR_BUFFERTOOSMALL) then return "DPNERR_BUFFERTOOSMALL";
    --elseif (hres == C.DPNERR_CANNOTCANCEL) then return "DPNERR_CANNOTCANCEL";
    --elseif (hres == C.DPNERR_CANTCREATEGROUP) then return "DPNERR_CANTCREATEGROUP";
    --elseif (hres == C.DPNERR_CANTCREATEPLAYER) then return "DPNERR_CANTCREATEPLAYER";
    --elseif (hres == C.DPNERR_CANTLAUNCHAPPLICATION) then return "DPNERR_CANTLAUNCHAPPLICATION";
    --elseif (hres == C.DPNERR_CONNECTING) then return "DPNERR_CONNECTING";
    --elseif (hres == C.DPNERR_CONNECTIONLOST) then return "DPNERR_CONNECTIONLOST";
    --elseif (hres == C.DPNERR_CONVERSION) then return "DPNERR_CONVERSION";
    --elseif (hres == C.DPNERR_DOESNOTEXIST) then return "DPNERR_DOESNOTEXIST";
    --elseif (hres == C.DPNERR_DUPLICATECOMMAND) then return "DPNERR_DUPLICATECOMMAND";
    --elseif (hres == C.DPNERR_ENDPOINTNOTRECEIVING) then return "DPNERR_ENDPOINTNOTRECEIVING";
    --elseif (hres == C.DPNERR_EXCEPTION) then return "DPNERR_EXCEPTION";
    --elseif (hres == C.DPNERR_GROUPNOTEMPTY) then return "DPNERR_GROUPNOTEMPTY";
    --elseif (hres == C.DPNERR_HOSTING) then return "DPNERR_HOSTING";
    --elseif (hres == C.DPNERR_HOSTREJECTEDCONNECTION) then return "DPNERR_HOSTREJECTEDCONNECTION";
    --elseif (hres == C.DPNERR_INCOMPLETEADDRESS) then return "DPNERR_INCOMPLETEADDRESS";
    --elseif (hres == C.DPNERR_INVALIDADDRESSFORMAT) then return "DPNERR_INVALIDADDRESSFORMAT";
    --elseif (hres == C.DPNERR_INVALIDAPPLICATION) then return "DPNERR_INVALIDAPPLICATION";
    --elseif (hres == C.DPNERR_INVALIDCOMMAND) then return "DPNERR_INVALIDCOMMAND";
    --elseif (hres == C.DPNERR_INVALIDENDPOINT) then return "DPNERR_INVALIDENDPOINT";
    --elseif (hres == C.DPNERR_INVALIDFLAGS) then return "DPNERR_INVALIDFLAGS";
    --elseif (hres == C.DPNERR_INVALIDGROUP) then return "DPNERR_INVALIDGROUP";
    --elseif (hres == C.DPNERR_INVALIDHANDLE) then return "DPNERR_INVALIDHANDLE";
    --elseif (hres == C.DPNERR_INVALIDINSTANCE) then return "DPNERR_INVALIDINSTANCE";
    --elseif (hres == C.DPNERR_INVALIDINTERFACE) then return "DPNERR_INVALIDINTERFACE";
    --elseif (hres == C.DPNERR_INVALIDDEVICEADDRESS) then return "DPNERR_INVALIDDEVICEADDRESS";
    --elseif (hres == C.DPNERR_INVALIDOBJECT) then return "DPNERR_INVALIDOBJECT";
    --elseif (hres == C.DPNERR_INVALIDPASSWORD) then return "DPNERR_INVALIDPASSWORD";
    --elseif (hres == C.DPNERR_INVALIDPLAYER) then return "DPNERR_INVALIDPLAYER";
    --elseif (hres == C.DPNERR_INVALIDPRIORITY) then return "DPNERR_INVALIDPRIORITY";
    --elseif (hres == C.DPNERR_INVALIDHOSTADDRESS) then return "DPNERR_INVALIDHOSTADDRESS";
    --elseif (hres == C.DPNERR_INVALIDSTRING) then return "DPNERR_INVALIDSTRING";
    --elseif (hres == C.DPNERR_INVALIDURL) then return "DPNERR_INVALIDURL";
    --elseif (hres == C.DPNERR_NOCAPS) then return "DPNERR_NOCAPS";
    --elseif (hres == C.DPNERR_NOCONNECTION) then return "DPNERR_NOCONNECTION";
    --elseif (hres == C.DPNERR_NOHOSTPLAYER) then return "DPNERR_NOHOSTPLAYER";
    --elseif (hres == C.DPNERR_NOMOREADDRESSCOMPONENTS) then return "DPNERR_NOMOREADDRESSCOMPONENTS";
    --elseif (hres == C.DPNERR_NORESPONSE) then return "DPNERR_NORESPONSE";
    --elseif (hres == C.DPNERR_NOTALLOWED) then return "DPNERR_NOTALLOWED";
    --elseif (hres == C.DPNERR_NOTHOST) then return "DPNERR_NOTHOST";
    --elseif (hres == C.DPNERR_NOTREADY) then return "DPNERR_NOTREADY";
    --elseif (hres == C.DPNERR_NOTREGISTERED) then return "DPNERR_NOTREGISTERED";
    --elseif (hres == C.DPNERR_PLAYERLOST) then return "DPNERR_PLAYERLOST";
    --elseif (hres == C.DPNERR_SENDTOOLARGE) then return "DPNERR_SENDTOOLARGE";
    --elseif (hres == C.DPNERR_SESSIONFULL) then return "DPNERR_SESSIONFULL";
    --elseif (hres == C.DPNERR_TABLEFULL) then return "DPNERR_TABLEFULL";
    --elseif (hres == C.DPNERR_TIMEDOUT) then return "DPNERR_TIMEDOUT";
    --elseif (hres == C.DPNERR_UNINITIALIZED) then return "DPNERR_UNINITIALIZED";
    --elseif (hres == C.DPNERR_USERCANCEL) then return "DPNERR_USERCANCEL";

    -- Direct3D X File Error Codes
    elseif (hres == C.DXFILEERR_BADOBJECT) then return "DXFILEERR_BADOBJECT";
    elseif (hres == C.DXFILEERR_BADVALUE) then return "DXFILEERR_BADVALUE";
    elseif (hres == C.DXFILEERR_BADTYPE) then return "DXFILEERR_BADTYPE";
    elseif (hres == C.DXFILEERR_BADSTREAMHANDLE) then return "DXFILEERR_BADSTREAMHANDLE";
    elseif (hres == C.DXFILEERR_BADALLOC) then return "DXFILEERR_BADALLOC";
    elseif (hres == C.DXFILEERR_NOTFOUND) then return "DXFILEERR_NOTFOUND";
    elseif (hres == C.DXFILEERR_NOTDONEYET) then return "DXFILEERR_NOTDONEYET";
    elseif (hres == C.DXFILEERR_FILENOTFOUND) then return "DXFILEERR_FILENOTFOUND";
    elseif (hres == C.DXFILEERR_RESOURCENOTFOUND) then return "DXFILEERR_RESOURCENOTFOUND";
    elseif (hres == C.DXFILEERR_URLNOTFOUND) then return "DXFILEERR_URLNOTFOUND";
    elseif (hres == C.DXFILEERR_BADRESOURCE) then return "DXFILEERR_BADRESOURCE";
    elseif (hres == C.DXFILEERR_BADFILETYPE) then return "DXFILEERR_BADFILETYPE";
    elseif (hres == C.DXFILEERR_BADFILEVERSION) then return "DXFILEERR_BADFILEVERSION";
    elseif (hres == C.DXFILEERR_BADFILEFLOATSIZE) then return "DXFILEERR_BADFILEFLOATSIZE";
    elseif (hres == C.DXFILEERR_BADFILECOMPRESSIONTYPE) then return "DXFILEERR_BADFILECOMPRESSIONTYPE";
    elseif (hres == C.DXFILEERR_BADFILE) then return "DXFILEERR_BADFILE";
    elseif (hres == C.DXFILEERR_PARSEERROR) then return "DXFILEERR_PARSEERROR";
    elseif (hres == C.DXFILEERR_NOTEMPLATE) then return "DXFILEERR_NOTEMPLATE";
    elseif (hres == C.DXFILEERR_BADARRAYSIZE) then return "DXFILEERR_BADARRAYSIZE";
    elseif (hres == C.DXFILEERR_BADDATAREFERENCE) then return "DXFILEERR_BADDATAREFERENCE";
    elseif (hres == C.DXFILEERR_INTERNALERROR) then return "DXFILEERR_INTERNALERROR";
    elseif (hres == C.DXFILEERR_NOMOREOBJECTS) then return "DXFILEERR_NOMOREOBJECTS";
    elseif (hres == C.DXFILEERR_BADINTRINSICS) then return "DXFILEERR_BADINTRINSICS";
    elseif (hres == C.DXFILEERR_NOMORESTREAMHANDLES) then return "DXFILEERR_NOMORESTREAMHANDLES";
    elseif (hres == C.DXFILEERR_NOMOREDATA) then return "DXFILEERR_NOMOREDATA";
    elseif (hres == C.DXFILEERR_BADCACHEFILE) then return "DXFILEERR_BADCACHEFILE";
    elseif (hres == C.DXFILEERR_NOINTERNET) then return "DXFILEERR_NOINTERNET";

    -- Direct3D Errors (d3d8.h)
    elseif (hres == C.D3DERR_OUTOFVIDEOMEMORY) then return "D3DERR_OUTOFVIDEOMEMORY";
    elseif (hres == C.D3DERR_WRONGTEXTUREFORMAT) then return "D3DERR_WRONGTEXTUREFORMAT";
    elseif (hres == C.D3DERR_UNSUPPORTEDCOLOROPERATION) then return "D3DERR_UNSUPPORTEDCOLOROPERATION";
    elseif (hres == C.D3DERR_UNSUPPORTEDCOLORARG) then return "D3DERR_UNSUPPORTEDCOLORARG";
    elseif (hres == C.D3DERR_UNSUPPORTEDALPHAOPERATION) then return "D3DERR_UNSUPPORTEDALPHAOPERATION";
    elseif (hres == C.D3DERR_UNSUPPORTEDALPHAARG) then return "D3DERR_UNSUPPORTEDALPHAARG";
    elseif (hres == C.D3DERR_TOOMANYOPERATIONS) then return "D3DERR_TOOMANYOPERATIONS";
    elseif (hres == C.D3DERR_CONFLICTINGTEXTUREFILTER) then return "D3DERR_CONFLICTINGTEXTUREFILTER";
    elseif (hres == C.D3DERR_UNSUPPORTEDFACTORVALUE) then return "D3DERR_UNSUPPORTEDFACTORVALUE";
    elseif (hres == C.D3DERR_CONFLICTINGRENDERSTATE) then return "D3DERR_CONFLICTINGRENDERSTATE";
    elseif (hres == C.D3DERR_UNSUPPORTEDTEXTUREFILTER) then return "D3DERR_UNSUPPORTEDTEXTUREFILTER";
    elseif (hres == C.D3DERR_CONFLICTINGTEXTUREPALETTE) then return "D3DERR_CONFLICTINGTEXTUREPALETTE";
    elseif (hres == C.D3DERR_DRIVERINTERNALERROR) then return "D3DERR_DRIVERINTERNALERROR";
    elseif (hres == C.D3DERR_NOTFOUND) then return "D3DERR_NOTFOUND";
    elseif (hres == C.D3DERR_MOREDATA) then return "D3DERR_MOREDATA";
    elseif (hres == C.D3DERR_DEVICELOST) then return "D3DERR_DEVICELOST";
    elseif (hres == C.D3DERR_DEVICENOTRESET) then return "D3DERR_DEVICENOTRESET";
    elseif (hres == C.D3DERR_NOTAVAILABLE) then return "D3DERR_NOTAVAILABLE";
    elseif (hres == C.D3DERR_INVALIDDEVICE) then return "D3DERR_INVALIDDEVICE";
    elseif (hres == C.D3DERR_INVALIDCALL) then return "D3DERR_INVALIDCALL";

    -- Direct Sound Error Codes
    --elseif (hres == C.DSERR_ALLOCATED) then return "DSERR_ALLOCATED";
    --elseif (hres == C.DSERR_CONTROLUNAVAIL) then return "DSERR_CONTROLUNAVAIL";
    --elseif (hres == C.DSERR_INVALIDCALL) then return "DSERR_INVALIDCALL";
    --elseif (hres == C.DSERR_PRIOLEVELNEEDED) then return "DSERR_PRIOLEVELNEEDED";
    --elseif (hres == C.DSERR_BADFORMAT) then return "DSERR_BADFORMAT";
    --elseif (hres == C.DSERR_NODRIVER) then return "DSERR_NODRIVER";
    --elseif (hres == C.DSERR_ALREADYINITIALIZED) then return "DSERR_ALREADYINITIALIZED";
    --elseif (hres == C.DSERR_BUFFERLOST) then return "DSERR_BUFFERLOST";
    --elseif (hres == C.DSERR_OTHERAPPHASPRIO) then return "DSERR_OTHERAPPHASPRIO";
    --elseif (hres == C.DSERR_UNINITIALIZED) then return "DSERR_UNINITIALIZED";

    -- Direct Music Error Codes
    --elseif (hres == C.DMUS_E_DRIVER_FAILED) then return "DMUS_E_DRIVER_FAILED";
    --elseif (hres == C.DMUS_E_PORTS_OPEN) then return "DMUS_E_PORTS_OPEN";
    --elseif (hres == C.DMUS_E_DEVICE_IN_USE) then return "DMUS_E_DEVICE_IN_USE";
    --elseif (hres == C.DMUS_E_INSUFFICIENTBUFFER) then return "DMUS_E_INSUFFICIENTBUFFER";
    --elseif (hres == C.DMUS_E_BUFFERNOTSET) then return "DMUS_E_BUFFERNOTSET";
    --elseif (hres == C.DMUS_E_BUFFERNOTAVAILABLE) then return "DMUS_E_BUFFERNOTAVAILABLE";
    --elseif (hres == C.DMUS_E_NOTADLSCOL) then return "DMUS_E_NOTADLSCOL";
    --elseif (hres == C.DMUS_E_INVALIDOFFSET) then return "DMUS_E_INVALIDOFFSET";
    --elseif (hres == C.DMUS_E_ALREADY_LOADED) then return "DMUS_E_ALREADY_LOADED";
    --elseif (hres == C.DMUS_E_INVALIDPOS) then return "DMUS_E_INVALIDPOS";
    --elseif (hres == C.DMUS_E_INVALIDPATCH) then return "DMUS_E_INVALIDPATCH";
    --elseif (hres == C.DMUS_E_CANNOTSEEK) then return "DMUS_E_CANNOTSEEK";
    --elseif (hres == C.DMUS_E_CANNOTWRITE) then return "DMUS_E_CANNOTWRITE";
    --elseif (hres == C.DMUS_E_CHUNKNOTFOUND) then return "DMUS_E_CHUNKNOTFOUND";
    --elseif (hres == C.DMUS_E_INVALID_DOWNLOADID) then return "DMUS_E_INVALID_DOWNLOADID";
    --elseif (hres == C.DMUS_E_NOT_DOWNLOADED_TO_PORT) then return "DMUS_E_NOT_DOWNLOADED_TO_PORT";
    --elseif (hres == C.DMUS_E_ALREADY_DOWNLOADED) then return "DMUS_E_ALREADY_DOWNLOADED";
    --elseif (hres == C.DMUS_E_UNKNOWN_PROPERTY) then return "DMUS_E_UNKNOWN_PROPERTY";
    --elseif (hres == C.DMUS_E_SET_UNSUPPORTED) then return "DMUS_E_SET_UNSUPPORTED";
    --elseif (hres == C.DMUS_E_GET_UNSUPPORTED) then return "DMUS_E_GET_UNSUPPORTED";
    --elseif (hres == C.DMUS_E_NOTMONO) then return "DMUS_E_NOTMONO";
    --elseif (hres == C.DMUS_E_BADARTICULATION) then return "DMUS_E_BADARTICULATION";
    --elseif (hres == C.DMUS_E_BADINSTRUMENT) then return "DMUS_E_BADINSTRUMENT";
    --elseif (hres == C.DMUS_E_BADWAVELINK) then return "DMUS_E_BADWAVELINK";
    --elseif (hres == C.DMUS_E_NOARTICULATION) then return "DMUS_E_NOARTICULATION";
    --elseif (hres == C.DMUS_E_NOTPCM) then return "DMUS_E_NOTPCM";
    --elseif (hres == C.DMUS_E_BADWAVE) then return "DMUS_E_BADWAVE";
    --elseif (hres == C.DMUS_E_BADOFFSETTABLE) then return "DMUS_E_BADOFFSETTABLE";
    --elseif (hres == C.DMUS_E_UNKNOWNDOWNLOAD) then return "DMUS_E_UNKNOWNDOWNLOAD";
    --elseif (hres == C.DMUS_E_NOSYNTHSINK) then return "DMUS_E_NOSYNTHSINK";
    --elseif (hres == C.DMUS_E_ALREADYOPEN) then return "DMUS_E_ALREADYOPEN";
    --elseif (hres == C.DMUS_E_ALREADYCLOSED) then return "DMUS_E_ALREADYCLOSED";
    --elseif (hres == C.DMUS_E_SYNTHNOTCONFIGURED) then return "DMUS_E_SYNTHNOTCONFIGURED";
    --elseif (hres == C.DMUS_E_SYNTHACTIVE) then return "DMUS_E_SYNTHACTIVE";
    --elseif (hres == C.DMUS_E_CANNOTREAD) then return "DMUS_E_CANNOTREAD";
    --elseif (hres == C.DMUS_E_DMUSIC_RELEASED) then return "DMUS_E_DMUSIC_RELEASED";
    --elseif (hres == C.DMUS_E_BUFFER_EMPTY) then return "DMUS_E_BUFFER_EMPTY";
    --elseif (hres == C.DMUS_E_BUFFER_FULL) then return "DMUS_E_BUFFER_FULL";
    --elseif (hres == C.DMUS_E_PORT_NOT_CAPTURE) then return "DMUS_E_PORT_NOT_CAPTURE";
    --elseif (hres == C.DMUS_E_PORT_NOT_RENDER) then return "DMUS_E_PORT_NOT_RENDER";
    --elseif (hres == C.DMUS_E_DSOUND_NOT_SET) then return "DMUS_E_DSOUND_NOT_SET";
    --elseif (hres == C.DMUS_E_ALREADY_ACTIVATED) then return "DMUS_E_ALREADY_ACTIVATED";
    --elseif (hres == C.DMUS_E_INVALIDBUFFER) then return "DMUS_E_INVALIDBUFFER";
    --elseif (hres == C.DMUS_E_WAVEFORMATNOTSUPPORTED) then return "DMUS_E_WAVEFORMATNOTSUPPORTED";
    --elseif (hres == C.DMUS_E_SYNTHINACTIVE) then return "DMUS_E_SYNTHINACTIVE";
    --elseif (hres == C.DMUS_E_DSOUND_ALREADY_SET) then return "DMUS_E_DSOUND_ALREADY_SET";
    --elseif (hres == C.DMUS_E_INVALID_EVENT) then return "DMUS_E_INVALID_EVENT";
    --elseif (hres == C.DMUS_E_UNSUPPORTED_STREAM) then return "DMUS_E_UNSUPPORTED_STREAM";
    --elseif (hres == C.DMUS_E_ALREADY_INITED) then return "DMUS_E_ALREADY_INITED";
    --elseif (hres == C.DMUS_E_INVALID_BAND) then return "DMUS_E_INVALID_BAND";
    --elseif (hres == C.DMUS_E_TRACK_HDR_NOT_FIRST_CK) then return "DMUS_E_TRACK_HDR_NOT_FIRST_CK";
    --elseif (hres == C.DMUS_E_TOOL_HDR_NOT_FIRST_CK) then return "DMUS_E_TOOL_HDR_NOT_FIRST_CK";
    --elseif (hres == C.DMUS_E_INVALID_TRACK_HDR) then return "DMUS_E_INVALID_TRACK_HDR";
    --elseif (hres == C.DMUS_E_INVALID_TOOL_HDR) then return "DMUS_E_INVALID_TOOL_HDR";
    --elseif (hres == C.DMUS_E_ALL_TOOLS_FAILED) then return "DMUS_E_ALL_TOOLS_FAILED";
    --elseif (hres == C.DMUS_E_ALL_TRACKS_FAILED) then return "DMUS_E_ALL_TRACKS_FAILED";
    --elseif (hres == C.DMUS_E_NOT_FOUND) then return "DMUS_E_NOT_FOUND";
    --elseif (hres == C.DMUS_E_NOT_INIT) then return "DMUS_E_NOT_INIT";
    --elseif (hres == C.DMUS_E_TYPE_DISABLED) then return "DMUS_E_TYPE_DISABLED";
    --elseif (hres == C.DMUS_E_TYPE_UNSUPPORTED) then return "DMUS_E_TYPE_UNSUPPORTED";
    --elseif (hres == C.DMUS_E_TIME_PAST) then return "DMUS_E_TIME_PAST";
    --elseif (hres == C.DMUS_E_TRACK_NOT_FOUND) then return "DMUS_E_TRACK_NOT_FOUND";
    --elseif (hres == C.DMUS_E_TRACK_NO_CLOCKTIME_SUPPORT) then return "DMUS_E_TRACK_NO_CLOCKTIME_SUPPORT";
    --elseif (hres == C.DMUS_E_NO_MASTER_CLOCK) then return "DMUS_E_NO_MASTER_CLOCK";
    --elseif (hres == C.DMUS_E_LOADER_NOCLASSID) then return "DMUS_E_LOADER_NOCLASSID";
    --elseif (hres == C.DMUS_E_LOADER_BADPATH) then return "DMUS_E_LOADER_BADPATH";
    --elseif (hres == C.DMUS_E_LOADER_FAILEDOPEN) then return "DMUS_E_LOADER_FAILEDOPEN";
    --elseif (hres == C.DMUS_E_LOADER_FORMATNOTSUPPORTED) then return "DMUS_E_LOADER_FORMATNOTSUPPORTED";
    --elseif (hres == C.DMUS_E_LOADER_FAILEDCREATE) then return "DMUS_E_LOADER_FAILEDCREATE";
    --elseif (hres == C.DMUS_E_LOADER_OBJECTNOTFOUND) then return "DMUS_E_LOADER_OBJECTNOTFOUND";
    --elseif (hres == C.DMUS_E_LOADER_NOFILENAME) then return "DMUS_E_LOADER_NOFILENAME";
    --elseif (hres == C.DMUS_E_INVALIDFILE) then return "DMUS_E_INVALIDFILE";
    --elseif (hres == C.DMUS_E_ALREADY_EXISTS) then return "DMUS_E_ALREADY_EXISTS";
    --elseif (hres == C.DMUS_E_OUT_OF_RANGE) then return "DMUS_E_OUT_OF_RANGE";
    --elseif (hres == C.DMUS_E_SEGMENT_INIT_FAILED) then return "DMUS_E_SEGMENT_INIT_FAILED";
    --elseif (hres == C.DMUS_E_ALREADY_SENT) then return "DMUS_E_ALREADY_SENT";
    --elseif (hres == C.DMUS_E_CANNOT_FREE) then return "DMUS_E_CANNOT_FREE";
    --elseif (hres == C.DMUS_E_CANNOT_OPEN_PORT) then return "DMUS_E_CANNOT_OPEN_PORT";
    --elseif (hres == C.DMUS_E_CANNOT_CONVERT) then return "DMUS_E_CANNOT_CONVERT";
    --elseif (hres == C.DMUS_E_DESCEND_CHUNK_FAIL) then return "DMUS_E_DESCEND_CHUNK_FAIL";
    --elseif (hres == C.DMUS_E_NOT_LOADED) then return "DMUS_E_NOT_LOADED";
    --elseif (hres == C.DMUS_E_SCRIPT_LANGUAGE_INCOMPATIBLE) then return "DMUS_E_SCRIPT_LANGUAGE_INCOMPATIBLE";
    --elseif (hres == C.DMUS_E_SCRIPT_UNSUPPORTED_VARTYPE) then return "DMUS_E_SCRIPT_UNSUPPORTED_VARTYPE";
    --elseif (hres == C.DMUS_E_SCRIPT_ERROR_IN_SCRIPT) then return "DMUS_E_SCRIPT_ERROR_IN_SCRIPT";
    --elseif (hres == C.DMUS_E_SCRIPT_CANTLOAD_OLEAUT32) then return "DMUS_E_SCRIPT_CANTLOAD_OLEAUT32";
    --elseif (hres == C.DMUS_E_SCRIPT_LOADSCRIPT_ERROR) then return "DMUS_E_SCRIPT_LOADSCRIPT_ERROR";
    --elseif (hres == C.DMUS_E_SCRIPT_INVALID_FILE) then return "DMUS_E_SCRIPT_INVALID_FILE";
    --elseif (hres == C.DMUS_E_INVALID_SCRIPTTRACK) then return "DMUS_E_INVALID_SCRIPTTRACK";
    --elseif (hres == C.DMUS_E_SCRIPT_VARIABLE_NOT_FOUND) then return "DMUS_E_SCRIPT_VARIABLE_NOT_FOUND";
    --elseif (hres == C.DMUS_E_SCRIPT_ROUTINE_NOT_FOUND) then return "DMUS_E_SCRIPT_ROUTINE_NOT_FOUND";
    --elseif (hres == C.DMUS_E_INVALID_SEGMENTTRIGGERTRACK) then return "DMUS_E_INVALID_SEGMENTTRIGGERTRACK";
    --elseif (hres == C.DMUS_E_INVALID_LYRICSTRACK) then return "DMUS_E_INVALID_LYRICSTRACK";
    --elseif (hres == C.DMUS_E_INVALID_PARAMCONTROLTRACK) then return "DMUS_E_INVALID_PARAMCONTROLTRACK";
    --elseif (hres == C.DMUS_E_AUDIOVBSCRIPT_SYNTAXERROR) then return "DMUS_E_AUDIOVBSCRIPT_SYNTAXERROR";
    --elseif (hres == C.DMUS_E_AUDIOVBSCRIPT_RUNTIMEERROR) then return "DMUS_E_AUDIOVBSCRIPT_RUNTIMEERROR";
    --elseif (hres == C.DMUS_E_AUDIOVBSCRIPT_OPERATIONFAILURE) then return "DMUS_E_AUDIOVBSCRIPT_OPERATIONFAILURE";
    --elseif (hres == C.DMUS_E_AUDIOPATHS_NOT_VALID) then return "DMUS_E_AUDIOPATHS_NOT_VALID";
    --elseif (hres == C.DMUS_E_AUDIOPATHS_IN_USE) then return "DMUS_E_AUDIOPATHS_IN_USE";
    --elseif (hres == C.DMUS_E_NO_AUDIOPATH_CONFIG) then return "DMUS_E_NO_AUDIOPATH_CONFIG";
    --elseif (hres == C.DMUS_E_AUDIOPATH_INACTIVE) then return "DMUS_E_AUDIOPATH_INACTIVE";
    --elseif (hres == C.DMUS_E_AUDIOPATH_NOBUFFER) then return "DMUS_E_AUDIOPATH_NOBUFFER";
    --elseif (hres == C.DMUS_E_AUDIOPATH_NOPORT) then return "DMUS_E_AUDIOPATH_NOPORT";
    --elseif (hres == C.DMUS_E_NO_AUDIOPATH) then return "DMUS_E_NO_AUDIOPATH";
    --elseif (hres == C.DMUS_E_INVALIDCHUNK) then return "DMUS_E_INVALIDCHUNK";
    --elseif (hres == C.DMUS_E_AUDIOPATH_NOGLOBALFXBUFFER) then return "DMUS_E_AUDIOPATH_NOGLOBALFXBUFFER";
    --elseif (hres == C.DMUS_E_INVALID_CONTAINER_OBJECT) then return "DMUS_E_INVALID_CONTAINER_OBJECT";
    else
        return string.format('UNKNOWN_ERROR: %08X', hres);
    end
end

--[[
* Converts the given ARGB values to a Direct3D color code.
*
* @param {number} a - The alpha color code.
* @param {number} r - The red color code.
* @param {number} g - The green color code.
* @param {number} b - The blue color code.
* @return {number} The converted color code.
--]]
local function D3DCOLOR_ARGB(a, r, g, b)
    local c_a = bit.lshift(bit.band(a, 0xFF), 24);
    local c_r = bit.lshift(bit.band(r, 0xFF), 16);
    local c_g = bit.lshift(bit.band(g, 0xFF), 8);
    local c_b = bit.band(b, 0xFF);

    return tonumber('0x' .. bit.tohex(bit.band(bit.bor(c_a, c_r, c_g, c_b), 0xFFFFFFFF)));
end

--[[
* Converts the given RGBA values to a Direct3D color code.
*
* @param {number} r - The red color code.
* @param {number} g - The green color code.
* @param {number} b - The blue color code.
* @param {number} a - The alpha color code.
* @return {number} The converted color code.
--]]
local function D3DCOLOR_RGBA(r, g, b, a)
    return D3DCOLOR_ARGB(a, r, g, b);
end

--[[
* Converts the given XRGB values to a Direct3D color code.
*
* @param {number} r - The red color code.
* @param {number} g - The green color code.
* @param {number} b - The blue color code.
* @return {number} The converted color code.
--]]
local function D3DCOLOR_XRGB(r, g, b)
    return D3DCOLOR_ARGB(0xFF, r, g, b);
end

--[[
* Converts the given float-based color values to a Direct3D color code.
*
* @param {number} r - The red color value.
* @param {number} g - The green color value.
* @param {number} b - The blue color value.
* @return {number} The converted color code.
--]]
local function D3DCOLOR_COLORVALUE(r, g, b, a)
    return D3DCOLOR_RGBA(r * 255.0, g * 255.0, b * 255.0, a * 255.0);
end

--[[
* Converts the given matrix index into a world matrix index.
*
* @param {number} index - The index to convert.
* @return {number} The converted index.
--]]
local function D3DTS_WORLDMATRIX(index)
    return (index + 256);
end

--[[
* Converts the given token type into a valid vertex definition type.
*
* @param {number} tokenType - The token type to convert.
* @return {number} The converted value.
--]]
local function D3DVSD_MAKETOKENTYPE(tokenType)
    return bit.band(bit.lshift(tokenType, C.D3DVSD_TOKENTYPESHIFT), C.D3DVSD_TOKENTYPEMASK);
end

--[[
* Sets the current stream.
*
* @param {number} streamNumber - The stream to use for data.
* @return {number} The converted value.
--]]
local function D3DVSD_STREAM(streamNumber)
    local ret = D3DVSD_MAKETOKENTYPE(C.D3DVSD_TOKEN_STREAM);
    return bit.bor(ret, streamNumber);
end

--[[
* Sets the tessellator stream.
*
* @return {number} The converted value.
--]]
local function D3DVSD_STREAM_TESS()
    local ret = D3DVSD_MAKETOKENTYPE(C.D3DVSD_TOKEN_STREAM);
    return bit.bor(ret, C.D3DVSD_STREAMTESSMASK);
end

--[[
* Binds a single vertex register to a vertex element from the vertex stream.
*
* @param {number} vertexRegister - Address of the vertex register.
* @param {number} type - The dimensionality and arithmetic data type
* @return {number} The converted value.
--]]
local function D3DVSD_REG(vertexRegister, type)
    local ret = D3DVSD_MAKETOKENTYPE(C.D3DVSD_TOKEN_STREAMDATA);
    local tsh = bit.lshift(type, C.D3DVSD_DATATYPESHIFT);
    return bit.bor(ret, tsh, vertexRegister);
end

--[[
* Sets the number of vertices to skip in the vertex.
*
* @param {number} dwordCount - The number of vertices to skip.
* @return {number} The converted value.
--]]
local function D3DVSD_SKIP(dwordCount)
    local ret = D3DVSD_MAKETOKENTYPE(C.D3DVSD_TOKEN_STREAMDATA);
    local csh = bit.lshift(dwordCount, C.D3DVSD_SKIPCOUNTSHIFT);
    return bit.bor(ret, 0x10000000, csh);
end

--[[
* Loads data into the vertex shader constant memory.
*
* @param {number} constantAddress - Address of the constant array to begin filling data.
* @param {number} count - Number of constant vectors to load.
* @return {number} The converted value.
--]]
local function D3DVSD_CONST(constantAddress, count)
    local ret = D3DVSD_MAKETOKENTYPE(C.D3DVSD_TOKEN_CONSTMEM);
    local csh = bit.lshift(count, C.D3DVSD_CONSTCOUNTSHIFT);
    return bit.bor(ret, csh, constantAddress);
end

--[[
* Enables tessellator-generated normals.
*
* @param {number} vertexRegisterIn - Address of the vertex register whose input stream will be used in normal computation.
* @param {number} vertexRegisterOut - Address of the vertex register to output the normal to.
* @return {number} The converted value.
--]]
local function D3DVSD_TESSNORMAL(vertexRegisterIn, vertexRegisterOut)
    local ret = D3DVSD_MAKETOKENTYPE(C.D3DVSD_TOKEN_TESSELLATOR);
    local ish = bit.lshift(vertexRegisterIn, C.D3DVSD_VERTEXREGINSHIFT);
    local osh = bit.bor(bit.lshift(0x02, C.D3DVSD_DATATYPESHIFT), vertexRegisterOut);
    return bit.bor(ret, ish, osh);
end

--[[
* Enables tessellator-generated surface parameters.
*
* @param {number} vertexRegister - Address of the vertex register to output parameters.
* @return {number} The converted value.
--]]
local function D3DVSD_TESSUV(vertexRegister)
    local ret = D3DVSD_MAKETOKENTYPE(C.D3DVSD_TOKEN_TESSELLATOR);
    local vsh = bit.bor(bit.lshift(0x01, C.D3DVSD_DATATYPESHIFT), vertexRegister);
    return bit.bor(ret, 0x10000000, vsh);
end

--[[
* Returns an end token.
*
* @return {number} The vertex definition end token.
--]]
local function D3DVSD_END()
    return 0xFFFFFFFF;
end

--[[
* Returns an NOP token.
*
* @return {number} The vertex definition NOP token.
--]]
local function D3DVSD_NOP()
    return 0x00000000;
end

--[[
* Generates a pixel shader version token.
*
* @param {number} major - The shader major version.
* @param {number} minor - The shader minor version.
* @return {number} The converted value.
--]]
local function D3DPS_VERSION(major, minor)
    return bit.bor(0xFFFF0000, bit.lshift(major, 0x08), minor);
end

--[[
* Generates a vertex shader version token.
*
* @param {number} major - The shader major version.
* @param {number} minor - The shader minor version.
* @return {number} The converted value.
--]]
local function D3DVS_VERSION(major, minor)
    return bit.bor(0xFFFE0000, bit.lshift(major, 0x08), minor);
end

--[[
* Returns the major version from a shader version value.
*
* @param {number} version - The shader version value.
* @return {number} The shaders major version value.
--]]
local function D3DSHADER_VERSION_MAJOR(version)
    return bit.band(bit.rshift(version, 0x08), 0xFF);
end

--[[
* Returns the minor version from a shader version value.
*
* @param {number} version - The shader version value.
* @return {number} The shaders minor version value.
--]]
local function D3DSHADER_VERSION_MINOR(version)
    return bit.band(bit.rshift(version, 0x00), 0xFF);
end

--[[
* Sets the number of bytes to skip for a comment.
*
* @param {number} dwordSize - The size of the comment.
* @return {number} The converted value.
--]]
local function D3DSHADER_COMMENT(dwordSize)
    return bit.bor(bit.band(bit.lshift(dwordSize, C.D3DSI_COMMENTSIZE_SHIFT), C.D3DSI_COMMENTSIZE_MASK), C.D3DSIO_COMMENT);
end

--[[
* Returns a pixel shader END token.
*
* @return {number} The pixel shader END token.
--]]
local function D3DPS_END()
    return 0x0000FFFF;
end

--[[
* Returns a vertex shader END token.
*
* @return {number} The vertex shader END token.
--]]
local function D3DVS_END()
    return 0x0000FFFF;
end

--[[
* Constructs bit patterns that are used to identify texture coordinate formats within a flexible vertex format description.
*
* @param {number} coordIndex - Value that identifies the texture coordinate set at which the texture coordinate size (1-, 2-, 3-, or 4-dimensional) applies.
* @return {number} The converted value.
--]]
local function D3DFVF_TEXCOORDSIZE1(coordIndex)
    return bit.lshift(C.D3DFVF_TEXTUREFORMAT1, (coordIndex * 2 + 16));
end

--[[
* Constructs bit patterns that are used to identify texture coordinate formats within a flexible vertex format description.
*
* @param {number} coordIndex - Value that identifies the texture coordinate set at which the texture coordinate size (1-, 2-, 3-, or 4-dimensional) applies.
* @return {number} The converted value.
--]]
local function D3DFVF_TEXCOORDSIZE2(coordIndex)
    return C.D3DFVF_TEXTUREFORMAT2;
end

--[[
* Constructs bit patterns that are used to identify texture coordinate formats within a flexible vertex format description.
*
* @param {number} coordIndex - Value that identifies the texture coordinate set at which the texture coordinate size (1-, 2-, 3-, or 4-dimensional) applies.
* @return {number} The converted value.
--]]
local function D3DFVF_TEXCOORDSIZE3(coordIndex)
    return bit.lshift(C.D3DFVF_TEXTUREFORMAT3, (coordIndex * 2 + 16));
end

--[[
* Constructs bit patterns that are used to identify texture coordinate formats within a flexible vertex format description.
*
* @param {number} coordIndex - Value that identifies the texture coordinate set at which the texture coordinate size (1-, 2-, 3-, or 4-dimensional) applies.
* @return {number} The converted value.
--]]
local function D3DFVF_TEXCOORDSIZE4(coordIndex)
    return bit.lshift(C.D3DFVF_TEXTUREFORMAT4, (coordIndex * 2 + 16));
end

--[[
* Converts the given params into a format value.
*
* @param {char} ch0 - Value to use to generate the result.
* @param {char} ch1 - Value to use to generate the result.
* @param {char} ch2 - Value to use to generate the result.
* @param {char} ch3 - Value to use to generate the result.
* @return {number} The converted value.
*
* @note
*
* Formats generally follow the following format guidelines:
*
*   A = Alpha
*   R = Red
*   G = Green
*   B = Blue
*   X = Unused Bits
*   P = Palette
*   L = Luminance
*   U = dU coordinate for BumpMap
*   V = dV coordinate for BumpMap
*   S = Stencil
*   D = Depth (e.g. Z or W buffer)
--]]
local function MAKEFOURCC(ch0, ch1, ch2, ch3)
    return bit.bor(string.byte(ch0), bit.lshift(string.byte(ch1), 0x08), bit.lshift(string.byte(ch2), 0x10), bit.lshift(string.byte(ch3), 0x18));
end

-- Return a table containing the above helpers..
return {
    -- Device Related
    get_device              = get_device,

    -- Helpers
    gc_safe_release         = gc_safe_release,
    iid_from_str            = iid_from_str,
    get_error               = get_error,

    -- D3DCOLOR Helpers
    D3DCOLOR_ARGB           = D3DCOLOR_ARGB,
    D3DCOLOR_RGBA           = D3DCOLOR_RGBA,
    D3DCOLOR_XRGB           = D3DCOLOR_XRGB,
    D3DCOLOR_COLORVALUE     = D3DCOLOR_COLORVALUE,

    -- D3DMATRIX Helpers
    D3DTS_WORLDMATRIX       = D3DTS_WORLDMATRIX,

    -- Direct3D Vertex Shader Declaration Helpers
    D3DVSD_MAKETOKENTYPE    = D3DVSD_MAKETOKENTYPE,
    D3DVSD_STREAM           = D3DVSD_STREAM,
    D3DVSD_STREAM_TESS      = D3DVSD_STREAM_TESS,
    D3DVSD_REG              = D3DVSD_REG,
    D3DVSD_SKIP             = D3DVSD_SKIP,
    D3DVSD_CONST            = D3DVSD_CONST,
    D3DVSD_TESSNORMAL       = D3DVSD_TESSNORMAL,
    D3DVSD_TESSUV           = D3DVSD_TESSUV,
    D3DVSD_END              = D3DVSD_END,
    D3DVSD_NOP              = D3DVSD_NOP,

    -- Direct3D Shader Helpers
    D3DPS_VERSION           = D3DPS_VERSION,
    D3DVS_VERSION           = D3DVS_VERSION,
    D3DSHADER_VERSION_MAJOR = D3DSHADER_VERSION_MAJOR,
    D3DSHADER_VERSION_MINOR = D3DSHADER_VERSION_MINOR,
    D3DSHADER_COMMENT       = D3DSHADER_COMMENT,
    D3DPS_END               = D3DPS_END,
    D3DVS_END               = D3DVS_END,

    -- Direct3D FVF Helpers
    D3DFVF_TEXCOORDSIZE1    = D3DFVF_TEXCOORDSIZE1,
    D3DFVF_TEXCOORDSIZE2    = D3DFVF_TEXCOORDSIZE2,
    D3DFVF_TEXCOORDSIZE3    = D3DFVF_TEXCOORDSIZE3,
    D3DFVF_TEXCOORDSIZE4    = D3DFVF_TEXCOORDSIZE4,

    -- Direct3D Format Helpers
    MAKEFOURCC              = MAKEFOURCC,
};