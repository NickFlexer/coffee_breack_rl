package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


local lovetoys = require "lovetoys"


lovetoys.initialize({
    globals = true,
    debug = true
})


local ViewSystem = require "systems.view_system"

local UpdateViewEvent = require "events.update_view_event"
local GenerateMapEvent = require "events.generate_map_event"

local MapType = require "enums.map_type"

local Map = require "world.map"


local engine = {}
local event_manager = {}


function love.load()
    engine = Engine()
    event_manager = EventManager()

    local map = Map()

    local view_system = ViewSystem({map = map})

    engine:addSystem(view_system, "update")
    engine:addSystem(view_system, "draw")

    event_manager:addListener("UpdateViewEvent", view_system, view_system.handle_event)
    event_manager:addListener("GenerateMapEvent", map, map.handle_event)

    event_manager:fireEvent(GenerateMapEvent(MapType.mushroom_forest))
    event_manager:fireEvent(UpdateViewEvent())
end


function love.update(dt)
    engine:update(dt)
end


function love.draw()
    engine:draw()
end

