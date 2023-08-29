local class = require "middleclass"

local BaseItem = require "world.items.base_item"

local Cells = require "enums.cells"
local Items = require "enums.items"
local CharacterAttributes = require "enums.character_attributes"
local ItemPlace = require "enums.item_place"


local LeatherJacket = class("LeatherJacket", BaseItem)

function LeatherJacket:initialize()
    BaseItem:initialize()

    self.name = Items.leather_jacket
    self.tile = Cells.leather_jacket
    self.visible_name = "Кожаная куртка"
    self.attributes = {CharacterAttributes.defence, CharacterAttributes.quality}
    self.item_place = ItemPlace.body

    self.cur_quality = 10
    self.max_quality = 10
end

function LeatherJacket:get_defence_bust()
    return 1
end

return LeatherJacket
