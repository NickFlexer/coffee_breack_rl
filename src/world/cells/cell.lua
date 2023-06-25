local class = require "middleclass"

local cells = require "enums.cells"


local Cell = class("Cell")

function Cell:initialize()
    self.name = cells.cell
    self.character = nil
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

return Cell