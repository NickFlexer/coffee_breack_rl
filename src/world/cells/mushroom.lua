local class = require "middleclass"

local Cell = require "world.cells.cell"
local cells = require "enums.cells"


local Mushroom = class("Mushroom", Cell)

function Mushroom:initialize()
    Cell.initialize(self)

    self.name = cells.mushroom
end

return Mushroom
