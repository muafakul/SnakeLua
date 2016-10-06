
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

---------------------------
-- LOAD IMAGE SHEET FILE -- 
---------------------------
local sheetInfo = require( "spritesheet")

local spriteSheetSnakeHead = graphics.newImageSheet("images/spritesheet.png", 
	 sheetInfo:getSheetSnakeHead() )

local spriteSheetSnakeBody = graphics.newImageSheet("images/spritesheet.png", 
	 sheetInfo:getSheetSnakeBody() )

local spriteSheetFood = graphics.newImageSheet("images/spritesheet.png", 
	 sheetInfo:getSheetFood() )
---------------
-- VARIABLES --
---------------
-- Game Objects
-- ground
local groundContainer
local ground
local groundSide
-- Apple
local apple
local appleGridPosition = {}
local count = 0

-- SnakeHead
local snakeHead
local snakeHeadGridPosition = {}
local snakeHeadPosition = {}
local movedHead = false

-- SnakeBody
local snakeBodyTable = {}


-- Movement
local direction = {}
direction.UP = 1
direction.DOWN = 2
direction.RIGHT = 3
direction.LEFT = 4
-- the grid number 
local GRID = 12
-- the gameloop
local gameLoopTimer

-- GameState
local play = false
local died = false
local score = 0
-- UI
local uiGroup
local scoreText


-- Sound 
local eatAppleSound

--------------------
-- CORE FUNCTIONS --
--------------------
--------
-- UI --
--------
local function createScoreText(  )
	scoreText = display.newText( uiGroup,
		"Score : "..score , 
		display.contentWidth*0.20
		, 30 , native.systemFont ,20 )
end
local function updateText(  )
	scoreText.text = "Score: "..score
end
----------
-- GRID --
----------
-- set the groundSide
local function setGroundSide()
	if(display.contentWidth < display.contentHeight) then
		groundSide = display.contentWidth
	else
		groundSide = display.contentHeight
	end
end
-- Only for gebug draw the grid
local function grid(k,l)
local gridX = {}
local gridY = {}

	--VERTICAL lines
	for i = 0, k do
		gridX[i] = display.newLine(i*(groundSide/k)-groundSide/2 , 
			-groundSide/2, 
		i*(groundSide/k)-groundSide/2 , groundSide/2 )
		gridX[i]:setStrokeColor( 0,0,0 )
		groundContainer:insert(gridX[i])
	end
	-- HORIZONTAL lines
	for i = 0, l do
		gridY[i] = display.newLine(-groundSide/2,
			i*(groundSide/k)-groundSide/2 ,
			groundSide/2 ,  
			i*(groundSide/l)-groundSide/2  )
		gridY[i]:setStrokeColor( 0,0,0 )
		groundContainer:insert(gridY[i])
	end
end

-- grid position
local function gridPosition(i,j)
	local gridPosition = {}
	gridPosition.x = (i*(groundSide/GRID)-(groundSide/GRID)/2 - groundSide/2)
	gridPosition.y = (j*(groundSide/GRID)-(groundSide/GRID)/2 - groundSide/2)
	return gridPosition
end

----------
-- FOOD --
----------
-----------
-- APPLE --
-----------
local function canPlaceApple()
	local place = true
	for k=0, #snakeBodyTable do
		if(k==0)then
			if(snakeHeadGridPosition.i == appleGridPosition.i 
				and 
				snakeHeadGridPosition.j == appleGridPosition.j)then
			place = false
			k = #snakeBodyTable + 1
			end
		else
			if(snakeBodyTable[k].i == appleGridPosition.i 
				and 
				snakeBodyTable[k].j == appleGridPosition.j)then
			place = false
			k = #snakeBodyTable + 1
			end
		end
	end
	return place
end

local function setAppleGridPosition()
	-- Generate a grid position for the apple
	-- If the apple not can be placed then 
	-- generate a new position
	repeat
		appleGridPosition.i = math.random(GRID)
		appleGridPosition.j = math.random(GRID)
	until (canPlaceApple()) -- EXIT WHEN CONDITION IS TRUE
end

local function createApple()
    apple = display.newSprite( spriteSheetFood , 
	{frames={sheetInfo:getFrameIndex("apple")}} )
	groundContainer:insert( apple )
	setAppleGridPosition()
	local applePosition = gridPosition(appleGridPosition.i,
		appleGridPosition.j)
	apple.x = applePosition.x
	apple.y = applePosition.y
	apple.width = groundSide/GRID
	apple.height = groundSide/GRID
