local class = require "middleclass"


local GenerateWorldEvent = class("GenerateWorldEvent")

function GenerateWorldEvent:initialize(map_type)
    self.map_type = map_type
end

function GenerateWorldEvent:get_map_type()
    return self.map_type
end

return GenerateWorldEvent
