local Game = require("game")
local C = require("const")
local UI = require("states.ui_typing")
local Words = require("words")
local StageData = require("stageData")
local suit = require("lib.suit")
local SoundManager = require("lib.soundManager")

local Typing = {}

local alphabet = {
    "a","b","c","d","e","f","g","h","i","j","k","l","m",
    "n","o","p","q","r","s","t","u","v","w","x","y","z"
}

------------------------------------------------------------------------------------
SoundManager:init("multiple", 
{
    "assets/sounds/sfx_kb1.mp3", 
    "assets/sounds/sfx_kb2.mp3", 
    "assets/sounds/sfx_kb3.mp3", 
    "assets/sounds/sfx_kb4.mp3"
}, 
"static")

SoundManager:init("complete",
    "assets/sounds/sfx_complete.mp3",
    "static"
)

------------------------------------------------------------------------------------

function Typing:load()
    self.stageData = StageData
    
    -- Load dictionary once
    self.dictionary = Words.load()
    
    -- Load UI once
    UI:load()
    
    -- Create tables once
    self.usedWords = {}
    
    self.input = {
        text = "",
        active = true
    }
    
    -- Starting stage
    self.stage = 1
end
------------------------------------------------------------------------------------
function Typing:enter()
    -- Stage settings
    self.maxPatience = self.stageData[self.stage].patience
    self.patienceTimer = self.maxPatience

    self.scoreTarget = self.stageData[self.stage].scoreTarget
    self.bonusCooldown = self.stageData[self.stage].bonusCooldown

    -- Gameplay
    self.score = 0

    self.usedWords = {}

    self.requiredLetter = ""
    self:generateLetter()

    -- Player input
    self.input.text = ""
    self.input.active = true

    -- Rewards
    self.reward = 3
    self.penalty = 1
end
------------------------------------------------------------------------------------
function Typing:nextStage()
    if self.stage < #self.stageData then
        self.stage = self.stage + 1
        return true
    end

    return false
end
------------------------------------------------------------------------------------
function Typing:update(dt)
    -- Patience timer
    self:countDownPatience(dt)
    self:stageFailedCheck(dt)

    -- Count down only if no bonus letter
    if self.bonusLetter == "" then
        self:countDownBonus(dt)
        
        if self.bonusCooldown <= 0 then
            self:generateLetter()
            self.bonusCooldown = 2
        end
    end

    UI:update(dt, self)
end
------------------------------------------------------------------------------------
function Typing:draw()
    UI:draw(self)
end
------------------------------------------------------------------------------------
function Typing:textinput(text)
    if not self.input.active then
        return
    end

    local tf = UI.typeField
    local newText = self.input.text .. text
    local wordLength = C.font.s:getWidth(newText)

    -- Check word length agains text box width
    if wordLength <= tf.w - 8 then
        self.input.text = newText
        SoundManager:play("multiple", "sfx", 0.8, 0.8)
    end
end
------------------------------------------------------------------------------------
function Typing:keypressed(key)
    if key == "backspace" then
        self.input.text = self.input.text:sub(1, -2)
        SoundManager:play("multiple", "sfx", 0.8, 0.8)
    end

    if key == "return" then
        self:submitWord()
    end

    if key == "escape" then
        Game.StateManager:push(Game.PauseMenu)
    end
end
------------------------------------------------------------------------------------
function Typing:submitWord()
    local word = self.input.text:lower()

    -- Check if empty
    if word == "" then
        print("type something")
        return
    end

    -- Check if in dictionary
    if not self.dictionary[word] then
        self:rejectWord(word)
        self.input.text = ""
        return
    end
    
    -- Check if it follows chaining rule
    if not self:checkChain(word) then
        self:rejectWord(word)
        self.input.text = ""
        return
    end

    if self:checkUsed(word) then
        self:rejectWord(word)
        self.input.text = ""
        return
    end
    
    -- Conditions met
    self:acceptWord(word)
    self.input.text = ""
end
------------------------------------------------------------------------------------
function Typing:acceptWord(word)
    local firstLetter = word:sub(1, 1)
    
    self.patienceTimer = math.min(
        self.maxPatience,
        self.patienceTimer + self.reward
    )

    print(word .. " is Valid")

    self.requiredLetter = word:sub(-1)
    print("Next letter is " .. self.requiredLetter)
    
    if firstLetter == self.bonusLetter then
        self.bonusLetter = ""
    end

    self.usedWords[word] = true

    self.score = math.min(
        self.scoreTarget,
        self.score + self:getWordScore(word)
    )
    print("score is " .. self.score)

    self:stageCompleteCheck()
end
------------------------------------------------------------------------------------
function Typing:stageCompleteCheck()
    if self.score >= self.scoreTarget then
        print("Stage Complete!")
        self.input.active = false
        Game.stageResult = "win"
        SoundManager:play("complete", "sfx", 0.5)
        Game.StateManager:setState(Game.ResultPage)
    end
end
------------------------------------------------------------------------------------
function Typing:stageFailedCheck(dt)
    if self.patienceTimer <= 0 then
        Game.result = "lose"
        Game.StateManager:setState(Game.ResultPage) 
    end
end
------------------------------------------------------------------------------------
function Typing:rejectWord(word)
    print(word .. " is Invalid")
    self.patienceTimer = self.patienceTimer - self.penalty
end
------------------------------------------------------------------------------------
function Typing:checkChain(word)
    local firstLetter = word:sub(1, 1)

    return firstLetter == self.requiredLetter
        or firstLetter == self.bonusLetter
end
------------------------------------------------------------------------------------
function Typing:checkUsed(word)
    print("Word is used")
    return self.usedWords[word]
end
------------------------------------------------------------------------------------
function Typing:generateLetter()
    self.bonusLetter = alphabet[love.math.random(#alphabet)]
    print("Bonus letter: " .. self.bonusLetter)
end
------------------------------------------------------------------------------------
function Typing:countDownPatience(dt)
    self.patienceTimer = math.max(0, self.patienceTimer - dt)
end
------------------------------------------------------------------------------------
function Typing:countDownBonus(dt)
    self.bonusCooldown = math.max(0, self.bonusCooldown - dt)
end
------------------------------------------------------------------------------------
function Typing:getWordScore(word)
    if #word <= 4 then
        return 2
    elseif #word <= 8 then
        return 4
    else
        return 8
    end
end
------------------------------------------------------------------------------------
return Typing
