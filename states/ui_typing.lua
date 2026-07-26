local C = require("const")

local UI = {}

--------------------------------------------------

local function boxSpecs(x, y, w, h)
    return {
        x = x,
        y = y,
        w = w,
        h = h
    }
end

--------------------------------------------------

local tfW, tfH = 180, 30

UI.typeField = boxSpecs(
    (C.virWidth - tfW) / 2,
    C.virHeight - (tfH + 15),
    tfW,
    tfH
)

local tmW, tmH = 20, 120

UI.timerMeter = boxSpecs(
    C.virWidth - (tmW + 30),
    (C.virHeight / 2) - tmH + 60,
    tmW,
    tmH
)

local sW, sH = 320, 30

UI.scoreBar = boxSpecs(
    (C.virWidth - sW) / 2,
    sH,
    sW,
    sH
)

--------------------------------------------------

function UI:load()
    love.graphics.setLineWidth(1)
end

function UI:update(dt, typing)
    -- Reserved for future UI-only effects
    -- (cursor blink, animations, etc.)
end

function UI:draw(typing)
    local tf = self.typeField
    local tm = self.timerMeter
    local s = self.scoreBar
    
    local timerRatio = typing.patienceTimer / typing.maxPatience
    local timerFill = (tm.h - 8) * timerRatio

    local scoreRatio = typing.score / typing.scoreTarget
    local scoreFill = (s.w - 8) * scoreRatio

    local wordLength = C.font.s:getWidth(typing.input.text)
    local cursorHeight = C.font.s:getHeight()

    -- Type field
    love.graphics.rectangle(
        "line",
        tf.x,
        tf.y,
        tf.w,
        tf.h
    )

    -- Timer outline
    love.graphics.rectangle(
        "line",
        tm.x,
        tm.y,
        tm.w,
        tm.h
    )

    -- Timer fill
    love.graphics.rectangle(
        "fill",
        tm.x + 4,
        tm.y + tm.h - 4 - timerFill,
        tm.w - 8,
        timerFill
    )

    -- Score bar
    love.graphics.rectangle(
        "line",
        s.x,
        s.y,
        s.w,
        s.h
    )

    -- Score bar fill
    love.graphics.rectangle(
        "fill",
        s.x + 4,
        s.y + 4,
        scoreFill,
        s.h - 8
    )

    -- Typed text
    love.graphics.setFont(C.font.s)
    love.graphics.print(
        typing.input.text,
        tf.x + 5,
        tf.y + 7
    )

    -- Cursor
    love.graphics.rectangle(
        "fill",
        tf.x + 5 + wordLength,
        tf.y + 7,
        2,
        cursorHeight
    )

    -- Bonus letter
    love.graphics.setFont(C.font.m)
    love.graphics.print("Bonus Letter: ", 10, 64)
    love.graphics.setFont(C.font.m)
    love.graphics.print(
        typing.bonusLetter,
        10,
        80
    )

    -- Require letter
    love.graphics.setFont(C.font.m)
    love.graphics.print("Current Letter: ", 10, 112)
    love.graphics.setFont(C.font.m)
    love.graphics.print(
        typing.requiredLetter,
        10,
        144
    )

end

return UI