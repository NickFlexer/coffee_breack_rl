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

    Log.trace("POSITION " .. cur_x, cur_y)
    Log.trace("PATH " .. path[2].x, path[2].y)

    if data.map:get_grid():get_cell(path[2].x, path[2].y):get_character() then
        owner:get_fsm():change_state(owner:get_states().careless)
    else
        local moving = data.character:get_moving_direction(cur_x, cur_y, path[2].x, path[2].y)

        if not moving then
            owner:get_fsm():change_state(owner:get_states().careless)

            return
        end

        data.character:set_action(MoveAction({direction = moving}))

        Log.trace("STEP")
    end

    table.remove(path, 2)

    if #path == 1 then
        owner:get_fsm():change_state(owner:get_states().careless)

        return
    end
end

function FollowPathState:exit(owner)
    Log.trace("FollowPathState:exit")
end

return FollowPathState
