local C = require("const")
local Game = require("game")
local ResultPage = {}

function ResultPage:load()

end

function ResultPage:update()

end

function ResultPage:draw()
    local winText = "Day Cleared"
    local loseText = "Try again"
    local x = (C.virWidth - C.font.l:getWidth(winText)) / 2
    local y = (C.virHeight - C.font.l:getHeight(winText)) / 2
    love.graphics.setFont(C.font.l)

    if Game.stageResult == "win" then
        love.graphics.print(winText, x, y)
    else
        love.graphics.print(loseText, x,y)
    end
        
end

function ResultPage:keypressed(key)
    if key == "return" then
        if Game.stageResult == "win" then
            if Game.Typing:nextStage() then
                Game.StateManager:setState(Game.Typing)
            else
                -- Finished all stages
                Game.StateManager:setState(Game.GameComplete)
            end
        else
            Game.StateManager:setState(Game.MainMenu)
        end
    end
end

return ResultPage