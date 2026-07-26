local push = require("lib.push")
local suit = require("lib.suit")

local C = require("const")
local Game = require("game")
local SoundManager = require("lib.soundManager")

Game.StateManager = require("lib.stateManager")
Game.ResultPage = require("states.resultPage")
Game.Typing = require("states.typing")
Game.MainMenu = require("states.mainMenu")
Game.PauseMenu = require("states.pauseMenu")
Game.GameComplete = require("states.gameComplete")

-----------------------------------------------------------------------------
function love.load()
    SoundManager:init("bgm", "assets/sounds/bgm_1.mp3", "stream")
    SoundManager:play("bgm", "b1", 0.5, 0.8, true)

    love.graphics.setDefaultFilter("nearest","nearest")
    
    push:setupScreen(
        C.virWidth, 
        C.virHeight, 
        C.winWidth, 
        C.winHeight, 
        {
            fullscreen = false, 
            vsync = true, 
            resizable = true
        }
    )
    love.keyboard.setKeyRepeat(true)

    Game.StateManager:setState(Game.MainMenu)
end
-----------------------------------------------------------------------------
function love.update(dt)

    local virMouseX, virMouseY = push:toGame(love.mouse.getPosition())
    suit.updateMouse(virMouseX, virMouseY, love.mouse.isDown(1))

    Game.StateManager:update(dt)
end
-----------------------------------------------------------------------------
function love.draw()
    push:start()

    Game.StateManager:draw()
    suit:draw()

    push:finish()
end
-----------------------------------------------------------------------------
function love.resize(w,h)
    push:resize(w,h)
end
-----------------------------------------------------------------------------
function love.textinput(text)
    Game.StateManager:textinput(text)
    suit:textinput(text)
end
-----------------------------------------------------------------------------
function love.keypressed(key)
    Game.StateManager:keypressed(key)
    suit:keypressed(key)
end
-----------------------------------------------------------------------------
