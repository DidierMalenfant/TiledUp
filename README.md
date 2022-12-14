# TiledUp for Playdate

[![MIT License](https://img.shields.io/github/license/DidierMalenfant/TiledUp)](https://spdx.org/licenses/MIT.html) [![Lua Version](https://img.shields.io/badge/Lua-5.4-yellowgreen)](https://lua.org) [![Toybox Compatible](https://img.shields.io/badge/toybox.py-compatible-brightgreen)](https://toyboxpy.io) [![Latest Version](https://img.shields.io/github/v/tag/DidierMalenfant/TiledUp)](https://github.com/DidierMalenfant/TiledUp/tags)

**TiledUp** is a [**Playdate**](https://play.date) **toybox** which lets you import and use [**Tiled**](https://www.mapeditor.org) levels. This is based on code found in the `Level1_1` example in the **Playdate** SDK but it extends it to provide new features and optimised level rendering.

‼️ This **toybox** is in active development, the API can change at any time... ‼️
 
You can add it to your **Playdate** project by installing [**toybox.py**](https://toyboxpy.io), going to your project folder in a Terminal window and typing:

```console
toybox add TiledUp
toybox update
```

Then, if your code is in the `source` folder, just import the following:

```lua
import '../toyboxes/toyboxes.lua'
```

This **toybox** contains **Lua** toys for you to play with.

---

### tiledup (Lua)

The `tiledup` module provides functionality to load **Tiled** levels. Level files need to conform to a few conventions in order to be correctly loaded:

* Tileset images need to be located in a subfolder of the level's `tmj` file.
* Tileset image names must be compatible with **Playdate**'s `Tilemap` naming convention (i.e. `MyTileSet-table-20-20` for tiles of 20x20).
* Tileset need to be embedded into the **Tiled** file, not saved as a separate file.

It provides two classes: `Level` and `Layer`.

#### `dm.tiledup.Level`

A `dm.tiledup.Level` object contains the following properties:

* `layers` -  A dictionary of `dm.tiledup.Layers`, sorted by layer name.
* `tile_width`, `tile_height` - Width and height of a single tile in the level.

##### `dm.tiledup.Level(path)`

Imports the **Tiled** json file (with the `.tmj` extension) located at `path`. Returns a `dm.tiledup.Level` object.

#### `dm.tiledup.Layer`

Layers are basically a subset of the `layer` objects found in the **Tiled** file. A `dm.tiledup.Layer` contains the following properties:

* `name` - Name of the layer.
* `x`, `y` - x and y offsets of the layer.
* `tileWidth`, `tileHeight` - Width and height of the tiles in that layer, in pixels.
* `pixelWidth`, `pixelHeight` - Total width and height of the layer, in pixels.
* `tilemap` - A **Playdate** [Tilemap](https://sdk.play.date/1.12.3/Inside%20Playdate.html#C-graphics.tilemap) object which contains all the tiles for this layer.
* `empty_ids` - A table of ids for tiles which have the custom property `no_collisions` set to `true`.

## Sample code

You can find an example of using **TiledUp** in the little [**Aspen**](https://github.com/DidierMalenfant/Aspen) **toybox**.

## TODO

* Add some more setup code, especially setting up wall collision.
* Add some rendering code that keeps track of only the tiles visible on screen.
* Support for **Tiled**'s collisions?

## License

**TiledUp** is distributed under the terms of the [MIT](https://spdx.org/licenses/MIT.html) license.
