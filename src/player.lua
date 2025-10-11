local utils = require("src.utils")
local input = require("src.input")
local pulse = require("src.pulse")
local colorManager = require("src.colorManager")
local player = {
    angle = 0,
    tangle = 0,
    focus = false,
    mujeok = false,
    spd = .5, -- lerp(a, b, amt) 에서 amt 부분 (1이최대)
    dead = false,
}

local lp = false
local rp = false
local lr = false
local rr = false
local respawnTimer = 0
local respawnTouch = false
local guiw = love.graphics.getWidth()
function love.touchpressed(id, x)
  if x > guiw/2 then
    rp = true
  elseif x < guiw/2 then
    lp = true
  end
end
function love.touchreleased(id, x)
    if respawnTouch then
        respawnTouch = false
        return false
    end
  if x > guiw/2 then
    rr = true
  elseif x < guiw/2 then
    lr = true
  end
end

function player.update(dt)
    if _G.gameTimer > 0.2 and not player.dead then
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
    elseif player.dead and (lp or rp or input.isPressed("space")) and respawnTimer > 0.2 then
        player.dead = false
        respawnTouch = true
        respawnTimer = 0
        player.angle, player.tangle = 0, 0
        _G.cameraAngle = 0
        _G.cameraTilt = 1
        require("src.attackManager").queue = {}
        require("src.wall").instances = {}
        local sfx = love.audio.newSource("assets/sounds/og214/go.ogg", "static")
        love.audio.setVolume(require("src.audioManager").sfxVolume)
        love.audio.play(sfx)
    -- elseif (player.dead or not _G.inGame) and (input.isPressed("space") or lp or rp) then
    --     player.dead = false
    --     _G.inGame = true
    --     _G.cameraAngle = 0
    --     _G.cameraTilt = 1
    --     require("src.attackManager").queue = {}
    --     require("src.wall").instances = {}
    end
    player.angle = utils.lerp(player.angle, player.tangle, 1 - math.exp(-player.spd * dt * 60))
    lp = false
    rp = false
    lr = false
    rr = false
    if player.dead then
        respawnTimer = respawnTimer + dt
    end
end

function player.draw()
    local off = 1--n 은 45 + 90k도 (k=1,2,3)에 가까운정도, 정확히 45+90k도 면 1.414, 가장멀리떨어진 즉 90도같은 각이면 1이게
    --local rd = math.rad(player.angle % 360)
    --off = math.abs(math.sin(rd)) + math.abs(math.cos(rd))
    local x = pulse.x + utils.lengthDirX(pulse.actualSize*0.9*off, player.angle)
    local y = pulse.y + utils.lengthDirY(pulse.actualSize*0.9*off, player.angle)
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    love.graphics.rectangle("fill", x - 5, y - 5, 10, 10)
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3], 0.5)
    --love.graphics.rectangle("line", pulse.x - pulse.actualSize*0.9, pulse.y - pulse.actualSize*0.9, pulse.actualSize * 2*0.9, pulse.actualSize * 2*0.9)
    --love.graphics.circle("line", pulse.x, pulse.y, pulse.actualSize * 0.9)
    love.graphics.setColor(1, 1, 1, 1)
end

return player