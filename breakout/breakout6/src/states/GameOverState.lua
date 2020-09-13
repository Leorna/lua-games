GameOverState = BaseState:new()


function GameOverState:new()
    local o = BaseState:new()
    setmetatable(o, self)
    self.__index = self

    o.score = nil

    return o
end


function GameOverState:enter(params)
    self.score = params.score
end


function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('q') then
        love.event.quit()
    end
end


function GameOverState:render()
    love.graphics.setFont(gFonts.large)
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts.medium)
    love.graphics.printf('Final Score: '..tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
end