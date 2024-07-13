local class = require "middleclass"

local TileCutter = require "tile_cutter"

local Cells = require "enums.cells"


local TileDrawer = class("TileDrawer")

function TileDrawer:initialize()
    self.cell_size = 32

    self.tc = TileCutter("res/tileset/fantasy-tileset-3.png", self.cell_size)
    self.tc:config_tileset(
        {
            {Cells.wall, 2, 2},
            {Cells.mushroom, 1, 21},
            {Cells.stairs, 6, 2},
            {Cells.fountain, 6, 17},

            {Cells.barbarian, 3, 19},
            {Cells.rabbit, 2, 21},
            {Cells.zombie, 2, 23},

            {Cells.shadow, 4, 1},

            {Cells.bones, 3, 17},

            {Cells.short_sword, 1, 8},

            {Cells.leather_helmet, 1, 13},

            {Cells.leather_jacket, 1, 12},

            {Cells.no_path, 2, 47, 16},
            {Cells.fight, 7, 47, 16}
        }
    )
end

function TileDrawer:draw(tile, x, y)
    self.tc:draw(tile, x, y)
end

return TileDrawer
