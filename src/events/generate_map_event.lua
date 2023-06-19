local class = require "middleclass"


local GenerateMapEvent = class("GenerateMapEvent")

function GenerateMapEvent:initialize(map_type)
    self.map_type = map_type
end

function GenerateMapEvent:get_map_type()
    return self.map_type
end

return GenerateMapEvent