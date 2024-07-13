local class = require "middleclass"

local TileDrawer = require "utils.tile_drawer"

local Colors = require "enums.colors"

local MenuInput = require "menu.menu_input"

local UpEvent = require "menu.menu_events.up_event"
local DownEvent = require "menu.menu_events.down_event"
local EnterEvent = require "menu.menu_events.enter_event"

local GameplayEvent = require "game.game_events.gameplay_event"


local FountainPreviewMenu = class("FountainPreviewMenu")

function FountainPreviewMenu:initialize(data)
    if not data.event_manager then
        error("FountainPreviewMenu:initialize No data.event_manager !")
    end

    if not data.hero then
        error("FountainPreviewMenu:initialize No data.hero !")
    end

    if not data.map then
        error("FountainPreviewMenu:initialize No data.map !")
    end

    self.game_event_manager = data.event_manager
    self.hero = data.hero
    self.map = data.map

    self.menu_font = love.graphics.newFont("res/fonts/keyrusMedium.ttf", 18)
    love.graphics.setFont(self.menu_font)

    self.item_preview_event_manager = EventManager()

    self.input = MenuInput({event_manager = self.item_preview_event_manager})

    self.item_preview_event_manager:addListener(UpEvent.name, self, self.handle_event)
    self.item_preview_event_manager:addListener(DownEvent.name, self, self.handle_event)
    self.item_preview_event_manager:addListener(EnterEvent.name, self, self.handle_event)

    self.cell_size = 32

    self.tc = TileDrawer()
end

function FountainPreviewMenu:init()
    Log.debug("FountainPreviewMenu:init start")

    Log.debug("FountainPreviewMenu:init ready")
end

function FountainPreviewMenu:enter(previous, fountain)
    Log.debug("FountainPreviewMenu:enter start")

    self.fountain = fountain

    if self.fountain:is_full() then
        self.menu_items = {
            {
                text = "Пить из фонтана",
                select = true,
                action = function ()  end
            },
            {
                text = "Уйти",
                select = false,
                action = function () self.game_event_manager:fireEvent(GameplayEvent()) end
            }
        }
    else
        self.menu_items = {
            {
                text = "Уйти",
                select = true,
                action = function () self.game_event_manager:fireEvent(GameplayEvent()) end
            }
        }
    end

    self.input:set_keys()

    Log.debug("FountainPreviewMenu:enter ready")
end

function FountainPreviewMenu:leave()
    Log.debug("FountainPreviewMenu:leave start")

    self.input:clear_keys()
    self.fountain = nil

    Log.debug("FountainPreviewMenu:leave ready")
end

function FountainPreviewMenu:update(dt)
    self.input:update(dt)
end

function FountainPreviewMenu:draw()
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
    for index, value in ipairs(self.menu_items) do
        local prefix = "   "

        if value.select then
            prefix = "-> "
        end

        love.graphics.print(
            prefix .. value.text,
            width/2 - 32,
            (height - self.cell_size * 7)  + (index - 1) * self.cell_size/2
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

function FountainPreviewMenu:handle_event(event)
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

return FountainPreviewMenu
