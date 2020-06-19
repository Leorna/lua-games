LevelMaker = {}


function LevelMaker.createMap(level)
    local bricks = {}

    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)

    for y = 1, numRows do
        for x = 1, numCols do
            brick = Brick:new(
                (x - 1) * 32 + 8 + (1 - numCols) * 16,
                y * 16
            )

            table.insert(bricks, brick)
        end
    end

    return bricks
end