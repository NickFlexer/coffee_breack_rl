local class = require "middleclass"


local Character = class("Character")

function Character:initialize(data)
    self.tile = data.tile
end

function Character:get_tile()
    return self.tile
end

return Character
