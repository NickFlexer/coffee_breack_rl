local class = require "middleclass"

local BasicAction = require "logic.actions.basic_action"
local ActionResult = require "logic.actions.action_result"
local FightAction = require "logic.actions.fight_action"

local MovingDirection = require "enums.moving_direction"
local Actions = require "enums.actions"
local EffectTypes = require "enums.effect_types"
local CharacterControl = require "enums.character_control"

local ShowEffectEvent = require "events.show_effect_event"
local ScreenLogEvent = require "events.screen_log_event"


local MoveAction = class("MoveAction", BasicAction)

function MoveAction:initialize(data)
    BasicAction:initialize(self)

    self.type = Actions.move
    self.cost = 10

    if not data.direction then
        error("MoveAction:initialize NO data.direction!")
    end

    self.direction = data.direction
end

function MoveAction:perform(data)
    if not data.actor then
        error("MoveAction:perform NO data.actor!")
    end

    if not data.map then
        error("MoveAction:perform NO data.map!")
    end

    if not data.event_manager then
        error("MoveAction:perform NO data.event_manager!")
    end

    local cur_x, cur_y = data.map:get_character_position(data.actor)
    local new_x, new_y

    if self.direction == MovingDirection.up then
        new_x, new_y = cur_x, cur_y - 1
    elseif self.direction == MovingDirection.down then
        new_x, new_y = cur_x, cur_y + 1
    elseif self.direction == MovingDirection.left then
        new_x, new_y = cur_x - 1, cur_y
    elseif self.direction == MovingDirection.right then
        new_x, new_y = cur_x + 1, cur_y
    end

    if data.map:get_grid():is_valid(new_x, new_y) and data.map:can_move(new_x, new_y) then
        if data.map:get_grid():get_cell(new_x, new_y):get_character() then
            Log.trace("Character!")

            local target = data.map:get_grid():get_cell(new_x, new_y):get_character()

            return ActionResult({succeeded = true, alternate = FightAction({target = target})})
        else
            data.map:move_cahracter(cur_x, cur_y, new_x, new_y)

            if data.actor:get_control() == CharacterControl.player then
                if data.map:get_grid():get_cell(new_x, new_y):get_message() then
                    data.event_manager:fireEvent(
                        ScreenLogEvent(
                            data.map:get_grid():get_cell(new_x, new_y):get_message()
                        )
                    )
                end
            end

            return ActionResult({succeeded = true, alternate = nil})
        end
    else
        Log.trace("Obstacle!")

        if data.actor:get_control() == CharacterControl.player then
            data.event_manager:fireEvent(ScreenLogEvent("Тут не пройти!"))
        end

        data.event_manager:fireEvent(ShowEffectEvent({type = EffectTypes.no_path, x = new_x, y = new_y}))
    end

    return ActionResult({succeeded = false, alternate = nil})
end

return MoveAction
