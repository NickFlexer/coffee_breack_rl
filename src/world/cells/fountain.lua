local class = require "middleclass"

local Cell = require "world.cells.cell"
local cells = require "enums.cells"

local Colors = require "enums.colors"


local Fountain = class("Fountain", Cell)

function Fountain:initialize()
    Cell.initialize(self)

    self.name = cells.fountain
    self.move_blocked = false

    self.transparent = true
    self.item_possibility = false

    self.full = true
end

function Fountain:is_full()
    return self.full
end

function Fountain:get_message()
    local name = "Полный фонтан жизни"

    if not self.full then
        name = "Пустой фонтан жизни"
    end

    local message = {
        Colors.white, "Это ",
        Colors.green, name,
        Colors.white, ". Нажми ",
        Colors.orange, "Enter",
        Colors.white, " чтобы прикоснуться к нему"
    }

    return message
end

return Fountain
