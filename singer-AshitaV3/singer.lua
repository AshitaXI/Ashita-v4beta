--[[
    Singer (Ashita v3 ONLY) - No HUD

    - نسخة مخصصة لـ Ashita v3 فقط.
    - لا تحتوي أي كود توافق v4.
    - الشروحات داخل الكود بالعربي فقط.
    - رسائل الشات (echo) بالإنجليزي فقط.
--]]

----------------------------------------------------------------------------------------------------
-- Addon info (Ashita v3 style)
----------------------------------------------------------------------------------------------------
_addon = _addon or {}
_addon.name     = 'singer'
_addon.author   = 'Aragan'
_addon.version  = '1.0-v3'
_addon.desc     = 'Singer (No HUD) for Ashita v3 ONLY'

pcall(require, 'common')

----------------------------------------------------------------------------------------------------
-- مسار الإضافة (مهم في Ashita v3 لأن require() قد لا يبحث داخل مجلد الإضافة)
----------------------------------------------------------------------------------------------------
local SCRIPT_DIR = ''
do
    local info = debug.getinfo(1, 'S')
    local src = (info and info.source) or ''
    src = src:gsub('^@', '')
    SCRIPT_DIR = src:match('^(.+[\\/])') or ''
end

-- نضيف مجلد الإضافة إلى package.path عشان require('settings') يشتغل
if SCRIPT_DIR ~= '' and type(package) == 'table' and type(package.path) == 'string' then
    package.path = package.path .. ';' .. SCRIPT_DIR .. '?.lua;' .. SCRIPT_DIR .. '?\\init.lua;' .. SCRIPT_DIR .. '?/init.lua'
end


----------------------------------------------------------------------------------------------------
-- State
----------------------------------------------------------------------------------------------------
local state = {
    enabled     = false,
    repeat_cycle = true,

    busy        = false,
    busy_until  = 0.0,

    pending     = nil,
    pending_i   = 0,
    next_action = 0.0,

    song_delay  = 8.5,
    interval    = 80.0,
    next_cycle  = 0.0,

    songs       = {
        "Mage's Ballad III",
        "Victory March",
        "Blade Madrigal",
    },

    target      = '<me>',

    nitro       = false,
    ccsv        = false,

    pad         = 2.5,

    settings    = nil,
    playlist    = nil,

    _last_tick_ms = -1,
    _queue_sig = nil, -- 'cmd_delay' | 'delay_cmd' | 'cmd_only'
}

----------------------------------------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------------------------------------
local function now_clock()
    return os.clock()
end