end

local function destroyApple()
	display.remove( apple )
end

---------------------
-- SNAKE FUNCTIONS --
---------------------

----------------
-- SNAKE HEAD --
----------------

-- Set the grid position of the snake respect his direction
local function setNewSnakeHeadGridPosition()
	snakeHeadGridPosition.lastI = snakeHeadGridPosition.i
	snakeHeadGridPosition.lastJ = snakeHeadGridPosition.j
	-- Change the position with Grid Coordinate
	-- Go to the right 
	if snakeHead.direction == direction.RIGHT then
		if snakeHeadGridPosition.i < GRID then
			snakeHeadGridPosition.i = snakeHeadGridPosition.i + 1
		else
			snakeHeadGridPosition.i = 1
		end
	-- Go up
	elseif snakeHead.direction == direction.UP then
		if snakeHeadGridPosition.j > 1 then
			snakeHeadGridPosition.j = snakeHeadGridPosition.j - 1
		else
			snakeHeadGridPosition.j = GRID
		end
	-- Go down
	elseif snakeHead.direction == direction.DOWN then
		if snakeHeadGridPosition.j < GRID then
			snakeHeadGridPosition.j = snakeHeadGridPosition.j + 1
		else
			snakeHeadGridPosition.j = 1
		end
	-- Go to the left
	elseif snakeHead.direction == direction.LEFT then
		if snakeHeadGridPosition.i > 1 then
			snakeHeadGridPosition.i = snakeHeadGridPosition.i - 1
		else
			snakeHeadGridPosition.i = GRID
		end
	end	
end

-- Set the orientation of the snake head
local function setNewSnakeHeadFacing( )
	
		snakeHead:play( )
		-- Go to the right 
		if snakeHead.direction == direction.RIGHT then
			-- Rotate face Right
			-- snakeHead:rotate(getDeltaAngle(snakeHead,0))
			snakeHead:pause( )
			snakeHead:setFrame( sheetInfo:getFrameIndex("snakeheadR") )
			snakeHead.width = groundSide/GRID
			snakeHead.height = groundSide/GRID
		-- Go up
		elseif snakeHead.direction == direction.UP then
			-- Rotate face Up
			-- snakeHead:rotate(getDeltaAngle(snakeHead,-90))
			snakeHead:pause( )
			snakeHead:setFrame( sheetInfo:getFrameIndex("snakeheadU") )
			snakeHead.width = groundSide/GRID
			snakeHead.height = groundSide/GRID
		-- Go down
		elseif snakeHead.direction == direction.DOWN then
			-- Rotate face Down
			-- snakeHead:rotate(getDeltaAngle(snakeHead,90))
			snakeHead:pause( )
			snakeHead:setFrame( sheetInfo:getFrameIndex("snakeheadD") )
			snakeHead.width = groundSide/GRID
			snakeHead.height = groundSide/GRID
		-- Go to the left
		elseif snakeHead.direction == direction.LEFT then
			-- Rotate face left
			-- snakeHead:rotate(getDeltaAngle(snakeHead,180))
			snakeHead:pause( )
			snakeHead:setFrame( sheetInfo:getFrameIndex("snakeheadL") )
			snakeHead.width = groundSide/GRID
			snakeHead.height = groundSide/GRID
	end	

end

-- create a new snake head
local function createSnakeHead()
    snakeHead = display.newSprite( spriteSheetSnakeHead , 
	sheetInfo:getSequencesSnakeHead() )
	groundContainer:insert( snakeHead )

	-- Initialize the position with Grid Coordinate
	snakeHeadGridPosition.i = 1
	snakeHeadGridPosition.j = 1

	-- Get the ground coordinate from Grid
    snakeHeadPosition = gridPosition(
    	snakeHeadGridPosition.i,
		snakeHeadGridPosition.j)

	snakeHead.x = snakeHeadPosition.x
	snakeHead.y = snakeHeadPosition.y

	snakeHead.width = groundSide/GRID
	snakeHead.height = groundSide/GRID

	-- Initialize direction
	snakeHead.direction = direction.RIGHT
	snakeHead.lastDirection = snakeHead.direction
	setNewSnakeHeadFacing()
end

