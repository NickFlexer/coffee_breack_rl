local class = require "middleclass"

local FSM = require "fsm"

local CarelessState = require "logic.ai.states.careless"
local PassState = require "logic.ai.states.pass"
local FollowPathState = require "logic.ai.states.follow_path"


local RabbitAI = class("RabbitAI")

function RabbitAI:initialize(data)
    self.path = nil

    self.fsm = FSM(self)

    self.states = {
        careless = CarelessState(),
        pass = PassState(),
        follow_path = FollowPathState
    }

    self.fsm:set_current_state(self.states.careless)
end

function RabbitAI:perform(data)
    self.fsm:update(data)

    if self.fsm:is_in_state(self.states.pass) and self.fsm:get_current_state():get_count() > 2 then
        self.fsm:change_state(self.states.careless)
    end

    self.fsm:update(data)
end

function RabbitAI:get_fsm()
    return self.fsm
end

function RabbitAI:get_states()
    return self.states
end

function RabbitAI:set_path(path)
    self.path = path
end

function RabbitAI:get_path()
    return self.path
end

return RabbitAI