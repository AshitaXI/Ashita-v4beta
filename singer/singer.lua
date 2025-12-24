
addon.name     = 'singer'
addon.author   = 'Aragan'
addon.version  = '1.0 , transformers coming'
addon.desc     = 'Singer (No HUD) for Ashita v4'
addon.link     = 'https://github.com/aragan/Ashita-addons/tree/main/singer'

require('common')

--[[
    Singer (Ashita v4) - No HUD (SAFE)
    Author: Aragan

    Goal:
      - Rotate BRD songs on Ashita v4.
      - No HUD, no ImGui, and no Windower libraries.

    Safety:
      - Use the correct QueueCommand signature in Ashita v4: (command, delay)
      - Delays + a max commands-per-cycle limit to avoid command spam.

    Supported commands:
      /singer on|off|toggle|status
      /singer now
      /singer songs "Song1" "Song2" ...
      /singer delay <sec>
      /singer interval <sec>
      /singer target <tgt>
      /singer nitro on|off|toggle
      /singer ccsv  on|off|toggle
      /singer marcato "Song"

    Also accepts /sing as a shortcut.
--]]
------------------------------------------------------------
-- State
------------------------------------------------------------
local state = {
    enabled     = false,
    busy        = false,
    busy_until  = 0.0,

    -- Internal step queue (to avoid QueueCommand limitations in some Ashita setups)
    pending     = nil,
    pending_i   = 0,
    next_action = 0.0,

    song_delay  = 8.5,
    interval    = 240.0,
    next_cycle  = 0.0,

    songs       = {
        "Mage's Ballad III",
        "Victory March",
        "Blade Madrigal",
    },

    target      = '<me>',

    nitro       = false,
    ccsv        = false,

    -- Extra time after each song to avoid /ma failing due to being busy (Aftercast pad)
    pad         = 2.5,

    -- Song playlists from settings.lua (optional)
    settings    = nil,
    playlist    = nil,
}


local echo

------------------------------------------------------------
-- settings.lua support (song playlists) - no HUD
------------------------------------------------------------
-- The legacy settings.lua style uses L{} and T{}.
-- Here we define them as simple functions so the file works without Windower libraries.
if type(_G.L) ~= 'function' then
    _G.L = function(t) return t end
end
if type(_G.T) ~= 'function' then
    _G.T = function(t) return t end
end

