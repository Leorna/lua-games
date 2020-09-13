Brick = {}


function Brick:new(x, y)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    -- used for coloring the score calculation
    o.tier = 0
    o.color = 1

    o.x = x
    o.y = y
    o.width = 32
    o.height = 16

    -- determinates if a brick should be rendered or not
    o.inPlay = true

    return o
end


--[[
    If a brick is hit it must be removed if its health is 0 or
    changing its color otherwise
]]
function Brick:hit()
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()
    
    if self.tier > 0 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end


function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures.main,

            -- multiply color by 4 (-1) to get the color offset, then add tier
            -- to draw the correct tier and color brick on the screen
            gFrames.bricks[1 + ((self.color-1) * 4) + self.tier],
            self.x,
            self.y
        )
    end
end