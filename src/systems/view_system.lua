local class = require "middleclass"

local TileCutter = require "tile_cutter"

local cells = require "enums.cells"


local ViewSystem = class("ViewSystem", System)

function ViewSystem:initialize(data)
    System.initialize(self)

    if not data.map then
        error("ViewSystem:initialize data.map is nil!")
    end

    self.map = data.map

    self.cell_size = 32

    self.canvas = love.graphics.newCanvas()
    self.tc = TileCutter("res/tileset/fantasy-tileset.png", self.cell_size)
    self.tc:config_tileset(
        {
            {cells.wall, 2, 2},
            {cells.mushroom, 1, 21}
        }
    )
end

function ViewSystem:update(dt)
end

function ViewSystem:draw()
    love.graphics.setColor(1, 1, 1);
    love.graphics.draw(self.canvas)
end

function ViewSystem:requires()
    return {}
end

function ViewSystem:handle_event(event)
    local map_grid = self.map:get_grid()

    self.canvas:renderTo(function()
        for x, y, cell in map_grid:iterate() do
            if cell:get_name() ~= cells.ground then
                self.tc:draw(cell:get_name(), (x - 1) * self.cell_size, (y - 1) * self.cell_size)
            end
        end
    end)
end

return ViewSystem
