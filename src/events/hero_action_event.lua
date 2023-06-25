local class = require "middleclass"


local HeroActionEvent = class("HeroActionEvent")

function HeroActionEvent:initialize(action_type)
    self.action_type = action_type
end

function HeroActionEvent:get_action_type()
    return self.action_type
end

return HeroActionEvent