--------------------------
-- SNAKE BODY FUNCTIONS --
--------------------------

local function updateBodyPosition(snakeBody,
						x, y,i,j)
	snakeBody.x = x
	snakeBody.y = y
	snakeBody.i = i
	snakeBody.j = j
end

local function setAngularOrStraightBody(part1,part2,part3)
	part2:play( )
	------------------------------
	--Straight horizzontal :--- --
	------------------------------
	if(((part1.i < part2.i and part2.i < part3.i) or
		(part1.i > part2.i and part2.i > part3.i) or
		-- Border conditions
		(part2.i == 1 and part1.i == GRID and part3.i > part2.i) or
		(part2.i == 1 and part3.i == GRID and part1.i > part2.i) or
		(part2.i == GRID and part3.i == 1 and part1.i < part2.i) or
		(part2.i == GRID and part1.i == 1 and part3.i < part2.i))
		and (part1.j == part2.j and part2.j == part3.j)) then
				part2:pause( )
				part2:setFrame( sheetInfo:getFrameIndex("snakebodyhorizzontal") )
				part2.width = groundSide/GRID
				part2.height = groundSide/GRID
	--------------------------
	--                    I --
	--Straight vertical : I --
	--                    I --
	--------------------------
	elseif(((part1.j < part2.j and part2.j < part3.j) or
		    (part1.j > part2.j and part2.j > part3.j) or
		    -- Border conditions
			(part2.j == 1 and part1.j == GRID and part3.j > part2.j) or
			(part2.j == 1 and part3.j == GRID and part1.j > part2.j) or
			(part2.j == GRID and part3.j == 1 and part1.j < part2.j) or
			(part2.j == GRID and part1.j == 1 and part3.j < part2.j))
		and (part1.i == part2.i and part2.i == part3.i)) then
				part2:pause( )
				part2:setFrame( sheetInfo:getFrameIndex("snakebodyvertical") )
				part2.width = groundSide/GRID
				part2.height = groundSide/GRID
	-------------------------
	--                     --
	--Curved LD : - I      --
	--              I      --
	-- j go from top to    --
	-- down                --
	-------------------------
	elseif(((part2.i ~= 1 and part2.i ~= GRID) and (part1.i < part2.i and part2.j < part3.j) 
			and (part1.j == part2.j and part2.i == part3.i))
		or ((part2.i ~= 1 and part2.i ~= GRID) and (part1.j > part2.j and part2.i > part3.i)
			and (part1.i == part2.i and part2.j == part3.j))
		-- Border conditions
		-- Right and Left border
		or (part2.i == 1 and part1.i == GRID and part3.j > part2.j)
		or (part2.i == 1 and part3.i == GRID and part1.j > part2.j)
		or (part2.i == GRID and part1.i == GRID-1 and part3.j > part2.j)
		or (part2.i == GRID and part3.i == GRID-1 and part1.j > part2.j)
		) then
				part2:pause( )
				part2:setFrame( sheetInfo:getFrameIndex("snakebodycurvedLD") )
				part2.width = groundSide/GRID
				part2.height = groundSide/GRID
	-------------------------
	--              I      --
	--Curved LU : - I      --
	--                     --
	-------------------------
	elseif(
		(part2.i ~= 1 and (part1.i < part2.i and part2.j > part3.j) 
			and (part1.j == part2.j and part2.i == part3.i))
		or (part2.i ~= 1 and (part1.j < part2.j and part2.i > part3.i)
			and (part1.i == part2.i and part2.j == part3.j))
		-- Border conditions
		-- Right and Left border
		or (part2.i == 1 and part1.i == GRID and part3.j < part2.j)
		or (part2.i == 1 and part3.i == GRID and part1.j < part2.j)
		) then
				part2:pause( )
				part2:setFrame( sheetInfo:getFrameIndex("snakebodycurvedLU") )
				part2.width = groundSide/GRID
				part2.height = groundSide/GRID
	-------------------------
	--              I      --
	--Curved RU :   I -    --
	--                     --
	-------------------------
	elseif(
		(part2.i ~= GRID and (part1.i > part2.i and part2.j > part3.j) 
			and (part1.j == part2.j and part2.i == part3.i))
		or (part2.i ~= GRID and (part1.j < part2.j and part2.i < part3.i)
			and (part1.i == part2.i and part2.j == part3.j))
		-- Border conditions
		-- Right and Left border
		-- or (part2.i == 1 and part1.i == GRID and part3.j < part2.j)
		or (part2.i == GRID and part1.i == 1 and part3.j < part2.j)
		-- or (part2.i == 1 and part3.i == GRID and part1.j < part2.j)
		or (part2.i == GRID and part3.i == 1 and part1.j < part2.j)
		) then
				part2:pause( )
				part2:setFrame( sheetInfo:getFrameIndex("snakebodycurvedRU") )
				part2.width = groundSide/GRID
				part2.height = groundSide/GRID
	-------------------------
	--                     --
	--Curved RD :   I -    --
	--              I      --
	-------------------------
	elseif(
		(part2.i ~= GRID and (part1.i > part2.i and part2.j < part3.j) 
			and (part1.j == part2.j and part2.i == part3.i))
		or (part2.i ~= GRID and (part1.j > part2.j and part2.i < part3.i)
			and (part1.i == part2.i and part2.j == part3.j))
		-- Border conditions
		-- Right and Left border
		-- or (part2.i == 1 and part1.i == GRID and part3.j < part2.j)
		or (part2.i == GRID and part1.i == 1 and part3.j > part2.j)
		-- or (part2.i == 1 and part3.i == GRID and part1.j < part2.j)
		or (part2.i == GRID and part3.i == 1 and part1.j > part2.j)
		) then
				part2:pause( )
				part2:setFrame( sheetInfo:getFrameIndex("snakebodycurvedRD") )
				part2.width = groundSide/GRID
				part2.height = groundSide/GRID
	end

