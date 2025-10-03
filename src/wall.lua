local utils = require("src.utils")
local colorManager = require("src.colorManager")
local pulse = require("src.pulse")
local wall = {
    id = 100,
    thick = 25,
    spd = 700,
    instances = {}
}

function wall.update(dt)
    for i = #wall.instances, 1, -1 do
        local v = wall.instances[i]
        v.dist = v.dist - dt * wall.spd
        if v.dist <= 0 then
            table.remove(wall.instances, i)
        end
    end
end

function wall.newInstance(s)
    local ins = {
        dist = 1000,
        side = s,
        thick = -wall.thick
    }
    table.insert(wall.instances, ins)
end

function wall.draw()
    for i, v in ipairs(wall.instances) do
        local col = colorManager.wallColor[v.side]
        love.graphics.setColor(col[1], col[2], col[3])
        if v.side == 1 then
            local px = pulse.x + pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px + v.dist, py, v.thick, pulse.actualSize)
        elseif v.side == 2 then
            local px = pulse.x + pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px + v.dist, py - v.dist, v.thick, v.dist)
            love.graphics.rectangle("fill", px, py - v.dist, v.dist, -v.thick)
        elseif v.side == 3 then
            local px = pulse.x - pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px, py - v.dist, pulse.actualSize, -v.thick)
        elseif v.side == 4 then
            local px = pulse.x - pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px - v.dist - v.thick, py - v.dist, v.thick, v.dist)
            love.graphics.rectangle("fill", px - v.dist, py - v.dist - v.thick, v.dist, v.thick)
        elseif v.side == 5 then
            local px = pulse.x - pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px - v.dist - v.thick, py, v.thick, pulse.actualSize)
        elseif v.side == 6 then
            local px = pulse.x - pulse.actualSize/2
            local py = pulse.y + pulse.actualSize/2
            love.graphics.rectangle("fill", px - v.dist, py + v.dist, v.dist, v.thick)
            love.graphics.rectangle("fill", px - v.dist - v.thick, py, v.thick, v.dist)
        elseif v.side == 7 then
            local px = pulse.x - pulse.actualSize/2
            local py = pulse.y + pulse.actualSize/2
            love.graphics.rectangle("fill", px, py + v.dist, pulse.actualSize, v.thick)
        elseif v.side == 8 then
            local px = pulse.x + pulse.actualSize/2
            local py = pulse.y + pulse.actualSize/2
            love.graphics.rectangle("fill", px + v.dist, py, v.thick, v.dist)
            love.graphics.rectangle("fill", px, py + v.dist, v.dist, v.thick)
        end
        love.graphics.setColor(1, 1, 1)
    end
end

return wall