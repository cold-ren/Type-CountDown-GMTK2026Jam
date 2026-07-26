local StateManager = {}

StateManager.currentState = nil
StateManager.stack = {}
StateManager.loadedStates = {}

------------------------------------------------------------

function StateManager:getState()
    return self.currentState
end

------------------------------------------------------------

function StateManager:setState(newState)
    -- Clear the stack
    self.stack = {}

    -- Reset current state
    self.currentState = nil

    -- Push the new state
    self:push(newState)
end

------------------------------------------------------------

function StateManager:push(newState)
    -- Pause current state
    if self.currentState and self.currentState.exit then
        self.currentState:exit()
    end

    table.insert(self.stack, newState)
    self.currentState = newState

    -- Load only once
    if not self.loadedStates[newState] then
        if newState.load then
            newState:load()
        end

        self.loadedStates[newState] = true
    end

    -- Called every time the state becomes active
    if newState.enter then
        newState:enter()
    end
end

------------------------------------------------------------

function StateManager:pop()
    if #self.stack <= 1 then
        return
    end

    -- Exit current state
    if self.currentState and self.currentState.exit then
        self.currentState:exit()
    end

    table.remove(self.stack)

    -- Resume previous state
    self.currentState = self.stack[#self.stack]

    if self.currentState and self.currentState.enter then
        self.currentState:enter()
    end
end

------------------------------------------------------------

function StateManager:update(dt)
    if self.currentState then
        self.currentState:update(dt)
    end
end

------------------------------------------------------------

function StateManager:draw()
    -- Draw every state from bottom to top
    for _, state in ipairs(self.stack) do
        if state.draw then
            state:draw()
        end
    end
end

------------------------------------------------------------

function StateManager:keypressed(key)
    if self.currentState and self.currentState.keypressed then
        self.currentState:keypressed(key)
    end
end

------------------------------------------------------------

function StateManager:textinput(text)
    if self.currentState and self.currentState.textinput then
        self.currentState:textinput(text)
    end
end

------------------------------------------------------------

return StateManager