local dkjson = require("libs.dkjson")

local colorManager = require("src.colorManager")
local touchManager = require("src.touchManager")

local mainMenu = {
    levelList = {},
    selectedLevel = 1,
    selectDelay = 0
}

function mainMenu.load()
    mainMenu.levelList = {}
    local levels = love.filesystem.getDirectoryItems("levels")
    for i, v in ipairs(levels) do
        if v:match("%.json$") then
            local good, json = pcall(love.filesystem.read, "string", "levels/"..v)
            if good and json then
                local good2, data = pcall(dkjson.decode, json, 1, nil)
                if good2 and data then
                    if data.selectable then
                        local t = {
                                fileName = v,
                                priority = data.menuPriority or math.huge(),
                        }
                        t.data = data
                        table.insert(mainMenu.levelList, t)
                    end
                end
            end
        end
    end
    
    -- 정렬 (키 menuPriority의 값이 작을수록 먼저), 못고르는거쳐내기 (selectable이 false)
    table.sort(mainMenu.levelList, function(a, b)
        return a.priority < b.priority
    end)
    
    -- 미리보기
    local level = mainMenu.levelList[mainMenu.selectedLevel].data
    colorManager.color1 = level.color1--{level.color1[1], level.color1[2], level.color1[3]}
    colorManager.color2 = level.color2--{level.color2[1], level.color2[2], level.color2[3]}
    colorManager.backgroundColor = level.backgroundColor
    _G.cameraRotateSpeed = level.menuRotateSpeed
end

function love.touchpressed(id, x, y)
    print(11)
end

function mainMenu.update(dt)
    mainMenu.selectDelay = mainMenu.selectDelay - dt
    -- TODO 왼쪽오른쪽으로 레벨고르기
    
    -- TODO 가운데터치로 레벨시작 (이 둘 하려면 먼저 touchManager를만들어아되오)
end

function mainMenu.draw()
    local guiw, guih = love.graphics.getDimensions()
    local ui = require("src.ui")
    local level = mainMenu.levelList[mainMenu.selectedLevel].data
    local levelName = level["name"]
    local levelDesc = level["description"]
    ui.drawText(levelName, 0, 20, 4, ui.fontBig2)
    ui.drawText(levelDesc, 0, 110, 2, ui.fontMain)
end

return mainMenu