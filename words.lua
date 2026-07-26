local Words = {}

function Words.load()
    local dictionary = {}

    local contents = love.filesystem.read("assets/enable1.txt")
    local count = 0
    for word in contents:gmatch("[^\r\n]+") do
        dictionary[word] = true
    end

    return dictionary
end

return Words