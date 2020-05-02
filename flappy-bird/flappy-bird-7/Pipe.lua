Pipe = {}


--Loading the image
--Only one is needed, otherwise, rendering several images, would consume a lot of memory
local PIPE_IMAGE = love.graphics.newImage('images/pipe.png') 

--The speed at which pipe should scroll right to left
--It is the same velocity as the ground velocity
PIPE_SCROLL_SPEED = 60


--Height and width of the pipe image avaiable globally
PIPE_HEIGHT = 288 --It is the same as the height of the virtual screen
PIPE_WIDTH = 70



function Pipe:new(orientation, y)
    local this = {}
    setmetatable(this, self)
    self.__index = self

    this.x = VIRTUAL_WIDTH
    this.y = y

    this.width = PIPE_IMAGE:getWidth()
    this.height = PIPE_HEIGHT

    --Top or bottom
    this.orientation = orientation

    return this
end


function Pipe:render()
    --Drawing the image as usual in x axis, but in y axis it is flipped depending on if the 
    --pipe orientation is top or bottom
    local y = self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y
    --self.y + PIPE_HEIGHT sets the y of the pipe at the top
    love.graphics.draw(
        PIPE_IMAGE,
        self.x,
        y,
        0, --rotation
        1, --x scale
        self.orientation == 'top' and -1 or 1 --y scale, the -1 flips the image
    )
end