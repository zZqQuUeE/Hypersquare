_G.cameraAngle = 45
_G.cameraTilt = 0.8

--#region 모듈불러오기
-- 기본적인거
local utils = require("src.utils")
local input = require("src.input")

-- 게임중기본적인거
local background = require("src.background")
local pulse = require("src.pulse")
local wall  = require("src.wall")
local player = require("src.player")
local attackManager = require("src.attackManager")

-- 유아이
local ui = require("src.ui")

-- 테스트용
local debug = require("test.debug")
--#endregion

--#region 변수들
local gameCanvas
local screenW, screenH = love.graphics.getDimensions()
--#endregion

-- 로드
function love.load()
    pulse.load()

    -- 해상도
    gameCanvas = love.graphics.newCanvas(1280, 720)
    love.window.setMode(screenW, screenH, {
        fullscreen = true,
        resizable = true,
        vsync = 1,
        msaa = 0
    })
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
    _G.cameraTilt = math.sin(love.timer.getTime())*0.3 + 0.7
    _G.cameraAngle = _G.cameraAngle + 300 * dt
    debug.update(dt)

    -- ~~Manager
    attackManager.update(dt)

    -- 게임의기본적인것들
    pulse.update(dt)
    wall.update(dt)
    player.update(dt)

    -- ui
    ui.update(dt)
    if input.isPressed("f11") then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    input.update()
end

-- 그리기
function love.draw()
    -- 리셋
    love.graphics.push()
    love.graphics.translate(pulse.x, pulse.y)
    love.graphics.rotate(math.rad(_G.cameraAngle))
    love.graphics.translate(-pulse.x, -pulse.y)
    love.graphics.setColor(1, 1, 1, 1)

    -- 그리기
    love.graphics.setCanvas(gameCanvas)
    love.graphics.clear(0, 0, 0, 1)
    background.draw()
    wall.draw()
    pulse.draw()
    player.draw()
    love.graphics.pop()
    love.graphics.setCanvas()

    -- 게임캔버스그리기
    screenW, screenH = love.graphics.getDimensions()
    local bx, by = 1280, 720-- * math.min(_G.cameraTilt, 1)
    local scale = math.max(screenW / bx, screenH / by)

    local offsetX = (screenW - bx * scale) / 2
    local offsetY = (screenH - by * scale) / 2
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, offsetX, offsetY, 0, scale, scale * math.min(_G.cameraTilt, 1))

    -- ui그리기
    ui.draw()
end