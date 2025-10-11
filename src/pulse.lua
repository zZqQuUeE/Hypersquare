local utils = require("src.utils")
local colorManager = require("src.colorManager")

local screenW = 1920
local screenH = 3600
local pulse = {
    size = 50,
    sizeOffset = 0,
    offsetSpeed = 2.2, -- sizeOffset이 줄거나 느는속도
    bpm = 172, -- -1이면 무효, 0이상아면 60/n 초 마다 sizeOffset 의 값이 bpmSizeOffset 의 값이 된다
    bpmSizeOffset = 70,
    outline = 10, -- 외곽선 두께 (0.5배됨 6은 실제로 두께 3인거)
    actualSize = 60,

    x = screenW / 2,
    y = screenH / 2,
    targetX = screenW / 2, -- x 좌표와 이 값이 다르면 거기로 감 (y 도 마찬가지)
    targetY = screenH / 2,
    targetMoveSpeed = 0.1 -- 가는 속도 (lerp 세번째파라매터)
}

function pulse.load()
    pulse.x = screenW / 2
    pulse.y = screenH / 2
end

local beatIndex = 1
function pulse.update(dt)
    if require("src.player").dead then
        beatIndex = 0
        return false
    end
    pulse.actualSize = pulse.size + pulse.sizeOffset
    
    -- _G.cameraTilt = math.sin(love.timer.getTime()/4*math.pi/(60/172)) * 0.2 + 0.8
    -- _G.cameraAngle = _G.cameraAngle + 250 * dt * utils.sign(math.sin(love.timer.getTime()/8*math.pi/(60/172)))
    -- if math.sin(_G.gameTimer*2*math.pi/(60/172/4)) > 0 then
    --     colorManager.wallColor = {
    --     {0.2, 0.9, 0.2},
    --     {0.8, 1, 0.2},
    --     {0.2, 0.9, 0.2},
    --     {0.8, 1, 0.2},
    --     {0.2, 0.9, 0.2}
    --     {0.8, 1, 0.2},
    --     {0.2, 0.9, 0.2},
    --     {0.8, 1, 0.2}
    -- }
    -- else
    --     colorManager.wallColor = {
    --     {0.5, 1, 0.5},{0.5, 1, 0.5},{0.5, 1, 0.5},{0.5, 1, 0.5},{0.5, 1, 0.5},{0.5, 1, 0.5},{0.5, 1, 0.5},{0.5, 1, 0.5},
    -- }
    -- end
    
    -- if _G.gameTimer > beatIndex * 60/pulse.bpm then
    --     pulse.sizeOffset = pulse.bpmSizeOffset
    --     beatIndex = beatIndex + 1
    --     local wall = require("src.wall")
    --     --require("src.attackManager").barrage1()
    --     local attackManager = require("src.attackManager")
    --     local rng = math.random(1, 6)
    --     if rng <= 1 then
    --         attackManager.tunnel2()
    --     elseif rng <= 2 then
    --         attackManager.tunnel1()
    --     elseif rng <= 3  then
    --         attackManager.tunnel4()
    --     elseif rng <= 4 then
    --         attackManager.tunnel3()
    --     elseif rng <= 5 then
    --         attackManager.pillar1()
    --     elseif math.random() < 0.5 then
    --         attackManager.barrage2()
    --     else
    --         attackManager.barrage1()
    --     end
    -- end
    
    -- 크기오프셋 줄이기
    if math.abs(pulse.sizeOffset) <= 1 then
        pulse.sizeOffset = 0
    else
        pulse.sizeOffset = pulse.sizeOffset - utils.sign(pulse.sizeOffset) * pulse.offsetSpeed * dt * 60
    end

    -- 위치옮기기
    pulse.x = utils.lerp(pulse.x, pulse.targetX, pulse.targetMoveSpeed)
    pulse.y = utils.lerp(pulse.y, pulse.targetY, pulse.targetMoveSpeed)
end

function pulse.draw()
    --local temp = pulse.size

    -- 외곽선
    --pulse.size = temp + pulse.sizeOffset + pulse.outline
    --pulse.actualSize = pulse.size
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    love.graphics.rectangle("fill", pulse.x - pulse.actualSize / 2, pulse.y - pulse.actualSize / 2, pulse.actualSize, pulse.actualSize)
    
    -- 안쪽
    love.graphics.setColor(colorManager.color2[1], colorManager.color2[2], colorManager.color2[3])
    love.graphics.rectangle("fill", pulse.x - (pulse.actualSize - pulse.outline) / 2, pulse.y - (pulse.actualSize - pulse.outline) / 2, pulse.actualSize - pulse.outline, pulse.actualSize - pulse.outline)
    --pulse.size = temp
end

return pulse