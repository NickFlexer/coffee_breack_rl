local class = require "middleclass"

local MovingDirection = require "enums.moving_direction"


local MoveAction = class("MoveAction")

function MoveAction:initialize(data)
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

    local cur_x, cur_y = data.map:get_hero_position()
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

    if data.map:get_grid():is_valid(new_x, new_y) then
        print("NEW X: " .. tostring(new_x) .. " NEW Y: " .. tostring(new_y))
        data.map:move_cahracter(cur_x, cur_y, new_x, new_y)

        return true
    else
        print("!!")
    end

    return false
end

return MoveAction
