local class = require "middleclass"

local Input = require 'Input'

local HeroActionEvent = require "events.hero_action_event"
local MovingDirection = require "enums.moving_direction"

local Actions = require "enums.actions"


local InputSystem = class("InputSystem", System)

function InputSystem:initialize(data)
    System.initialize(self)

    if not data.event_manager then
        error("InputSystem:initialize NO data.event_manager!")
    end

    self.event_manager = data.event_manager

    self.input = Input()

    self.buttons = {
        {"w", MovingDirection.up},
        {"s", MovingDirection.down},
        {"a", MovingDirection.left},
        {"d", MovingDirection.right},

        {"p", Actions.pass}
    }

    for _, button in ipairs(self.buttons) do
        self.input:bind(button[1], button[2])
    end
end

function InputSystem:update(dt)
    for _, button in ipairs(self.buttons) do
        if self.input:down(button[2], 0.5) then
            self.event_manager:fireEvent(HeroActionEvent(button[2]))

            return
        end
    end
end

function InputSystem:requires()
    return {}
end

return InputSystem
