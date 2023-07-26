local class = require "middleclass"

local BaseAI = require "logic.ai.base_ai"

local FollowPathState = require "logic.ai.states.follow_path"
local PassState = require "logic.ai.states.pass"
local ZombieBrainState = require "logic.ai.states.zombie_brain"
local FightState = require "logic.ai.states.fight"


local ZombieAI = class("ZombieAI", BaseAI)

function ZombieAI:initialize(data)
    BaseAI:initialize(self)

    self.states = {
        follow_path = FollowPathState(),
        pass = PassState(),
        zombie_brain = ZombieBrainState(),
        fight = FightState()
    }

    self.fsm:set_owner(self)
    self.fsm:set_global_state(self.states.zombie_brain)
    self.fsm:set_current_state(self.states.pass)
    self.fsm:set_previous_state(self.states.pass)

    self.last_hero_pos = {x = nil, y = nil}
end

function ZombieAI:perform(data)
    self.fsm:update(data)
end

function ZombieAI:get_last_hero_pos()
    return self.last_hero_pos.x, self.last_hero_pos.y
end

function ZombieAI:set_last_hero_pos(x, y)
    self.last_hero_pos = {x = x, y = y}
end

return ZombieAI