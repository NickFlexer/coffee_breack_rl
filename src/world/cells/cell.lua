local class = require "middleclass"

local cells = require "enums.cells"


local Cell = class("Cell")

function Cell:initialize()
    self.name = cells.cell
    self.character = nil
    self.bones = false
    self.move_blocked = false

    self.obscured = true
    self.visible = false
    self.transparent = true
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

return Cell