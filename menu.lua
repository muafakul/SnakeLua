--------------------------------------------
-- Created by Fabio Roncari 16/09/2016    --
-- Menu section of the snake game         --
--------------------------------------------


local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

---------------
-- VARIABLES --
---------------

-- timer variables
local  timerUpdate -- used for the loop

-- Sheet Info
local sheetInfo 
local spriteSheetButtonPlay 
local spriteSheetButtonHighscore
local spriteSheetStaticElements 

-- Menu objects
local title
local backgroundColor
local background

-- Sound
local buttonSound

-- MusicTrack
local musicTrack

-------------------
-- SET VARIABLES --
-------------------


---------------
-- FUNCTIONS --
---------------
local function randomColor()
	local r = math.random( 0,100 ) * 0.01
	local g = math.random( 0,100 ) * 0.01
	local b = math.random( 0,100 ) * 0.01

	title:setFillColor( r,g,b )
end


local  function goToGame( event )
	local button = event.target
	button:setFillColor( 0.85, 0.75 ,0.5 )
	audio.play( buttonSound )
	composer.removeScene( "game" )
	composer.gotoScene( "game" ,{time=800, effect="crossFade"} )
end

local function goToHighScores( event )
	local button = event.target
	button:setFillColor( 0.85, 0.75 ,0.5 )
	audio.play( buttonSound )
	composer.removeScene( "highscores" )
	composer.gotoScene( "highscores" )
end




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Spritesheets
	sheetInfo = require("spritesheetMenu")

	spriteSheetStaticElements = graphics.newImageSheet("images/spritesheetMenu.png", 
	 sheetInfo:getSheetStaticElements() )

	background = display.newImageRect( sceneGroup,
		"images/bg.png", 
		display.contentWidth, display.viewableContentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- TITLE --

	title = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("title")}} )

	title.x = display.contentCenterX
	title.y = title.height * 0.5

	-- BACKGROUND SNAKE HEAD

	backgroundSH = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("snake")}} )
	backgroundSH.x = display.contentCenterX
	backgroundSH.y = title.height + backgroundSH.height * 0.5

	--MENU CHOICES
	-- PLAY
	local playButton = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("play")}} )
	playButton.x = display.contentWidth - playButton.width * 0.5 - 40
	playButton.y = display.contentHeight - playButton.height * 0.5 - 40
	-- HIGHSCORE
	local highScores = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("highscore")}} )
	highScores.x = 20 + highScores.width * 0.5
	highScores.y = title.height + 60 + highScores.height * 0.5
	-- HIGHSCORE
	local exit = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("exit")}} )
	exit.x = highScores.x
	exit.y = playButton.y
	-- HOW TO
	local howto = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("howto")}})
	howto.x = playButton.x
	howto.y = playButton.y - playButton.height * 0.5 
			- howto.height * 0.5 - 20
	-- OPTIONS
	local options = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("options")}})
	options.x = playButton.x
	options.y = howto.y - howto.height * 0.5 
			- options.height * 0.5 - 10

	-- Resize options and how to
	howto.width = howto.width * 0.8
	howto.height = howto.height * 0.8
	options.width = howto.width
	options.height = howto.height
	--EVENT LISTENERS
	playButton:addEventListener( "tap", goToGame )
	--highScoresButton:addEventListener( "tap", goToHighScores )

	-- get the parent group of title 
	-- the same of the other objects of the menu
	local parent = title.parent
	-- Move title to the top of the group 
	parent:insert(  title )

	-- LOAD SOUND OBJECTS
	buttonSound = audio.loadSound( "audio/menu/button.ogg" )

	musicTrack = audio.loadStream( "audio/music/AnAdventureAwaits.ogg" )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		timerUpdate = timer.performWithDelay( 800, randomColor , 0 )
		-- title:setFillColor( r,g,b )

		-- Start the music
		audio.play( musicTrack , {channel = 1, loops = -1} )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( timerUpdate )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

		-- Stop the music
		audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose( buttonSound )
	audio.dispose( musicTrack )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
