local class = require "middleclass"

local BaseItem = require "world.items.base_item"

local Cells = require "enums.cells"
local Items = require "enums.items"
local Colors = require "enums.colors"


local ShortSword = class("ShortSword", BaseItem)

function ShortSword:initialize()
    BaseItem:initialize({
        tile = Cells.short_sword,
        name = Items.short_sword
    })
end

function ShortSword:get_message()
    local message = {
        Colors.white, "Тут лежит ",
        Colors.green, "Короткий меч",
        Colors.white, ". Нажмите ",
        Colors.orange, "Enter",
        Colors.white, " чтобы подобрать"
    }

    return message
end

return ShortSword
