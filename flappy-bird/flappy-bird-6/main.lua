-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
-- https://github.com/Ulydev/push
local push  = require 'push'


require 'Bird'
require 'Pipe'
require 'PipePair'


--Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Virtual resolution dimension
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


--Creating a background image object and setting its first x position
local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

--Creating a ground image object and setting its first x position
local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

--Defining speed of scroll to background and ground
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60


--Defining the point where the background and ground image will reset
--that is, go back to their initial position at x axis, x == 0
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514


--Creating the bird
local bird = Bird:new()


--A table to store the pair of pipes
local pipePairs = {}


--A timer to count the frames to update and spawn the pipes
local timer = 0


--With this variable we can keep track of where the last set of pipes
--spawned their gap
local lastY = -PIPE_HEIGHT + math.random(80) + 20


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync=true,
        fullscreen=false,
        resizable=true
    })

    -- a table created by ourselves
    --this table is to track the keys pressed
    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    --add to the keysPressed table the keys pressed in this frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'q' then
        love.event.quit()
    end
end


--[[ 
    a function created by ourselves
    Used to check the global input table we activated
    during this frame, looked up by their string value
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


function love.update(dt)
    --Scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
    --Scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    timer = timer + dt
    
    --Spawn a new pair pipes if the timer is past 2 seconds
    if timer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local valueOne = -PIPE_HEIGHT + 10
        local valueTwo = math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - PIPE_HEIGHT - 90)
        local y = math.max(valueOne, valueTwo)

        --y is where the gap starts
        table.insert(pipePairs, PipePair:new(y))
        timer = 0
    end


    --Updating the bird
    bird:update(dt)

    --Updating each pair of pipes 
    for _, pair in pairs(pipePairs) do
        pair:update(dt)
    end 

    --Check if some pipe needs to be removed
    for index, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, index)
        end
    end

    --Reseting the input table
    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start() --new way of starting a new virtual render 
    --[[
        push:apply('start') and push:apply('end') are deprecated
    ]]

    --Draw the background
    love.graphics.draw(background, -backgroundScroll, 0)

    --Render all the pipe pairs
    for _, pair in pairs(pipePairs) do
        pair:render()
    end

    --Draw the ground
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)


    --Render the bird
    bird:render()

    push:finish()
end