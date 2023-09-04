local class = require "middleclass"
local Grid = require "grid"
local Ring = require "ringer"

local FOV = require "ppfov"
local Luastar = require "lua-star"
local Bresenham = require "Bresenham"

local SolveFovEvent = require "events.solve_fov_event"

local Ground = require "world.cells.ground"


local Map = class("Map")

function Map:initialize(data)
    self.map_size_x = 50
    self.map_size_y = 30
    self.world_map = Grid(self.map_size_x, self.map_size_y)

    for x, y, cell in self.world_map:iterate() do
        self.world_map:set_cell(x, y, Ground())
    end

    self.hero = data.hero

    self.characters = Ring()

    self.characters:insert(self.hero)

    self.world_name = nil
    self.world_number = 0
end

function Map:get_grid()
    return self.world_map
end

function Map:clear_data()
    self.characters = Ring()
end

function Map:handle_event(event)
    if event.class.name == SolveFovEvent.name then
        self:reset_visible()

        local is_transparent = function (x, y)
            if self.world_map:is_valid(x, y) then
                return self.world_map:get_cell(x, y):is_transparent()
            end
        end

        local on_visible = function (x, y)
            if self.world_map:is_valid(x, y) then
                if self.world_map:get_cell(x, y):is_obscured() then
                    self.world_map:get_cell(x, y):illuminate()
                end

                self.world_map:get_cell(x, y):set_visible(true)
            end
        end

        local hero_x, hero_y = self:get_character_position(self.hero)
        local hero_view_radius = self.hero:get_view_radius()

        FOV(hero_x, hero_y, hero_view_radius, is_transparent, on_visible)
    end
end

function Map:get_hero()
    return self.hero
end

function Map:get_character_position(character)
    for x, y, cell in self.world_map:iterate() do
        if cell:get_character() == character then
            return x, y
        end
    end
end

function Map:get_item_position(item)
    for x, y, cell in self.world_map:iterate() do
        if cell:get_item() == item then
            return x, y
        end
    end
end

function Map:get_characters()
    return self.characters
end

function Map:add_character(character, x, y)
    if not self.characters:is_exist(character) then
        self.characters:insert(character)
    end

    self.world_map:get_cell(x, y):set_character(character)
end

function Map:add_item(item, x, y)
    local cur_cell = self.world_map:get_cell(x, y)

    if cur_cell:can_place_item() then
        cur_cell:set_item(item)

        return true
    else
        return false
    end
end

function Map:kill_character(character)
    local pos_x, pos_y = self:get_character_position(character)

    self.world_map:get_cell(pos_x, pos_y):remove_character()
    self.characters:remove(character)

    if not self.world_map:get_cell(pos_x, pos_y):get_bones() then
        self.world_map:get_cell(pos_x, pos_y):set_bones()
    end
end

function Map:get_size()
    return self.map_size_x, self.map_size_y
end

function Map:can_move(x, y)
    return (self.world_map:is_valid(x, y) and not self.world_map:get_cell(x, y):is_move_blocked())
end

function Map:move_cahracter(x0, y0, x1, y1)
    local character = self.world_map:get_cell(x0, y0):remove_character()
    self.world_map:get_cell(x1, y1):set_character(character)
end

function Map:reset_visible()
    for x, y, cell in self.world_map:iterate() do
        self.world_map:get_cell(x, y):set_visible(false)
    end
end

function Map:solve_path(x0, y0, x1, y1)
    local path = Luastar:find(
        self.map_size_x,
        self.map_size_y,
        {x = x0, y = y0},
        {x = x1, y = y1},
        function (x, y)
            local pos_result = not self.world_map:get_cell(x, y):get_character()

            if x == x1 and y == y1 then
                if self.world_map:get_cell(x, y):get_character() == self:get_hero() then
                    pos_result = true
                end
            end

            local result = (self:can_move(x, y) and pos_result)

            return result
        end,
        false,
        true
    )

    if path then
        table.remove(path, 1)
    end

    return path
end

function Map:can_see(source, target)
    local source_x, source_y = self:get_character_position(source)
    local target_x, target_y = self:get_character_position(target)
    local source_view_radius = source:get_view_radius()

    local function callback(x, y)
        return self.world_map:get_cell(x, y):is_transparent()
    end

    local result, counter = Bresenham.line(
        source_x, source_y,
        target_x, target_y,
        callback
    )

    if result and counter <= source_view_radius then
        return true
    end

    return false
end

function Map:is_character_near(source, target)
    local source_x, source_y = self:get_character_position(source)
    local target_x, target_y = self:get_character_position(target)

    local neighbours = {
        {-1, 0},
        {1, 0},
        {0, -1},
        {0, 1}
    }

    for _, data in ipairs(neighbours) do
        if source_x - target_x == data[1] and source_y - target_y == data[2] then
            return true
        end
    end

    return false
end

function Map:get_title()
    return self.world_name
end

function Map:set_title(title)
    self.world_name = title
end

function Map:get_world_number()
    return self.world_number
end

function Map:set_world_number(numb)
    self.world_number = numb
end

return Map
