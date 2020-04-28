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

    --set the title of the window
    love.window.setTitle("Pong")

    math.randomseed(os.time())


    --init the fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

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

    servingPlayer = 1


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
    if gameState == 'serve' then
        --before switching to play, initialize ball's velocity based
        --on player who last scored
        ball.dy = math.random(-50, 50)

        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then
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
        
            --if we reached a score of 10 the game is over
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1

            --if we reached a score of 10 the game is over
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
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

    if gameState == 'play' then
        ball:update(dt)
    end

    --update the players
    player1:update(dt)
    player2:update(dt)

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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            --we restart the game
            gameState = 'serve'

            --reseting the ball
            ball:reset()

            --reset scores to 0
            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end


--[[
    Called after update by love2d
    Used to draw
]]
function love.draw()
    --begin rendering at virtual resolution
    push:apply('start')
    --[[
        everything between the push:apply('start') and push:apply('end')
        will render at virtual resolution
    ]]
    --love.graphics.clear(40, 45, 52, 255)

    --draw welcome text toward the top of the screen
    love.graphics.setFont(smallFont)


    drawScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Wealcome to pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        local text = 'Player '..tostring(servingPlayer).."'s serve!"
        love.graphics.printf(text, 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        local text = 'Player '..tostring(winningPlayer)..' wins!'
        love.graphics.printf(text, 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to begin!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    player1:render()
    player2:render()
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


--[[
    Draws the score to the screen
]]

function drawScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), (VIRTUAL_WIDTH/2)-50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), (VIRTUAL_WIDTH/2)+30, VIRTUAL_HEIGHT/3)
end
