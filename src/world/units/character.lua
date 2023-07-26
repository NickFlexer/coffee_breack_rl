local class = require "middleclass"

local MovingDirection = require "enums.moving_direction"


local Character = class("Character")

function Character:initialize(data)
    self.tile = data.tile
    self.action = nil
    self.control = nil
    self.ai = nil
    self.max_hp = nil
    self.current_hp = nil
    self.attack = {min = 0, max = 0}
    self.view_radius = nil
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

function Character:get_hp()
    return {max = self.max_hp, cur = self.current_hp}
end

function Character:new_attack()
    return math.random(self.attack.min, self.attack.max)
end

function Character:get_attacks()
    return self.attack
end

function Character:decreace_hp(attack)
    self.current_hp = math.max(self.current_hp - attack, 0)
end

function Character:get_view_radius()
    return self.view_radius
end

function Character:is_dead()
    return self.current_hp == 0
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
