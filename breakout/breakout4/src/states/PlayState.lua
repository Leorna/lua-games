PlayState = BaseState:new()


function PlayState:new()
    local o = BaseState:new()
    setmetatable(o, self)
    self.__index = self

    o.paddle = Paddle:new()
    o.paused = false


    o.ball = Ball:new(math.random(7))
    o.ball.dx = math.random(-200, 200)
    o.ball.dy = math.random(-50, -60)

    --give ball position in the center
    o.ball.x = VIRTUAL_WIDTH / 2 - 4
    o.ball.y = VIRTUAL_HEIGHT - 42

    o.bricks = LevelMaker.createMap()

    return o
end


function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    
    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        -- if we hit the paddle on its left side while moving left
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 - (8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
         
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end


    for _, brick in pairs(self.bricks) do
        -- checks for collisions among the ball and some brick
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()

            -- check if the ball left edge is outside the brick and ball dx is positive
            -- ball is moving from left to right
            -- if true, then the ball hit the brick on its left side
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx -- flip the x velocity
                self.ball.x = brick.x - 8 -- reset position outside the brick
            
            -- check if the ball right edge is outside the brick and ball dx is negative
            -- ball is moving from right to left
            -- if true, then the ball hit the brick on its left side
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx -- flip x velocity
                self.ball.x = brick.x + 32 -- reset position outside the brick
            
            -- top edge if no X collisions
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy -- flip the y velocity
                self.ball.y = brick.y - 8 -- reset position outside of brick

            -- bottom edge if no X collision or top collision
            else
                self.ball.dy = -self.ball.dy -- flip y velocity
                self.ball.y = brick.y + 16 -- reset position outside of brick
            end

            self.ball.dy = self.ball.dy * 1.02 -- scale the y velocity to speed up the game
            
            break
        end
    end


    if love.keyboard.wasPressed('q') then
        love.event.quit()
    end
end


function PlayState:render()
    -- render bricks
    for _, brick in pairs(self.bricks) do
        brick:render()
    end


    self.paddle:render()
    self.ball:render()

    if self.paused then
        love.graphics.setFont(gFonts.large)
        love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT/2-16, VIRTUAL_WIDTH, 'center')
    end
end