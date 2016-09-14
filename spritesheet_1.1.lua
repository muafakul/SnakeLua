--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- 
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheetSnakeBody =
{
    frames ={
        -- SNAKE BODY
        {
            --FRAME1: Snake Body horizontal
            x = 0,
            y = 0,
            width = 32,
            height = 32
        },
        {
            --FRAME2: Snake Body vertical
            x = 32,
            y = 0,
            width = 32,
            height = 32
        },
        {
            --FRAME3: Snake Body curved LU
            x = 64,
            y = 0,
            width = 32,
            height = 32
        },
        {
            --FRAME4: Snake Body curved RU
            x = 96,
            y = 0,
            width = 32,
            height = 32
        },
        {
            --FRAME5: Snake Body curved LD
            x = 128,
            y = 0,
            width = 32,
            height = 32
        },
        {
            --FRAME6: Snake Body curved RD
            x = 160,
            y = 0,
            width = 32,
            height = 32
        }
    }
}

SheetInfo.sheetSnakeHead ={
    frames = {
        -- SNAKE HEAD
        {
            --FRAME1: Snake Head R
            x = 0,
            y = 32,
            width = 32,
            height = 32
        },
        {
            --FRAME2: Snake Head U
            x = 32,
            y = 32,
            width = 32,
            height = 32
        },
        {
            --FRAME3: Snake Head L
            x = 64,
            y = 32,
            width = 32,
            height = 32
        },
        {
            --FRAME4: Snake Head D
            x = 96,
            y = 32,
            width = 32,
            height = 32
        }
    }
}

SheetInfo.sheetFood ={
    frames = {
        -- FOOD
        {
            --FRAME1: Apple
            x = 0,
            y = 64,
            width = 32,
            height = 32
        }
    }
}

SheetInfo.frameIndex =
{
    -- SNAKE BODY
    ["snakebodyhorizzontal"] = 1,
    ["snakebodyvertical"] = 2,
    ["snakebodycurvedLU"] = 3,
    ["snakebodycurvedRU"] = 4,
    ["snakebodycurvedLD"] = 5,
    ["snakebodycurvedRD"] = 6,
    -- SNAKE HEAD
    ["snakeheadR"] = 1,
    ["snakeheadU"] = 2,
    ["snakeheadL"] = 3,
    ["snakeheadD"] = 4,
    -- FOOD
    ["apple"] = 1
}

SheetInfo.sequencesSnakeBody = {
    {
        name = "snakeBody",
        frames = {1,2,3,4,5,6}
    }
}

SheetInfo.sequencesSnakeHead = {
    {
        name = "snakeBody",
        frames = {1,2,3,4}
    }
}



function SheetInfo:getSheetSnakeBody()
    return self.sheetSnakeBody;
end

function SheetInfo:getSheetSnakeHead()
    return self.sheetSnakeHead;
end

function SheetInfo:getSheetFood()
    return self.sheetFood;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

function SheetInfo:getSequencesSnakeBody()
    return self.sequencesSnakeBody;
end

function SheetInfo:getSequencesSnakeHead()
    return self.sequencesSnakeHead;
end

return SheetInfo
