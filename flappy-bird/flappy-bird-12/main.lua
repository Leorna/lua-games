-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
-- https://github.com/Ulydev/push
local push  = require 'push'


require 'Bird'
require 'Pipe'
require 'PipePair'

--all code related to game state and state machine
require 'StateMachine'
require 'states.BaseState'
require 'states.PlayState'
require 'states.ScoreState'
require 'states.TitleScreenState'
require 'states.CountdownState'


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
GROUND_SCROLL_SPEED = 60


--Defining the point where the background and ground image will reset
--that is, go back to their initial position at x axis, x == 0
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flappy Bird')

    math.randomseed(os.time())


    --initialize the nice-looking retro fonts
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/font.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)



    --initialize the table of sounds
    sounds = {
        jump = love.audio.newSource('sounds/jump.wav', 'static'),
        explosion = love.audio.newSource('sounds/explosion.wav', 'static'),
        hurt = love.audio.newSource('sounds/hurt.wav', 'static'),
        score = love.audio.newSource('sounds/score.wav', 'static'),
        music = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    --play the sounds
    sounds.music:setLooping(true)
    sounds.music:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync=true,
        fullscreen=false,
        resizable=true
    })


    --initialize state machine with all state-returning functions
    gStateMachine = StateMachine:new {
        title = function () return TitleScreenState:new() end,
        play = function () return PlayState:new() end,
        score = function () return ScoreState:new() end,
        countdown = function () return CountdownState:new() end
    }

    gStateMachine:change('title')

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
    
    
    --now, we just update the state machine
    gStateMachine:update(dt)
    
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

    gStateMachine:render()

    --Draw the ground
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end