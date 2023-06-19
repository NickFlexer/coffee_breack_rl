local class = require "middleclass"
local Grid = require "grid"

local Ground = require "world.cells.ground"
local Mushroom = require "world.cells.mushroom"

local MapType = require "enums.map_type"


local Map = class("Map")

function Map:initialize()
    self.world_map = Grid(200, 100)

    for x, y, cell in self.world_map:iterate() do
        self.world_map:set_cell(x, y, Ground())
    end
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
end

return Map
