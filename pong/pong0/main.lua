--global window's dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720



--[[
    Runs at the first start up, only once
    Used to init the game
]]

function love.load()
    --seting our window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen=false,
        resizable=false,
        vsync=true
    })
end

--[[
    Called after update by love2d
    Used to draw
]]

function love.draw()
    local textToRender = "Hello Pong!"
    local x = 0 -- our x
    local y = (WINDOW_HEIGHT / 2) - 6 -- our y, halfway down the screen
    love.graphics.printf(textToRender, x, y, WINDOW_WIDTH, 'center')
end