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
            y = 150,
            width = 50,
            height = 50
        },
        {
            --FRAME2: Snake Body vertical
            x = 50,
            y = 150,
            width = 50,
            height = 50
        },
        {
            --FRAME3: Snake Body curved LU
            x = 0,
            y = 50,
            width = 50,
            height = 50
        },
        {
            --FRAME4: Snake Body curved RU
            x = 50,
            y = 50,
            width = 50,
            height = 50
        },
        {
            --FRAME5: Snake Body curved LD
            x = 100,
            y = 50,
            width = 50,
            height = 50
        },
        {
            --FRAME6: Snake Body curved RD
            x = 150,
            y = 50,
            width = 50,
            height = 50
        }
    }
}

SheetInfo.sheetSnakeHead ={
    frames = {
        -- SNAKE HEAD
        {
            --FRAME1: Snake Head R
            x = 0,
            y = 0,
            width = 50,
            height = 50
        },
        {
            --FRAME2: Snake Head U
            x = 50,
            y = 0,
            width = 50,
            height = 50
        },
        {
            --FRAME3: Snake Head L
            x = 100,
            y = 0,
            width = 50,
            height = 50
        },
        {
            --FRAME4: Snake Head D
            x = 150,
            y = 0,
            width = 50,
            height = 50
        }
    }
}

SheetInfo.sheetFood ={
    frames = {
        -- FOOD
        {
            --FRAME1: Apple
            x = 0,
            y = 200,
            width = 50,
            height = 50
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
