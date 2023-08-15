local class = require "middleclass"


local BaseItem = class("BaseItem")

function BaseItem:initialize(data)
    self.tile = data.tile
    self.name = data.name

    self.attributes = {}
    self.item_place = nil
end

function BaseItem:get_tile()
    return self.tile
end

function BaseItem:get_name()
    return self.name
end

function BaseItem:get_visible_name()
    return self.visible_name
end

function BaseItem:get_attributes()
    return self.attributes
end

function BaseItem:get_item_place()
    return self.item_place
end

return BaseItem
