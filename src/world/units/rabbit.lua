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
        error("Rabbit:initializ: no data.hp !")
    end

    if not data.view_radius then
        error("Rabbit:initializ: no data.view_radius !")
    end

    if not data.speed then
        error("Rabbit:initializ: no data.speed !")
    end

    self.ai = data.ai
    self.max_hp = data.hp
    self.current_hp = data.hp
    self.view_radius = data.view_radius
    self.speed = data.speed
end

return Rabbit
