# TiledUp for Playdate

![](https://img.shields.io/github/license/DidierMalenfant/tiled-up) ![](https://img.shields.io/badge/Lua-5.4-yellowgreen) ![](https://img.shields.io/badge/toybox.py-compatible-brightgreen) ![](https://img.shields.io/github/v/tag/DidierMalenfant/tiled-up)

**TiledUp** is a [**Playdate**](https://play.date) **toybox** which lets you import and use [**Tiled**](https://www.mapeditor.org) levels. This is based on code found in the `Level1_1` example in the **Playdate** SDK but it extends it to provide new features and optimised level rendering.

You can add it to your **Playdate** project by installing [**toybox.py**](https://toyboxpy.io), going to your project folder in a Terminal window and typing:

```console
toybox add DidierMalenfant/tiled-up
```

This **toybox** contains **Lua** toys for you to play with.

---

### tiledup (Lua)

The `tiledup` module provides functionality to load **Tiled** levels. Level files need to conform to a few conventions in order to be correctly loaded:

* Tileset images need to be located in a subfolder of the level's `tmj` file.
* Tileset image names must be compatible with **Playdate**'s `Tilemap` naming convention (i.e. `MyTileSet-table-20-20` for tiles of 20x20).
* Tileset need to be embedded into the **Tiled** file, not saved as a separate file.

It provides two classes: `Level` and `Layer`.

#### `tiledup.Level`

A `tiledup.Level` object contains the following properties:

* `Level.layers` -  An array of `tiledup.Layers`.
* `Level.tile_width`, `Level.tile_height` - Width and height of a single tile in the level.

##### `tiledup.Level(path)`

Imports the **Tiled** json file (with the `.tmj` extension) located at `path`. Returns a `tiledup.Level` object.

#### `tiledup.Layer`

Layers are basically a subset of the `layer` objects found in the **Tiled** file. A `tiledup.Layer` contains the following properties:

* `Layer.name` - Name of the layer.
* `Layer.x`, `layer.y` - x and y offsets of the layer.
* `Layer.tileWidth`, `layer.tileHeight` - Width and height of the tiles in that layer, in pixels.
* `Layer.pixelWidth`, `layer.pixelHeight` - Total width and height of the layer, in pixels.
* `Layer.tilemap` - A **Playdate** [Tilemap](https://sdk.play.date/1.12.3/Inside%20Playdate.html#C-graphics.tilemap) object which contains all the tiles for this layer.
* `Layer.empty_ids` - A table of ids for tiles which have the custom property `no_collisions` set to `true`.

## TODO

* Add some more setup code, especially setting up wall collision.
* Add some rendering code that keeps track of only the tiles visible on screen.
* Support for **Tiled**'s collisions?

## License

`TiledUp` is distributed under the terms of the [MIT](https://spdx.org/licenses/MIT.html) license.
