PlayState = BaseState:new()

--The speed at which pipe should scroll right to left
--It is the same velocity as the ground velocity
PIPE_SPEED = 60


--Height and width of the pipe image avaiable globally
PIPE_HEIGHT = 288 --It is the same as the height of the virtual screen
PIPE_WIDTH = 70


BIRD_WIDTH = 38
BIRD_HEIGHT = 24


function PlayState:new()
    local this = BaseState:new()
    setmetatable(this, self)
    self.__index = self

    this.bird = Bird:new()
    this.timer = 0
    this.pipePairs = {}

    --keep track of the score
    this.score = 0

    --initialize our last recorded Y value for a gap placement to base other gaps off of
    this.lastY = -PIPE_HEIGHT + math.random(80) + 20

    return this
end


function PlayState:update(dt)
    --update timer for pipe spawning
    self.timer = self.timer + dt

    --spawn a new pipe pair every second and a half
    if self.timer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local valueOne = -PIPE_HEIGHT + 10
        local valueTwo = math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - PIPE_HEIGHT - 90)
        local y = math.max(valueOne, valueTwo)

        self.lastY = y
    
        --y is where the gap starts
        table.insert(self.pipePairs, PipePair:new(y))

        --reset the timer
        self.timer = 0
    end

    --for every pair of pipes
    for _, pair in pairs(self.pipePairs) do
        --check if the bird passed the right edge of the pair of pipes
        --only check if the pair has not been scored
        if not pair.scored then
            --if the position of the bird is greater than the right edge
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds.score:play()
            end
        end

        --updating the pair's position
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for index, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, index)
        end
    end

    --detects collision between the bird and the pipes
    for _, pair in pairs(self.pipePairs) do
        for _, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds.explosion:play()
                sounds.hurt:play()

                gStateMachine:change('score', { score=self.score })
            end
        end
    end

    --update the bird based on gravity and input
    self.bird:update(dt)

    --reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds.explosion:play()
        sounds.hurt:play()

        gStateMachine:change('score', { score=self.score })
    end
end


function PlayState:render()
    for _, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: '..tostring(self.score), 8, 8)

    self.bird:render()
end