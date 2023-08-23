local class = require "middleclass"

local Zombie = require "world.units.zombie"
local Rabbit = require "world.units.rabbit"

local ZombieAI = require "logic.ai.zombie_ai"
local RabbitAI = require "logic.ai.rabbit_ai"

local Monsters = require "enums.monsters"
local MonsterLevel = require "enums.monster_level"


local MonsterFactory = class("MonsterFactory")

function MonsterFactory:initialize()
    self.monster_level = {
        [MonsterLevel.base] = {
            [Monsters.rabbit] = 15,
            [Monsters.zombie] = 90
        }
    }
end

function MonsterFactory:get_zombie()
    local unit = Zombie(
        {
            ai = ZombieAI(),
            hp = 10,
            damage = {min = 1, max = 4},
            view_radius = 8,
            speed = 6
        }
    )

    return unit
end

function MonsterFactory:get_rabbit()
    local unit = Rabbit(
        {
            ai = RabbitAI(),
            hp = 4,
            view_radius = 8,
            speed = 12
        }
    )

    return unit
end

function MonsterFactory:get_random_monster(level)
    local unit = nil

    while true do
        local rnd = math.random(0, 100)

        for monster_name, monster_possibility in pairs(self.monster_level[level]) do
            if rnd <= monster_possibility then
                if monster_name == Monsters.rabbit then
                    unit = self:get_rabbit()

                    return unit
                elseif monster_name == Monsters.zombie then
                    unit = self:get_zombie()

                    return unit
                end
            end
        end
    end
end

return MonsterFactory
