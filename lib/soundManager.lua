local SoundManager = {
    active = {},
    source = {}
}

function SoundManager:init(id, source, soundType)
    assert(self.source[id] == nil, "Sound with that ID already exists")

    if type(source) == "table" then
        self.source[id] = {}
        for i = 1, #source do
            self.source[id][i] = love.audio.newSource(source[i], soundType)
        end
    else
        self.source[id] = love.audio.newSource(source, soundType)
    end
end

function SoundManager:clean(id)
    self.source[id] = nil
end

function SoundManager:play(id, channel, volume, pitch, loop)
    local source

    if type(self.source[id]) == "table" then
        source = self.source[id][love.math.random(1, #self.source[id])]
    else
        source = self.source[id]
    end

    channel = channel or "default"

    local clone = source:clone()
    clone:setVolume(volume or 1)
    clone:setPitch(pitch or 1)
    clone:setLooping(loop or false)
    clone:play()

    if self.active[channel] == nil then
        self.active[channel] = {}
    end

    table.insert(self.active[channel], clone)

    return clone
end

function SoundManager:setVolume(channel, volume)
    assert(self.active[channel] ~= nil, "Channel doesn't exist")

    for _, sound in pairs(self.active[channel]) do
        sound:setVolume(volume)
    end
end

function SoundManager:setPitch(channel, pitch)
    assert(self.active[channel] ~= nil, "Channel doesn't exist")

    for _, sound in pairs(self.active[channel]) do
        sound:setPitch(pitch)
    end
end

function SoundManager:stop(channel)
    assert(self.active[channel] ~= nil, "Channel doesn't exist")

    for _, sound in pairs(self.active[channel]) do
        sound:stop()
    end
end

function SoundManager:update()
    for _, channel in pairs(self.active) do
        for i = #channel, 1, -1 do
            if not channel[i]:isPlaying() then
                table.remove(channel, i)
            end
        end
    end
end

return SoundManager