--Ball class

Ball = {}

--Constructor

function Ball:new(x, y, width, height)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    --setting atributes
    o.x = x
    o.y = y
    o.width = width
    o.height = height
    
    --variables for velocity
    o.dx = math.random(2) == 1 and -100 or 100
    o.dy = math.random(-50, 50)

    return o
end


--[[
    Return true or false, depending on wheter the paddle and teh ball have collided
]]
function Ball:collides(paddle)
    --first, check to see if the left edge is either farther to the right
    --then the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    --then check to see if the bottom edge of either is higher than the top edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end
    
    return true
end




--[[
    Places the ball in the middle of the screen and a initial random velocity
    for x and y axis
]]

function Ball:reset()
    self.x = (VIRTUAL_WIDTH / 2) - 2
    self.y = (VIRTUAL_HEIGHT / 2) - 2
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

--[[
    Updating the velocity
]]

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--Rendering the ball
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end