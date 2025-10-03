local utils = require("src.utils")
local colorManager = require("src.colorManager")
local ui = {}

function ui.load()
    ui.fontMain = love.graphics.newFont("assets/misc/gamefont.ttf", 32)
    love.graphics.setFont(ui.fontMain)
    --ui.fontJp = love.graphics.newFont("assets/misc/gamejpfont.ttf", 32)
end

function ui.update(dt)
    
end

function ui.draw()
    love.graphics.setColor(colorManager.color2[1], colorManager.color2[2], colorManager.color2[3])
    love.graphics.print(utils.round(love.timer.getTime()*100)/100, 12, 12)
    love.graphics.setColor(colorManager.color1[1], colorManager.color1[2], colorManager.color1[3])
    love.graphics.print(utils.round(love.timer.getTime()*100)/100, 10, 10)
end

return ui