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

    if not data.hp then
        error("Hero:initializ: no data.hp !")
    end

    self.ai = data.ai
    self.max_hp = data.hp
    self.current_hp = data.hp
end

return Rabbit
