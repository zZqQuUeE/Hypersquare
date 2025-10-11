_G.cameraAngle = 0
_G.cameraTilt = 1
_G.cameraRotateSpeed = 0
--_G.gameStarted = false
_G.gameTimer = -1
_G.testValue = false
_G.inLevelSelect = true

--#region 모듈불러오기
-- 라이브러리
local dkjson = require("libs.dkjson")

-- 기본적인거
local utils = require("src.utils")
local input = require("src.input")
local touchManager = require("src.touchManager")

-- 게임중기본적인거
local background = require("src.background")
local pulse = require("src.pulse")
local wall  = require("src.wall")
local player = require("src.player")
local attackManager = require("src.attackManager")
local audioManager = require("src.audioManager")

-- 유아이
local ui = require("src.ui")

-- 기타등듣
local mainMenu = require("src.mainMenu")
local debug = require("test.debug")
--#endregion

--#region 변수들
local gameCanvas
local wallCanvas
local backgroundCanvas
local uiCanvas
local screenW, screenH = love.graphics.getDimensions()

local startGameTimer = 0
--#endregion

-- 로드
function love.load()
    mainMenu.load()
    ui.load()
    pulse.load()

    -- 해상도
    love.window.setMode(screenW, screenH, {
        fullscreen = false,
        resizable = false,
        vsync = 1,
        msaa = 4
    })
    gameCanvas = love.graphics.newCanvas(1920, 3600)
    backgroundCanvas = love.graphics.newCanvas(1920, 3600)
    wallCanvas = love.graphics.newCanvas(1920, 3600)
    uiCanvas = love.graphics.newCanvas(1280, 720)
    love.graphics.setDefaultFilter("nearest", "nearest")
end

-- 입력감지
function love.keypressed(key)
    input.keypressed(key)
end
function love.keyreleased(key)
    input.keyreleased(key)
end

-- 업뎃
local musicPositions = {0, 13.9, 36} -- TODO 이건임시
function love.update(dt)
    _G.cameraAngle = _G.cameraAngle + dt * _G.cameraRotateSpeed
    
    if not player.dead then
        if startGameTimer == -1 then
            startGameTimer = love.timer.getTime()
            if nil == audioManager.music then
                audioManager.newMusic("assets/sounds/suwa.ogg")
            else
                audioManager.music:play()
                audioManager.music:seek(musicPositions[math.random(1, #musicPositions)])
            end
        end
        _G.gameTimer = love.timer.getTime() - startGameTimer
    else
        startGameTimer = -1
        if audioManager.music then
            audioManager.music:stop()
        end
    end
    
    debug.update(dt)

    -- ~~Manager
    attackManager.update(dt)

    -- 게임의기본적인것들
    pulse.update(dt)
    wall.update(dt)
    player.update(dt)

    -- ui
    ui.update(dt)
    
    -- 기타등등
    mainMenu.update(dt)
    
    -- 입력처리
    input.update()
    touchManager.update()
end

-- 그리기
function love.draw()
    -- 변수
    screenW, screenH = love.graphics.getDimensions()
    local bx, by = 1280, 720
    local scale = math.max(screenW / bx, screenH / by)
    --local offsetX = (screenW - bx * scale) / 2
    --local offsetY = (screenH - by * scale) / 2
    --offsetY = (screenH - by * scale * math.min(_G.cameraTilt, 1)) / 2
    local function threeD(canv)
        local shadowDepth = 4 -- TODO 그림자 깊이 (한번그릴때 이 값만큼 내려감)
        local shadowAmount = 10 -- 그림자 몇번그리는지
        local shadowAlpha = .5 -- 첫 그림자 투명도
        local shadowColor = {0, 1, 0} -- 그림자색
        local shadowFade = -0.05 -- 이 값 만큼 투명도가늘음 음수면줄겟죠?????
        for si = 1, shadowAmount do
            local alp = shadowAlpha + shadowFade * si
            local rd = shadowDepth * (1-_G.cameraTilt)
            love.graphics.setColor(shadowColor[1], shadowColor[2], shadowColor[3], alp)
            love.graphics.draw(canv, screenW/2, screenH/2 + shadowDepth * si * rd, 0, scale, scale * math.min(_G.cameraTilt, 1), canv:getWidth()/2, canv:getHeight()/2)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- 리셋
    local function reset(followAngle)
        love.graphics.push()
        if followAngle then
            love.graphics.translate(pulse.x, pulse.y)
            love.graphics.rotate(math.rad(_G.cameraAngle))
            love.graphics.translate(-pulse.x, -pulse.y)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- 캔버스내용그리기 (배경)
    reset(true)
    love.graphics.setCanvas(backgroundCanvas)
    love.graphics.clear(0, 0, 0, 0)
    background.draw()
    love.graphics.pop()

    -- 캔버스내용그리기 (펄스랑플레이어)
    reset(true)
    love.graphics.setCanvas(gameCanvas)
    love.graphics.clear(0, 0, 0, 0)
    pulse.draw()
    player.draw()
    love.graphics.pop()
    
    -- 캔버스내용그리기 (벽)
    reset(true)
    love.graphics.setCanvas(wallCanvas)
    love.graphics.clear(0, 0, 0, 0)
    wall.draw()
    love.graphics.pop()

    -- 캔버스내용그리기 (ui)
    reset(false)
    love.graphics.setCanvas(uiCanvas)
    love.graphics.clear(0, 0, 0, 0)
    ui.draw()
    love.graphics.pop()

    love.graphics.setCanvas()

    -- 캔버스그리기
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(backgroundCanvas, screenW/2, screenH/2, 0, scale, scale * math.min(_G.cameraTilt, 1), backgroundCanvas:getWidth()/2, backgroundCanvas:getHeight()/2)
    threeD(gameCanvas)
    threeD(wallCanvas)
    love.graphics.draw(wallCanvas, screenW/2, screenH/2, 0, scale, scale * math.min(_G.cameraTilt, 1), wallCanvas:getWidth()/2, wallCanvas:getHeight()/2)
    love.graphics.draw(gameCanvas, screenW/2, screenH/2, 0, scale, scale * math.min(_G.cameraTilt, 1), gameCanvas:getWidth()/2, gameCanvas:getHeight()/2)

    -- ui그리기
    local scope = 1
	if screenW / 1280 < screenH / 720 then
		scope = screenH / 720
	else
		scope = screenW / 1280
    end
	local guiw = screenW / scope
	local guih = screenH / scope
    love.graphics.draw(uiCanvas, 0, 0, 0, scope, scope)
end