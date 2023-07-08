local class = require "middleclass"

local PassAction = require "logic.actions.pass_action"


local DummyAI = class("DummyAI")

function DummyAI:initialize(data)

end

function DummyAI:perform(data)
    data.character:set_action(PassAction())
end

return DummyAI
