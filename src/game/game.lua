local class = require "middleclass"

local Gamestate = require "hump.gamestate"

local GameplayEvent = require "game.game_events.gameplay_event"
local StartMenuEvent = require "game.game_events.start_menu_event"
local ExitMenuEvent = require "game.game_events.exit_menu_event"
local GenerateWorldEvent = require "game.game_events.generate_world_event"
local PostMortemEvent = require "game.game_events.post_mortem_event"
local ItemPreviewEvent = require "game.game_events.item_preview_event"

local GameplayState = require "game.game_states.gameplay"
local StartMenuState = require "game.game_states.start_menu"
local ExitMenuState = require "game.game_states.exit_menu"
local GenerateWorldState = require "game.game_states.generate_world"
local PostMortemMenuState = require "game.game_states.post_mortem_menu"
local ItemPreviewMenuState = require "game.game_states.item_preview_menu"

local Map = require "world.map"
local Hero = require "world.units.hero"


local Game = class("Game")

function Game:initialize(data)
    if not data.event_manager then
        error("Game:initialize No data.states !")
    end

    self.game_event_manager = data.event_manager

    local hero = Hero(
        {
            hp = 20,
            damage = {min = 1, max = 4},
            view_radius = 8,
            speed = 8,
            protection_chance = 30
        }
    )
    local map = Map({hero = hero})

    self.states = {
        gameplay = GameplayState(
            {
                event_manager = self.game_event_manager,
                map = map,
                hero = hero
            }
        ),
        start_menu = StartMenuState({event_manager = self.game_event_manager}),
        exit_menu = ExitMenuState({event_manager = self.game_event_manager}),
        generate_world = GenerateWorldState(
            {
                event_manager = self.game_event_manager,
                map = map,
                hero = hero
            }
        ),
        post_mortem_menu = PostMortemMenuState({event_manager = self.game_event_manager}),
        item_preview = ItemPreviewMenuState(
            {
                event_manager = self.game_event_manager,
                hero = hero,
                map = map
            }
        )
    }

    Gamestate.registerEvents()
end

function Game:handle_event(event)
    if event.class.name == StartMenuEvent.name then
        Gamestate.switch(self.states.start_menu)
    elseif event.class.name == GameplayEvent.name then
        Gamestate.switch(self.states.gameplay)
    elseif event.class.name == ExitMenuEvent.name then
        Gamestate.switch(self.states.exit_menu)
    elseif event.class.name == GenerateWorldEvent.name then
        Gamestate.switch(self.states.generate_world, event:get_map_type())
    elseif event.class.name == PostMortemEvent.name then
        Gamestate.switch(self.states.post_mortem_menu)
    elseif event.class.name == ItemPreviewEvent.name then
        Gamestate.switch(self.states.item_preview, event:get_item())
    end
end

return Game
