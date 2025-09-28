local input = {}

input.pressed = {}
input.released = {}

function input.keypressed(key)
    input.pressed[key] = true
end

function input.keyreleased(key)
    input.released[key] = true
end

function input.isPressed(key)
    return input.pressed[key]
end

function input.isReleased(key)
    return input.released[key]
end

function input.update()
    input.pressed = {}
    input.released = {}
end

return input