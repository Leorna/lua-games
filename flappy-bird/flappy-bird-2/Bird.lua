--Bird class

Bird = {}

function Bird:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.image = love.graphics.newImage('images/bird.png')
    o.width = o.image:getWidth()
    o.height = o.image:getHeight()

    o.x = VIRTUAL_WIDTH / 2 - (o.width / 2)
    o.y = VIRTUAL_HEIGHT / 2 - (o.height / 2)

    return o
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end