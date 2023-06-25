---
-- ringer.lua


local Ringer = {
    _DESCRIPTION = "Lua implementation of ring buffer"
}

local Ringer_mt = {__index = Ringer}

function Ringer_mt.__len(self)
    return #self.buffer
end

function Ringer_mt.__tostring(self)
    local result_table = {}

    for _, value in pairs(self.buffer) do
        table.insert(result_table, tostring(value))
    end

    return "[" .. table.concat(result_table, ", ") .. "]"
end

function Ringer:new(data)
    if data and type(data) ~= "table" then
        error("Ringer(): data need to be table type")
    end

    self.buffer = data or {}
    self.current_index = 1

    return setmetatable({}, Ringer_mt)
end

function Ringer:insert(item)
    table.insert(self.buffer, item)
end

function Ringer:remove(item)
    for index, cur_item in pairs(self.buffer) do
        if item == cur_item then
            table.remove(self.buffer, index)

            return
        end
    end

    error("remove(): item '" .. tostring(item) .. "' not available")
end

function Ringer:get()
    if #self.buffer == 0 then
        error("get(): buffer is empty!")
    end

    if self.current_index > #self.buffer then
        self.current_index = 1
    end

    return self.buffer[self.current_index]
end

function Ringer:next()
    if #self.buffer == 0 then
        error("next(): buffer is empty!")
    end

    local result = self.buffer[self.current_index]

    self.current_index = self.current_index + 1

    if self.current_index > #self.buffer then
        self.current_index = 1
    end

    return result
end

function Ringer:is_empty()
    return not next(self.buffer)
end

return setmetatable(Ringer, {__call = Ringer.new})
