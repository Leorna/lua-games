require 'src.Dependencies'



--[[
    Called once, is the first function to run
    Used to set up game settings, objects and so on
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    --loading fonts
    gFonts = {
        small = love.graphics.newFont('fonts/font.ttf', 8),
        medium = love.graphics.newFont('fonts/font.ttf', 16),
        large = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts.small)

    --loading the graphics
    gTextures = {
        background = love.graphics.newImage('images/background.png'),
        main = love.graphics.newImage('images/breakout.png'),
        arrows = love.graphics.newImage('images/arrows.png'),
        hearts = love.graphics.newImage('images/hearts.png'),
        particle = love.graphics.newImage('images/particle.png')
    }

    gFrames = {
        paddles = util.generateQuadsPaddles(gTextures.main),
        balls = util.generateQuadsBalls(gTextures.main)
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] =  love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    gStateMachine = StateMachine:new {
        start = function () return StartState:new() end,
        play = function () return PlayState:new() end
    }
    gStateMachine:change('start')


    --custom table
    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end


--[[
    Custom function
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


function love.draw()
    push:start()

    local bgWidth = gTextures.background:getWidth()
    local bgHeight = gTextures.background:getHeight()


    love.graphics.draw(
        gTextures.background, --image object 
        0, --x position
        0, --y position
        0, --no rotation

        --scale factors on x and y axis so it fills the screen
        VIRTUAL_WIDTH / (bgWidth - 1), VIRTUAL_HEIGHT / (bgHeight - 1)
    )

    gStateMachine:render()

    displayFPS()

    push:finish()
end



--[[
    Renders the current fps
]]
function displayFPS()
    love.graphics.setFont(gFonts.small)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 5, 5)
end