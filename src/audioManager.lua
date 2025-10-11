local utils = require("src.utils")
local audioManager = {
    sfxVolume = 1,
    musicVolume = 0.7,
    music = nil,
}

function audioManager.newMusic(str, loop)
    local a = love.audio.newSource(str, "static")
    audioManager.music = a
    love.audio.setVolume(audioManager.musicVolume)
    loop = loop or true
    a:setLooping(loop)
    love.audio.play(a)
    return a
end

-- function newInstance(self, str, _type, name)
--     local a = love.audio.newSource(str, _type)
--     self.instances[name] = a
--     return a
-- end

return audioManager