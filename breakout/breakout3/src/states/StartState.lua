StartState = BaseState:new()


function StartState:new()
    local o = BaseState:new()
    setmetatable(o, self)
    self.__index = self
    return o
end


--whether we are highlighting start or high scores
local highlighted = 1

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1 --highlighted == 1 ? 2 : 1
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('play')
        end
    end

    if love.keyboard.wasPressed('q') then
        love.event.quit()
    end
end



function StartState:render()
    --title
    love.graphics.setFont(gFonts.large)
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

    --instructios
    love.graphics.setFont(gFonts.medium)

    --if we are highlighted 1, render that option blue
    if highlighted == 1 then
        love.graphics.setColor(0.4, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT/2+70, VIRTUAL_WIDTH, 'center')
   
    --reset color
    love.graphics.setColor(1, 1, 1, 1)


    --render option 2 blue if we are highlighting that one
    if highlighted == 2 then
        love.graphics.setColor(0.4, 1, 1, 1)
    end

    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT/2+90, VIRTUAL_WIDTH, 'center')

    --reset the color
    love.graphics.setColor(1, 1, 1, 1)
end