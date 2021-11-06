# ChatMon

Plays sounds as a reaction to certain events in chat. (And some other helpful events.)

## Commands

ChatMon exposes the following commands:

  * **/chatmon** - _Toggles the ChatMon settings editor window._

## Sound File Credits

The sound files included are generated using the following services:

  - https://ttsmp3.com/ - _Text to speech engine._
  - https://www.freeconvert.com/mp3-to-wav/ - _.mp3 to .wav converter._

The files are generated using the `US English / Salli` voice, with the text speed set to `fast`. 

Fast text peed is made using the following text format:

```html
<prosody rate="fast">incoming tell</prosody>
```

## Rulesets

ChatMon for Ashita v4 uses a new 'ruleset' file format to allow adding additional rules/triggers easily. The ruleset files should be placed inside of the `/rules/` folder.

Your ruleset file should return a table containing the following:

```lua
local ruleset = T{
    name = '(string)', -- The name of your ruleset.
    desc = '(string)', -- The description of your ruleset.
    event = '(string)', -- The Ashita addon event name your ruleset needs to work properly. (ie. packet_in)

    settings = T{
        -- Any settings your ruleset would save per-character should be here..
    },

    -- Any additional local variables to your ruleset here..
};

-- The event callback your ruleset requested to use via the 'ruleset.event' field.
ruleset.callback = function (e)
end

-- The callback used when the ChatMon editor is rendering the configuration editor for this ruleset.
ruleset.ui = function ()
    --[[
        This is optional and not required. If you do not wish to offer configurable settings for your ruleset
        or do not wish to render any editor, just delete this function from your ruleset.

        You should not call any Begin/End calls that would create a new window, group, child, etc. here as this
        callback is invoked from inside a child already.
    --]]
end

return ruleset;
```
