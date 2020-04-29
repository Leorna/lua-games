local game_functions = {}


--[[
    Called if the game state is serve
]]
function game_functions.on_serve_state(ball, settings)
    --before switching to play, init ball's velocity based 
    --on player who last scored
    ball.dy = math.random(-50,50)
   
    if settings.serving_player == 1 then
        ball.dx = math.random(140, 200)
    else
        ball.dx = -math.random(140, 200)
    end
end


--[[
    Checks if there are any collisions with the players (paddles)
]]
function game_functions.collision_with_players(ball, player1, player2, sounds, settings)
    if ball:collides(player1) then
        ball.dx = -ball.dx * settings.VELOCITY_INCREASE
        ball.x = player1.x + 5
        
        --changes the direction in y axis
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds.paddle_hit:play()
    end

    if ball:collides(player2) then
        ball.dx = -ball.dx * settings.VELOCITY_INCREASE
        ball.x = player2.x - 4

        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds.paddle_hit:play()
    end
end


--[[
    Checks if the ball collides with the wall, on top or bottom
]]
function game_functions.collision_with_wall(ball, sounds, settings)
    --detect upper and lower screen boundry collision
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds.wall_hit:play()
    end

    if ball.y > settings.virtual_height - 4 then
        ball.y = settings.virtual_height - 4
        ball.dy = -ball.dy
        sounds.wall_hit:play()
    end
end


--[[
    Check if someone scored
]]
function game_functions.check_for_scores(ball, player1, player2, sounds, settings)
    --if the ball goes beyond left or right, that is, someone made a score
    if ball.x < 0 then
        settings.serving_player = 1
        player2.score = player2.score + 1

        sounds.score:play()
        
        if player2.score == 10 then
            settings.winning_player = 2
            settings.game_state = 'done'
        else
            settings.game_state = 'serve'
            ball:reset(settings)
        end
    end

    if ball.x > settings.virtual_width then
        settings.serving_player = 2
        player1.score = player1.score + 1

        sounds.score:play()

        if player1.score == 10 then
            settings.winning_player = 1
            settings.game_state = 'done'
        else
            settings.game_state = 'serve'
            ball:reset(settings)
        end
    end
end


--[[
    Checks for keyboard input and moves the paddle (player)
]]
function game_functions.move_players(player1, player2, settings)
    --player1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -settings.player_speed
    elseif love.keyboard.isDown('s') then
        player1.dy = settings.player_speed
    else
        player1.dy = 0
    end

    --player2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -settings.player_speed
    elseif love.keyboard.isDown('down') then
        player2.dy = settings.player_speed
    else
        player2.dy = 0
    end
end


function game_functions.reset(ball, player1, player2, settings)
    ball:reset(settings)
    player1.score = 0
    player2.score = 0

    if settings.winning_player == 1 then
        settings.serving_player = 2
    else
        settings.serving_player = 1
    end
end


return game_functions