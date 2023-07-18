local class = require "middleclass"


local ActionResult = class("ActionResult")

function ActionResult:initialize(data)
    self.succeeded = data.succeeded
    self.alternate = data.alternate
end

function ActionResult:is_success()
    return self.succeeded
end

function ActionResult:get_alternate()
    return self.alternate
end

function ActionResult:set_alternate(action)
    self.alternate = action
end

return ActionResult
