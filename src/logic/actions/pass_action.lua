local class = require "middleclass"

local BasicAction = require "logic.actions.basic_action"
local ActionResult = require "logic.actions.action_result"

local Actions = require "enums.actions"


local PassAction = class("PassAction", BasicAction)

function PassAction:initialize(data)
    BasicAction:initialize(self)

    self.type = Actions.pass
end

function PassAction:perform(data)
    Log.trace("PASS!")

    return ActionResult({succeeded = true, alternate = nil})
end

return PassAction

