
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheetStaticElements ={
    frames = {
        {
            --FRAME1: title
            x = 0,
            y = 0,
            width = 880,
            height = 200
        },

        {
            --FRAME2: snake
            x = 0,
            y = 200,
            width = 560,
            height = 560
        },

        {
            --FRAME3: how to
            x = 560,
            y = 200,
            width = 160,
            height = 160
        },

        {
            --FRAME4: options
            x = 720,
            y = 200,
            width = 160,
            height = 160
        },

        {
            --FRAME5: highscore
            x = 560,
            y = 360,
            width = 200,
            height = 120
        },
        {
            --FRAME6: play
            x = 560,
            y = 480,
            width = 200,
            height = 120
        },
        {
            --FRAME7: exit
            x = 560,
            y = 600,
            width = 200,
            height = 120
        },
    }
}

SheetInfo.frameIndex =
{
    -- BUTTON PLAY
    ["play"] = 6,
    -- BUTTON HIGHSCORE
    ["highscore"] = 5,
    -- Static Elements
    -- TITLE
    ["title"] = 1,
    -- SNAKE 
    ["snake"] = 2,
    -- HOW TO
    ["howto"] = 3,
    -- OPTIONS
    ["options"] = 4,
    -- EXIT
    ["exit"] = 7
}

function SheetInfo:getSheetStaticElements()
    return self.sheetStaticElements;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
