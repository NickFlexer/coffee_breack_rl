local class = require "middleclass"

local Character = require "world.units.character"

local Cells = require "enums.cells"
local CharacterControl = require "enums.character_control"


local Rabbit = class("Rabbit", Character)

function Rabbit:initialize(data)
    Character:initialize(self)

    self.tile = Cells.rabbit
    self.control = CharacterControl.ai

    if not data.ai then
        error("Rabbit:initialize no data.ai !")
    end

    self.ai = data.ai
end

return Rabbit
