local class = require "middleclass"


local ItemPreviewEvent = class("ItemPreviewEvent")

function ItemPreviewEvent:initialize(item)
    self.item = item
end

function ItemPreviewEvent:get_item()
    return self.item
end

return ItemPreviewEvent
