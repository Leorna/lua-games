PlayState = BaseState:new()


function PlayState:new()
    local o = BaseState:new()
    setmetatable(o, self)
    self.__index = self

    o.paddle = Paddle:new()
    o.paused = false

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

    if love.keyboard.wasPressed('q') then
        love.event.quit()
    end
end


function PlayState:render()
    self.paddle:render()

    if self.paused then
        love.graphics.setFont(gFonts.large)
        love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT/2-16, VIRTUAL_WIDTH, 'center')
    end
end