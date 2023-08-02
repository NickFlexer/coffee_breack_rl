local class = require "middleclass"

local MenuInput = require "menu.menu_input"

local Colors = require "enums.colors"

local UpEvent = require "menu.menu_events.up_event"
local DownEvent = require "menu.menu_events.down_event"
local EnterEvent = require "menu.menu_events.enter_event"

local StartMenuState = require "game.game_states.start_menu"
local PostMortemMenuState = require "game.game_states.post_mortem_menu"
local GameplayState = require "game.game_states.gameplay"

local StartMenuEvent = require "game.game_events.start_menu_event"
local PostMortemEvent = require "game.game_events.post_mortem_event"
local GameplayEvent = require "game.game_events.gameplay_event"


local ExitMenuState = class("ExitMenuState")

function ExitMenuState:initialize(data)
    if not data.event_manager then
        error("StartMenuState:initialize No data.event_manager !")
    end

    self.game_event_manager = data.event_manager

    self.menu_font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18)
    love.graphics.setFont(self.menu_font)

    self.exit_menu_event_manager = EventManager()

    self.input = MenuInput({event_manager = self.exit_menu_event_manager})

    self.exit_menu_event_manager:addListener(UpEvent.name, self, self.handle_event)
    self.exit_menu_event_manager:addListener(DownEvent.name, self, self.handle_event)
    self.exit_menu_event_manager:addListener(EnterEvent.name, self, self.handle_event)

    self.previous = nil
end

function ExitMenuState:init()
    Log.debug("ExitMenuState:init start")

    self.cell_size = 32

    Log.debug("ExitMenuState:init ready")
end

function ExitMenuState:enter(previous)
    Log.debug("ExitMenuState:enter start")

    self.menu_items = {
        {
            text = "Да",
            select = true,
            action = function () love.event.quit()  end
        },
        {
            text = "Нет",
            select = false,
            action = function ()
                if self.previous.class.name == StartMenuState.name then
                    self.game_event_manager:fireEvent(StartMenuEvent())
                elseif self.previous.class.name == PostMortemMenuState.name then
                    self.game_event_manager:fireEvent(PostMortemEvent())
                elseif self.previous.class.name == GameplayState.name then
                    self.game_event_manager:fireEvent(GameplayEvent())
                end
            end
        },
    }

    self.previous = previous
    self.input:set_keys()

    Log.debug("ExitMenuState:enter ready")
end

function ExitMenuState:leave()
    Log.debug("ExitMenuState:leave start")

    self.input:clear_keys()

    Log.debug("ExitMenuState:leave ready")
end

function ExitMenuState:update(dt)
    self.input:update(dt)
end

function ExitMenuState:draw()
    local width, height = love.graphics.getDimensions()

    love.graphics.setColor(Colors.white)
    love.graphics.rectangle(
        "line",
        4,
        4,
        width - 8,
        height - 8
    )

    love.graphics.setColor(Colors.orange)
    love.graphics.print(
        "Хотите выйти из игры?",
        width/2 - 64,
        height/3
    )

    love.graphics.setColor(Colors.white)
    for index, value in ipairs(self.menu_items) do
        local prefix = "   "

        if value.select then
            prefix = "-> "
        end

        love.graphics.print(
            prefix .. value.text,
            width/2 - 32,
            (height/3 + self.cell_size * 4)  + (index - 1) * self.cell_size/2
        )
    end

    love.graphics.setColor(Colors.gray)
    love.graphics.print(
        {
            Colors.orange, "w",
            Colors.gray, " - вверх ",
            Colors.orange, "s",
            Colors.gray, " - вниз ",
            Colors.orange, "Enter",
            Colors.gray, " - выбрать",
        },
        width/2 - 128,
        height - self.cell_size * 3
    )
end

function ExitMenuState:handle_event(event)
    if event.class.name == UpEvent.name then
        for index, item in ipairs(self.menu_items) do
            if item.select and index ~= 1 then
                item.select = false
                self.menu_items[index - 1].select = true

                return
            end
        end
    elseif event.class.name == DownEvent.name then
        for index, item in ipairs(self.menu_items) do
            if item.select and index ~= #self.menu_items then
                item.select = false
                self.menu_items[index + 1].select = true

                return
            end
        end
    elseif event.class.name == EnterEvent.name then
        for index, item in ipairs(self.menu_items) do
            if item.select then
                item.action()

                return
            end
        end
    end
end

return ExitMenuState
