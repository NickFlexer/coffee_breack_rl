local class = require "middleclass"

local Timer = require "hump.timer"

local Colors = require "enums.colors"
local MapTypes = require "enums.map_type"

local GameplayEvent = require "game.game_events.gameplay_event"

local MushroomForestGenerator = require "world.generators.mushroom_forest"


local GenerateWorld = class("GenerateWorld")

function GenerateWorld:initialize(data)
    if not data.event_manager then
        error("StartMenuState:initialize No data.event_manager !")
    end

    if not data.map then
        error("StartMenuState:map No data.event_manager !")
    end

    if not data.hero then
        error("StartMenuState:hero No data.event_manager !")
    end

    self.game_event_manager = data.event_manager
    self.map = data.map
    self.hero = data.hero

    self.menu_font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18)
    love.graphics.setFont(self.menu_font)

    self.map_type = nil
    self.map_ready = false

    self.timer = Timer.new()
end

function GenerateWorld:init()
    Log.debug("GenerateWorld:init start")

    Log.debug("GenerateWorld:init ready")
end

function GenerateWorld:enter(previous, map_type)
    Log.debug("GenerateWorld:enter start")

    self.map_type = map_type
    self.map_ready = false
    self.generato = nil

    if self.map_type == MapTypes.mushroom_forest then
        self.generator = MushroomForestGenerator()
    end

    Log.debug("GenerateWorld:enter ready")
end

function GenerateWorld:leave()
    Log.debug("GenerateWorld:leave start")

    self.map_type = nil

    Log.debug("GenerateWorld:leave ready")
end

function GenerateWorld:update(dt)
    self.timer:update(dt)

    if not self.map_ready then
        -- self.map_ready = self.map:generate(self.map_type)
        self.map_ready = self.generator:generate(self.map)

        if self.map_ready then
            self.timer:after(
                1,
                function ()
                    self.game_event_manager:fireEvent(GameplayEvent())
                end
            )
        end
    end
end

function GenerateWorld:draw()
    local width, height = love.graphics.getDimensions()

    love.graphics.setColor(Colors.white)
    love.graphics.rectangle(
        "line",
        4,
        4,
        width - 8,
        height - 8
    )

    love.graphics.setColor(Colors.white)
    love.graphics.print(
        "Загрузка...",
        width/2 - 64,
        height/2
    )
end

return GenerateWorld
