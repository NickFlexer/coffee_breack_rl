local class = require "middleclass"

local MoveAction = require "logic.actions.move_action"
local PassAction = require "logic.actions.pass_action"


local FollowPathState = class("FollowPathState")

function FollowPathState:initialize(data)
    
end

function FollowPathState:enter(owner)
    Log.trace("FollowPathState:enter")
end

function FollowPathState:execute(owner, data)
    Log.trace("FollowPathState:execute")

    if not data.character then
        error("CarelessState:execute no data.character !")
    end

    if not data.map then
        error("CarelessState:execute no data.map !")
    end

    local cur_x, cur_y = data.map:get_character_position(data.character)

    local path = owner:get_path()

    if not path then
        Log.trace("not path revent_to_previous_state")

        return
    end

    if data.map:get_grid():get_cell(path[1].x, path[1].y):get_character() then
        owner:set_path(nil)
        Log.trace("character on cell! revent_to_previous_state")
        return
    else
        local moving = data.character:get_moving_direction(cur_x, cur_y, path[1].x, path[1].y)

        if not moving then
            return
        end

        data.character:set_action(MoveAction({direction = moving}))

        Log.trace("STEP")
    end

    table.remove(path, 1)

    if #path < 1 then
        Log.trace("#path < 1 revent_to_previous_state")

        owner:set_path(nil)

        return
    end
end

function FollowPathState:exit(owner)
    Log.trace("FollowPathState:exit")
end

return FollowPathState
