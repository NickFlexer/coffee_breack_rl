local class = require "middleclass"

local PassAction = require "logic.actions.pass_action"


local PassState = class("PassState")

function PassState:initialize(data)
    self.count = 0
end

function PassState:enter(owner)
    print("PassState:enter")

    self.count = 0
end

function PassState:execute(owner, data)
    data.character:set_action(PassAction())

    self.count = self.count + 1

    print("PASS COUNT " .. self.count)
end

function PassState:exit(owner)
    print("PassState:exit")
end

function PassState:get_count()
    return self.count
end

return PassState
