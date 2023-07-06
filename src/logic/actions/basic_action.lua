local class = require "middleclass"


local BasicAction = class("BasicAction")

function BasicAction:initialize()
    self.type = nil
end

function BasicAction:get_type()
    return self.type
end

return BasicAction
