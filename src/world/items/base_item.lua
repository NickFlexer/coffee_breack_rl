local class = require "middleclass"


local BaseItem = class("BaseItem")

function BaseItem:initialize(data)
    self.tile = data.tile
    self.name = data.name
end

function BaseItem:get_tile()
    return self.tile
end

function BaseItem:get_name()
    return self.name
end

return BaseItem
