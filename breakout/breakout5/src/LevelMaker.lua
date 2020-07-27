LevelMaker = {}


--[[
    Creates a table, of Bricks to be returned to the main game, with
    different possible ways of randomizing eow and columns of bricks.
    Calculates the brick color and tiers to choose based on the level passed in
]]

function LevelMaker.createMap(level)
    local brick
    local bricks = {}
    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)

    for y = 1, numRows do
        for x = 1, numCols do
            brick = Brick:new(
                -- x-coordinate
                -- decrement x by one because the first index of a table in Lua is 1, coords are 0
                -- multiply by the brick width, which is 32
                -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                -- left-side padding for when are fewer than 13 columns
                (x-1) * 32 + 8 + (13 - numCols) * 16,

                -- y-coordinate
                y * 16
            )

            table.insert(bricks, brick)
        end
    end

    return bricks
end