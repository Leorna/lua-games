Pipe = {}


local PIPE_IMAGE = love.graphics.newImage('images/pipe.png') 
local PIPE_SCROLL = -60



function Pipe:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = VIRTUAL_WIDTH
    o.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)
    o.width = PIPE_IMAGE:getWidth()

    return o
end


function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end


function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end