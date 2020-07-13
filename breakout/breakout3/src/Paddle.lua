-- a class that represents the paddles in the game

Paddle = {}


function Paddle:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    -- x is placed in the middle
    o.x = VIRTUAL_WIDTH / 2 - 32
    
    -- y is placed a lil above the bottom edge of the screen
    o.y = VIRTUAL_HEIGHT - 32

    -- velocity = 0
    o.dx = 0

    -- init dimensions
    o.width = 64
    o.height = 16

    -- keep track of what color is the color paddle
    o.skin = 1

    o.size = 2
    
    return o
end


function Paddle:update(dt)
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH-self.width, self.x + self.dx * dt)
    end
end


function Paddle:render()
    love.graphics.draw(gTextures.main, gFrames.paddles[self.size + 4 * (self.skin - 1)], self.x, self.y)
end