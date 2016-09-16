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

SheetInfo.sheetButtonPlay =
{
    frames ={
        {
            --FRAME1: play
            x = 550,
            y = 900,
            width = 350,
            height = 125
        },
        {
            --FRAME2: play tap
            x = 550,
            y = 775,
            width = 350,
            height = 125
        }
    }
}

SheetInfo.sheetButtonHighscore =
{
    frames ={
        {
            --FRAME1: highscore
            x = 0,
            y = 125,
            width = 700,
            height = 125
        },
        {
            --FRAME2: highscoreTap
            x = 0,
            y = 0,
            width = 700,
            height = 125
        }
    }
}

SheetInfo.sheetStaticElements ={
    frames = {
        {
            --FRAME1: title
            x = 0,
            y = 250,
            width = 600,
            height = 175
        },

        {
            --FRAME2: snake
            x = 0,
            y = 425,
            width = 550,
            height = 600
        }
    }
}

SheetInfo.frameIndex =
{
    -- BUTTON PLAY
    ["play"] = 1,
    ["playTap"] = 2,
    -- BUTTON HIGHSCORE
    ["highscore"] = 1,
    ["highscoreTap"] = 2,
    -- Static Elements
    -- TITLE
    ["title"] = 1,
    -- SNAKE 
    ["snake"] = 2
}

SheetInfo.sequencesButtonPlay = {
    {
        name = "play",
        frames = {1,2}
    }
}

SheetInfo.sequencesButtonHighscore = {
    {
        name = "highscore",
        frames = {1,2}
    }
}



function SheetInfo:getSheetButtonPlay()
    return self.sheetButtonPlay;
end

function SheetInfo:getSheetButtonHighscore()
    return self.sheetButtonHighscore;
end

function SheetInfo:getSheetStaticElements()
    return self.sheetStaticElements;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

function SheetInfo:getSequencesButtonPlay()
    return self.sequencesButtonPlay;
end

function SheetInfo:getSequencesButtonHighscore()
    return self.sequencesButtonHighscore;
end

return SheetInfo
