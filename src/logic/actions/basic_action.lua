local class = require "middleclass"


local BasicAction = class("BasicAction")

function BasicAction:initialize()
    self.type = nil
    self.cost = 0
end

function BasicAction:get_type()
    return self.type
end

function BasicAction:get_cost()
    return self.cost
end

return BasicAction
