local utils = require("src.utils")
local colorManager = require("src.colorManager")
local pulse = require("src.pulse")

local screenW = love.graphics.getWidth()
local screenH = love.graphics.getHeight()

local background = {}

function background.draw()
    --love.graphics.polygon("fill", pulse.x, pulse.y, pulse.x+10000, pulse.y-10000, pulse.x-10000, pulse.y-10000)
    local col
    local function setcol(s)
        col = colorManager.backgroundColor[s]
        love.graphics.setColor(col[1], col[2], col[3])
    end
    setcol(1)
    love.graphics.rectangle("fill", pulse.x, pulse.y - pulse.actualSize / 2, 9999, pulse.actualSize)
    setcol(2)
    love.graphics.rectangle("fill", pulse.x + pulse.actualSize / 2, -9999, 9999, 9999 + pulse.y - pulse.actualSize / 2)
    setcol(3)
    love.graphics.rectangle("fill", pulse.x - pulse.actualSize / 2, -9999, pulse.actualSize, 9999 + pulse.y - pulse.actualSize / 2)
    setcol(4)
    love.graphics.rectangle("fill", pulse.x - pulse.actualSize / 2, pulse.y - pulse.actualSize / 2, -9999, -9999)
    setcol(5)
    love.graphics.rectangle("fill", pulse.x - pulse.actualSize / 2, pulse.y + pulse.actualSize / 2, -9999, -pulse.actualSize)
    setcol(6)
    love.graphics.rectangle("fill", pulse.x - pulse.actualSize / 2, pulse.y + pulse.actualSize / 2, -9999, 9999)
    setcol(7)
    love.graphics.rectangle("fill", pulse.x + pulse.actualSize / 2, pulse.y + pulse.actualSize / 2, -pulse.actualSize, 9999)
    setcol(8)
    love.graphics.rectangle("fill", pulse.x + pulse.actualSize / 2, pulse.y + pulse.actualSize / 2, 9999, 9999)

    love.graphics.setColor(1,1,1,1)
end

return background