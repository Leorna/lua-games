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

    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    local highestTier = math.min(3, math.floor(level / 5))
    local highestColor = math.min(5, level % 5 + 3)

    for y = 1, numRows do
        -- whether we want to enable skipping for this row
        local skipPattern = math.random(1, 2) == 1 and true or false

        -- whether we want to enable alternating colors for this row
        local alternatePattern = math.random(1, 2) == 1 and true or false
         
        -- choose two colors to alternate between
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)
         
        -- used only when we want to skip a block, for skip pattern
        local skipFlag = math.random(2) == 1 and true or false
 
        -- used only when we want to alternate a block, for alternate pattern
        local alternateFlag = math.random(2) == 1 and true or false
 
        -- solid color we'll use if we're not alternating
        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(0, highestTier)

        for x = 1, numCols do
            if skipPattern and skipFlag then
                skipFlag = not skipFlag

                goto continue
            else
                skipFlag = not skipFlag
            end
            
            brick = Brick:new(
                -- x-coordinate
                (x-1)                   -- decrement x by 1 because tables are 1-indexed, coords are 0
                * 32                    -- multiply by 32, the brick width
                + 8                     -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
                + (13 - numCols) * 16,  -- left-side padding for when there are fewer than 13 columns
                 
                -- y-coordinate
                y * 16     
            )

            if alternatePattern and alternateFlag then
                brick.color = alternateColor1
                brick.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                brick.color = alternateColor2
                brick.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            if not alternatePattern then
                brick.color = solidColor
                brick.tier = solidTier
            end

            table.insert(bricks, brick)

            ::continue::
        end
    end

    if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end