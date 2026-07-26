local suit = require("lib.suit")
local Game = require("game")
local C = require("const")
local SoundManager = require("lib.soundManager")

local MainMenu = {}

function MainMenu:load()

end

function MainMenu:update(dt)
    local w = 120
    local h = 30
    local x = (C.virWidth - w) / 2
    local y = 120
    local padX = 0
    local padY = 10

    love.graphics.setFont(C.font.m)

    if suit.Button("Play", x, y, w, h).hit then
        Game.StateManager:setState(Game.Typing)
    end
    suit.Button("Settings", x, y + h + padY, w, h)
    if suit.Button("Quit", x, y + ((h + padY) * 2), w, h).hit then
        love.event.quit()
    end
    
    SoundManager:update()
end

function MainMenu:draw()

end

function MainMenu:keypressed(key)
    if key == "return" then
        Game.StateManager:setState(Game.Typing)
    end
    if key == "escape" then
        love.event.quit()
    end
end

return MainMenu