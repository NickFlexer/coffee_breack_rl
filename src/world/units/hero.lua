local class = require "middleclass"

local Character = require "world.units.character"

local Cells = require "enums.cells"
local MovingDirection = require "enums.moving_direction"
local Actions = require "enums.actions"
local CharacterControl = require "enums.character_control"

local MoveAction = require "logic.actions.move_action"
local PassAction = require "logic.actions.pass_action"


local Hero = class("Hero", Character)

function Hero:initialize(data)
    Character:initialize(self)

    if not data.hp then
        error("Hero:initializ: no data.hp !")
    end

    if not data.attack then
        error("Hero:initializ: no data.attack !")
    end

    self.max_hp = data.hp
    self.current_hp = data.hp
    self.attack = data.attack

    self.tile = Cells.barbarian
    self.control = CharacterControl.player
end

function Hero:handle_event(event)
    if event:get_action_type() == MovingDirection.up then
        self:set_action(MoveAction({direction = MovingDirection.up}))

        return
    end

    if event:get_action_type() == MovingDirection.down then
        self:set_action(MoveAction({direction = MovingDirection.down}))

        return
    end

    if event:get_action_type() == MovingDirection.left then
        self:set_action(MoveAction({direction = MovingDirection.left}))

        return
    end

    if event:get_action_type() == MovingDirection.right then
        self:set_action(MoveAction({direction = MovingDirection.right}))

        return
    end

    if event:get_action_type() == Actions.pass then
        self:set_action(PassAction())
    end
end

return Hero
