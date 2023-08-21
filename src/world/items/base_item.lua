local class = require "middleclass"

local Colors = require "enums.colors"


local BaseItem = class("BaseItem")

function BaseItem:initialize(data)
    self.tile = nil
    self.name = nil
    self.visible_name = ""

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

function BaseItem:get_message()
    local message = {
        Colors.white, "Тут лежит ",
        Colors.green, self.visible_name,
        Colors.white, ". Нажмите ",
        Colors.orange, "Enter",
        Colors.white, " чтобы подобрать"
    }

    return message
end

return BaseItem
