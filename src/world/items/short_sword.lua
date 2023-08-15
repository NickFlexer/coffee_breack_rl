local class = require "middleclass"

local BaseItem = require "world.items.base_item"

local Cells = require "enums.cells"
local Items = require "enums.items"
local Colors = require "enums.colors"
local CharacterAttributes = require "enums.character_attributes"
local ItemPlace = require "enums.item_place"


local ShortSword = class("ShortSword", BaseItem)

function ShortSword:initialize()
    BaseItem:initialize({
        tile = Cells.short_sword,
        name = Items.short_sword
    })

    self.visible_name = "Короткий меч"
    self.attributes = {CharacterAttributes.damage}
    self.item_place = ItemPlace.right_hand
end

function ShortSword:get_message()
    local message = {
        Colors.white, "Тут лежит ",
        Colors.green, self.visible_name,
        Colors.white, ". Нажмите ",
        Colors.orange, "Enter",
        Colors.white, " чтобы подобрать"
    }

    return message
end

function ShortSword:get_damage_bust()
    return {min = 1, max = 1}
end

return ShortSword
