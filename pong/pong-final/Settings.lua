--[[
    A class to keep all the game settings, such as state and window's size
]]


Settings = {}

function Settings:new(width, height, virtual_width, virtual_height, game_state)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.width = width
    o.height = height
    o.virtual_width = virtual_width
    o.virtual_height = virtual_height
    o.game_state = game_state
    o.serving_player = 1
    o.winning_player = nil
    o.player_speed = 200
    o.VELOCITY_INCREASE = 1.03

    return o
end


function Settings:setup_screen(push, font)
    --set love's default filter to "nearest-neighbor"
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    math.randomseed(os.time())

    love.graphics.setFont(font)

    push:setupScreen(self.virtual_width, self.virtual_height, self.width, self.height, {
        fullscreen=false,
        resizable=true,
        vsync=true
    })
end