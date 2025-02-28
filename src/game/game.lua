local class = require "middleclass"

local Gamestate = require "hump.gamestate"

local MapeTypes = require "enums.map_type"

local GameplayEvent = require "game.game_events.gameplay_event"
local StartMenuEvent = require "game.game_events.start_menu_event"
local ExitMenuEvent = require "game.game_events.exit_menu_event"
local GenerateWorldEvent = require "game.game_events.generate_world_event"
local PostMortemEvent = require "game.game_events.post_mortem_event"
local ItemPreviewEvent = require "game.game_events.item_preview_event"
local FountainPreviewEvent = require "game.game_events.fountain_preview_event"

local GameplayState = require "game.game_states.gameplay"
local StartMenuState = require "game.game_states.start_menu"
local ExitMenuState = require "game.game_states.exit_menu"
local GenerateWorldState = require "game.game_states.generate_world"
local PostMortemMenuState = require "game.game_states.post_mortem_menu"
local ItemPreviewMenuState = require "game.game_states.item_preview_menu"
local FountainPreviewState = require "game.game_states.fountain_preview_menu"

local Map = require "world.map"
local Hero = require "world.units.hero"


local Game = class("Game")

function Game:initialize(data)
    if not data.event_manager then
        error("Game:initialize No data.states !")
    end

    self.game_event_manager = data.event_manager

    self.hero = Hero(
        {
            hp = 20,
            damage = {min = 1, max = 4},
            hit_chance = 75,
            crit_chance = 15,
            view_radius = 8,
            speed = 8,
            protection_chance = 30
        }
    )
    local map = Map({hero = self.hero})

    self.states = {
        gameplay = GameplayState(
            {
                event_manager = self.game_event_manager,
                map = map,
                hero = self.hero
            }
        ),
        start_menu = StartMenuState({event_manager = self.game_event_manager}),
        exit_menu = ExitMenuState({event_manager = self.game_event_manager}),
        generate_world = GenerateWorldState(
            {
                event_manager = self.game_event_manager,
                map = map,
                hero = self.hero
            }
        ),
        post_mortem_menu = PostMortemMenuState({event_manager = self.game_event_manager}),
        item_preview = ItemPreviewMenuState(
            {
                event_manager = self.game_event_manager,
                hero = self.hero,
                map = map
            }
        ),
        fountain_preview = FountainPreviewState(
            {
                event_manager = self.game_event_manager,
                hero = self.hero,
                map = map
            }
        )
    }

    Gamestate.registerEvents()

    self.map_type = MapeTypes.mushroom_forest
    self.current_world = 0
end

function Game:handle_event(event)
    if event.class.name == StartMenuEvent.name then
        Gamestate.switch(self.states.start_menu)
    elseif event.class.name == GameplayEvent.name then
        Gamestate.switch(self.states.gameplay)
    elseif event.class.name == ExitMenuEvent.name then
        Gamestate.switch(self.states.exit_menu)
    elseif event.class.name == GenerateWorldEvent.name then
        if self.hero:is_dead() then
            self.hero:restore()
            self.current_world = 0
        end

        self.current_world = self.current_world + 1

        Gamestate.switch(self.states.generate_world, self.map_type, self.current_world)
    elseif event.class.name == PostMortemEvent.name then
        Gamestate.switch(self.states.post_mortem_menu)
    elseif event.class.name == ItemPreviewEvent.name then
        Gamestate.switch(self.states.item_preview, event:get_item())
    elseif event.class.name == FountainPreviewEvent.name then
        Gamestate.switch(self.states.fountain_preview, event:get_fountain())
    end
end

return Game
