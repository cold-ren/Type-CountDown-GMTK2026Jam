local C = require("const")
local Game = require("game")
local GameComplete = {}

function GameComplete:load()

end

function GameComplete:update()

end

function GameComplete:draw()
    local text = "Yes, that's the whole game.\nI don't have enough time T_T\n\nI only started programming recently.\nSo if you have time to check out the code in GitHub, please leave me any comment of how I could do better. I needed that.\n\nThank you! :D"
    
    love.graphics.setFont(C.font.s)

    love.graphics.printf(
        text,
        (C.virWidth - 280) / 2,    -- x
        90,    -- y
        280,    -- maximum width
        "center"  -- alignment: "left", "center", "right", or "justify"
)
end

function GameComplete:keypressed(key)
    if key == "return" then
        Game.StateManager:setState(Game.MainMenu)
    end
end

return GameComplete