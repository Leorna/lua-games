--[[
    A class to represent the ball
]]

Ball = {}

function Ball:new(x, y, width, height)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    o.width = width
    o.height = height

    --velocity atributes
    o.dx = math.random(2) == 1 and -100 or 100 
    --same as math.random(2) == 1? -100 : 100

    o.dy = math.random(-50, 50)

    return o
end


function Ball:collides(player)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end

    --then check to see if the bottom edge of either is higher than the top edge of the other
    if self.y > player.y + player.height or player.y > self.y + self.height then
        return false
    end

    return true
end


function Ball:reset(settings)
    self.x = settings.virtual_width / 2 - 2
    self.y = settings.virtual_height / 2 - 2
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end


function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end


function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end