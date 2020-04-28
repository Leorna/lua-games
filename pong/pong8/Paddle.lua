--Class Paddle

Paddle = {}

--[[
    Paddle Constructor
]]

function Paddle:new(x, y, width, height)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.dy = 0

    return o
end

--[[
    Checks if the paddle can keep going up or down
]]

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT-self.height, self.y + self.dy * dt)
    end
end

--[[
    Rendering the padle
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end