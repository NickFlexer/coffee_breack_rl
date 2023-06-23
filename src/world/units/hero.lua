local class = require "middleclass"

local Character = require "world.units.character"

local Cells = require "enums.cells"


local Hero = class("Hero", Character)

function Hero:initialize()
    self.tile = Cells.barbarian

    Character:initialize(self)
end

return Hero
