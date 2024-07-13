local class = require "middleclass"

local Cell = require "world.cells.cell"
local cells = require "enums.cells"

local Colors = require "enums.colors"


local Stairs = class("Stairs", Cell)

function Stairs:initialize()
    Cell.initialize(self)

    self.name = cells.stairs
    self.move_blocked = false

    self.transparent = true
    self.item_possibility = false
end

function Stairs:get_message()
    local message = {
        Colors.white, "Тут ",
        Colors.green, "Лестница",
        Colors.white, " в неведомое подземелье. ",
        Colors.white, "Нажмите ",
        Colors.orange, "Enter",
        Colors.white, " чтобы пройти"
    }

    return message
end

return Stairs
