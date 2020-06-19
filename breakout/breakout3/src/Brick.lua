Brick = {}


function Brick:new(x, y)
    local o = {}
    setmetatable(self, o)
    self.__index = self

    o.tier = 0
    o.color = 1

    o.x = x
    o.y = y
    o.width = 32
    o.height = 16

    o.inPlay = true

    return o
end


function Brick:hit()
    gSounds['brick-hit-2']:play()
    self.inPlay = false
end


function Brick:render()
    if self.inPlay then
        love.graphics.draw(
            gTextures.main,
            gFrames.bricks[1 + ((self.color - 1) * 4) + self.tier],
            self.x,
            self.y
        )
    end
end