end

local function setBodyOrientation( )

	if (#snakeBodyTable == 1) then
		snakeBodyTable[1]:play()

		if((snakeHeadGridPosition.i > snakeBodyTable[1].i  and 
			snakeHeadGridPosition.j == snakeBodyTable[1].j)
			or
			(snakeHeadGridPosition.i < snakeBodyTable[1].i  and 
			snakeHeadGridPosition.j == snakeBodyTable[1].j)) then
				snakeBodyTable[1]:pause( )
				snakeBodyTable[1]:setFrame( sheetInfo:getFrameIndex("snakebodyhorizzontal") )
				snakeBodyTable[1].width = groundSide/GRID
				snakeBodyTable[1].height = groundSide/GRID
		elseif((snakeHeadGridPosition.i == snakeBodyTable[1].i  and 
			snakeHeadGridPosition.j > snakeBodyTable[1].j)
			or
			(snakeHeadGridPosition.i == snakeBodyTable[1].i  and 
			snakeHeadGridPosition.j < snakeBodyTable[1].j)) then
				snakeBodyTable[1]:pause( )
				snakeBodyTable[1]:setFrame( sheetInfo:getFrameIndex("snakebodyvertical") )
				snakeBodyTable[1].width = groundSide/GRID
				snakeBodyTable[1].height = groundSide/GRID
		end
	elseif(#snakeBodyTable > 1) then
		for i=1,#snakeBodyTable do
			if(i == 1) then
			setAngularOrStraightBody(snakeHeadGridPosition,
				snakeBodyTable[i],
				snakeBodyTable[i+1])	
			elseif(i==#snakeBodyTable)then

				snakeBodyTable[#snakeBodyTable]:play()

				if((snakeBodyTable[#snakeBodyTable-1].i > snakeBodyTable[#snakeBodyTable].i  and 
					snakeBodyTable[#snakeBodyTable-1].j == snakeBodyTable[#snakeBodyTable].j)
				or
					(snakeBodyTable[#snakeBodyTable-1].i < snakeBodyTable[#snakeBodyTable].i  and 
					snakeBodyTable[#snakeBodyTable-1].j == snakeBodyTable[#snakeBodyTable].j)) then
						snakeBodyTable[#snakeBodyTable]:pause( )
						snakeBodyTable[#snakeBodyTable]:setFrame( sheetInfo:getFrameIndex("snakebodyhorizzontal") )
						snakeBodyTable[#snakeBodyTable].width = groundSide/GRID
						snakeBodyTable[#snakeBodyTable].height = groundSide/GRID
				elseif((snakeBodyTable[#snakeBodyTable-1].i == snakeBodyTable[#snakeBodyTable].i  and 
					snakeBodyTable[#snakeBodyTable-1].j > snakeBodyTable[#snakeBodyTable].j)
					or
					(snakeBodyTable[#snakeBodyTable-1].i == snakeBodyTable[#snakeBodyTable].i  and 
					snakeBodyTable[#snakeBodyTable-1].j < snakeBodyTable[#snakeBodyTable].j)) then
						snakeBodyTable[#snakeBodyTable]:pause( )
						snakeBodyTable[#snakeBodyTable]:setFrame( sheetInfo:getFrameIndex("snakebodyvertical") )
						snakeBodyTable[#snakeBodyTable].width = groundSide/GRID
						snakeBodyTable[#snakeBodyTable].height = groundSide/GRID
				end

			else
			setAngularOrStraightBody(snakeBodyTable[i-1],
				snakeBodyTable[i],
				snakeBodyTable[i+1])
			end
		end

	end
end

local function createSnakeBody(  )
	setNewSnakeHeadFacing()
	local newSnakeBody 
	newSnakeBody = display.newSprite( spriteSheetSnakeBody , 
	sheetInfo:getSequencesSnakeBody() )
	if(count == 1) then
		newSnakeBody.x = snakeHead.lastPositionX
		newSnakeBody.y = snakeHead.lastPositionY
	elseif(count > 1) then
		newSnakeBody.x =snakeBodyTable[#snakeBodyTable].lastPositionX 
		newSnakeBody.y =snakeBodyTable[#snakeBodyTable].lastPositionY 
	end
	newSnakeBody.width = groundSide / GRID
	newSnakeBody.height = groundSide / GRID
	groundContainer:insert(newSnakeBody,false)
	newSnakeBody.lastPositionX = newSnakeBody.x
	newSnakeBody.lastPositionY = newSnakeBody.y
	if(count == 1) then
		newSnakeBody.i = snakeHeadGridPosition.lastI
		newSnakeBody.j = snakeHeadGridPosition.lastJ
		newSnakeBody.lastI = newSnakeBody.i
		newSnakeBody.lastJ = newSnakeBody.j
	else
		newSnakeBody.i = snakeBodyTable[#snakeBodyTable].lastI
		newSnakeBody.j = snakeBodyTable[#snakeBodyTable].lastJ
		newSnakeBody.lastI = newSnakeBody.i
		newSnakeBody.lastJ = newSnakeBody.j
	end
	table.insert( snakeBodyTable, newSnakeBody)
	setBodyOrientation()
end



local function moveSnakeBody()
	for i = #snakeBodyTable ,1, -1 do
		snakeBodyTable[i].lastPositionX = snakeBodyTable[i].x
		snakeBodyTable[i].lastPositionY = snakeBodyTable[i].y
		snakeBodyTable[i].lastI = snakeBodyTable[i].i
		snakeBodyTable[i].lastJ = snakeBodyTable[i].j
	end

	for i=#snakeBodyTable,1, -1 do
		if (i == 1) then
			updateBodyPosition(snakeBodyTable[i],
						snakeHead.lastPositionX,
						snakeHead.lastPositionY,
						snakeHeadGridPosition.lastI,
						snakeHeadGridPosition.lastJ
						)
		elseif(i > 1) then
			updateBodyPosition(snakeBodyTable[i],
						snakeBodyTable[i-1].lastPositionX,
						snakeBodyTable[i-1].lastPositionY,
						snakeBodyTable[i-1].lastI,
						snakeBodyTable[i-1].lastJ
						)
		end
	end

	setBodyOrientation()
end

local function appleEaten()
	if (snakeHeadGridPosition.i == appleGridPosition.i
		and
		snakeHeadGridPosition.j == appleGridPosition.j) then
			count = count + 1
			score = count * 10
			updateText()
			audio.play( eatAppleSound )
			createSnakeBody()
			destroyApple()
			createApple()
	end
end

local function getDeltaAngle( object, angle )
	local deltaAngle = angle - object.rotation
	return deltaAngle
end

------------------------
-- CONTROLS FUNCTIONS --
------------------------

-- Set direction of the snake based on touch event
local function changeDirection(event)
	local ground = event.target
	local phase = event.phase
	if("began" == phase) then
		-- Store the last direction of the snake
		snakeHead.lastDirection = snakeHead.direction
		-- Set touch focus on the ground
		display.currentStage:setFocus( ground )
		-- Store initial offset position
		ground.touchX = event.x 
		ground.touchY = event.y
		
	elseif ("moved" == phase) then
		if (event.x > ground.touchX and 
			(event.y <= ground.touchY + 10 
				and event.y >= ground.touchY - 10)) then
		snakeHead.direction = direction.RIGHT
		elseif (event.x < ground.touchX and 
			(event.y <= ground.touchY + 10 
				and event.y >= ground.touchY - 10)) then
		snakeHead.direction = direction.LEFT
		elseif (event.y < ground.touchY and 
			(event.x <= ground.touchX + 10 
				and event.x >= ground.touchX - 10)) then
		snakeHead.direction = direction.UP
		elseif (event.y > ground.touchY and 
			(event.x <= ground.touchX + 10 
				and event.x >= ground.touchX - 10)) then
		snakeHead.direction = direction.DOWN
		end
	elseif ("ended"== phase or "cancelled" == phase) then
		--Release touch focus on the ground
		display.currentStage:setFocus( nil )
	end
end

-- Check if the snake can move in some direction or not
local function canMove()
	if(#snakeBodyTable > 0) then


		if(snakeBodyTable[1].i == snakeHeadGridPosition.i and 
			snakeBodyTable[1].j == snakeHeadGridPosition.j)then

			return false

		else

			return true

		end
	else
		-- Snake head can move if there are no body parts
		return true
	end
	
end

-- Move the snake head on the grid
local function moveSnake()
	-- Get the ground coordinate from Grid
    snakeHeadPosition = gridPosition(
    	snakeHeadGridPosition.i,
		snakeHeadGridPosition.j)
	snakeHead.lastPositionX = snakeHead.x
	snakeHead.lastPositionY = snakeHead.y

	snakeHead.x = snakeHeadPosition.x
	snakeHead.y = snakeHeadPosition.y
	setNewSnakeHeadFacing()
	-- The Head is moved
	movedHead = true
	
end

-- Check if the snake is died
local function isDied( )
	if (#snakeBodyTable > 2) then
		for k=3,#snakeBodyTable do
			if(snakeBodyTable[k].i == snakeHeadGridPosition.i and 
				snakeBodyTable[k].j == snakeHeadGridPosition.j)then
					audio.play( ouchSound )
					died = true
					play = false -- Stop to play
					k= #snakeBodyTable + 1 -- Exit from the loop
			end
		end
	end
end

-- Move all the snake
local function updateSnake()
	if(canMove()) then
		moveSnake()
	else
		snakeHead.direction = snakeHead.lastDirection
	    setNewSnakeHeadGridPosition()	
	    movedHead = false
	end

	if (movedHead) then
		moveSnakeBody()
	else
		moveSnake()
	end
	isDied() -- check if the game is over
end

local function startPlay()
	play = true
	died = false
end

local function gameLoop()
	if(play)then
	setNewSnakeHeadGridPosition()
	updateSnake()
	appleEaten()
	else
		
	end	
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	--------------------------------------------------
	-- CREATE THE GROUND OF THE GAME                --
	--  A SQUARE                                    --
	--------------------------------------------------
	--Set Background image
	local background = display.newImageRect( sceneGroup,
		"images/bg.png", 
		display.contentWidth, display.viewableContentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	--Set the side of the square
	setGroundSide()
	--Set the container of the game ground
	groundContainer = display.newContainer(groundSide, groundSide )
	sceneGroup:insert( groundContainer )

	groundContainer.x = display.contentCenterX
	groundContainer.y = display.contentCenterY

	-- The ground
	ground = display.newImageRect("images/Ground.png", 
		groundSide, groundSide )
	groundContainer:insert( ground, true )

	-- DISPLAY SCORE
	uiGroup = display.newGroup( )
	sceneGroup:insert(uiGroup)

	createScoreText()

	-- Create the initial gameObjects
	createSnakeHead()
	createApple()

	-- ADD THE EVENT LISTENER
	-- Start playing when player touch on the screen
	groundContainer:addEventListener( "tap", startPlay )
	-- Change direction when player touch moving on the ground
	groundContainer:addEventListener( "touch", changeDirection )

	-- Load the sound
	eatAppleSound = audio.loadSound( "audio/game/eatApple.ogg" )
	ouchSound = audio.loadSound( "audio/game/ouch.ogg" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		gameLoopTimer = timer.performWithDelay( 500, gameLoop , 0 )

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose( eatAppleSound )
	audio.dispose( ouchSound )
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
