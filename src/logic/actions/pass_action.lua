local class = require "middleclass"

local BasicAction = require "logic.actions.basic_action"
local ActionResult = require "logic.actions.action_result"

local Actions = require "enums.actions"
local CharacterControl = require "enums.character_control"

local ScreenLogEvent = require "events.screen_log_event"


local PassAction = class("PassAction", BasicAction)

function PassAction:initialize(data)
    BasicAction:initialize(self)

    self.type = Actions.pass
end

function PassAction:perform(data)
    if not data.actor then
        error("PassAction:perform NO data.actor!")
    end

    if not data.event_manager then
        error("PassAction:perform NO data.event_manager!")
    end

    if data.actor:get_control() == CharacterControl.player then
        data.event_manager:fireEvent(ScreenLogEvent("Пас"))
    end

    Log.trace("PASS!")

    return ActionResult({succeeded = true, alternate = nil})
end

return PassAction

