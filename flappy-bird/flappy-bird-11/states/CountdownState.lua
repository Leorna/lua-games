COUNTDOWN_TIME = 0.75 --takes one second to count down each time


CountdownState = BaseState:new()


function CountdownState:new()
    local this = BaseState:new()
    setmetatable(this, self)
    self.__index = self

    this.count = 3
    this.timer = 0

    return this
end


function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end


function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end