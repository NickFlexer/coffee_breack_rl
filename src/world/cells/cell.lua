local class = require "middleclass"

local cells = require "enums.cells"


local Cell = class("Cell")

function Cell:initialize()
    self.name = cells.cell
    self.character = nil
    self.item = nil
    self.bones = false
    self.move_blocked = false

    self.obscured = true
    self.visible = false
    self.transparent = true
    self.item_possibility = false
end

function Cell:get_name()
    return self.name
end

function Cell:set_character(character)
    self.character = character
end

function Cell:get_character()
    return self.character
end

function Cell:remove_character()
    local character = self.character
    self.character = nil

    return character
end

function Cell:get_bones()
    return self.bones
end

function Cell:set_bones()
    self.bones = true
end

function Cell:is_move_blocked()
    return self.move_blocked
end

function Cell:is_obscured()
    return self.obscured
end

function Cell:is_transparent()
    return self.transparent
end

function Cell:illuminate()
    self.obscured = false
end

function Cell:is_visible()
    return self.visible
end

function Cell:set_visible(visible)
    self.visible = visible
end

function Cell:set_item(item)
    self.item = item
end

function Cell:get_item()
    return self.item
end

function Cell:remove_item()
    local item = self.item
    self.item = nil

    return item
end

function Cell:can_place_item()
    return self.item_possibility
end

function Cell:get_message()
    local message = nil

    if self.bones then
        message = "Тут лежат кости твоих врагов"
    end

    if self.item then
        message = self.item:get_message()
    end

    return message
end

return Cell