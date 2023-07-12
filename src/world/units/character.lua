local class = require "middleclass"

local MovingDirection = require "enums.moving_direction"


local Character = class("Character")

function Character:initialize(data)
    self.tile = data.tile
    self.action = nil
    self.control = nil
    self.ai = nil
end

function Character:get_tile()
    return self.tile
end

function Character:set_action(action)
    Log.trace("NEW ACTION " .. self.class.name)
    self.action = action
end

function Character:get_action()
    local action =  self.action
    self.action = nil

    return action
end

function Character:get_control()
    return self.control
end

function Character:think(data)
    self.ai:perform(data)
end

function Character:get_moving_direction(x0, y0, x1, y1)
    if x0 == x1 + 1 and y0 == y1 then
        return MovingDirection.left
    elseif x0 == x1 - 1 and y0 == y1 then
        return MovingDirection.right
    elseif x0 == x1 and y0 == y1 + 1 then
        return MovingDirection.up
    elseif x0 == x1 and y0 == y1 - 1 then
        return MovingDirection.down
    else
        return
    end
end

return Character
