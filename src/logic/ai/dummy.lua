local class = require "middleclass"

local BaseAI = require "logic.ai.base_ai"

local PassAction = require "logic.actions.pass_action"


local DummyAI = class("DummyAI", BaseAI)

function DummyAI:initialize(data)
    BaseAI:initialize(self)

    self.fsm:set_owner(self)
end

function DummyAI:perform(data)
    data.character:set_action(PassAction())
end

return DummyAI
