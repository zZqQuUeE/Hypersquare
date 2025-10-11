local utils = require("src.utils")
local colorManager = require("src.colorManager")
local pulse = require("src.pulse")
local ui = require("src.ui")
local audioManager = require("src.audioManager")
local wall = {
    id = 100,
    thick = 25,
    spd = 600,
    instances = {}
}

function wall.update(dt)
    local player = require("src.player")
    if player.dead then
        return false
    end
    for i = #wall.instances, 1, -1 do
        local v = wall.instances[i]
        v.pdist = v.dist
        v.dist = v.dist - dt * wall.spd
        if v.dist <= v.thick then
            table.remove(wall.instances, i)
        elseif not player.mujeok then
            -- 충돌
            local pulse = require("src.pulse")
            local rd = math.rad(player.angle % 360)
            local off = math.abs(math.sin(rd)) + math.abs(math.cos(rd))
            off = 1
            local plrx = pulse.x + utils.lengthDirX(pulse.actualSize*0.9*off, player.angle)
            local plry = pulse.y + utils.lengthDirY(pulse.actualSize*0.9*off, player.angle)
            local px, py = pulse.x, pulse.y
            local size = pulse.actualSize
            local wx, wy, ww, wh = 1, 1, 1, 1
            local coll = false
            
            -- 벽좌표정하기
            local function setWp(i)
                if v.side == 1 then
                    local px = pulse.x + pulse.actualSize/2
                    local py = pulse.y - pulse.actualSize/2
                    return px + v.dist + i+v.thick, py, -v.thick, pulse.actualSize
                elseif v.side == 2 then
                    wx = px + size/2 + v.dist + i + v.thick
                    wy = py - size/2 - v.dist - i - v.thick
                elseif v.side == 3 then
                    local px = pulse.x - pulse.actualSize/2
                    local py = pulse.y - pulse.actualSize/2
                    return px, py - v.dist, pulse.actualSize, -v.thick
                elseif v.side == 4 then
                    wx = px - size/2 - v.dist - i - v.thick
                    wy = py - size/2 - v.dist - i - v.thick
                elseif v.side == 5 then
                local px = pulse.x - pulse.actualSize/2
                local py = pulse.y - pulse.actualSize/2
                return px - v.dist, py, -v.thick, pulse.actualSize
                elseif v.side == 6 then
                    wx = px - size/2 - v.dist - i - v.thick
                    wy = py + size/2 + v.dist + i + v.thick
                elseif v.side == 7 then
                    local px = pulse.x - pulse.actualSize/2
                    local py = pulse.y + pulse.actualSize/2
                    return px, py + v.dist + v.thick, pulse.actualSize, -v.thick
                elseif v.side == 8 then
                    wx = px + size/2 + v.dist + i + v.thick
                    wy = py + size/2 + v.dist + i + v.thick
                end
                if i == v.pdist - v.dist and false then
                    v.pwx, v.pwy = wx, wy
                end
            end
            
            -- 충돌계산
            if true then
                local steps = math.ceil((v.pdist - v.dist) / 5)  -- 5픽셀 간격으로 보간
                for s = steps, 0, -1 do
                    local i = (s / steps) * (v.pdist - v.dist)
                    if v.side == 1 or v.side == 3 or v.side == 5 or v.side == 7 then
                        wx, wy, ww, wh = setWp(i)
                        --v.rx, v.ry, v.rw, v.rh = wx, wy, ww, wh
                        if utils.pointInRect_TopLeft(plrx, plry, wx, wy, ww, wh) then
                            coll = true
                            break
                        end
                    else
                        setWp(i)
                        if utils.CCCollision(wx, wy, v.thick/2, plrx, plry, 5) then
                            coll = true
                            break
                        end
                    end
                end
            end
            
            -- 충돌이면죽이기
            if coll and not player.dead then
                player.dead = true
                player.tangle = player.angle
                ui.deathEffect = 1
                --audioManager:newInstance("assets/sounds/og214/death.ogg", "static", "deathSound")
                local sfx = {
                    love.audio.newSource("assets/sounds/og214/death.ogg", "static")
                    ,love.audio.newSource("assets/sounds/og214/game_over.ogg", "static")
                    }
                love.audio.setVolume(audioManager.sfxVolume)
                love.audio.play(sfx[1])
                love.audio.play(sfx[2])
            end
        --     if v.dist > v.thick then
        --         -- for i = v.pdist - v.dist - v.thick/2 , 0, -1 do
        --         --     setWp(i)
        --         --     if utils.CCCollision(wx, wy, -v.thick/2, plrx, plry, 5) then
        --         --         coll = true
        --         --     end
        --         -- end
        --         local steps = math.ceil((v.pdist - v.dist) / 5)  -- 5픽셀 간격으로 보간
        --         for s = steps, 0, -1 do
        --             local i = (s / steps) * (v.pdist - v.dist)
        --             setWp(i)
        --             if utils.CCCollision(wx, wy, v.thick/2, plrx, plry, 5) then
        --                 coll = true
        --                 break
        --             end
        --         end
        --         v.wx, v.wy = wx, wy
        --     end
            
        --     -- 충돌이면죽이기
            
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
        love.graphics.setColor(1, 1, 1, 1)
        
        -- if v.rx then
        --     love.graphics.rectangle("fill", v.rx, v.ry, v.rw, v.rh)
        -- end
    end
end

return wall