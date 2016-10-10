-----------------------------------------------------------------------------------------
--
-- main.lua
-- created by Fabio Roncari 14/09/2016
-- with composer for snake game
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local json = require( "json" )

-- OPTIONS VARIABLES
local optionsTable = {}
local music
local sound

-- File variables
local optionsFilePath = system.pathForFile( "options.json", system.DocumentsDirectory )
--Set filePath for the whole game
composer.setVariable( "optionsFilePath", optionsFilePath ) 

--FUNCTIONS
-- READ THE FILE OR CREATE IF NOT EXISTS
local function readOptions( )
	local optionsFile = io.open( optionsFilePath , "r" )
	if optionsFile then
		local contents = optionsFile:read( "*a" )
        io.close( optionsFile )
        optionsTable = json.decode( contents )
        print(optionsTable)
	end 
	if ( optionsTable == nil or #optionsTable == 0) then
        optionsTable = {
        	 music = true, 
        	 sound = true  -- sound
        }
        local writeFile = io.open( optionsFilePath ,"w" )
        if writeFile then
        	writeFile:write( json.encode( optionsTable ) )
        	io.close( writeFile )
        end 
    end
end


-- HIDE STATUS BAR
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time( ) )

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )

-- Reduce the overall volume of the channel
audio.setVolume( 0.5 , {channel = 1} )

--Read options
readOptions()
print( json.encode( optionsTable ) )
composer.setVariable( "music", optionsTable.music )
composer.setVariable( "sound", optionsTable.sound )

-- Go to the menu screen
composer.gotoScene( "menu"  )