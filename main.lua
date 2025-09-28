--#region 모듈불러오기
-- 기본적인거
local utils = require("src.input")
local input = require("src.input")

-- 게임중기본적인거
local pulse = require("src.pulse")
local wall  = require("src.wall")
local player = require("src.player")

-- 테스트용
local debug = require("test.debug")
--#endregion

-- 로드
function love.load()

end

-- 입력감지
function love.keypressed(key)
    input.keypressed(key)
end
function love.keyreleased(key)
    input.keyreleased(key)
end

-- 업뎃
function love.update(dt)
    debug.update(dt)

    pulse.update(dt)
    wall.update(dt)
    player.update(dt)

    input.update()
end

-- 그리기
function love.draw()
    -- 리셋
    love.graphics.setColor(1, 1, 1, 1)

    -- 펄스
    wall.draw()
    pulse.draw()
    player.draw()
end