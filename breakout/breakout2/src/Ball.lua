Ball = {}


function Ball:new(skin)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.width = 8
    o.height = 8

    -- velocities in x and y axis
    o.dx = 0
    o.dy = 0

    o.skin = skin

    return o
end


function Ball:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end


function Ball:reset()
end