local class = require "middleclass"

local Input = require "Input"
local Timer = require "hump.timer"

local UpEvent = require "menu.menu_events.up_event"
local DownEvent = require "menu.menu_events.down_event"
local EnterEvent = require "menu.menu_events.enter_event"


local MenuInput = class("MenuInput")

function MenuInput:initialize(data)
    if not data.event_manager then
        error("MenuInput:initialize NO data.event_manager!")
    end

    self.event_manager = data.event_manager

    self.timer = Timer.new()
    self.input = Input()

    self.buttons = {
        {"w", "UP", function () self.event_manager:fireEvent(UpEvent()) end},
        {"s", "DOWN", function () self.event_manager:fireEvent(DownEvent()) end},
        {"return", "ENTER", function () self.event_manager:fireEvent(EnterEvent()) end}
    }
end

function MenuInput:set_keys()
    for _, button in ipairs(self.buttons) do
        self.input:bind(button[1], button[2])
    end

    self.timer:every(
        0.1,
        function()
            for _, button in ipairs(self.buttons) do
                if self.input:down(button[2]) then
                    button[3]()

                    return
                end
            end
        end
    )
end

function MenuInput:update(dt)
    self.timer:update(dt)
end

function MenuInput:clear_keys()
    for _, button in ipairs(self.buttons) do
        self.input:unbind(button[1])
    end

    self.timer:clear()
end

return MenuInput
