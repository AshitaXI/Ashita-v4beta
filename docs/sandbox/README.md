## Donations

Want to say thanks? Feel free to donate via Paypal here: [https://www.paypal.me/atom0s](https://www.paypal.me/atom0s)

## Sandbox

Sandbox is a PlayOnline plugin for Ashita v4 that can virtualize the registry and COM information required to load and play PlayOnline, Final Fantasy XI, _and potentially any other game ran through PlayOnline_. This allows you to play the game from (virtually) anywhere without installing it, at all. _(No registry backups needed. No DLL registrions needed.)_

Sandbox works for both retail and private servers.

Sandbox has been tested to work on the following:
  * Windows 7, 8, 8.1, 10

Sandbox has been tested to work in the following environments / setups:
  * Copying the SquareEnix folder from one machine to another. (Without any extra steps.)
  * Ran from a USB thumbdrive.
  * Ran from an SD card.
  * Ran from a network attached storage and/or another machine on a network. (Proper permissions required.)
  * Ran from within a VM.
  * Ran from within a VM using all the above listed methods as additional layers.

With Sandbox, it's now easier than ever to dual-'install' the game, without actually installing and corrupting your real install(s)! \
Play on as many private servers (and/or retail) with unique 'installs' as you want!

## How To Install Sandbox Manually

Installing Sandbox is pretty simple and straight forward. All you need is a text editor.

Follow the steps below to get started:

1. **Downloading**
    * Download the latest version of Sandbox.
    * Extract all the files included with Sandbox into the proper folders in Ashita v4's folder structure.

2. **Enabling Sandbox**
    * _Sandbox allows per-boot configurations, allowing you to easily setup multiple different installs with ease._
    * Open the Ashita boot configuration folder: `/config/boot/`
    * Open the configuration file you wish to use Sandbox with in your text editor. (ie. `example.ini`)
    * In the boot configuration, locate the `[ashita.polplugins]` section. (If one is not present, create it.)
    * Add `sandbox` to this list in numerical order. For example, if Sandbox is the only polplugin you are using then it would look like this:
    ```ini
    [ashita.polplugins]
    0=sandbox
    ```

3. **Setting Sandbox's Paths**
    * _Sandbox allows per-boot configurations, allowing you to easily setup multiple different installs with ease._
    * Open the Ashita boot configuration folder: `/config/boot/`
    * Open the configuration file you wish to use Sandbox with in your text editor. (ie. `example.ini`)
    * At the bottom of the file, add the following section and be sure to update the paths to where you have the game data located:
      * _Relative paths are supported._
    ```ini
    [sandbox.paths]
    common = C:\Program Files (x86)\Common Files
    pol    = C:\Program Files (x86)\SquareEnix\PlayOnlineViewer
    ffxi   = C:\Program Files (x86)\SquareEnix\FINAL FANTASY XI
    tetra  = C:\Program Files (x86)\SquareEnix\TetraMaster
    ```

4. **Editing Sandbox Configurations / Overrides**
     * Open the `/config/sandbox/sandbox.ini` file in your text editor.
     * Edit any options present you wish to adjust.
     * **Advanced:** Add your own registry overrides you need/want to use.

## Sandbox Configuration Files

Sandbox includes two configuration files.

  * **`sandbox.registry.ini`** - **[DO NOT EDIT THIS FILE!]** This file contains the default registry and COM information required for Sandbox to operate properly. These are considered the base values/information needed. _(If you feel there is something inside of `sandbox.registry.ini` that should be permanently changed, please contact atom0s.)_

  * **`sandbox.ini`** - This file contains the additional configurations that can be made for Sandbox. This file is also used as an override to any registry and COM information you wish to alter that is found inside of the `sandbox.registry.ini` file. All overrides should be placed in this file.

When Sandbox loads, it will first load `sandbox.registry.ini` then load `sandbox.ini` to merge and override the configurations.

If you wish to override any information found inside of the `sandbox.registry.ini` file, you should copy the block of data you are wanting to override and paste it into the `sandbox.ini` file and make your edits there. This will ensure your edits are used instead of the defaults and that future updates will not overwrite your changes.

## Sandbox Configurations

The `sandbox.ini` file is used to configure Sandbox's features. Sandbox currently offers the following additional settings:

```ini
[sandbox.hooks]
use_interface_bypass = 1
use_playonline_encryption_override = 1
```

### sandbox.hooks

#### use_interface_bypass

  * **Type**: boolean
  * **Default**: 1

Hooks the games patch.ver interface id check to validate the game data and version. \
This allows bypassing the required proper values of the 'Interface' registry keys found in:

  * 32bit: HKEY_LOCAL_MACHINE\SOFTWARE\PlayOnlineUS\Interface
  * 64bit: HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\PlayOnlineUS\Interface

If this setting is disabled, then you must provide the valid interface ids for the game(s) you are attempting to play. Otherwise, they will fail to launch properly.

#### use_playonline_encryption_override

  * **Type**: boolean
  * **Default**: 1

Hooks the games PlayOnline encryption handler that deals with the local machine encryption that is used when saving PlayOnline accounts to the retail POL client. This is required if you want the retail version of PlayOnline to save your account data. This data is normally stored in the following registry key (SPS000):

  * 32bit: HKEY_LOCAL_MACHINE\SOFTWARE\PlayOnlineUS\SquareEnix\PlayOnlineViewer
  * 64bit: HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer

This feature in PlayOnline also makes use of the following fake image file: `PlayOnlineViewer\data\icon\cicn_m000.png`

This fake image file that stores a 24 character random string that is used as the base key for encryption. The SPS000 is a 1860 byte long randomized key that holds your password and encryption information.

Because Sandbox emulates and virtualizes the registry, it prevents anything from being written. This configuration option will allow the `SPS000` key to be stored locally on disk instead. When enabled, whenever PlayOnline attempts to recreate/write this registry key or access it, it will instead to written to and accessed from: `/config/sandbox/sps000.bin`

**Warning:** This file contains sensitive information. While it is encrypted and the png file key is needed to decrypt it, it should still not be shared with others! Be sure to not upload/store this file anywhere others can access it!

## Sandbox Configuration Overrides

Sandbox makes use of regular expressions to match key names inside of the registry when virtualizing overrides. This allows for easier rules to match multiple entries that are used for the same thing. For example, the different versions of PlayOnline store information within 'PlayOnline', 'PlayOnlineUS' and 'PlayOnlineEU' registry keys for the JP, NA and EU versions respectively. 

From there, Sandbox makes use of generally standard exported registry 5.0 data.

  * The default value name of a key is named: **@**.
  * String values are simply wrapped in quotes.
  * DWORD values are prefixed with 'dword:' and stored as hex.
  * The additional types are stored as their hex byte format. (Multi-line hex is not supported, all data should be on a single line.)

When Sandbox makes a registry override, it overrides and takes control of an entire key. This is important to note as all values you do not include when overriding will be returned as 'not found' otherwise. If you override a key, you should override all expected values, even if you must set them to their expected defaults. Sandbox will not fallback to the real registry for any keys it overrides.

If you are overriding a key found in the base 'sandbox.registry.ini' file, you do not need to copy and override every value as it already exists in the base. You can simply override the specific value(s) you wish to alter.

## Sandbox Configuration Tokens

Sandbox will parse and replace specific string values to make pathing easier for COM related things. These replacement tokens include:

  * `{COMMON_PATH}` - The path to your common files folder.
  * `{FFXI_PATH}` - The path to your FFXI folder.
  * `{POL_PATH}` - The path to your PlayOnline folder.
  * `{TETRA_PATH}` - The path to your TetraMaster folder.

These are replaced with the values you put for the Sandbox path configurations explained above.

## Using Japanese PlayOnline & Final Fantasy XI

By default, Sandbox will attempt to force the English language for both POL and FFXI. For those that need/wish to use the Japanese version of POL/FFXI here is a quick adjustment guide to get that working.

  * Follow all the instructions above on how to install Sandbox accordingly first.
  * Make sure that your pol path for Sandbox is pointed to a proper Japanese PlayOnline folder.
  * Next, open the 'sandbox.ini' configuration file in a text editor.
  * Add the following data to this file, or edit accordingly if it already exists:
```ini
[(PlayOnline|PlayOnlineUS|PlayOnlineEU)\\(Square|SquareEnix)\\PlayOnlineViewer\\Settings$]
Language=dword:00000000
```

This will set PlayOnline and Final Fantasy XI to be Japanese. 

## Check Files Showing Unknown Versions

This is a common issue with installs and no different than here with Sandbox. Because of how PlayOnline calculates/handles version information, it is virtually impossible for us to have proper information for everyones install regarding this. PlayOnline makes use of the 'Interface' registry values to decrypt the patch.ver files used by each property installed. These values are generated when you first install PlayOnline and any associated games that run through POL. So these keys are generally unique.

However, you can fix them and force them to use 0 as the interface value like Sandbox emulates.

 * **To Fix PlayOnline Version**
   * Open your `PlayOnline` folder.
   * Go into the `/data/doc/` folder.
   * Delete the `polerr.bin` file.
   * Open PlayOnline and run 'Check Files' on PlayOnline.
   * This should update POL and adjust the version to encrypt with 0 as the new key.

 * **To Fix FFXI Version**
   * Open your `Final Fantasy XI` folder.
   * Go into the `/ROM/0/` folder.
   * Delete the `0.DAT` file. _(Just the single file, not the whole 0 folder!)_
   * Open PlayOnline and run 'Check Files' on Final Fantasy XI.
   * This should update FFXI and adjust the version to encrypt with 0 as the new key.

**Please note:** _Doing this may cause PlayOnline to attempt to restart itself. If this happens, it will reload without Ashita or Sandbox and throw errors. Simply close the errors that pop up and relaunch with Ashita afterward._

**Please note:** _Doing this for Final Fantasy XI will force-update you to the latest retail client! This will break your ability to connect to some private servers with this install afterward. Only force-update like this if the server accepts the latest retail client._

## Known Issues

Sandbox is an experimental plugin and thus will have weird quirks or potential bugs. Please understand that you should back up any current/valid installs of the game and any registry data before making use of Sandbox. Vigorous testing was done to try to limit any potential problems, but bugs always slip through as its impossible to test every use-case.

Here is a list of what we know is broken/buggy/wrong.

  * None at this time!