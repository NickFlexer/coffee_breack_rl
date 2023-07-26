local class = require "middleclass"

local BaseAI = require "logic.ai.base_ai"

local CarelessState = require "logic.ai.states.careless"
local PassState = require "logic.ai.states.pass"
local FollowPathState = require "logic.ai.states.follow_path"


local RabbitAI = class("RabbitAI", BaseAI)

function RabbitAI:initialize(data)
    BaseAI:initialize(self)

    self.states = {
        careless = CarelessState(),
        pass = PassState(),
        follow_path = FollowPathState()
    }
    self.fsm:set_owner(self)
    self.fsm:set_current_state(self.states.careless)
end

function RabbitAI:perform(data)
    if self.fsm:is_in_state(self.states.pass) and self.fsm:get_current_state():get_count() > 2 then
        self.fsm:change_state(self.states.careless)
    end

    self.fsm:update(data)
end

return RabbitAI
