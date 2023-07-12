local class = require "middleclass"

local BasicAction = require "logic.actions.basic_action"

local MovingDirection = require "enums.moving_direction"
local Actions = require "enums.actions"


local MoveAction = class("MoveAction", BasicAction)

function MoveAction:initialize(data)
    BasicAction:initialize(self)

    self.type = Actions.move

    if not data.direction then
        error("MoveAction:initialize NO data.direction!")
    end

    self.direction = data.direction
end

function MoveAction:perform(data)
    if not data.actor then
        error("MoveAction:perform NO data.actor!")
    end

    if not data.map then
        error("MoveAction:perform NO data.map!")
    end

    local cur_x, cur_y = data.map:get_character_position(data.actor)
    local new_x, new_y

    if self.direction == MovingDirection.up then
        new_x, new_y = cur_x, cur_y - 1
    elseif self.direction == MovingDirection.down then
        new_x, new_y = cur_x, cur_y + 1
    elseif self.direction == MovingDirection.left then
        new_x, new_y = cur_x - 1, cur_y
    elseif self.direction == MovingDirection.right then
        new_x, new_y = cur_x + 1, cur_y
    end

    if data.map:get_grid():is_valid(new_x, new_y) and data.map:can_move(new_x, new_y) then
        if data.map:get_grid():get_cell(new_x, new_y):get_character() then
            Log.trace("Character!")

            return false
        else
            data.map:move_cahracter(cur_x, cur_y, new_x, new_y)

            return true
        end
    else
        Log.trace("Obstacle!")
    end

    return false
end

return MoveAction
