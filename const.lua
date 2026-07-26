local C = {}

C.winWidth = love.graphics.getWidth()
C.winHeight = love.graphics.getHeight()
C.virWidth = 640
C.virHeight = 360
C.winCenter = love.graphics.getWidth()/2, love.graphics.getHeight()/2
C.font = {
    s = love.graphics.newFont("assets/monogram.ttf", 16),
    m = love.graphics.newFont("assets/monogram.ttf", 32),
    l = love.graphics.newFont("assets/monogram.ttf", 64)
}
for key, value in pairs(C.font) do
    value:setFilter("nearest", "nearest")
end

return C