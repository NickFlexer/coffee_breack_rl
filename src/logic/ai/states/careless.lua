local class = require "middleclass"


local CarelessState = class("CarelessState")

function CarelessState:initialize(data)

end

function CarelessState:enter(owner)
    print("CarelessState:enter")

    owner:set_path(nil)
end

function CarelessState:execute(owner, data)
    if not data.character then
        error("CarelessState:execute no data.character !")
    end

    if not data.map then
        error("CarelessState:execute no data.map !")
    end

    local cur_x, cur_y = data.map:get_character_position(data.character)
    print(cur_x, cur_y)

    local aim_x, aim_y

    while true do
        aim_x, aim_y = math.random(cur_x - 4, cur_x + 4), math.random(cur_y - 4, cur_y + 4)
        print("AIM " .. aim_x, aim_y)

        if data.map:can_move(aim_x, aim_y) and (cur_x ~= aim_x and cur_y ~= aim_y) then
            break
        end
    end

    local path = data.map:solve_path(cur_x, cur_y, aim_x, aim_y)

    if path then
        owner:set_path(path)
        owner:get_fsm():change_state(owner:get_states().follow_path)
    else
        owner:get_fsm():change_state(owner:get_states().pass)
    end
end

function CarelessState:exit(owner)
    print("CarelessState:exit")
end

return CarelessState
