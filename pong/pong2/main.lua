--https://github.com/Ulydev/push
local push = require 'push' --is a resulution handling library

--global window's dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


--[[
    Runs at the first start up, only once
    Used to init the game
]]
 
function love.load()
    --changing the default texture scaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --font that gives more retro-looking
    local smallFont = love.graphics.newFont('font.ttf', 8)

    --seting the love2d's active font
    love.graphics.setFont(smallFont)

    --seting our window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen=false,
        resizable=false,
        vsync=true
    })
end


--[[
    Keyboard handling, called by love2d each frame
    Passes in the key we pressed so we can access
]]

function love.keypressed(key)
    --keys can be accessed by string name
    if key == 'escape' then
        love.event.quit() --terminates the app
    end
end

--[[
    Called after update by love2d
    Used to draw
]]

function love.draw()
    --begin rendering at virtual resolution
    push:apply('start')

    --clear the screen with a specific color
    --love.graphics.clear(40, 45, 52, 255)

    --[[
        everything between the push:apply('start') and push:apply('end')
        will render at virtual resolution
    ]]

    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    --reder the first paddle (left side)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    --render the second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-50, 5, 20)

    --render the ball (center)
    local ballX = (VIRTUAL_WIDTH / 2) - 2
    local ballY = (VIRTUAL_HEIGHT / 2) - 2
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    --end the rendering at virtual resolution
    push:apply('end')
end