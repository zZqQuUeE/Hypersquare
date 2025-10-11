local touch = {}
touch.pressed = {}
touch.released = {}

function love.touchpressed(id, x, y)
    
end

function love.touchreleased(id, x, y)
    
end

function touch.update()
    touch.pressed = {}
    touch.released = {}
end

return touch