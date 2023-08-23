local class = require "middleclass"

local ShortSword = require "world.items.short_sword"
local LeatherHelmet = require "world.items.leather_helmet"
local LeatherJacket = require "world.items.leather_jacket"

local Items = require "enums.items"
local ItemLevel = require "enums.item_level"
local ItemTypes = require "enums.items_type"


local ItemFactory = class("ItemFactory")

function ItemFactory:initialize()
    self.items = {
        [ItemLevel.base] = {
            [ItemTypes.armor] = {
                Items.leather_helmet,
                Items.leather_jacket
            },
            [ItemTypes.weapon] = {
                Items.short_sword
            }
        }
    }
end

function ItemFactory:get_random_item(level)
    local items_type_count = 0
    local data = {}

    for item_type, _ in pairs(self.items[level]) do
        items_type_count = items_type_count + 1
        table.insert(data, item_type)
    end

    local rnd = math.random(items_type_count)

    local items = {}
    local items_count = 0

    for _, item_data in pairs(self.items[level][data[rnd]]) do
        items_count = items_count + 1
        table.insert(items, item_data)
    end

    local rnd_item = items[math.random(items_count)]

    local item = nil

    if rnd_item == Items.short_sword then
        item = ShortSword()
    elseif rnd_item == Items.leather_helmet then
        item = LeatherHelmet()
    elseif rnd_item == Items.leather_jacket then
        item = LeatherJacket()
    end

    return item
end

return ItemFactory
