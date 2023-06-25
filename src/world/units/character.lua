local class = require "middleclass"


local Character = class("Character")

function Character:initialize(data)
    self.tile = data.tile
    self.action = nil
end

function Character:get_tile()
    return self.tile
end

function Character:get_action()
    local action =  self.action
    self.action = nil

    return action
end

return Character
