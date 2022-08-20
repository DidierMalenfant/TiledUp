-- SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
--
-- SPDX-License-Identifier: MIT
 
-- This is super fragile. Hopefully can be replaced in the future if pdc supports absolute paths from project root.
import '../../pdbase/pdbase.lua'

tiledup {}

local gfx <const> = playdate.graphics
local file <const> = playdate.file
local path <const> = pdbase.filepath

class('Layer', { }, tiledup).extends()

function tiledup.Layer:init()
    tiledup.Layer.super.init(self)
    
    self.name = nil
    self.layers = {}
end

-- loads the json file and returns a Lua table containing the data
local function getjson_tableFromTiledFile(level_path)
    local f = file.open(level_path)
    if file == nil then
        print('Error opening level file.')
        return nil
    end

    local s = file.getSize(level_path)
    local level_data = f:read(s)
    f:close()

    if level_data == nil then
        print('Error reading level data.')
        return nil
    end

    local json_table = json.decode(level_data)
    if json_table == nil then
        print('Error decoding JSON data.')
        return nil
    end

    return json_table
end

-- returns an array containing the tile sets from the json file
local function getTilesetsFromJSON(json_table, parent_folder)
    local tilesets = {}

    for i=1, #json_table.tilesets do
        local tileset = json_table.tilesets[i]
        if tileset.source ~= nil then
            print('Error: Tilesets need to be embedded in the Tiled map.')
            return nil
        end

        local new_tileset = {}
        new_tileset.firstgid = tileset.firstgid
        new_tileset.lastgid = tileset.firstgid + tileset.tilecount - 1
        new_tileset.name = tileset.name
        new_tileset.tileHeight = tileset.tileheight
        new_tileset.tileWidth = tileset.tilewidth

        local table_index = string.find(tileset.image, '-table-')
        if table_index == nil then
            print('Error: Invalid image name for tileset.')
            return nil
        end

        local tileset_image_name = string.sub(tileset.image, 1, table_index - 1)
        if parent_folder ~= nil then
            tileset_image_name = path.join(parent_folder, tileset_image_name)
        end

        new_tileset.imageTable = gfx.imagetable.new(tileset_image_name)
        if new_tileset.imageTable == nil then
            print('Error creating new imagetable.')
            return nil
        end

        tilesets[i] = new_tileset
    end

    return tilesets
end

-- utility function for importTilemapsFromTiledJSON()
local function tilesetWithName(tilesets, name)
    for _, tileset in pairs(tilesets) do
        if tileset.name == name then
            return tileset
        end
    end

    return nil

end

local function tileset_nameForProperies(properties)
    for _, property in ipairs(properties) do
        if property.name == 'tileset' then
            return property.value
        end
    end
    return nil
end

local function collisions_onForProperies(properties)
    for _, property in ipairs(properties) do
        if property.name == 'collisions_on' then
            return property.value == true
        end
    end

    return false
end

class('Level', { }, tiledup).extends()

function tiledup.Level:init(tiled_path)
    tiledup.Level.super.init(self)
    
    self.tile_width = 0
    self.tile_height = 0
    self.layers = {}

    local json_table = getjson_tableFromTiledFile(tiled_path)
    if json_table == nil then
        return
    end

    -- load tile sets
    local parent_folder = path.directory(tiled_path)
    local tilesets = getTilesetsFromJSON(json_table, parent_folder)
    if tilesets == nil then
        return
    end

    -- create tile maps from the level data and already-loaded tile sets
    for i = 1, #json_table.layers do
        local level = {}
        local json_layer = json_table.layers[i]

        level.name = json_layer.name
        level.x = json_layer.x
        level.y = json_layer.y
        level.tileHeight = json_layer.height
        level.tileWidth = json_layer.width

        local tileset = nil
        local properties = json_layer.properties
        if properties ~= nil then
            local tileset_name = tileset_nameForProperies(properties)
            if tileset_name ~= nil then
                tileset = tilesetWithName(tilesets, tileset_name)
                level.pixelHeight = level.tileHeight * tileset.tileHeight
                level.pixelWidth = level.tileWidth * tileset.tileWidth

                local tilemap = gfx.tilemap.new()
                assert(tilemap)

                tilemap:setImageTable(tileset.imageTable)
                tilemap:setSize(level.tileWidth, level.tileHeight)

                -- we want our indexes for each tile set to be 1-based, so remove the offset that Tiled adds.
                -- this is only makes sense because because we have exactly one tile map image per layer
                local index_modifier = tileset.firstgid - 1

                local tileData = json_layer.data
                local x = 1
                local y = 1

                for j = 1, #tileData do
                    local tile_index = tileData[j]

                    if tile_index > 0 then
                        tile_index = tile_index - index_modifier
                        tilemap:setTileAtPosition(x, y, tile_index)
                    end

                    x = x + 1

                    if x > level.tileWidth - 1 then
                        x = 0
                        y = y + 1
                    end
                end

                level.tilemap = tilemap
                
                self.layers[json_layer.name] = level
            end

            level.collisions_on = collisions_onForProperies(properties)
        end

        if tileset == nil then
            print('Could not find a tileset name property for layer \'' .. layer.name .. '\'')
        end
    end

    self.tile_width = json_table.tilewidth
    if self.tile_width == nil then
        print('Error: Can\'t read tile width from Tiles data.')
        return nil
    end

    self.tile_height = json_table.tileheight
    if self.tile_height == nil then
        print('Error: Can\'t read tile height from Tiles data.')
        return nil
    end
end
