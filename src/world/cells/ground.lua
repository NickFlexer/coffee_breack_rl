local class = require "middleclass"

local Cell = require "world.cells.cell"
local cells = require "enums.cells"


local Ground = class("Ground", Cell)

function Ground:initialize()
    Cell.initialize(self)

    self.name = cells.ground
    self.move_blocked = false

    self.transparent = true
end

return Ground
