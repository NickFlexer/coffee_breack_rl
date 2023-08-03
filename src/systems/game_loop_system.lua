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

    if not data.game_event_manager then
        error("GameLoopSystem:initialize NO data.game_event_manager!")
    end

    self.map = data.map
    self.event_manager = data.event_manager
    self.still_playing = true
    self.game_event_manager = data.game_event_manager
end

function GameLoopSystem:update(dt)
    local actor = self.map:get_characters():get()

    local action = actor:get_action()

    if not action then
        return
    end

    while true do
        local result = action:perform(
            {actor = actor, map = self.map, event_manager = self.event_manager, game_event_manager = self.game_event_manager}
        )

        Log.debug("ACTOR " .. actor.class.name)

        self.event_manager:fireEvent(SolveFovEvent())
        self.event_manager:fireEvent(UpdateViewEvent())

        if not result:is_success() then
            return
        end

        if not result:get_alternate() then
            break
        end

        action = result:get_alternate()
    end

    self.map:get_characters():next()
end

function GameLoopSystem:requires()
    return {}
end

return GameLoopSystem
