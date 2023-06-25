local class = require "middleclass"

local Character = require "world.units.character"

local Cells = require "enums.cells"
local MovingDirection = require "enums.moving_direction"

local MoveAction = require "logic.actions.move_action"


local Hero = class("Hero", Character)

function Hero:initialize()
    self.tile = Cells.barbarian

    Character:initialize(self)
end

function Hero:handle_event(event)
    if event:get_action_type() == MovingDirection.up then
        self.action = MoveAction({direction = MovingDirection.up})

        return
    end

    if event:get_action_type() == MovingDirection.down then
        self.action = MoveAction({direction = MovingDirection.down})

        return
    end

    if event:get_action_type() == MovingDirection.left then
        self.action = MoveAction({direction = MovingDirection.left})

        return
    end

    if event:get_action_type() == MovingDirection.right then
        self.action = MoveAction({direction = MovingDirection.right})

        return
    end
end

return Hero
