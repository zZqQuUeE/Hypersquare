local utils = require("src.utils")
local wall = require("src.wall")
local attackManager = {
  queue = {}
}

function attackManager.tunnel1()
    local s = math.random(1, 4) * 2 - 1
    local aaa = {}
    for i=1, 8 do
        if i ~= s then
            table.insert(aaa, i)
        end
    end
    table.insert(attackManager.queue, aaa)
end
function attackManager.tunnel2()
    local s = math.random(1, 4) * 2 - 1
    local aaa = {}
    for i = 1, 8 do
        if not (i == s or i == ((s-2) % 8) + 1 or i == (s % 8) + 1) then
            table.insert(aaa, i)
        end
    end
    table.insert(attackManager.queue, aaa)
end

local queueIndex = 1
local queueTimer = 1
local delay = 0.5 -- TODO 이건임시

function attackManager.update(dt)
    local t = love.timer.getTime()
    if t >= queueTimer * delay then
        if #attackManager.queue >= queueIndex then
            for i, v in ipairs(attackManager.queue[queueIndex]) do
                if v ~= 0 then
                    wall.newInstance(v)
                end
            end
            queueIndex = queueIndex + 1
        end
        queueTimer = queueTimer + 1
    end
end

return attackManager