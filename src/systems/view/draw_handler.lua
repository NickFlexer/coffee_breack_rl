local class = require "middleclass"

local Cells = require "enums.cells"
local Colors = require "enums.colors"


local DrawHandler = class("DrawHandler")

function DrawHandler:initialize(data)
    self.radius_x = data.radius_x
    self.radius_y = data.radius_y
    self.cell_size = data.cell_size
    self.tc = data.tc
    self.shift_x = data.shift_x
    self.shift_y = data.shift_y

    self.font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18)
    love.graphics.setFont(self.font)
end

function DrawHandler:draw_map(data)
    local map_grid = data.map_grid
    local hero = data.hero
    local map = data.map
    local map_canvas = data.map_canvas
    local effects = data.effects

    local map_size_x, map_size_y = map:get_size()
    local hero_pos_x, hero_pos_y = map:get_character_position(hero)

    local y_0 = math.max(1, hero_pos_y - self.radius_y)
    local y_1 = math.min(map_size_y, hero_pos_y + self.radius_y)

    if y_0 == 1 then
        y_1 = self.radius_y * 2 + 1
    elseif y_1 == map_size_y then
        y_0 = map_size_y - self.radius_y * 2
    end

    local x_0 = math.max(1, hero_pos_x - self.radius_x)
    local x_1 = math.min(map_size_x, hero_pos_x + self.radius_x)

    if x_0 == 1 then
        x_1 = self.radius_x * 2 + 1
    elseif x_1 == map_size_x then
        x_0 = map_size_x - self.radius_x * 2
    end

    map_canvas:renderTo(function()
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
                if map_grid:is_valid(map_x, map_y) then
                    local cell = map_grid:get_cell(map_x, map_y)

                    if not map_grid:get_cell(map_x, map_y):is_obscured() then
                        if cell:get_name() ~= Cells.ground then
                            self.tc:draw(
                                cell:get_name(),
                                (x - 1) * self.cell_size + self.shift_x,
                                (y - 1) * self.cell_size + self.shift_y
                            )
                        end

                        if not cell:is_visible() then
                            self.tc:draw(
                                Cells.shadow,
                                (x - 1) * self.cell_size + self.shift_x,
                                (y - 1) * self.cell_size + self.shift_y
                            )
                        else
                            if cell:get_character() then
                                self.tc:draw(
                                    cell:get_character():get_tile(),
                                    (x - 1) * self.cell_size + self.shift_x,
                                    (y - 1) * self.cell_size + self.shift_y
                                )
                            end
                        end
                    else
                        self.tc:draw(
                            Cells.shadow,
                            (x - 1) * self.cell_size + self.shift_x,
                            (y - 1) * self.cell_size + self.shift_y
                        )
                    end
                end

                if #effects > 0 then
                    for _, effect in ipairs(effects) do
                        if map_x == effect.x and map_y == effect.y then
                            self.tc:draw(
                                effect.cell,
                                (x - 1) * self.cell_size + self.shift_x + self.cell_size/4,
                                (y - 1) * self.cell_size + self.shift_y + self.cell_size/4
                            )
                        end
                    end
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

function DrawHandler:draw_ui(data)
    local ui_canvas = data.ui_canvas
    local hero = data.hero

    local width, height = love.graphics.getDimensions()

    ui_canvas:renderTo(function()
        love.graphics.clear()

        local ui_panel_width = (width - (self.radius_x * 2 + 1) * self.cell_size) - 20

        love.graphics.rectangle(
            "line",
            (self.radius_x * 2 + 1) * self.cell_size + 16,
            4,
            ui_panel_width,
            (self.cell_size * 3) + 4
        )

        love.graphics.rectangle(
            "line",
            (self.radius_x * 2 + 1) * self.cell_size + 16,
            (self.cell_size * 3) + 12,
            ui_panel_width,
            (height - (self.cell_size * 3) + 12) - 32
        )

        -- hero preview
        self.tc:draw(
            hero:get_tile(),
            (self.radius_x * 2 + 1) * self.cell_size + 16 + ui_panel_width/2 - self.cell_size/2,
            (self.cell_size * 3) + 12 + self.cell_size * 3
        )

        love.graphics.rectangle(
            "line",
            (self.radius_x * 2 + 1) * self.cell_size + 16 + ui_panel_width/2 - self.cell_size/2,
            (self.cell_size * 3) + 12 + self.cell_size * 3,
            self.cell_size,
            self.cell_size
        )

        -- hero conditions
        local hero_hp = hero:get_hp()

        love.graphics.setColor(Colors.red)
        love.graphics.print(
            "HP: " .. hero_hp.cur .. "/" .. hero_hp.max,
            (self.radius_x * 2 + 1) * self.cell_size + 16 + ui_panel_width/4,
            (self.cell_size * 3) + 12 + self.cell_size * 7
        )
    end)
end

return DrawHandler
