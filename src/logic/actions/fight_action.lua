local class = require "middleclass"

local BasicAction = require "logic.actions.basic_action"
local ActionResult = require "logic.actions.action_result"

local Actions = require "enums.actions"
local EffectTypes = require "enums.effect_types"

local ShowEffectEvent = require "events.show_effect_event"


local FightAction = class("FightAction", BasicAction)

function FightAction:initialize(data)
    BasicAction:initialize(self)

    if not data.target then
        error("MoveAction:perform NO data.target!")
    end

    self.target = data.target
    self.type = Actions.fight
end

function FightAction:perform(data)
    Log.trace("FIGHT!")

    if not data.actor then
        error("MoveAction:perform NO data.actor!")
    end

    if not data.map then
        error("MoveAction:perform NO data.map!")
    end

    local x, y = data.map:get_character_position(self.target)

    data.event_manager:fireEvent(ShowEffectEvent({type = EffectTypes.fight, x = x, y = y}))

    local actor_attack = data.actor:new_attack()

    self.target:decreace_hp(actor_attack)

    if self.target:is_dead() then
        Log.trace(data.actor.class.name .." hit " .. self.target.class.name .." and caused damage " .. actor_attack ..
            ". " .. self.target.class.name .. " is dead!"
        )

        data.map:kill_character(self.target)
    else
        Log.trace(data.actor.class.name .." hit " .. self.target.class.name .." and caused damage " .. actor_attack ..
            ". " .. self.target.class.name .. " is still alive!"
        )
    end

    return ActionResult({succeeded = true, alternate = nil})
end

return FightAction