local class = require "middleclass"
local Grid = require "grid"

local Ground = require "world.cells.ground"
local Mushroom = require "world.cells.mushroom"

local MapType = require "enums.map_type"
local cells = require "enums.cells"


local Map = class("Map")

function Map:initialize(data)
    self.map_size_x = 200
    self.map_size_y = 100
    self.world_map = Grid(self.map_size_x, self.map_size_y)

    for x, y, cell in self.world_map:iterate() do
        self.world_map:set_cell(x, y, Ground())
    end

    self.hero = {
        hero = data.hero,
        pos_x = 0,
        pos_y = 0
    }
end

function Map:get_grid()
    return self.world_map
end

function Map:handle_event(generate_event)
    if generate_event:get_map_type() == MapType.mushroom_forest then
        math.randomseed(os.time())

        for x, y, cell in self.world_map:iterate() do
            if math.random(100) <= 25 then
                self.world_map:set_cell(x, y, Mushroom())
            end
        end
    end

    while true do
        local pos_x, pos_y = math.random(self.map_size_x), math.random(self.map_size_y)

        if self.world_map:get_cell(pos_x, pos_y):get_name() == cells.ground then
            self.world_map:get_cell(pos_x, pos_y):set_character(self.hero.hero)

            self.hero.pos_x = pos_x
            self.hero.pos_y = pos_y

            break
        end
    end
end

function Map:get_hero_position()
    return self.hero.pos_x, self.hero.pos_y
end

function Map:get_size()
    return self.map_size_x, self.map_size_y
end

return Map
