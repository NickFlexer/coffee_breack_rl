local class = require "middleclass"


local ScreenLogEvent = class("ScreenLogEvent")

function ScreenLogEvent:initialize(message)
    self.msg = message
end

function ScreenLogEvent:get_message()
    return self.msg
end

return ScreenLogEvent