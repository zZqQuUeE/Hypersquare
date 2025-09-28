local utils = require("src.input")
local colorManager = require("src.colorManager")
local pulse = require("src.pulse")
local wall = {
    id = 100,
    thick = 20,
    spd = 500,
    instances = {}
}

function wall.update(dt)
    for i = #wall.instances, 1, -1 do
        local v = wall.instances[i]
        v.dist = v.dist - dt * wall.spd
        if v.dist <= -(pulse.actualSize/2) then
            table.remove(wall.instances, i)
        end
    end
end

function wall.newInstance(s)
    local ins = {
        dist = 900,
        side = s
    }
    table.insert(wall.instances, ins)
end

function wall.draw()
    for i, v in ipairs(wall.instances) do
        local col = colorManager.sideColor[v.side]
        love.graphics.setColor(col[1], col[2], col[3])
        if v.side == 1 then
            local px = pulse.x + pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px + v.dist, py, wall.thick, pulse.actualSize)
        elseif v.side == 2 then
            local px = pulse.x + pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px + v.dist, py - v.dist, wall.thick, v.dist)
            love.graphics.rectangle("fill", px, py - v.dist, v.dist, -wall.thick)
        elseif v.side == 3 then
            local px = pulse.x - pulse.actualSize/2
            local py = pulse.y - pulse.actualSize/2
            love.graphics.rectangle("fill", px, py - v.dist, pulse.actualSize, -wall.thick)
        end
        love.graphics.setColor(1, 1, 1)
    end
end

return wall