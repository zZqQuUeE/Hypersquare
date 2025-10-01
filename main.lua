_G.cameraAngle = 0

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

-- 유아이
local ui = require("src.ui")

-- 테스트용
local debug = require("test.debug")
--#endregion

--#region 변수들
local gameCanvas
local screenW = love.graphics.getWidth()
local screenH = love.graphics.getHeight()
--#endregion

-- 로드
function love.load()
    pulse.load()

    -- 해상도
    gameCanvas = love.graphics.newCanvas(1920, 1080)
    love.window.setMode(screenW, screenH, {
        fullscreen = false,   -- 전체화면
        resizable = true,   -- 창 크기 조절 가능 여부
        vsync = 1,           -- 수직동기화 (0 = 끔, 1 = 켬)
        msaa = 1             -- 안티앨리어싱
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

function love.resize(w, h)
    screenW = love.graphics.getWidth()
    screenH = love.graphics.getHeight()
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
    local bx = 1920
    local by = 1080
    local scale = math.max(screenW / bx, screenH / by)
    local offsetX = (screenW - bx * scale) / 2
    local offsetY = (screenH - by * scale) / 2
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gameCanvas, offsetX, offsetY, 0, scale, scale)

    -- ui그리기
    ui.draw()
end