local function tokenize_command(cmd)
    local out = {}
    local i, n = 1, #cmd
    local inq = false
    local cur = {}

    while i <= n do
        local c = cmd:sub(i, i)
        if c == '"' then
            inq = not inq
        elseif (not inq) and (c == ' ' or c == '\t') then
            if #cur > 0 then
                out[#out+1] = table.concat(cur)
                cur = {}
            end
        else
            cur[#cur+1] = c
        end
        i = i + 1
    end

    if #cur > 0 then
        out[#out+1] = table.concat(cur)
    end

    return out
end

local function norm_prefix(tok)
    tok = tok or ''
    tok = tok:gsub('^//', '/')
    return tok:lower()
end

----------------------------------------------------------------------------------------------------
-- QueueCommand (Ashita v3) + تثبيت التوقيع لمنع مشاكل التعليق
----------------------------------------------------------------------------------------------------
local function queue_command_raw(cm, cmd, delay)
    local d = tonumber(delay) or 0
    if d < -1 then d = -1 end

    if state._queue_sig == 'cmd_delay' then
        return pcall(function() cm:QueueCommand(cmd, d) end)
    elseif state._queue_sig == 'delay_cmd' then
        return pcall(function() cm:QueueCommand(d, cmd) end)
    elseif state._queue_sig == 'cmd_only' then
        return pcall(function() cm:QueueCommand(cmd) end)
    end

    local ok = pcall(function() cm:QueueCommand(cmd, d) end)
    if ok then state._queue_sig = 'cmd_delay'; return true end

    ok = pcall(function() cm:QueueCommand(d, cmd) end)
    if ok then state._queue_sig = 'delay_cmd'; return true end

    ok = pcall(function() cm:QueueCommand(cmd) end)
    if ok then state._queue_sig = 'cmd_only'; return true end

    return false
end

local function queue_command(cmd, delay)
    if type(cmd) ~= 'string' or cmd == '' then return false end
    if not AshitaCore or not AshitaCore.GetChatManager then return false end

    local cm = AshitaCore:GetChatManager()
    if not cm then return false end

    return queue_command_raw(cm, cmd, delay)
end

local function echo(msg)
    -- نحاول الطباعة المباشرة للشات (أكثر أمانًا من /echo في v3)
    local prefix = '[Singer] '
    local cm = (AshitaCore and AshitaCore.GetChatManager) and AshitaCore:GetChatManager() or nil
    if cm and cm.AddChatMessage then
        -- نجرب أكثر من توقيع (color,msg) ثم (msg)
        local ok = pcall(function() cm:AddChatMessage(200, prefix .. msg) end)
        if ok then return end
        ok = pcall(function() cm:AddChatMessage(prefix .. msg) end)
        if ok then return end
    end

    -- fallback: /echo مرة واحدة فقط
    local ok = queue_command(('/echo %s%s'):format(prefix, msg), 0)
    if not ok then
        print(prefix .. msg)
    end
end

----------------------------------------------------------------------------------------------------
-- settings.lua (playlists)
----------------------------------------------------------------------------------------------------
if type(_G.L) ~= 'function' then _G.L = function(t) return t end end
if type(_G.T) ~= 'function' then _G.T = function(t) return t end end

local function load_settings()
    package.loaded['settings'] = nil

    -- 1) require (بعد تعديل package.path فوق)
    local ok, cfg = pcall(require, 'settings')
    if ok and type(cfg) == 'table' then
        state.settings = cfg
        return true
    end

    -- 2) fallback: dofile من نفس مجلد الإضافة (أقوى في v3)
    if SCRIPT_DIR ~= '' then
        ok, cfg = pcall(dofile, SCRIPT_DIR .. 'settings.lua')
        if ok and type(cfg) == 'table' then
            state.settings = cfg
            return true
        end
    end

    state.settings = nil
    return false
end

local function list_playlists()
    local cfg = state.settings
    if not cfg or type(cfg.playlist) ~= 'table' then
        echo('No playlists found. Put settings.lua next to singer.lua.')
        return
    end

    -- نبني قائمة الأسماء مرة واحدة ونخزنها (لتقليل الحمل ومنع تعليق v3)
    if not state._pl_names_cache then
        local names = {}
        for k, _ in pairs(cfg.playlist) do
            if type(k) == 'string' then
                names[#names + 1] = k
            end
        end
        table.sort(names)
        state._pl_names_cache = names
        state._pl_pos = 1
    end

    local names = state._pl_names_cache
    if not names or #names == 0 then
        echo('No playlists in settings.lua (playlist table is empty).')
        return
    end

    local per_call = 10  -- نعرض 10 أسماء فقط في كل مرة
    local i = state._pl_pos or 1
    if i > #names then
        i = 1
    end

    local j = math.min(i + per_call - 1, #names)
    local slice = {}
    for k = i, j do
        slice[#slice + 1] = names[k]
    end

    echo(('Playlists %d-%d of %d: %s'):format(i, j, #names, table.concat(slice, ', ')))

    if j >= #names then
        state._pl_pos = #names + 1
        echo('Use /singer playlists again to restart from the beginning.')
    else
        state._pl_pos = j + 1
        echo('Use /singer playlists again for next list.')
    end
end

local function set_playlist(name)
    local cfg = state.settings
    if not cfg or type(cfg.playlist) ~= 'table' then
        echo('settings.lua not loaded.')
        return false
    end

    local pl = cfg.playlist[name]
    if type(pl) ~= 'table' then
        echo('Playlist not found: ' .. tostring(name))
        return false
    end

    local songs = {}
    for i = 1, #pl do
        if type(pl[i]) == 'string' and pl[i] ~= '' then
            songs[#songs + 1] = pl[i]
        end
    end

    state.songs = songs
    state.playlist = name

    echo('Playlist set: ' .. name)
    if #songs > 0 then
        local max_show = 6
        local show = {}
        for i = 1, math.min(#state.songs, max_show) do
            show[#show + 1] = state.songs[i]
        end
        local extra = (#state.songs > max_show) and (' (+%d more)'):format(#state.songs - max_show) or ''
        echo('Songs: ' .. table.concat(show, ' | ') .. extra)
    else
        echo('Songs: (empty)')
    end
    return true
end

----------------------------------------------------------------------------------------------------
-- Casting logic
----------------------------------------------------------------------------------------------------
local MAX_ACTIONS_PER_CYCLE = 32

local function begin_busy(total_delay)
    state.busy = true
    state.busy_until = now_clock() + (tonumber(total_delay) or 0) + 0.25
end

local function start_pending(steps)
    if state.pending ~= nil then return false end
    if type(steps) ~= 'table' or #steps == 0 then return false end

    state.pending = steps
    state.pending_i = 1
    state.next_action = now_clock() + 0.10

    local total = 0.0
    for _, s in ipairs(steps) do
        total = total + (tonumber(s.wait) or 0)
    end
    begin_busy(total)
    return true
end

local function build_steps_for_song_list(list)
    local steps = {}
    local actions = 0

    if state.nitro then
        steps[#steps+1] = { cmd = '/ja \"Nightingale\" <me>', wait = 1.6 }
        steps[#steps+1] = { cmd = '/ja \"Troubadour\" <me>',  wait = 1.6 }
        actions = actions + 2
    end

    if state.ccsv then
        steps[#steps+1] = { cmd = '/ja \"Clarion Call\" <me>', wait = 1.6 }
        steps[#steps+1] = { cmd = '/ja \"Soul Voice\" <me>',   wait = 2.0 }
        actions = actions + 2
    end

    for _, song in ipairs(list) do
        if actions >= MAX_ACTIONS_PER_CYCLE then break end
        steps[#steps+1] = {
            cmd  = ('/ma "%s" %s'):format(song, state.target),
            wait = (state.song_delay + (state.pad or 0)),
        }
        actions = actions + 1
    end

    return steps
end

local function cast_song_list(list)
    if state.pending ~= nil then return false end
    if state.busy then return false end
    if type(list) ~= 'table' then return false end

    local steps = build_steps_for_song_list(list)
    if #steps == 0 then return false end
    return start_pending(steps)
end

local function cast_cycle()
    return cast_song_list(state.songs)
end

local function cast_marcato(song)
    if state.pending ~= nil then return end
    if state.busy then return end
    if type(song) ~= 'string' or song == '' then
        echo('Usage: /singer marcato "Song"')
        return
    end

    local steps = {
        { cmd = '/ja "Marcato" <me>', wait = 2.2 },
        { cmd = ('/ma "%s" %s'):format(song, state.target), wait = (state.song_delay + (state.pad or 0)) },
    }

    start_pending(steps)
    echo(('Marcato: %s'):format(song))
end

----------------------------------------------------------------------------------------------------
-- Status / Help
----------------------------------------------------------------------------------------------------
local function show_status()
    echo(('Status: %s | Repeat: %s | Delay: %.1fs (+%.1f) | Interval: %.0fs | Target: %s | Nitro: %s | CCSV: %s | Playlist: %s'):format(
        state.enabled and 'ON' or 'OFF',
        state.repeat_cycle and 'ON' or 'OFF',
        state.song_delay,
        (state.pad or 0),
        state.interval,
        state.target,
        state.nitro and 'ON' or 'OFF',
        state.ccsv and 'ON' or 'OFF',
        state.playlist or 'custom'
    ))

    if #state.songs > 0 then
        echo(('Songs: %s'):format(table.concat(state.songs, ' | ')))
    else
        echo('Songs: (empty)')
    end
end

local function show_help()
    echo('Commands:')
    echo('/singer on | off | toggle | status')
    echo('/singer now')
    echo('/singer marcato "Song"')
    echo('/singer songs "Song1" "Song2" ...')
    echo('/singer playlists')
    echo('/singer playlist <name>')
    echo('/singer delay <sec>   (min 0.5)')
    echo('/singer interval <sec> (min 30)')
    echo('/singer target <tgt>  (ex: <me> or <t>)')
    echo('/singer nitro on|off|toggle')
    echo('/singer ccsv  on|off|toggle')
    echo('/singer repeat on|off|toggle')
end

----------------------------------------------------------------------------------------------------
-- Tick
----------------------------------------------------------------------------------------------------
local function tick()
    local t = now_clock()
    local ms = math.floor(t * 1000)
    if ms == state._last_tick_ms then return end
    state._last_tick_ms = ms

    if state.pending ~= nil then
        local step = state.pending[state.pending_i]
        if step and t >= (state.next_action or 0.0) then
            queue_command(step.cmd, 0)
            local wait = tonumber(step.wait) or 0
            state.pending_i = state.pending_i + 1

            if state.pending_i > #state.pending then
                state.pending = nil
                state.pending_i = 0
                state.busy = false
                state.busy_until = 0.0
            else
                state.next_action = t + wait
            end
        end
        return
    end

    if state.busy and t >= (state.busy_until or 0.0) then
        state.busy = false
    end

    if not state.enabled then return end
    if state.busy then return end
    if t >= (state.next_cycle or 0.0) then
        cast_cycle()
        if state.repeat_cycle then
        state.next_cycle = t + (state.interval or 240.0)
    else
        -- Repeat is OFF: run only once (still allow /singer now manually)
        state.next_cycle = t + 9999999.0
    end
    end
end

----------------------------------------------------------------------------------------------------
-- Command handler (Ashita v3)
----------------------------------------------------------------------------------------------------
local function handle_command(cmd, nType)
    if type(cmd) ~= 'string' or cmd == '' then return false end

    local parts = tokenize_command(cmd)
    if #parts == 0 then return false end

    local p0 = norm_prefix(parts[1])
    if p0 ~= '/singer' and p0 ~= '/sing' then
        return false
    end

    local sub = (parts[2] or ''):lower()

    if sub == '' or sub == 'status' then
        show_status(); return true
    end
    if sub == 'help' then
        show_help(); return true
    end

    if sub == 'on' then
        state.enabled = true
        state.busy = false
        state.next_cycle = now_clock() + 0.5
        echo('Enabled.')
        return true
    elseif sub == 'off' then
        state.enabled = false
        state.busy = false
        echo('Disabled.')
        return true
    elseif sub == 'toggle' then
        state.enabled = not state.enabled
        state.busy = false
        if state.enabled then state.next_cycle = now_clock() + 0.5 end
        echo(('Toggled: %s'):format(state.enabled and 'ON' or 'OFF'))
        return true
    elseif sub == 'now' then
        local ok = cast_cycle()
        echo(ok and 'Casting.' or 'Busy.')
        return true
    elseif sub == 'marcato' then
        local song = parts[3]
        if not song or song == '' then
            echo('Usage: /singer marcato "Song"')
            return true
        end
        cast_marcato(song)
        return true
    elseif sub == 'songs' then
        local new = {}
        for i = 3, #parts do
            if parts[i] and #parts[i] > 0 then new[#new+1] = parts[i] end
        end
        state.songs = new
        echo('Songs updated.')
        show_status()
        return true
    elseif sub == 'playlists' then
        if not state.settings then load_settings() end
        list_playlists()
        return true
    elseif sub == 'playlist' then
        local name = parts[3]
        if not name or name == '' then
            echo('Usage: /singer playlist <name>')
            return true
        end
        if not state.settings then load_settings() end
        set_playlist(name)
        return true
    elseif sub == 'delay' then
        local v = tonumber(parts[3] or '')
        if not v or v < 0.5 then
            echo('Invalid delay. Minimum 0.5')
            return true
        end
        state.song_delay = v
        echo(('Delay set to %.1f'):format(state.song_delay))
        return true
    elseif sub == 'interval' then
        local v = tonumber(parts[3] or '')
        if not v or v < 30 then
            echo('Invalid interval. Minimum 30')
            return true
        end
        state.interval = v
        echo(('Interval set to %.0f'):format(state.interval))
        return true
    elseif sub == 'target' then
        local tgt = parts[3]
        if not tgt or #tgt == 0 then
            echo('Invalid target.')
            return true
        end
        state.target = tgt
        echo(('Target set to %s'):format(state.target))
        return true
    elseif sub == 'nitro' then
        local v = (parts[3] or ''):lower()
        if v == '' or v == 'toggle' then state.nitro = not state.nitro
        elseif v == 'on' then state.nitro = true
        elseif v == 'off' then state.nitro = false
        else
            echo('Usage: /singer nitro on|off|toggle')
            return true
        end
        echo(('Nitro: %s'):format(state.nitro and 'ON' or 'OFF'))
        return true
    elseif sub == 'ccsv' then
        local v = (parts[3] or ''):lower()
        if v == '' or v == 'toggle' then state.ccsv = not state.ccsv
        elseif v == 'on' then state.ccsv = true
        elseif v == 'off' then state.ccsv = false
        else
            echo('Usage: /singer ccsv on|off|toggle')
            return true
        end
        echo(('CCSV: %s'):format(state.ccsv and 'ON' or 'OFF'))
        return true
    end

    if sub == 'repeat' then
        local v = (parts[3] or ''):lower()
        if v == '' or v == 'toggle' then state.repeat_cycle = not state.repeat_cycle
        elseif v == 'on' then state.repeat_cycle = true
        elseif v == 'off' then state.repeat_cycle = false
        else
            echo('Usage: /singer repeat on|off|toggle')
            return true
        end

        if state.repeat_cycle then
            state.next_cycle = now_clock() + 0.5
        end
        echo(('Repeat: %s'):format(state.repeat_cycle and 'ON' or 'OFF'))
        return true
    end

    echo('Unknown command. Use /singer help')
    return true
end

----------------------------------------------------------------------------------------------------
-- Events (Ashita v3 only)
----------------------------------------------------------------------------------------------------
if ashita and ashita.register_event then
    ashita.register_event('load', function()
        state.next_cycle = now_clock() + 2.0
        echo('Loaded (Ashita v3 ONLY, NO HUD). Use /singer help')

        if load_settings() then
            echo('settings.lua loaded. Use /singer playlists and /singer playlist <name>.')
        else
            echo('settings.lua not loaded (optional).')
        end
    end)

    ashita.register_event('unload', function()
        echo('Unloaded.')
    end)

    ashita.register_event('command', function(cmd, nType)
        local handled = handle_command(cmd, nType)
        return handled
    end)

    -- Tick
    pcall(function() ashita.register_event('d3d_present', function() tick() end) end)
    pcall(function() ashita.register_event('render',      function() tick() end) end)
    pcall(function() ashita.register_event('prerender',   function() tick() end) end)
end

return nil
