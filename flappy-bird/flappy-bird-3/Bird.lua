--Bird class

Bird = {}

local GRAVITY = 9.8


function Bird:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    --load bird image from disk and assign its width and height
    o.image = love.graphics.newImage('images/bird.png')
    o.width = o.image:getWidth()
    o.height = o.image:getHeight()

    --position bird in the middle of the screen
    o.x = VIRTUAL_WIDTH / 2 - (o.width / 2)
    o.y = VIRTUAL_HEIGHT / 2 - (o.height / 2)

    o.dy = 0

    return o
end


function Bird:update(dt)
    --gravity acting in the y velocity, dy component
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end