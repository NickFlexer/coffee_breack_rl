local class = require "middleclass"


local CarelessState = class("CarelessState")

function CarelessState:initialize(data)

end

function CarelessState:enter(owner)
    Log.trace("CarelessState:enter")

    owner:set_path(nil)
end

function CarelessState:execute(owner, data)
    Log.trace("CarelessState:execute")

    if not data.character then
        error("CarelessState:execute no data.character !")
    end

    if not data.map then
        error("CarelessState:execute no data.map !")
    end

    local pass_chance = math.random(100)

    if pass_chance < 30 then
        Log.trace("It ganes pass!")
        owner:get_fsm():change_state(owner:get_states().pass)

        return
    end

    local cur_x, cur_y = data.map:get_character_position(data.character)
    Log.trace("CURRENT POSITION: " .. cur_x, cur_y)

    local aim_x, aim_y

    while true do
        aim_x, aim_y = math.random(cur_x - 4, cur_x + 4), math.random(cur_y - 4, cur_y + 4)

        if data.map:can_move(aim_x, aim_y) and (cur_x ~= aim_x and cur_y ~= aim_y) then
            Log.trace("Aim find! " .. aim_x, aim_y)

            local path = data.map:solve_path(cur_x, cur_y, aim_x, aim_y)

            if path then
                owner:set_path(path)
                owner:get_fsm():change_state(owner:get_states().follow_path)

                return
            else
                Log.trace("No path!")
                owner:get_fsm():change_state(owner:get_states().pass)

                return
            end
        else
            Log.trace("Resolve aim")
        end
    end
end

function CarelessState:exit(owner)
    Log.trace("CarelessState:exit")
end

return CarelessState
