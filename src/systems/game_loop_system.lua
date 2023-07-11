local class = require "middleclass"

local UpdateViewEvent = require "events.update_view_event"
local SolveFovEvent = require "events.solve_fov_event"


local GameLoopSystem = class("GameLoopSystem", System)

function GameLoopSystem:initialize(data)
    System.initialize(self)

    if not data.map then
        error("GameLoopSystem:initialize NO data.map!")
    end

    if not data.event_manager then
        error("GameLoopSystem:initialize NO data.event_manager!")
    end

    self.map = data.map
    self.event_manager = data.event_manager
    self.still_playing = true
end

function GameLoopSystem:update(dt)
    local actor = self.map:get_characters():get()

    local action = actor:get_action()

    if not action then
        return
    end

    local success = action:perform({actor = actor, map = self.map})

    print("ACTOR " .. actor.class.name)

    if success then
        self.event_manager:fireEvent(SolveFovEvent())
        self.event_manager:fireEvent(UpdateViewEvent())
    end

    self.map:get_characters():next()
end

function GameLoopSystem:requires()
    return {}
end

return GameLoopSystem
