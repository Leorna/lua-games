local push = require 'push'

require 'Bird'
require 'Pipe'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0


local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413


local bird = Bird:new()

local pipes = {}

local timer = 0



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
    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    print(love.keyboard.keysPressed[key])
    if key == 'q' then
        love.event.quit()
    end
end


-- a function created by ourselves
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    timer = timer + dt
    
    if timer > 2 then
        table.insert(pipes, Pipe:new())
        timer = 0
    end


    bird:update(dt)

    for index, pipe in pairs(pipes) do
        pipe:update(dt)

        if pipe.x < -pipe.width then
            table.remove(pipes, index)
        end
    end


    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start() --new way of starting a new virtual render 
    --[[
        push:apply('start') and push:apply('end') are deprecated
    ]]
    love.graphics.draw(background, -backgroundScroll, 0)

    for _, pipe in pairs(pipes) do
        pipe:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

    push:finish()
end