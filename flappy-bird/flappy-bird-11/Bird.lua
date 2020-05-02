--Bird class

Bird = {}

local GRAVITY = 9.8


function Bird:new()
    local this = {}
    setmetatable(this, self)
    self.__index = self

    --load bird image from disk and assign its width and height
    this.image = love.graphics.newImage('images/bird.png')
    this.width = this.image:getWidth()
    this.height = this.image:getHeight()

    --position bird in the middle of the screen
    this.x = VIRTUAL_WIDTH / 2 - (this.width / 2)
    this.y = VIRTUAL_HEIGHT / 2 - (this.height / 2)

    this.dy = 0

    return this
end


function Bird:update(dt)
    --gravity acting in the y velocity, dy component
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -2.2
        sounds.jump:play()
    end

    self.y = self.y + self.dy
end


function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) < pipe.x or pipe.x + pipe.width < self.x then
        return false
    end

    if (self.y + 2) + (self.height - 4) < pipe.y or pipe.y + pipe.height < self.y then
        return false
    end

    return true
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end