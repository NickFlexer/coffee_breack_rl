local class = require "middleclass"

local CharacterControl = require "enums.character_control"


local AISystem = class("AISystem", System)

function AISystem:initialize(data)
    System.initialize(self)

    if not data.map then
        error("AISystem:initialize data.map is nil!")
    end

    self.map = data.map
end

function AISystem:update(dt)
    local character = self.map:get_characters():get()

    if character:get_control() == CharacterControl.ai then
        if not character:get_action() then
            character:think({character = character})
        end
    end
end

function AISystem:requires()
    return {}
end

return AISystem
