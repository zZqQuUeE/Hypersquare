--#region 모듈불러오기
-- 기본적인거
local utils = require("src.input")
local input = require("src.input")

-- 게임중기본적인거
local background = require("src.background")
local pulse = require("src.pulse")
local wall  = require("src.wall")
local player = require("src.player")
local attackManager = require("src.attackManager")

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

    attackManager.update(dt)

    pulse.update(dt)
    wall.update(dt)
    player.update(dt)

    input.update()
end

-- 그리기
function love.draw()
    -- 리셋
    love.graphics.push()

    -- 화면 중심 기준으로 이동
    love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    -- 45도 회전 (라디안 단위)
    love.graphics.rotate(math.rad(love.timer.getTime()*60))
    -- 다시 원점으로 돌려놓기
    love.graphics.translate(-love.graphics.getWidth()/2, -love.graphics.getHeight()/2)
    love.graphics.setColor(1, 1, 1, 1)
    background.draw()
    wall.draw()
    pulse.draw()
    player.draw()
    love.graphics.pop()
end