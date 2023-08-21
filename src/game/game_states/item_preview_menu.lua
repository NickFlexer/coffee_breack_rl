local class = require "middleclass"

local TileDrawer = require "utils.tile_drawer"

local Colors = require "enums.colors"
local Cells = require "enums.cells"
local CharacterAttributes = require "enums.character_attributes"
local ItemPlace = require "enums.item_place"

local MenuInput = require "menu.menu_input"

local UpEvent = require "menu.menu_events.up_event"
local DownEvent = require "menu.menu_events.down_event"
local EnterEvent = require "menu.menu_events.enter_event"

local GameplayEvent = require "game.game_events.gameplay_event"


local ItemPreviewMenu = class("ItemPreviewMenu")

function ItemPreviewMenu:initialize(data)
    if not data.event_manager then
        error("ItemPreviewMenu:initialize No data.event_manager !")
    end

    if not data.hero then
        error("ItemPreviewMenu:initialize No data.hero !")
    end

    if not data.map then
        error("ItemPreviewMenu:initialize No data.map !")
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

function ItemPreviewMenu:init()
    Log.debug("ItemPreviewMenu:init start")

    Log.debug("ItemPreviewMenu:init ready")
end

function ItemPreviewMenu:enter(previous, item)
    Log.debug("ItemPreviewMenu:enter start")

    self.item = item

    print(self.item)
    print(self.item:get_item_place())

    self.menu_items = {
        {
            text = "Подобрать",
            select = true,
            action = function ()
                local item_place = self.item:get_item_place()
                local cur_item = self.hero:get_item(item_place)

                self.hero:set_item(item_place, self.item)

                local pos_x, pos_y = self.map:get_item_position(self.item)
                self.map:get_grid():get_cell(pos_x, pos_y):remove_item()

                if cur_item then
                    self.map:get_grid():get_cell(pos_x, pos_y):set_item(cur_item)
                end

                self.game_event_manager:fireEvent(GameplayEvent())
            end
        },
        {
            text = "Бросить",
            select = false,
            action = function () self.game_event_manager:fireEvent(GameplayEvent()) end
        },
    }

    self.input:set_keys()

    Log.debug("ItemPreviewMenu:enter ready")
end

function ItemPreviewMenu:leave()
    Log.debug("ItemPreviewMenu:leave start")

    self.input:clear_keys()
    self.item = nil

    Log.debug("ItemPreviewMenu:leave ready")
end

function ItemPreviewMenu:update(dt)
    self.input:update(dt)
end

function ItemPreviewMenu:draw()
    local width, height = love.graphics.getDimensions()

    love.graphics.setColor(Colors.white)
    love.graphics.rectangle(
        "line",
        4,
        4,
        width - 8,
        height - 8
    )

    -- new item
    love.graphics.setColor(Colors.white)
    love.graphics.rectangle(
        "line",
        width/2 - self.cell_size * 4,
        self.cell_size * 7,
        self.cell_size,
        self.cell_size
    )

    self.tc:draw(
        self.item:get_tile(),
        width/2 - self.cell_size * 4,
        self.cell_size * 7
    )

    love.graphics.setColor(Colors.green)
    love.graphics.print(
        self.item:get_visible_name(),
        width/2 - self.cell_size * 4,
        self.cell_size * 8
    )

    -- current item
    love.graphics.setColor(Colors.white)
    love.graphics.rectangle(
        "line",
        width/2 + self.cell_size * 3,
        self.cell_size * 7,
        self.cell_size,
        self.cell_size
    )

    local new_item_place = self.item:get_item_place()
    local current_item = nil
    local current_item_name = nil

    if new_item_place == ItemPlace.right_hand then
        current_item = self.hero:get_items().right_hand

        if not current_item then
            current_item_name = "Кулаки"
        else
            current_item_name = current_item:get_visible_name()
        end
    elseif new_item_place == ItemPlace.head then
        current_item = self.hero:get_items().head

        if not current_item then
            current_item_name = "Пустая голова"
        else
            current_item_name = current_item:get_visible_name()
        end
    elseif new_item_place == ItemPlace.body then
        current_item = self.hero:get_items().body

        if not current_item then
            current_item_name = "Голое тело"
        else
            current_item_name = current_item:get_visible_name()
        end
    end

    if current_item then
        self.tc:draw(
            current_item:get_tile(),
            width/2 + self.cell_size * 3,
            self.cell_size * 7
        )
    end

    love.graphics.setColor(Colors.green)
    love.graphics.print(
        current_item_name,
        width/2 + self.cell_size * 3,
        self.cell_size * 8
    )

    -- data
    for index, attribute in ipairs(self.item:get_attributes()) do
        local title_color = nil
        local title = nil
        local new_data = nil
        local current_data = nil
        local new_attribute_color = Colors.white
        local current_attribute_color = Colors.white

        if attribute == CharacterAttributes.damage then
            local cur_damage = self.hero:get_damage()
            local new_damage = self.hero:get_preview_damage(self.item)

            title_color = Colors.orange
            title = "Урон"
            new_data = new_damage.min .. " - " .. new_damage.max
            current_data = cur_damage.min .. " - " .. cur_damage.max

            if new_damage.min > cur_damage.min or new_damage.max > cur_damage.max then
                new_attribute_color = Colors.green
                current_attribute_color = Colors.red
            elseif new_damage.min < cur_damage.min or new_damage.max < cur_damage.max then
                new_attribute_color = Colors.red
                current_attribute_color = Colors.green
            end
        elseif attribute == CharacterAttributes.defence then
            local cur_defence = self.hero:get_defence()
            local new_defence = self.hero:get_preview_defence(self.item)

            title_color = Colors.orange
            title = "Защита"
            new_data = new_defence
            current_data = cur_defence

            if new_defence > cur_defence then
                new_attribute_color = Colors.green
                current_attribute_color = Colors.red
            elseif new_defence < cur_defence then
                new_attribute_color = Colors.red
                current_attribute_color = Colors.green
            end
        end

        love.graphics.setColor(title_color)
        love.graphics.print(
            title,
            width/2 - self.cell_size * 6,
            (self.cell_size * 9)  + (index - 1) * self.cell_size/2
        )

        -- new
        love.graphics.setColor(new_attribute_color)
        love.graphics.print(
            new_data,
            width/2 - self.cell_size * 4,
            (self.cell_size * 9)  + (index - 1) * self.cell_size/2
        )

        -- current
        love.graphics.setColor(current_attribute_color)
        love.graphics.print(
            current_data,
            width/2 + self.cell_size * 3,
            (self.cell_size * 9)  + (index - 1) * self.cell_size/2
        )
    end


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

function ItemPreviewMenu:handle_event(event)
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

return ItemPreviewMenu
