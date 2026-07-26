local suit = require("lib.suit")
local Game = require("game")
local C = require("const")

local PauseMenu = {}

function PauseMenu:update(dt)
    local w = 120
    local h = 30
    local x = (C.virWidth - w) / 2
    local y = 120
    local padX = 0
    local padY = 10

    love.graphics.setFont(C.font.m)

    if suit.Button("Resume", x, y, w, h).hit then
        Game.StateManager:pop()
    end
    suit.Button("Settings", x, y + h + padY, w, h)
    if suit.Button("Menu", x, y + ((h + padY) * 2), w, h).hit then
        Game.StateManager:setState(Game.MainMenu)
    end
end

function PauseMenu:draw()
    
    -- Dim gameplay
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, C.virWidth, C.virHeight)

    love.graphics.setColor(1, 1, 1, 1)
end

function PauseMenu:keypressed(key)
    if key == "escape" then
        Game.StateManager:pop()
    end
end

return PauseMenu