local class = require "middleclass"

local Grid = require "grid"

local Ground = require "world.cells.ground"
local Mushroom = require "world.cells.mushroom"
local Stairs = require "world.cells.stairs"

local Cells = require "enums.cells"
local MonsterLevel = require "enums.monster_level"
local ItemLevel = require "enums.item_level"

local MonsterFactory = require "world.factories.monster_factory"
local ItemFactory = require "world.factories.item_factory"


local MushroomForestGenerator = class("MushroomForestGenerator")

function MushroomForestGenerator:initialize()
    self.base_density = 50

    self.monster_factory = MonsterFactory()
    self.item_factory = ItemFactory()
end

function MushroomForestGenerator:generate(map, world_number)
    map:clear_data()
    local map_grid = map:get_grid()

    self:_make_noise_grid(map_grid)
    self:_apply_celular_automata(map_grid, 2)

    self:_set_hero(map)

    while true do
        local stair_result = self:_set_stairs(map)

        if stair_result then
            break
        else
            return false
        end
    end

    local monsters_number = math.random(1, 4)

    for i = 1, monsters_number do
        local unit = self.monster_factory:get_random_monster(MonsterLevel.base)

        if not self:_set_monster(map, unit) then
            return false
        end
    end

    local item_number = math.random(1, 3)

    for i = 1, item_number do
        local item = self.item_factory:get_random_item(ItemLevel.base)

        if not self:_set_item(map, item) then
            return false
        end
    end

    map:set_title("Грибной лес")
    map:set_world_number(world_number)

    return true
end

function MushroomForestGenerator:_make_noise_grid(grid)
    local density = math.random(self.base_density - 5, self.base_density + 5)

    for x, y, _ in grid:iterate() do
        if math.random(100) > density then
            grid:set_cell(x, y, Ground())
        else
            grid:set_cell(x, y, Mushroom())
        end
    end
end

function MushroomForestGenerator:_apply_celular_automata(grid, max_count)
    for count = 1, max_count do
        local temp_grid = self:_copy_grid(grid)

        for x, y, _ in temp_grid:iterate() do
            local neighbor_count = self:_calculate_neighbor(temp_grid, x, y)

            if neighbor_count > 4 then
                grid:set_cell(x, y, Mushroom())
            else
                grid:set_cell(x, y, Ground())
            end
        end
    end
end

function MushroomForestGenerator:_copy_grid(grid)
    local size_x, size_y = grid:get_size()

    local new_grid = Grid(size_x, size_y)

    for x, y, _ in grid:iterate() do
        local new_cell = nil

        if grid:get_cell(x, y):get_name() == Cells.ground then
            new_cell = Ground()
        elseif grid:get_cell(x, y):get_name() == Cells.mushroom then
            new_cell = Mushroom()
        end

        new_grid:set_cell(x, y, new_cell)
    end

    return new_grid
end

function MushroomForestGenerator:_calculate_neighbor(grid, x, y)
    local count = 0

    for i = x - 1, x + 1 do
        for j = y - 1, y + 1 do
            if grid:is_valid(i, j) then
                if i ~= x or j ~= y then
                    if grid:get_cell(i, j):get_name() == Cells.mushroom then
                        count = count + 1
                    end
                end
            else
                count = count + 1
            end
        end
    end

    return count
end

function MushroomForestGenerator:_set_hero(map)
    local map_grid = map:get_grid()
    local hero = map:get_hero()
    local map_size_x, map_size_y = map:get_size()

    while true do
        local pos_x, pos_y = math.random(map_size_x), math.random(map_size_y)
        local cur_cell = map_grid:get_cell(pos_x, pos_y)

        if cur_cell:get_name() == Cells.ground and not cur_cell:get_character() then
            map:add_character(hero, pos_x, pos_y)

            break
        end
    end
end

function MushroomForestGenerator:_set_monster(map, monster)
    local map_grid = map:get_grid()
    local map_size_x, map_size_y = map:get_size()
    local hero_x, hero_y = map:get_character_position(map:get_hero())

    local count = 0

    while true do
        local pos_x, pos_y = math.random(map_size_x), math.random(map_size_y)
        local cur_cell = map_grid:get_cell(pos_x, pos_y)

        if cur_cell:get_name() == Cells.ground and not cur_cell:get_character() then
            if map:solve_path(hero_x, hero_y, pos_x, pos_y) then
                map:add_character(monster, pos_x, pos_y)

                return true
            else
                count = count +1
            end
        end

        if count > 3 then
            return false
        end
    end
end

function MushroomForestGenerator:_set_item(map, item)
    local map_size_x, map_size_y = map:get_size()
    local hero_x, hero_y = map:get_character_position(map:get_hero())

    local count = 0

    while true do
        local pos_x, pos_y = math.random(map_size_x), math.random(map_size_y)

        if map:add_item(item, pos_x, pos_y) and map:solve_path(hero_x, hero_y, pos_x, pos_y) then
            return true
        else
            count = count + 1
        end

        if count > 6 then
            return false
        end
    end
end

function MushroomForestGenerator:_set_stairs(map)
    local map_grid = map:get_grid()
    local map_size_x, map_size_y = map:get_size()
    local hero_x, hero_y = map:get_character_position(map:get_hero())

    while true do
        local pos_x, pos_y = math.random(map_size_x), math.random(map_size_y)

        local cell = map_grid:get_cell(pos_x, pos_y)

        if cell:get_name() == Cells.ground and not cell:get_character() then
            map_grid:set_cell(pos_x, pos_y, Stairs())

            return map:solve_path(hero_x, hero_y, pos_x, pos_y)
        end
    end
end

return MushroomForestGenerator
