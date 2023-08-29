local class = require "middleclass"

local BasicAction = require "logic.actions.basic_action"
local ActionResult = require "logic.actions.action_result"

local Actions = require "enums.actions"
local EffectTypes = require "enums.effect_types"
local CharacterControl = require "enums.character_control"
local Colors = require "enums.colors"

local ShowEffectEvent = require "events.show_effect_event"
local ScreenLogEvent = require "events.screen_log_event"
local HeroDeadEvent = require "events.hero_dead_event"


local FightAction = class("FightAction", BasicAction)

function FightAction:initialize(data)
    BasicAction:initialize(self)

    if not data.target then
        error("FightAction:perform NO data.target!")
    end

    self.target = data.target
    self.type = Actions.fight
    self.cost = 10
end

function FightAction:perform(data)
    Log.trace("FIGHT!")

    if not data.actor then
        error("FightAction:perform NO data.actor!")
    end

    if not data.map then
        error("FightAction:perform NO data.map!")
    end

    local x, y = data.map:get_character_position(self.target)

    data.event_manager:fireEvent(ShowEffectEvent({type = EffectTypes.fight, x = x, y = y}))

    if math.random(0, 100) > data.actor:get_hit_chance() then
        data.event_manager:fireEvent(
            ScreenLogEvent(
                {
                    Colors.red, data.actor.class.name,
                    Colors.white, " промахивается!"
                }
            )
        )

        return ActionResult({succeeded = true, alternate = nil})
    end

    local actor_damage = data.actor:new_damage()
    local is_crit = false

    if math.random(0, 100) <= data.actor:get_crit_chance() then
        actor_damage = actor_damage * 2
        is_crit = true
    end

    if not is_crit then
        if math.random(0, 100) <= data.actor:get_protection_chance() then
            data.event_manager:fireEvent(
                ScreenLogEvent(
                    {
                        Colors.red, data.actor.class.name,
                        Colors.white, " бьет ",
                        Colors.red, self.target.class.name,
                        Colors.white, ". Но ",
                        Colors.red, self.target.class.name,
                        Colors.white, " ловко отбивает удар!"
                    }
                )
            )

            return ActionResult({succeeded = true, alternate = nil})
        end
    end

    local target_defence = self.target:get_defence()
    local result_damage = actor_damage - target_defence

    if actor_damage - target_defence < 0 then
        result_damage = 0
    end

    if target_defence > 0 then
        self.target:decreace_armor_quality(target_defence)
    end

    if result_damage > 0 then
        data.actor:decreace_weapon_quality(result_damage)
    end

    self.target:decreace_hp(result_damage)
    local is_target_item_destroyed = self.target:check_item_destroyed()
    local is_actor_item_destroyed = data.actor:check_item_destroyed()

    if self.target:is_dead() then
        Log.trace(data.actor.class.name .." hit " .. self.target.class.name .." and caused damage " .. actor_damage ..
            ". " .. self.target.class.name .. " is dead!"
        )

        if is_crit then
            data.event_manager:fireEvent(
                ScreenLogEvent(
                    {
                        Colors.red, data.actor.class.name,
                        Colors.white, " бьет ",
                        Colors.red, self.target.class.name,
                        Colors.white, " и вносит урон ",
                        Colors.orange, actor_damage - target_defence,
                        Colors.white, ". ",
                        Colors.white, "Зщита отбила ",
                        Colors.orange, target_defence,
                        Colors.white, " урона ",
                        Colors.red, self.target.class.name,
                        Colors.white, " мертв!"
                    }
                )
            )
        else
            data.event_manager:fireEvent(
                ScreenLogEvent(
                    {
                        Colors.red, data.actor.class.name,
                        Colors.white, " бьет ",
                        Colors.red, self.target.class.name,
                        Colors.white, " и вносит ",
                        Colors.red, "критический",
                        Colors.white," урон ",
                        Colors.orange, actor_damage - target_defence,
                        Colors.white, ". ",
                        Colors.white, "Зщита отбила ",
                        Colors.orange, target_defence,
                        Colors.white, " урона ",
                        Colors.red, self.target.class.name,
                        Colors.white, " мертв!"
                    }
                )
            )
        end

        if self.target:get_control() == CharacterControl.player then
            Log.debug("Player is dead!!")
            data.event_manager:fireEvent(HeroDeadEvent())

            return ActionResult({succeeded = false, alternate = nil})
        end

        data.map:kill_character(self.target)
    else
        Log.trace(data.actor.class.name .." hit " .. self.target.class.name .." and caused damage " .. actor_damage ..
            ". " .. self.target.class.name .. " is still alive!"
        )

        if is_crit then
            data.event_manager:fireEvent(
                ScreenLogEvent(
                    {
                        Colors.red, data.actor.class.name,
                        Colors.white, " бьет ",
                        Colors.red, self.target.class.name,
                        Colors.white, " и вносит ",
                        Colors.red, "критический",
                        Colors.white," урон ",
                        Colors.orange, actor_damage - target_defence,
                        Colors.white, ". Зщита отбила ",
                        Colors.orange, target_defence,
                        Colors.white, " урона. ",
                        Colors.red, self.target.class.name,
                        Colors.white, " все еще жив!"
                    }
                )
        )
        else
            data.event_manager:fireEvent(
                ScreenLogEvent(
                    {
                        Colors.red, data.actor.class.name,
                        Colors.white, " бьет ",
                        Colors.red, self.target.class.name,
                        Colors.white, " и вносит урон ",
                        Colors.orange, actor_damage - target_defence,
                        Colors.white, ". Зщита отбила ",
                        Colors.orange, target_defence,
                        Colors.white, " урона. ",
                        Colors.red, self.target.class.name,
                        Colors.white, " все еще жив!"
                    }
                )
            )
        end
    end

    if is_target_item_destroyed then
        for _, item_data in ipairs(is_target_item_destroyed) do
            data.event_manager:fireEvent(
                ScreenLogEvent(
                    {
                        Colors.red, item_data.name,
                        Colors.white, " безвозвратно разрушается!"
                    }
                )
            )
        end
    end

    if is_actor_item_destroyed then
        for _, item_data in ipairs(is_actor_item_destroyed) do
            data.event_manager:fireEvent(
                ScreenLogEvent(
                    {
                        Colors.red, item_data.name,
                        Colors.white, " безвозвратно разрушается!"
                    }
                )
            )
        end
    end

    return ActionResult({succeeded = true, alternate = nil})
end

return FightAction