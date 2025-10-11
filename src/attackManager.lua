local utils = require("src.utils")
local wall = require("src.wall")
local player = require("src.player")
local attackManager = {
  queue = {}
}

function attackManager.tunnel1()
    local s = math.random(1, 4) * 2 - 1
    local aaa = {}
    for i=1, 8 do
        if i ~= s then
            table.insert(aaa, i)
            table.insert(aaa, 0)
            table.insert(aaa, 0)
            table.insert(aaa, 0)
        end
    end
    table.insert(attackManager.queue, aaa)
    table.insert(attackManager.queue, {0})
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
    table.insert(attackManager.queue, {0})
end
function attackManager.tunnel3()
    local s = math.random(1, 4) * 2 - 1
    local aaa = {}
    local ii = utils.sign(math.random() - 0.51) * 4
    repeat
        for i=1, 8 do
            if i ~= ((s + 2*ii - 1) % 8) + 1 then
                table.insert(aaa, i)
            end
        end
        table.insert(attackManager.queue, aaa)
        aaa = {}
        ii = ii - utils.sign(ii)
    until (ii == 0)
    table.insert(attackManager.queue, {0})
end
function attackManager.tunnel4()
    local s = math.random(1, 4) * 2 - 1
    for ii = 0, 2 do
        local aaa = {}
        for i=1, 8 do
            if i ~= s then
                table.insert(aaa, i + ii * 4)
                table.insert(aaa, 0)
                table.insert(aaa, 0)
                table.insert(aaa, 0)
            end
        end
        table.insert(attackManager.queue, aaa)
        table.insert(attackManager.queue, {0})
    end
    --table.insert(attackManager.queue, {0})
end
function attackManager.barrage1()
    local aaa 
    if math.random() > 0.5 then
        aaa = {1, 2, 5, 6}
        table.insert(attackManager.queue, aaa)
    end
    aaa = {3, 4, 7, 8}
    table.insert(attackManager.queue, aaa)
    aaa = {1, 2, 5, 6}
    table.insert(attackManager.queue, aaa)
    aaa = {3, 4, 7, 8}
    table.insert(attackManager.queue, aaa)
    aaa = {1, 2, 5, 6}
    table.insert(attackManager.queue, aaa)
    table.insert(attackManager.queue, {0})
end
function attackManager.barrage2()
    local aaa 
    if math.random() > 0.5 then
        aaa = {1, 3, 5, 7}
        table.insert(attackManager.queue, aaa)
    end
    aaa = {2, 4, 6, 8}
    table.insert(attackManager.queue, aaa)
    aaa = {1, 3, 5, 7}
    table.insert(attackManager.queue, aaa)
    aaa = {2, 4, 6, 8}
    table.insert(attackManager.queue, aaa)
    aaa = {1, 3, 5, 7}
    table.insert(attackManager.queue, aaa)
    aaa = {2, 4, 6, 8}
    table.insert(attackManager.queue, aaa)
    table.insert(attackManager.queue, {0})
end
function attackManager.pillar1()
    local pillarSide = math.random(1, 4) * 2 + 9
    for ii = 1, math.random(1, 2) do
        table.insert(attackManager.queue, {pillarSide, pillarSide-1, pillarSide-2, pillarSide-3, pillarSide-4, pillarSide-5, -1})
        for i=1, 20 do
            table.insert(attackManager.queue, {pillarSide, -1})
        end
        table.insert(attackManager.queue, {pillarSide, pillarSide+1, pillarSide+2, pillarSide+3, pillarSide+4, pillarSide+5, -1})
        for i=1, 20 do
            table.insert(attackManager.queue, {pillarSide, -1})
        end
    end
    table.insert(attackManager.queue, {0})
end
-- function attackManager.pillar2() TOOHARD
--     local pillarSide = math.random(1, 4) * 2 + 9
--     for ii = 1, math.random(1, 2) do
--         table.insert(attackManager.queue, {pillarSide, pillarSide-1, pillarSide-2, pillarSide-3, pillarSide-4, pillarSide-5, pillarSide-6, -1})
--         for i=1, 20 do
--             table.insert(attackManager.queue, {pillarSide, -1})
--         end
--         table.insert(attackManager.queue, {pillarSide, pillarSide+1, pillarSide+2, pillarSide+3, pillarSide+4, pillarSide+5, pillarSide+6, -1})
--         for i=1, 20 do
--             table.insert(attackManager.queue, {pillarSide, -1})
--         end
--     end
--     table.insert(attackManager.queue, {0})
-- end

local queueIndex = 1
local queueTimer = 1
local queueTimerOffset = 0
local delay = 99999999999999

function attackManager.update(dt)
    if player.dead then
        queueIndex = 1
        queueTimer = 1
        queueTimerOffset = 0
        return false
    end
    
    --_G.testValue = queueTimerOffset
    -- 큐 처리
    local t = _G.gameTimer
    if t >= (queueTimer - queueTimerOffset) * delay then
        if #attackManager.queue >= queueIndex then
            for i, v in ipairs(attackManager.queue[queueIndex]) do
                if v > 0 then
                    local bozo = ((v - 1) % 8) + 1
                    wall.newInstance(bozo)
                end
                if v == -1 then
                    queueTimerOffset = queueTimerOffset + .9
                end
            end
            queueIndex = queueIndex + 1
        end
        queueTimer = queueTimer + 1
    end
end

return attackManager