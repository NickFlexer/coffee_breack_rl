local class = require "middleclass"

local BasicAction = require "logic.actions.basic_action"
local ActionResult = require "logic.actions.action_result"

local Actions = require "enums.actions"
local CharacterControl = require "enums.character_control"
local MapType = require "enums.map_type"

local ScreenLogEvent = require "events.screen_log_event"

local GenerateWorldEvent = require "game.game_events.generate_world_event"

local Stairs = require "world.cells.stairs"


local InteractionAction = class("InteractionAction", BasicAction)

function InteractionAction:initialize(data)
    BasicAction:initialize(self)

    self.type = Actions.interaction
    self.cost = 10
end

function InteractionAction:perform(data)
    if not data.actor then
        error("InteractionAction:perform NO data.actor!")
    end

    if not data.event_manager then
        error("InteractionAction:perform NO data.event_manager!")
    end

    if not data.game_event_manager then
        error("InteractionAction:perform NO data.game_event_manager!")
    end

    if not data.map then
        error("InteractionAction:perform NO data.map!")
    end

    if data.actor:get_control() == CharacterControl.player then
        local pos_x, pos_y = data.map:get_character_position(data.actor)

        if data.map:get_grid():get_cell(pos_x, pos_y).class.name == Stairs.name then
            data.event_manager:fireEvent(ScreenLogEvent("Ты спускаешься по лестнице!"))

            data.game_event_manager:fireEvent(GenerateWorldEvent(MapType.mushroom_forest))

            return ActionResult({succeeded = true, alternate = nil})
        end

        data.event_manager:fireEvent(ScreenLogEvent("Тут не с чем взаимодействовать!"))
    end

    Log.trace("INTERACTION!")

    return ActionResult({succeeded = true, alternate = nil})
end

return InteractionAction

