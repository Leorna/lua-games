ServeState = BaseState:new()


function ServeState:new()
    local o = BaseState:new()
    setmetatable(o, self)
    self.__index = self
    return o
end


function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score

    self.ball = Ball:new(math.random(7))
end


function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball
        })
    end

    if love.keyboard.wasPressed('q') then
        love.event.quit()
    end
end


function ServeState:render()
    self.paddle:render()
    self.ball:render()

    for _, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts.medium)
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end