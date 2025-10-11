local utils = require("src.utils")
local input = require("src.input")
local colorManager = require("src.colorManager")
local mainMenu = require("src.mainMenu")
local ui = {
    deathEffect = 0
}

function ui.load()
    ui.fontMain = love.graphics.newFont("assets/misc/gamefont.ttf", 32)
    ui.fontSmall = love.graphics.newFont("assets/misc/gamefont.ttf", 16)
    ui.fontBig1 = love.graphics.newFont("assets/misc/gamefont.ttf", 48)
    ui.fontBig2 = love.graphics.newFont("assets/misc/gamefont.ttf", 64)
    ui.fontBig3 = love.graphics.newFont("assets/misc/gamefont.ttf", 64+32)
    love.graphics.setFont(ui.fontMain)
    --ui.fontJp = love.graphics.newFont("assets/misc/gamejpfont.ttf", 32)
end

function ui.update(dt)
    if ui.deathEffect > 0 then
        ui.deathEffect = ui.deathEffect - 2 * dt
    end
    
    if input.isPressed("f11") then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end

function ui.drawText(text, x, y, t, font, w, align)
    local guiw, guih = 1280, 720
    font = font or ui.fontMain
    love.graphics.setFont(font)
    w = w or guiw
    align = align or "center"
    local textW = font:getWidth(text)
    local textH = font:getHeight()
    -- 정렬 보정
    -- if align == "center" then
    --     x = x - w / 2
    -- elseif align == "right" then
    --     x = x - w
    -- end
    --y = y + textH / 2
    -- x = 0
    
    love.graphics.setColor(colorManager.color2[1], colorManager.color2[2], colorManager.color2[3])
    love.graphics.printf(text, x+t, y, w, align)
    love.graphics.printf(text, x, y+t, w, align)
    love.graphics.printf(text, x-t, y, w, align)
    love.graphics.printf(text, x, y-t, w, align)
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    love.graphics.printf(text, x, y, w, align)
end

function ui.draw()
    if _G.inLevelSelect then
        mainMenu.draw()
    end
    
    -- 인게임유아이
    if not _G.inLevelSelect then
        ui.drawText(utils.round(_G.gameTimer*100)/100, 12, 12, 2)
        ui.drawText(love.timer.getFPS().." FPS", 12, 36, 2)
    end
    
    -- 죽엇을때이펙
    if ui.deathEffect > 0 and not _G.inLevelSelect then
        love.graphics.setColor(1, 1, 1, ui.deathEffect)
        love.graphics.rectangle("fill", 0, 0, 9999, 9999)
    end
    
    -- test thingy
    --love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    --love.graphics.print(love.timer.getFPS(), 12, 36)
    if _G.testValue then love.graphics.print(_G.testValue, 12, 60) end
end

return ui