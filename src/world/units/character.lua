local class = require "middleclass"


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

return Character
