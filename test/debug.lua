local input = require("src.input")
local pulse = require("src.pulse")
local debug = {}

function debug.update(dt)
    -- 키입력테스트
    if input.isPressed("f") then
        pulse.sizeOffset = 30
    end
end

return debug