local function load_settings()
    -- Reads addons/singer/settings.lua if it exists
    package.loaded['settings'] = nil
    local ok, cfg = pcall(require, 'settings')
    if ok and type(cfg) == 'table' then
        state.settings = cfg
        return true
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

    local names = {}
    for k, _ in pairs(cfg.playlist) do
        if type(k) == 'string' then
            names[#names + 1] = k
        end
    end
    table.sort(names)

    if #names == 0 then
        echo('No playlists in settings.lua (playlist table is empty).')
        return
    end

    echo('Playlists: ' .. table.concat(names, ', '))
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

    if #songs == 0 then
        echo('Playlist is empty: ' .. tostring(name))
        return false
    end

    state.songs = songs
    state.playlist = name
    echo('Playlist set: ' .. name)
    echo('Songs: ' .. table.concat(state.songs, ' | '))
    return true
end

------------------------------------------------------------
-- Utilities
------------------------------------------------------------
local function now_clock()
    return os.clock()
end

-- Ashita v4: QueueCommand(command, delay)
-- IMPORTANT: argument order is (command_string, delay_seconds).
local function queue_command(cmd, delay)
    if type(cmd) ~= 'string' or cmd == '' then
        return false
    end

    local cm = AshitaCore and AshitaCore:GetChatManager() or nil
    if not cm then
        return false
    end

    local d = tonumber(delay) or 0
    -- Many Ashita addons use -1 to mean "execute immediately".
    if d < -1 then d = -1 end

    -- Ashita v4 Lua bindings seen in the wild use both:
    --   QueueCommand(command, delay)
    --   QueueCommand(delay, command)
    -- To avoid "does nothing" on one setup (or "spam / freeze" on another),
    -- we try both signatures safely.
    local ok = pcall(function()
        cm:QueueCommand(cmd, d)
    end)

    if not ok then
        ok = pcall(function()
            cm:QueueCommand(d, cmd)
        end)
    end

    return ok
end

echo = function(msg)
    -- Chat messages are English-only per your preference
    local ok = queue_command(('/echo [Singer] %s'):format(msg), 0)
    if not ok then
        -- fallback: at least show it somewhere if QueueCommand is unavailable / wrong.
        print(('[Singer] %s'):format(msg))
    end
end

-- Tokenize commands with support for quotes ""
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

------------------------------------------------------------
-- Singing logic (no buff checking to avoid API differences)
------------------------------------------------------------
local MAX_ACTIONS_PER_CYCLE = 32

local function begin_busy(total_delay)
    state.busy = true
    state.busy_until = now_clock() + (tonumber(total_delay) or 0) + 0.25
end

local function start_pending(steps)
    if state.pending ~= nil then
        return false
    end
    if type(steps) ~= 'table' or #steps == 0 then
        return false
    end

    state.pending = steps
    state.pending_i = 1
    state.next_action = now_clock() + 0.10

    -- Keep busy enabled while steps are still executing
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
        steps[#steps+1] = { cmd = '/ja "Nightingale" <me>', wait = 1.0 }
        steps[#steps+1] = { cmd = '/ja "Troubadour" <me>',  wait = 1.0 }
        actions = actions + 2
    end

    if state.ccsv then
        steps[#steps+1] = { cmd = '/ja "Clarion Call"', wait = 1.0 }
        steps[#steps+1] = { cmd = '/ja "Soul Voice"',   wait = 1.0 }
        actions = actions + 2
    end

    for _, song in ipairs(list) do
        if actions >= MAX_ACTIONS_PER_CYCLE then
            break
        end
        steps[#steps+1] = { cmd = ('/ma "%s" %s'):format(song, state.target), wait = (state.song_delay + (state.pad or 0)) }
        actions = actions + 1
    end

    return steps
end

local function cast_song_list(list)
    if state.pending ~= nil then return false end
    if state.busy then return false end

    if type(list) ~= 'table' or #list == 0 then
        return false
    end

    local steps = build_steps_for_song_list(list)
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
        { cmd = '/ja "Marcato" <me>', wait = 1.0 },
        { cmd = ('/ma "%s" %s'):format(song, state.target), wait = (state.song_delay + (state.pad or 0)) },
    }

    start_pending(steps)
    echo(('Marcato: %s'):format(song))
end


------------------------------------------------------------
-- Status and help
------------------------------------------------------------
local function show_status()
    echo(('Status: %s | Delay: %.1fs (+%.1f) | Interval: %.0fs | Target: %s | Nitro: %s | CCSV: %s | Playlist: %s'):format(
        state.enabled and 'ON' or 'OFF',
        state.song_delay,
        (state.pad or 0),
        state.interval,
        state.target,
        state.nitro and 'ON' or 'OFF',
        state.ccsv and 'ON' or 'OFF',
        state.playlist or 'custom'
    ))
    echo(('Songs: %s'):format(table.concat(state.songs, ' | ')))
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
end

------------------------------------------------------------
-- Events
------------------------------------------------------------
ashita.events.register('load', 'singer_load_cb', function()
    state.next_cycle = now_clock() + 2.0
    echo('Loaded (Ashita v4, NO HUD). Use /singer help')

    if load_settings() then
        echo('settings.lua loaded. Use /singer playlists and /singer playlist <name>.')
    end
end)

ashita.events.register('unload', 'singer_unload_cb', function()
    echo('Unloaded.')
end)

ashita.events.register('d3d_present', 'singer_present_cb', function()
    local t = now_clock()

    -- Execute one step at a time (without relying on QueueCommand to batch multiple commands)
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

    if not state.enabled then
        return
    end

    if state.busy then
        return
    end

    if t >= (state.next_cycle or 0.0) then
        cast_cycle()
        state.next_cycle = t + (state.interval or 240.0)
    end
end)


ashita.events.register('command', 'singer_command_cb', function(e)
    local cmd = e.command or ''
    if cmd == '' then return end

    local parts = tokenize_command(cmd)
    if #parts == 0 then return end

    local p0 = norm_prefix(parts[1])
    if p0 ~= '/singer' and p0 ~= '/sing' then
        return
    end

    e.blocked = true

    local sub = (parts[2] or ''):lower()

    if sub == '' or sub == 'status' then
        show_status()
        return
    end

    if sub == 'help' then
        show_help()
        return
    end

    if sub == 'on' then
        state.enabled = true
        state.busy = false
        state.next_cycle = now_clock() + 0.5
        echo('Enabled.')
        return
    elseif sub == 'off' then
        state.enabled = false
        state.busy = false
        echo('Disabled.')
        return
    elseif sub == 'toggle' then
        state.enabled = not state.enabled
        state.busy = false
        if state.enabled then
            state.next_cycle = now_clock() + 0.5
        end
        echo(('Toggled: %s'):format(state.enabled and 'ON' or 'OFF'))
        return
    elseif sub == 'now' then
        local ok = cast_cycle()
        if ok then
            echo('Casting.')
        else
            echo('Busy.')
        end
        return
    elseif sub == 'marcato' then
        local song = parts[3]
        if not song or song == '' then
            echo('Usage: /singer marcato "Song"')
            return
        end
        cast_marcato(song)
        return
    elseif sub == 'songs' then
        local new = {}
        for i = 3, #parts do
            if parts[i] and #parts[i] > 0 then
                new[#new+1] = parts[i]
            end
        end
        if #new == 0 then
            echo('No songs given.')
            return
        end
        state.songs = new
        echo('Songs updated.')
        show_status()
        return
    
elseif sub == 'playlists' then
    if not state.settings then
        load_settings()
    end
    list_playlists()
    return
elseif sub == 'playlist' then
    local name = parts[3]
    if not name or name == '' then
        echo('Usage: /singer playlist <name>')
        return
    end
    if not state.settings then
        load_settings()
    end
    set_playlist(name)
    return
elseif sub == 'delay' then
        local v = tonumber(parts[3] or '')
        if not v or v < 0.5 then
            echo('Invalid delay. Minimum 0.5')
            return
        end
        state.song_delay = v
        echo(('Delay set to %.1f'):format(state.song_delay))
        return
    elseif sub == 'interval' then
        local v = tonumber(parts[3] or '')
        if not v or v < 30 then
            echo('Invalid interval. Minimum 30')
            return
        end
        state.interval = v
        echo(('Interval set to %.0f'):format(state.interval))
        return
    elseif sub == 'target' then
        local t = parts[3]
        if not t or #t == 0 then
            echo('Invalid target.')
            return
        end
        state.target = t
        echo(('Target set to %s'):format(state.target))
        return
    elseif sub == 'nitro' then
        local v = (parts[3] or ''):lower()
        if v == '' or v == 'toggle' then
            state.nitro = not state.nitro
        elseif v == 'on' then
            state.nitro = true
        elseif v == 'off' then
            state.nitro = false
        else
            echo('Usage: /singer nitro on|off|toggle')
            return
        end
        echo(('Nitro: %s'):format(state.nitro and 'ON' or 'OFF'))
        return
    elseif sub == 'ccsv' then
        local v = (parts[3] or ''):lower()
        if v == '' or v == 'toggle' then
            state.ccsv = not state.ccsv
        elseif v == 'on' then
            state.ccsv = true
        elseif v == 'off' then
            state.ccsv = false
        else
            echo('Usage: /singer ccsv on|off|toggle')
            return
        end
        echo(('CCSV: %s'):format(state.ccsv and 'ON' or 'OFF'))
        return
    else
        echo('Unknown command. Use /singer help')
        return
    end
end)