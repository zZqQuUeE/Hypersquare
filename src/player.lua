local utils = require("src.utils")
local input = require("src.input")
local pulse = require("src.pulse")
local colorManager = require("src.colorManager")
local player = {
    angle = 0,
    tangle = 0,
    focus = false,
    mujeok = false,
    spd = 0.5 -- lerp(a, b, amt) 에서 amt 부분 (1이최대)
}

function player.update(dt)
    if input.isPressed("a") then
        player.tangle = player.tangle + 45
    end
    if input.isReleased("a") then
        player.tangle = player.tangle + 45
    end
    if input.isPressed("d") then
        player.tangle = player.tangle - 45
    end
    if input.isReleased("d") then
        player.tangle = player.tangle - 45
    end
    player.angle = utils.lerp(player.angle, player.tangle, player.spd)
end

function player.draw()
    local x = pulse.x + utils.lengthDirX(30 + pulse.actualSize / 2, player.angle)
    local y = pulse.y + utils.lengthDirY(30 + pulse.actualSize / 2, player.angle)
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    love.graphics.rectangle("fill", x - 5, y - 5, 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

return player