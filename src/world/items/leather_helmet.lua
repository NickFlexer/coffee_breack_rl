local class = require "middleclass"

local BaseItem = require "world.items.base_item"

local Cells = require "enums.cells"
local Items = require "enums.items"
local CharacterAttributes = require "enums.character_attributes"
local ItemPlace = require "enums.item_place"


local LeatherHelmet = class("LeatherHelmet", BaseItem)

function LeatherHelmet:initialize()
    BaseItem:initialize()

    self.name = Items.leather_helmet
    self.tile = Cells.leather_helmet
    self.visible_name = "Кожаный шлем"
    self.attributes = {CharacterAttributes.defence, CharacterAttributes.quality}
    self.item_place = ItemPlace.head

    self.cur_quality = 10
    self.max_quality = 10
end

function LeatherHelmet:get_defence_bust()
    return 1
end

return LeatherHelmet
