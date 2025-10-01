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

local lp = false
local rp = false
local lr = false
local rr = false
local guiw = love.graphics.getWidth()
function love.touchpressed(id, x)
  if x > guiw/2 then
    require("src.attackManager").tunnel2()
    rp = true
  elseif x < guiw/2 then
    require("src.attackManager").tunnel1()
    lp = true
  end
end
function love.touchreleased(id, x)
  if x > guiw/2 then
    rr = true
  elseif x < guiw/2 then
    lr = true
  end
end

function player.update(dt)
    if input.isPressed("a") or lp then
        player.tangle = player.tangle + 45
    end
    if input.isReleased("a") or lr then
        player.tangle = player.tangle + 45
    end
    if input.isPressed("d") or rp then
        player.tangle = player.tangle - 45
    end
    if input.isReleased("d") or rr then
        player.tangle = player.tangle - 45
    end
    player.angle = utils.lerp(player.angle, player.tangle, player.spd)
    lp = false
    rp = false
    lr = false
    rr = false
end

function player.draw()
    local x = pulse.x + utils.lengthDirX(pulse.actualSize, player.angle)
    local y = pulse.y + utils.lengthDirY(pulse.actualSize, player.angle)
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    love.graphics.rectangle("fill", x - 5, y - 5, 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

return player