## Minimap

Minimap is a plugin for Ashita that renders a custom in-game minimap overlay.

## How To Install

Minimap can be installed by simply placing the Minimap.dll into the Ashita plugins folder.

  - ex. `<Path To Ashita>/plugins/Minimap.dll`

Once installed, you can load Minimap in-game via: `/load minimap`

_You can also add Minimap to your default script to automatically load when the game starts._

## Commands

Minimap offers the following in-game commands:

 - `/minimap` - _Toggles the visibility of the Minimap configuration editor._
 - `/minimap <position | pos> <x> <y>` - _Sets the Minimap position._
 - `/minimap scale <x> <y>` - _Sets the Minimap scale._
 - `/minimap <opacitymap | om> <opacity>` - _Sets the Minimap map opacity._
 - `/minimap <opacityframe | of> <opacity>` - _Sets the Minimap frame opacity._
 - `/minimap <opacityarrow | oa> <opacity>` - _Sets the Minimap arrow opacity._
 - `/minimap zoom <amount>` - _Sets the Minimap zoom amount._
 - `/minimap zoomstep <amount>` - _Sets the Minimap zoom step amount._
 - `/minimap rotatemap [0 | 1]` - _Sets, or toggles, the Minimap map rotation._
 - `/minimap rotateframe [0 | 1]` - _Sets, or toggles, the Minimap frame rotation._
 - `/minimap hideunknown [0 | 1]` - _Sets, or toggles, the Minimap hide unknown maps feature._
 - `/minimap drawmonsters [0 | 1]` - _Sets, or toggles, if monsters will be drawn on the Minimap._
 - `/minimap drawnpcs [0 | 1]` - _Sets, or toggles, if npcs will be drawn on the Minimap._
 - `/minimap drawplayers [0 | 1]` - _Sets, or toggles, if players will be drawn on the Minimap._
 - `/minimap <colormonsters | cm> <a> <r> <g> <b>` - _Sets the color of monster entities on the Minimap._
 - `/minimap <colornpcs | cn> <a> <r> <g> <b>` - _Sets the color of npcs entities on the Minimap._
 - `/minimap <colorplayers | cp> <a> <r> <g> <b>` - _Sets the color of players entities on the Minimap._

## Themes

Minimap allows users to create additional themes to apply to the in-game minimap. Themes are made up of a few .png images and a theme.ini configuration file.

Themes are found within the following folder: `<Path To Ashita>/config/minimap/themes/`

Each theme must have the following files to be considered valid:

  - `arrow.png` - _The texture used to draw the local player arrow in the center of the minimap._
  - `entity.png` - _The texture used to draw the entity dots on the minimap._
  - `frame.png` - _The texture used to draw the frame around the minimap._
  - `mask.png` - _The texture used to mask what part of the map is visible within the minimap._
  - `target.png` - _The texture used to draw the targeted entity dot._
  - `theme.ini` - _The themes configuration file._

## Themes - Frame

![frame.png](https://i.imgur.com/B6mBu35.png)

The frame.png texture is what is rendered around the map image. An example of the frames texture configurations for the circle theme, found in the themes `theme.ini` file, looks like this:

```ini
[frame]
w = 276
h = 276
p = 40
```

The `w` and `h` values are the width and height (frame size) of the frame.png image. For best results, your frame.png should be a square image, even if your map is not a square. The frame should be centered, equal distance from all sides, in the image.

The `p` value is the frame padding value. This value is the amount of space from the image edge (ie. pixel 0 x 0) until the closest point of the frame where the map will be drawn. In the example image above, our frame sits offset of the edge by 40px at its closest points to the rendering area. So we use 40 as the value for the frame padding.

## Themes - Mask

![mask.png](https://i.imgur.com/ej7kB2Q.png)

The mask.png texture is used to 'punch out' what part of the full game map image will be displayed. The mask texture should be white where you want the map to draw, and transparent everywhere else. For proper visual results, your mask image should fill the empty space within your frames area that you wish the map to be drawn to. 

In the examples images above, our frame size is 276 x 276, but the inner circle where the map would be drawn is 200 x 200 pixels. So our mask image should be a white circle that fills that space.

_Masks are not required to be one solid object (ie. circle or square). You can be creative and mask out different shapes/areas within the location the mask would be applied to create unique minimap themes._