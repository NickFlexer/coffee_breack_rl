local class = require "middleclass"

local cells = require "enums.cells"


local Cell = class("Cell")

function Cell:initialize()
    self.name = cells.cell
end

function Cell:get_name()
    return self.name
end

return Cell