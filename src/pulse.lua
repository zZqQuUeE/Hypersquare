local utils = require("src.utils")
local colorManager = require("src.colorManager")

local screenW = love.graphics.getWidth()
local screenH = love.graphics.getHeight()
local pulse = {
    size = 20,
    sizeOffset = 0,
    offsetSpeed = .7, -- sizeOffset이 줄거나 느는속도
    bpm = 129, -- -1이면 무효, 0이상아면 60/n 초 마다 sizeOffset 의 값이 bpmSizeOffset 의 값이 된다
    bpmSizeOffset = 20,
    outline = 3, -- 외곽선 두께 (0.5배됨 6은 실제로 두께 3인거)
    actualSize = 60,

    x = screenW / 2,
    y = screenH / 2,
    targetX = screenW / 2, -- x 좌표와 이 값이 다르면 거기로 감 (y 도 마찬가지)
    targetY = screenH / 2,
    targetMoveSpeed = 0.1 -- 가는 속도 (lerp 세번째파라매터)
}

local beatIndex = 1
function pulse.update(dt)
    -- TODO 비피앰맞춰서 크기바꾸기 (이건임시) (브금만들고온다)
    local aaaClock = love.timer.getTime()
    if aaaClock > beatIndex * 60/pulse.bpm then
        pulse.sizeOffset = pulse.bpmSizeOffset
        beatIndex = beatIndex + 1
        local wall = require("src.wall")
        for i=1, 8 do
          --if math.random() < 0.3 then wall.newInstance(i) end
        end
    end
    
    -- 크기오프셋 줄이기
    if math.abs(pulse.sizeOffset) <= 1 then
        pulse.sizeOffset = 0
    else
        pulse.sizeOffset = pulse.sizeOffset - utils.sign(pulse.sizeOffset) * pulse.offsetSpeed * dt * 60
    end
end

function pulse.draw()
    local temp = pulse.size

    -- 외곽선
    pulse.size = temp + pulse.sizeOffset + pulse.outline
    pulse.actualSize = pulse.size
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    love.graphics.rectangle("fill", screenW / 2 - pulse.size / 2, screenH / 2 - pulse.size / 2, pulse.size, pulse.size)
    
    -- 안쪽
    pulse.size = temp + pulse.sizeOffset
    love.graphics.setColor(colorManager.color2[1], colorManager.color2[2], colorManager.color2[3])
    love.graphics.rectangle("fill", screenW / 2 - pulse.size / 2, screenH / 2 - pulse.size / 2, pulse.size, pulse.size)
    pulse.size = temp
end

return pulse