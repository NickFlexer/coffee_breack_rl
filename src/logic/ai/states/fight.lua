local class = require "middleclass"

local FightAction = require "logic.actions.fight_action"


local FightState = class("FightState")

function FightState:initialize()
    self.target = nil
end

function FightState:enter(owner)
    Log.trace("FightState:enter")

end

function FightState:execute(owner, data)
    Log.trace("FightState:execute")

    if self.target then
        data.character:set_action(FightAction({target = self.target}))

        self.target = nil
    else
        self.target = nil

        return
    end
end

function FightState:exit(owner)
    Log.trace("FightState:exit")
end

function FightState:set_target(target)
    self.target = target
end

return FightState
