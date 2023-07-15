local class = require "middleclass"


local ShowEffectEvent = class("ShowEffectEvent")

function ShowEffectEvent:initialize(data)
    self.type = data.type
    self.x = data.x
    self.y = data.y
end

function ShowEffectEvent:get_type()
    return self.type
end

function ShowEffectEvent:get_position()
    return self.x, self.y
end

return ShowEffectEvent
