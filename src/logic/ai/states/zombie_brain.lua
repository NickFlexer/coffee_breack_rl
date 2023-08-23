local class = require "middleclass"


local ZombieBrainState = class("ZombieBrainState")

function ZombieBrainState:initialize()
    self.see_hero = false
end

function ZombieBrainState:enter(owner)
    Log.trace("ZombieBrainState:enter")
end

function ZombieBrainState:execute(owner, data)
    Log.trace("ZombieBrainState:execute")

    if not data.character then
        error("CarelessState:execute no data.character !")
    end

    if not data.map then
        error("CarelessState:execute no data.map !")
    end

    local hero = data.map:get_hero()
    local hero_pos_x, hero_pos_y = data.map:get_character_position(hero)
    local cur_pos_x, cur_pos_y = data.map:get_character_position(data.character)

    if data.map:is_character_near(data.character, hero) then
        Log.trace("Попался!!")
        owner:get_fsm():change_state(owner:get_states().fight)

        owner:get_fsm():get_current_state():set_target(hero)

        return
    end

    if data.map:can_see(data.character, hero) then
        Log.trace("It see you!!")
        self.see_hero = true

        owner:set_last_hero_pos(hero_pos_x, hero_pos_y)
    else
        self.see_hero = false
    end

    if self.see_hero then
        Log.trace("It see hero")

        local last_x, last_y = owner:get_last_hero_pos()

        if hero_pos_x == last_x and hero_pos_y == last_y then
            local path = data.map:solve_path(cur_pos_x, cur_pos_y, last_x, last_y)

            if path then
                owner:set_path(path)
                owner:get_fsm():change_state(owner:get_states().follow_path)

                return
            end
        end
    end

    if not owner:get_path() then
        local neighbours = {
            {-1, 0},
            {1, 0},
            {0, -1},
            {0, 1}
        }

        while true do
            local new_pos = neighbours[math.random(1, #neighbours)]
            Log.trace(new_pos[1], new_pos[2])

            if data.map:can_move(cur_pos_x + new_pos[1], cur_pos_y + new_pos[2]) then
                local path = data.map:solve_path(cur_pos_x, cur_pos_y, cur_pos_x + new_pos[1], cur_pos_y + new_pos[2])

                Log.trace("Cur pos! " .. cur_pos_x, cur_pos_y)

                if path and #path > 0 then
                    Log.trace("Path found! " .. #path)
                    owner:set_path(path)
                    owner:get_fsm():change_state(owner:get_states().follow_path)

                    return
                else
                    Log.trace("No path!")

                    return
                end
            else
                Log.trace("No way!")
                owner:get_fsm():change_state(owner:get_states().pass)

                return
            end
        end
    end
end

function ZombieBrainState:exit(owner)
    Log.trace("ZombieBrainState:exit")
end

return ZombieBrainState
