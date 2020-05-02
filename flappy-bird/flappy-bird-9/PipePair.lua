PipePair = {}


--Setting the gap between the pipes
local GAP_HEIGHT = 90


function PipePair:new(y)
    local this = {}
    setmetatable(this, self)
    self.__index = self

    this.x = VIRTUAL_WIDTH + 32
    this.y = y

    this.pipes = {
        upper = Pipe:new('top', this.y),
        lower = Pipe:new('bottom', this.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    --whether this pipe pairs is read to be removed from the scene
    this.remove = false

    return this
end


function PipePair:update(dt)
    --move the pipe from right to left
    --else remove the pipe from scene if it is beyond the left edge of the screen
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes.upper.x = self.x
        self.pipes.lower.x = self.x
    else
        self.remove = true
    end
end


function PipePair:render()
    for _, pipe in pairs(self.pipes) do
        pipe:render()
    end
end