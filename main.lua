package.path = package.path .. ";lib/?/init.lua;lib/?.lua;src/?.lua"


Log = require "log"


local Game = require "game.game"

local StartMenuEvent = require "game.game_events.start_menu_event"


local game = {}
local game_event_manager = {}


function love.load()
    Log.debug("Load start")

    math.randomseed(os.time())

    game_event_manager = EventManager()

    game = Game({event_manager = game_event_manager})

    game_event_manager:addListener("GameplayEvent", game, game.handle_event)
    game_event_manager:addListener("StartMenuEvent", game, game.handle_event)
    game_event_manager:addListener("ExitMenuEvent", game, game.handle_event)
    game_event_manager:addListener("GenerateWorldEvent", game, game.handle_event)
    game_event_manager:addListener("PostMortemEvent", game, game.handle_event)

    game_event_manager:fireEvent(StartMenuEvent())
end


function love.update(dt)
    
end


function love.draw()
    
end

