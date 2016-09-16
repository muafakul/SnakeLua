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

	spriteSheetButtonPlay = graphics.newImageSheet("images/spritesheetMenu.png", 
	 	sheetInfo:getSheetButtonPlay() )

	spriteSheetButtonHighscore = graphics.newImageSheet("images/spritesheetMenu.png", 
	 sheetInfo:getSheetButtonHighscore() )

	spriteSheetStaticElements = graphics.newImageSheet("images/spritesheetMenu.png", 
	 sheetInfo:getSheetStaticElements() )

	backgroundColor = display.newRect( sceneGroup, 
		display.contentCenterX, display.contentCenterY, 
		display.contentWidth+10, display.contentHeight+10 )
	backgroundColor:setFillColor(0.8,0.7,0.7)

	-- TITLE --

	title = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("title")}} )

    width = display.contentWidth - 50
	height = (width * title.height)
		/title.width
	title.width = width
	title.height = height

	title.x = display.contentCenterX
	title.y = title.height * 0.5

	-- BACKGROUND SNAKE HEAD

	background = display.newSprite( sceneGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("snake")}} )
	local width = display.contentWidth - 50
	local height = (width * background.height)
		/background.width
	background.width = width
	background.height = height
	background.x = display.contentCenterX
	background.y = title.height + background.height * 0.5
		- 25

	--MENU CHOICES
	-- PLAY
	local playButton = display.newSprite( sceneGroup,
		spriteSheetButtonPlay, 
		{frames={sheetInfo:getFrameIndex("play")}} )
	playButton:setFillColor( 1,1,1 )
	playButton.x = display.contentCenterX
	playButton.y = title.height + background.height 
	playButton.width = playButton.width * 0.3
	playButton.height = playButton.height * 0.3
	-- HIGHSCORE
	local highScoresButton = display.newSprite( sceneGroup,
		spriteSheetButtonHighscore, 
		{frames={sheetInfo:getFrameIndex("highscores")}} )
	highScoresButton:setFillColor( 1,1,1 )
	highScoresButton.x = display.contentCenterX
	highScoresButton.y = title.height + background.height 
		+ playButton.height
	highScoresButton.width = playButton.width 
	highScoresButton.height = playButton.height 
	--EVENT LISTENERS
	playButton:addEventListener( "tap", goToGame )
	highScoresButton:addEventListener( "tap", goToHighScores )

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
