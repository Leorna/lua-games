--[[
    A class to represent the player
]]

Player = {}

function Player:new(x, y, width, height)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.dy = 0

    o.score = 0

    return o
end


function Player:update(dt, settings)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(settings.virtual_height - self.height, self.y + self.dy * dt)
    end
end


function Player:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end