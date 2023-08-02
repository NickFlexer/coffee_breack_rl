local class = require "middleclass"

local lovetoys = require "lovetoys"

lovetoys.initialize({
    globals = true,
    debug = true
})

local GenerateWorldState = require "game.game_states.generate_world"

local ViewSystem = require "src.systems.view.view_system"
local InputSystem = require "systems.input_system"
local GameLoopSystem = require "systems.game_loop_system"
local AISystem = require "systems.ai_system"

local UpdateViewEvent = require "events.update_view_event"
local SolveFovEvent = require "events.solve_fov_event"
local ScreenLogEvent = require "events.screen_log_event"
local HeroDeadEvent = require "events.hero_dead_event"

local PostMortemEvent = require "game.game_events.post_mortem_event"


local GameplayState = class("GameplayState")

function GameplayState:initialize(data)
    if not data.event_manager then
        error("StartMenuState:initialize No data.event_manager !")
    end

    if not data.map then
        error("GameplayState:map No data.map !")
    end

    if not data.hero then
        error("GameplayState:hero No data.hero !")
    end

    self.game_event_manager = data.event_manager
    self.map = data.map
    self.hero = data.hero

    self.init_msg = false
end

function GameplayState:init()
    Log.debug("GameplayState:init start")

    self.engine = Engine()
    self.event_manager = EventManager()

    self.init_msg = true

    local view_system = ViewSystem({map = self.map, event_manager = self.event_manager})

    self.engine:addSystem(view_system, "update")
    self.engine:addSystem(InputSystem(
        {event_manager = self.event_manager, game_event_manager = self.game_event_manager}), "update"
    )
    self.engine:addSystem(AISystem({map = self.map}), "update")
    self.engine:addSystem(GameLoopSystem({map = self.map, event_manager = self.event_manager}), "update")
    self.engine:addSystem(view_system, "draw")

    self.event_manager:addListener("UpdateViewEvent", view_system, view_system.handle_event)
    self.event_manager:addListener("ShowEffectEvent", view_system, view_system.handle_event)
    self.event_manager:addListener("ScreenLogEvent", view_system, view_system.handle_event)
    self.event_manager:addListener("SolveFovEvent", self.map, self.map.handle_event)
    self.event_manager:addListener("HeroActionEvent", self.hero, self.hero.handle_event)

    Log.debug("GameplayState:init ready")
end

function GameplayState:enter(previous)
    Log.debug("GameplayState:enter start")

    self.event_manager:addListener("HeroDeadEvent", self, self.handle_event)

    self.engine:startSystem(ViewSystem.name)
    self.engine:startSystem(InputSystem.name)
    self.engine:startSystem(AISystem.name)
    self.engine:startSystem(GameLoopSystem.name)

    self.event_manager:fireEvent(SolveFovEvent())
    self.event_manager:fireEvent(UpdateViewEvent())

    if previous.class.name == GenerateWorldState.name then
        for i = 1, 7 do
            self.event_manager:fireEvent(ScreenLogEvent(""))
        end

        self.init_msg = true
    end

    if self.init_msg then
        self.event_manager:fireEvent(ScreenLogEvent("Добро пожаловать!"))

        self.init_msg = false
    end

    Log.debug("GameplayState:enter ready")
end

function GameplayState:leave()
    Log.debug("GameplayState:leave start")

    self.engine:stopSystem(ViewSystem.name)
    self.engine:stopSystem(InputSystem.name)
    self.engine:stopSystem(AISystem.name)
    self.engine:stopSystem(GameLoopSystem.name)

    self.event_manager:removeListener("HeroDeadEvent", self)

    Log.debug("GameplayState:leave ready")
end

function GameplayState:update(dt)
    self.engine:update(dt)
end

function GameplayState:draw()
    self.engine:draw()
end

function GameplayState:handle_event(event)
    if event.class.name == HeroDeadEvent.name then
        self.game_event_manager:fireEvent(PostMortemEvent())
    end
end

return GameplayState
