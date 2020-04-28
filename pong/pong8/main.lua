require 'Paddle'
require 'Ball'

--https://github.com/Ulydev/push
push = require 'push' --is a resulution handling library

--global window's dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--setting the paddle speed
PADDLE_SPEED = 200


--[[
    Runs at the first start up, only once
    Used to init the game
]]

function love.load()
    --changing the default texture scaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Pong")

    math.randomseed(os.time())

    --font that gives more retro-looking
    smallFont = love.graphics.newFont('font.ttf', 8)

    --larger font for the score
    scoreFont = love.graphics.newFont('font.ttf', 32)

    --seting the love2d's active font
    love.graphics.setFont(smallFont)

    --seting our window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen=false,
        resizable=false,
        vsync=true
    })

    --init score variables
    player1Score = 0
    player2Score = 0


    --initialize the players
    player1 = Paddle:new(10, 30, 5, 20)
    player2 = Paddle:new(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20)

    --place the ball in the middle of the screen
    ball = Ball:new(VIRTUAL_WIDTH/2-2, VIRTUAL_HEIGHT/2-2, 4, 4)


    --game state variable used to transition between different parts of the game
    gameState = 'start'
end


--[[
    Runs every frame, with dt passed in
    dt in secondssince the last frame
]]

function love.update(dt)
    if gameState == 'play' then
        --if there is a collision
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            --keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            --keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        --detect upper and lower screen boundry collision and reverse the dy if there is a collision
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        -- -4 to account the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end


        --if the ball goes beyond left or right, that is, someone made a point
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            ball:reset()
            gameState = 'serve'
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            ball:reset()
            gameState = 'serve'
        end

        --player one movement
        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end

        --player two movement
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end

        --update our ball based on its dx and dy only if we're in play state
        ball:update(dt)
        

        --update the players
        player1:update(dt)
        player2:update(dt)
    end
end


--[[
    Keyboard handling, called by love2d each frame
    Passes in the key we pressed so we can access
]]

function love.keypressed(key)
    --keys can be accessed by string name
    if key == 'q' then
        love.event.quit() --terminates the app
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            --reseting the ball
            ball:reset()
        end
    end
end


--[[
    Called after update by love2d
    Used to draw
]]

function drawScore()
    local score1X = (VIRTUAL_WIDTH / 2) - 50
    local score1Y = VIRTUAL_HEIGHT / 3
    local score2X = (VIRTUAL_WIDTH / 2) + 30
    local score2Y = VIRTUAL_HEIGHT / 3

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), score1X, score1Y)
    love.graphics.print(tostring(player2Score), score2X, score2Y)
end


function love.draw()
    --begin rendering at virtual resolution
    push:apply('start')
    --[[
        everything between the push:apply('start') and push:apply('end')
        will render at virtual resolution
    ]]

    --draw welcome text toward the top of the screen
    love.graphics.setFont(smallFont)

    local text = nil

    if gameState == 'start' then
        text = 'Hello Start State!'
    else
        text = 'Hello Play State!'
    end

    love.graphics.printf(text, 0, 20, VIRTUAL_WIDTH, 'center')

    drawScore()
    
    --rendering the paddles
    player1:render()
    player2:render()

    --rendering the ball
    ball:render()

    displayFPS()


    --end the rendering at virtual resolution
    push:apply('end')
end


--[[
    Renders the current fps
]]

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 10, 10)
end