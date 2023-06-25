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
    self.radius_x = 15
    self.radius_y = 10

    self.shift_x = 8
    self.shift_y = 8

    self.canvas = love.graphics.newCanvas()
    self.tc = TileCutter("res/tileset/fantasy-tileset.png", self.cell_size)
    self.tc:config_tileset(
        {
            {cells.wall, 2, 2},
            {cells.mushroom, 1, 21},

            {cells.barbarian, 3, 19}
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

    local map_size_x, map_size_y = self.map:get_size()
    local hero_pos_x, hero_pos_y = self.map:get_hero_position()

    local x_0 = math.max(1, hero_pos_x - self.radius_x)
    local x_1 = math.min(map_size_x, hero_pos_x + self.radius_x)

    local y_0 = math.max(1, hero_pos_y - self.radius_y)
    local y_1 = math.min(map_size_y, hero_pos_y + self.radius_y)

    if x_0 == 1 then
        x_1 = self.radius_x * 2 + 1
    end

    if x_1 == map_size_x then
        x_0 = map_size_x - self.radius_x * 2 + 1
    end

    if y_0 == 1 then
        y_1 = self.radius_y * 2 + 1
    end

    if y_1 == map_size_y then
        y_0 = map_size_y - self.radius_y * 2 + 1
    end

    self.canvas:renderTo(function()
        love.graphics.clear()
        love.graphics.rectangle(
            "line",
            4,
            4,
            (self.radius_x * 2 + 1) * self.cell_size + 8,
            (self.radius_y * 2 + 1) * self.cell_size + 8
        )

        local x, y = 1, 1

        for map_y = y_0, y_1 do

            for map_x = x_0, x_1 do
                local cell = map_grid:get_cell(map_x, map_y)

                if cell:get_name() ~= cells.ground then
                    self.tc:draw(
                        cell:get_name(),
                        (x - 1) * self.cell_size + self.shift_x,
                        (y - 1) * self.cell_size + self.shift_y
                    )
                end

                if cell:get_character() then
                    self.tc:draw(
                        cell:get_character():get_tile(),
                        (x - 1) * self.cell_size + self.shift_x,
                        (y - 1) * self.cell_size + self.shift_y
                    )
                end

                x = x + 1

                if x > self.radius_x * 2 + 1 then
                    x = 1
                end
            end

            y = y + 1
        end
    end)
end

return ViewSystem
