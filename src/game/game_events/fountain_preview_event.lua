local class = require "middleclass"


local FountainPreviewEvent = class("FountainPreviewEvent")

function FountainPreviewEvent:initialize(fountain)
    self.fountain = fountain
end

function FountainPreviewEvent:get_fountain()
    return self.fountain
end

return FountainPreviewEvent
