# Pouches

An Ashita 4 addon that automatically uses pouches and similar self-targetable items repeatedly.

## Overview

Pouches is a simple yet useful addon that automates the consumption of usable items that can target yourself. Instead of manually clicking items over and over, you can use a single command to automatically consume all instances of an item in your inventory with proper timing delays.

## Features

- **Automatic Item Usage**: Repeatedly uses specified items until depleted
- **Smart Targeting**: Only works with items that can target self
- **Status Awareness**: Stops automatically if you move, engage in combat, or change status
- **Inventory Detection**: Automatically counts all instances of the item in your main inventory
- **Timing Control**: Uses proper cast delays plus safety buffer to prevent spam

## Installation

1. Place `pouches.lua` in your `addons/pouches/` directory
2. Load the addon in-game: `/addon load pouches`
3. (Optional) Add to your autoload list for automatic loading

## Usage

### Basic Command
```
/pouches <item_name>
```

### Examples
```
/pouches remedy
/pouches "hi-potion"
/pouches "vile elixir"
/pouches "catholicon"
/pouches "echo drops"
```

### Common Use Cases

**Status Effect Removal:**
- `/pouches remedy` - Remove poison, paralysis, silence
- `/pouches "holy water"` - Remove curse
- `/pouches "echo drops"` - Remove silence specifically

**HP/MP Recovery:**
- `/pouches "hi-potion"` - Restore HP
- `/pouches "vile elixir"` - Restore MP
- `/pouches "max-potion"` - Full HP recovery

**Food Consumption:**
- `/pouches "rice ball"` - Consume food items
- `/pouches "boiled crab"` - Any consumable food

## How It Works

1. **Item Validation**: Checks if the specified item exists in the game database
2. **Inventory Search**: Scans your main inventory for all instances of the item
3. **Target Compatibility**: Verifies the item can be used on yourself
4. **Automatic Execution**: Uses the item repeatedly with proper timing delays
5. **Status Monitoring**: Stops if your character status changes (moving, fighting, etc.)

## Stopping the Addon

The addon will automatically stop when:
- You run out of the specified item
- Your character moves or changes status
- You engage in combat or other activities
- You manually unload the addon with `/addon unload pouches`

## Technical Details

- **Delay Calculation**: Uses item's cast delay + 2 second safety buffer
- **Target Check**: Uses bitfield check (`bit.band(targets, 0x01)`) for self-targeting
- **Status Check**: Monitors `player.StatusServer == 0` (idle status)
- **Inventory Container**: Only searches main inventory (container 0)

## Compatibility

- **Platform**: Ashita v4
- **Game**: Final Fantasy XI
- **Dependencies**: Common library, Chat library

## Limitations

- Only works with items in your main inventory
- Only works with items that can target yourself
- Stops automatically if you perform any action that changes your status
- No built-in stop command (must move or unload addon)

## Credits

- **Original Author**: Omnys@Valefor (Windower version)
- **Ashita 4 Port**: Palmer
- **License**: BSD 3-Clause (see source file for full license)

## Contributing

If you find bugs or want to suggest improvements, please feel free to contribute. The addon is designed to be simple and focused on its core functionality.

## Version History

- **v1.0**: Initial Ashita 4 port from Windower version
  - Converted event system from Windower to Ashita
  - Updated resource access methods
  - Fixed target checking for Ashita's bitfield system
  - Implemented proper task scheduling
