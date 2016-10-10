-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local json = require( "json" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- VARIABLES
local optionsFilePath = composer.getVariable( "optionsFilePath" ) 
local musicOptions = composer.getVariable( "music" )
local soundOptions = composer.getVariable( "sound" )
local buttonSound = composer.getVariable( "buttonSound" )

-- FUNCTIONS
local function playButtonSound( )
	if(soundOptions) then
		audio.play( buttonSound )	
end

end
local function musicSwitched(event)
	local switch = event.target
	musicOptions = switch.isOn
end

local function soundSwitched(event)
	local switch = event.target
	soundOptions = switch.isOn
end

local function accepted( event )
	local button = event.target
	local optionsTable = {
        	music = musicOptions,
        	sound = soundOptions
        }
        local writeFile = io.open( optionsFilePath ,"w" )
        if writeFile then
        	writeFile:write( json.encode( optionsTable ) )
        	io.close( writeFile )
        end 
    composer.setVariable( "music", musicOptions )
    composer.setVariable( "sound", soundOptions )
    playButtonSound()
    composer.hideOverlay(  true ,"fromLeft" , 50 )
end

local function cancelled(event)
	local button = event.target
	playButtonSound()
	composer.hideOverlay(  true ,"fromLeft" , 50 )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- SET PARENT
	parent = event.parent
	-- Spritesheets
	sheetInfo = require("spritesheetMenu")

	spriteSheetStaticElements = graphics.newImageSheet("images/spritesheetMenu.png", 
	sheetInfo:getSheetStaticElements() )
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local shader = display.newRect( sceneGroup, 
		display.contentCenterX, display.contentCenterY, 
		display.contentWidth, display.contentHeight)
	shader:setFillColor( 0,0,0,0.8 )
	local optionsGroup = display.newGroup( )
	optionsGroup.x = 360
	optionsGroup.y = 200
	optionsGroup.anchorX = 0
	optionsGroup.anchorY = 0
	optionsGroup.anchorChildren = true
	sceneGroup:insert(  optionsGroup )
	local bgColor = display.newRect( optionsGroup, 
		460, 300, 
		920, 600)
	 bgColor:setFillColor( 0.149,0.416,0.118,1 )
	 bgColor:setStrokeColor( 0.149,0.416,0.118,0.5 )
	 bgColor.strokeWidth = 10
	 local optionsImg = display.newSprite( optionsGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("options")}})
	 optionsImg.x = 80
	 optionsImg.y = 80
	 optionsImg.width = optionsImg.width*0.8
	 optionsImg.height = optionsImg.height*0.8

	 -- MUSIC CHECKBOX
	 local musicImg = display.newSprite( optionsGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("music")}})
	 musicImg.x = 320
	 musicImg.y = 200
	 musicImg.width =optionsImg.width
	 musicImg.height = optionsImg.height
	 local musicButton = widget.newSwitch( 
	 {
	 	x = 400,
	 	y = 200,
	 	style = "checkbox",
	 	id = "musicOptons",
	 	initialSwitchState = musicOptions,
	 	onPress = musicSwitched
	 }
	  )	
	 optionsGroup:insert(musicButton)

	 -- SOUND CHECHBOX
	 local soundImg = display.newSprite( optionsGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("sound")}})
	 soundImg.x = 320
	 soundImg.y = 360
	 soundImg.width =optionsImg.width
	 soundImg.height = optionsImg.height

	 local soundButton = widget.newSwitch( 
	 {
	 	x = 400,
	 	y = 360,
	 	style = "checkbox",
	 	id = "soundOptons",
	 	initialSwitchState = soundOptions,
	 	onPress = soundSwitched
	 }
	  )	
	 optionsGroup:insert(soundButton)

	 -- CANCEL BUTTON
	 local cancelImg = display.newSprite( optionsGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("cancel")}})
	 cancelImg.x = 680
	 cancelImg.y = 520
	 cancelImg.width =optionsImg.width
	 cancelImg.height = optionsImg.height
	 cancelImg:setFillColor( 1,0,0,0.8 )
	 -- OK BUTTON
	 local okImg = display.newSprite( optionsGroup,
		spriteSheetStaticElements, 
		{frames={sheetInfo:getFrameIndex("ok")}})
	 okImg.x = 840
	 okImg.y = 520
	 okImg.width =optionsImg.width
	 okImg.height = optionsImg.height
	 -- Listeners
	 okImg:addEventListener( "tap", accepted )
	 cancelImg:addEventListener( "tap", cancelled )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
