local class = require "middleclass"

local MovingDirection = require "enums.moving_direction"
local CharacterAttributes = require "enums.character_attributes"
local ItemPlace = require "enums.item_place"


local Character = class("Character")

function Character:initialize(data)
    self.tile = data.tile
    self.action = nil
    self.control = nil
    self.ai = nil
    self.max_hp = nil
    self.current_hp = nil
    self.damage = {min = 0, max = 0}
    self.hit_chance = 50
    self.crit_chance = 10
    self.view_radius = nil
    self.speed = nil
    self.energy = 0
    self.protection_chance = 10
    self.defence = 0

    self.right_hand = nil
    self.head = nil
    self.body = nil
end

function Character:get_tile()
    return self.tile
end

function Character:set_action(action)
    Log.trace("NEW ACTION " .. self.class.name)
    self.action = action
end

function Character:get_action()
    local action =  self.action
    self.action = nil

    self.energy = self.energy - action:get_cost()

    return action
end

function Character:has_action()
    return not not self.action
end

function Character:can_take_turn()
    return self.energy >= self.action:get_cost()
end

function Character:gain_energy()
    self.energy = self.energy + self.speed
end

function Character:get_control()
    return self.control
end

function Character:think(data)
    self.ai:perform(data)
end

function Character:get_hp()
    return {max = self.max_hp, cur = self.current_hp}
end

function Character:new_damage()
    local damage = self:get_damage()

    return math.random(damage.min, damage.max)
end

function Character:get_preview_damage(new_item)
    local damage = {min = self.damage.min, max = self.damage.max}

    local items = self:get_items()

    if new_item:get_item_place() == ItemPlace.right_hand then
        items.right_hand = new_item
    end

    for _, cur_item in pairs(items) do
        local attributes = cur_item:get_attributes()

        for _, attribute in pairs(attributes) do
            if attribute == CharacterAttributes.damage then
                local new_damage = cur_item:get_damage_bust()

                damage.min = damage.min + new_damage.min
                damage.max = damage.max + new_damage.max
            end
        end
    end

    return damage
end

function Character:get_damage()
    local result_damage = {min = self.damage.min, max = self.damage.max}

    for _, item in pairs(self:get_items()) do
        local attributes = item:get_attributes()

        for _, attribute in pairs(attributes) do
            if attribute == CharacterAttributes.damage then
                local new_damage = item:get_damage_bust()

                result_damage.min = result_damage.min + new_damage.min
                result_damage.max = result_damage.max + new_damage.max
            end
        end
    end

    return result_damage
end

function Character:get_hit_chance()
    return self.hit_chance
end

function Character:get_crit_chance()
    return self.crit_chance
end

function Character:get_protection_chance()
    return self.protection_chance
end

function Character:get_defence()
    local result_defence = self.defence

    for _, item in pairs(self:get_items()) do
        local attributes = item:get_attributes()

        for _, attribute in pairs(attributes) do
            if attribute == CharacterAttributes.defence then
                result_defence = result_defence + item:get_defence_bust()
            end
        end
    end

    return result_defence
end

function Character:get_preview_defence(new_item)
    local defence = self.defence

    local items = self:get_items()

    if new_item:get_item_place() == ItemPlace.right_hand then
        items.right_hand = new_item
    elseif new_item:get_item_place() == ItemPlace.head then
        items.head = new_item
    elseif new_item:get_item_place() == ItemPlace.body then
        items.body = new_item
    end

    for _, cur_item in pairs(items) do
        local attributes = cur_item:get_attributes()

        for _, attribute in pairs(attributes) do
            if attribute == CharacterAttributes.defence then
                defence = defence + cur_item:get_defence_bust()
            end
        end
    end

    return defence
end

function Character:decreace_hp(damage)
    self.current_hp = math.max(self.current_hp - damage, 0)
end

function Character:get_view_radius()
    return self.view_radius
end

function Character:is_dead()
    return self.current_hp == 0
end

function Character:restore_hp()
    self.current_hp = self.max_hp
end

function Character:get_speed()
    return self.speed
end

function Character:get_items()
    local items = {
        right_hand = self.right_hand,
        head = self.head,
        body = self.body
    }

    return items
end

function Character:set_item(item_place, item)
    if item_place == ItemPlace.right_hand then
        self.right_hand = item
    elseif item_place == ItemPlace.head then
        self.head = item
    elseif item_place == ItemPlace.body then
        self.body = item
    end
end

function Character:get_item(item_place)
    if item_place == ItemPlace.right_hand then
        return self.right_hand
    elseif item_place == ItemPlace.head then
        return self.head
    elseif item_place == ItemPlace.body then
        return self.body
    end
end

function Character:get_moving_direction(x0, y0, x1, y1)
    if x0 == x1 + 1 and y0 == y1 then
        return MovingDirection.left
    elseif x0 == x1 - 1 and y0 == y1 then
        return MovingDirection.right
    elseif x0 == x1 and y0 == y1 + 1 then
        return MovingDirection.up
    elseif x0 == x1 and y0 == y1 - 1 then
        return MovingDirection.down
    else
        return
    end
end

return Character
