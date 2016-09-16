-----------------------------------------------------------------------------------------
--
-- main.lua
-- created by Fabio Roncari 14/09/2016
-- with composer
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )

-- HIDE STATUS BAR
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time( ) )

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )

-- Reduce the overall volume of the channel
audio.setVolume( 0.5 , {channel = 1} )

-- Go to the menu screen
composer.gotoScene( "menu"  )