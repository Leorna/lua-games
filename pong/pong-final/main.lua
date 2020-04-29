--[[
    Game learned in the Harvard CS50's Introduction to Game Development
    Instructor: Colton Ogden

    Pong Remake

    Author: Gabriel Dias
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
-- https://github.com/Ulydev/push
local push  = require 'push'


local game_functions = require 'game_functions'
local fonts = require 'fonts'
local sounds = require 'sounds'
require 'Settings'
require 'Player'
require 'Ball'



--[[
    Runs at the first start up
    Runs before the other love functions
]]
function love.load()
    settings = Settings:new(1280, 720, 432, 243, 'start')
    settings:setup_screen(push, fonts.small)

    player1 = Player:new(10, 30, 5, 20)
    player2 = Player:new(settings.virtual_width-10, settings.virtual_height-30, 5, 20)

    --place the ball in the middle of the screen
    ball = Ball:new(settings.virtual_width/2-2, settings.virtual_height/2-2, 4, 4)

end


--[[
    Called by love whenever we resize the screen
]]
function love.resize(w, h)
    push:resize(w, h)
end


--[[
    Runs every frame, with dt pass in
    dt in seconds since last frame
]]
function love.update(dt)
    if settings.game_state == 'serve' then
        game_functions.on_serve_state(ball, settings)
    elseif settings.game_state == 'play' then
        game_functions.collision_with_players(ball, player1, player2, sounds, settings)
        game_functions.collision_with_wall(ball, sounds, settings)
        game_functions.check_for_scores(ball, player1, player2, sounds, settings)
        ball:update(dt)
    end

    game_functions.move_players(player1, player2, settings)

    --update the position of the players
    player1:update(dt, settings)
    player2:update(dt, settings)
end


--[[
    Keyboard handling, called by love2d each frame
    Passes in the key we pressed so we can access
]]
function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if settings.game_state == 'start' then
            settings.game_state = 'serve'
        elseif settings.game_state == 'serve' then
            settings.game_state = 'play'
        elseif settings.game_state == 'done' then
            settings.game_state = 'serve'
            game_functions.reset(ball, player1, player2, settings)
        end
    end
end


--[[
    Renders the current fps
]]
local function display_fps()
    love.graphics.setFont(fonts.small)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()), 10, 10)
end


--[[
    Draws the score to the screen
]]
local function display_score()
    love.graphics.setFont(fonts.score_font)
    love.graphics.print(tostring(player1.score), settings.virtual_width/2-50, settings.virtual_height/3)
    love.graphics.print(tostring(player2.score), settings.virtual_width/2+30, settings.virtual_height/3)
end


--[[
    Displays the info of the game
]]
local function display_info()
    if settings.game_state == 'start' then
        love.graphics.setFont(fonts.small)
        love.graphics.printf('Welcome to Pong Remake!', 0, 10, settings.virtual_width, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, settings.virtual_width, 'center')
    elseif settings.game_state == 'serve' then
        love.graphics.setFont(fonts.small)
        local text = 'Player '..tostring(settings.serving_player).."'s serve!"
        love.graphics.printf(text, 0, 10, settings.virtual_width, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, settings.virtual_width, 'center')
    elseif settings.game_state == 'done' then
        love.graphics.setFont(fonts.large)
        local text = 'Player '..tostring(settings.winning_player)..' wins'
        love.graphics.printf(text, 0, 10, settings.virtual_width, 'center')
        love.graphics.setFont(fonts.small)
        love.graphics.printf('Press Enter to begin!', 0, 30, settings.virtual_width, 'center')
    end
end


--[[
    Claeed after update by love2d
    Used to draw
]]
function love.draw()
    --begin rendering at virtual resolution
    push:apply('start')
    --[[
        everything between the push:apply('start') and push:apply('end')
        will render at virtual resolution
    ]] 
    love.graphics.clear(0.1, 0.4, 0.6, 1)

    display_score()
    display_info()

    player1:render()
    player2:render()
    ball:render()

    display_fps()

    push:apply('end')
end