local class = require "middleclass"

local Input = require 'Input'

local HeroActionEvent = require "events.hero_action_event"
local MovingDirection = require "enums.moving_direction"

local Actions = require "enums.actions"

local ExitMenuEvent = require "game.game_events.exit_menu_event"


local InputSystem = class("InputSystem", System)

function InputSystem:initialize(data)
    System.initialize(self)

    if not data.event_manager then
        error("InputSystem:initialize NO data.event_manager!")
    end

    if not data.game_event_manager then
        error("InputSystem:initialize NO data.game_event_manager!")
    end

    self.event_manager = data.event_manager
    self.game_event_manager = data.game_event_manager

    self.input = Input()

    self.buttons = {
        {"w", "UP", function () self.event_manager:fireEvent(HeroActionEvent(MovingDirection.up)) end},
        {"s", "DOWN", function () self.event_manager:fireEvent(HeroActionEvent(MovingDirection.down)) end},
        {"a", "LEFT", function () self.event_manager:fireEvent(HeroActionEvent(MovingDirection.left)) end},
        {"d", "RIGHT", function () self.event_manager:fireEvent(HeroActionEvent(MovingDirection.right)) end},

        {"p", "PASS", function () self.event_manager:fireEvent(HeroActionEvent(Actions.pass)) end},

        {"return", "ENTER", function () self.event_manager:fireEvent(HeroActionEvent(Actions.interaction)) end},
        {"escape", "ESC", function () self.game_event_manager:fireEvent(ExitMenuEvent()) end}
    }

    for _, button in ipairs(self.buttons) do
        self.input:bind(button[1], button[2])
    end
end

function InputSystem:update(dt)
    for _, button in ipairs(self.buttons) do
        if self.input:down(button[2], 0.5) then
            button[3]()

            return
        end
    end
end

function InputSystem:requires()
    return {}
end

return InputSystem
