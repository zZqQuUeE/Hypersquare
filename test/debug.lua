local input = require("src.input")
local attackManager = require("src.attackManager")
local pulse = require("src.pulse")
local wall = require("src.wall")
local debug = {}

function debug.update(dt)
    -- 키입력테스트
    if input.isPressed("f") then
        -- local asdf = math.random(0, 1)
        -- if asdf == 0 then
        --     attackManager.tunnel1()
        -- else
            
        -- end
        attackManager.tunnel2()
        --pulse.sizeOffset = 30
        --wall.newInstance(1)
        --wall.newInstance(2)
        --wall.newInstance(3)
    end
end

return debug