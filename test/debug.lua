local input = require("src.input")
local pulse = require("src.pulse")
local wall = require("src.wall")
local debug = {}

function debug.update(dt)
    -- 키입력테스트
    if input.isPressed("f") then
        pulse.sizeOffset = 30
        wall.newInstance(1)
        wall.newInstance(2)
        wall.newInstance(3)
    end
end

return debug