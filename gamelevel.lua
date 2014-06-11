local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local playerSpeedY = 0
local playerSpeedX = 0
local playerMoveSpeed = 7
local playerWidth  = 60
local playerHeight = 48
local bulletWidth  = 8
local bulletHeight =  19
local islandHeight = 81
local islandWidth = 100
local numberofEnemysToGenerate = 0
local numberOfEnemysGenerated = 0
local playerBullets = {}
local enemyBullets = {}
local islands = {}
local planeGrid = {}
local enemyPlanes = {}
local livesImages = {}
local numberOfLives = 3
local freeLifes = {}local playerIsInvincible = false
local gameOver = false
local numberOfTicks = 0local islandGroup
local planeGroup
local player
local  planeSoundChannel
local firePlayerBulletTimer
local generateIslandTimer
local fireEnemyBulletsTimer
local generateFreeLifeTimer
local rectUp
local rectDown
local rectLeft
local rectRight
function scene:createScene( event )
        local group = self.view
         setupBackground()         setupGroups()         setupDisplay()         setupPlayer()         setupLivesImages()         setupDPad()         resetPlaneGrid()end-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )function scene:enterScene( event )
        local group = self.view
        local previousScene = storyboard.getPrevious()
        storyboard.removeScene(previousScene)
		rectUp:addEventListener( "touch", movePlane)
		rectDown:addEventListener( "touch", movePlane)
		rectLeft:addEventListener( "touch", movePlane)
		rectRight:addEventListener( "touch", movePlane)		local planeSound = audio.loadStream("planesound.mp3")
       planeSoundChannel = audio.play( planeSound, {loops=-1} )        Runtime:addEventListener("enterFrame", gameLoop)
endscene:addEventListener( "enterScene", scene )function setupBackground ()
		local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
		background:setFillColor( 0,0,1)
		scene.view:insert(background)
endfunction setupGroups()
	 islandGroup = display.newGroup()
     planeGroup = display.newGroup()
     scene.view:insert(islandGroup)
     scene.view:insert(planeGroup)
endfunction setupDisplay ()
    local tempRect = display.newRect(0,display.contentHeight-70,display.contentWidth,124);
	tempRect:setFillColor(0,0,0);
	scene.view:insert(tempRect)
	local logo = display.newImage("logo.png",display.contentWidth-139,display.contentHeight-70);
    scene.view:insert(logo)
    local dpad = display.newImage("dpad.png",10,display.contentHeight - 70)
    scene.view:insert(dpad)
endfunction setupPlayer()
player = display.newImage("player.png",(display.contentWidth/2)-(playerWidth/2),(display.contentHeight - 70)-playerHeight)
player.name = "Player"
scene.view:insert(player)
endfunction setupLivesImages()
	for i = 1, 6 do
 		local tempLifeImage = display.newImage("life.png",  40* i - 20, 10)
 		table.insert(livesImages,tempLifeImage)
 		scene.view:insert(tempLifeImage)
 		if( i > 3) then
 			tempLifeImage.isVisible = false;
 		end
	end
endfunction setupDPad()
	rectUp = display.newRect( 34, display.contentHeight-70, 23, 23)
	rectUp:setFillColor(1,0,0)
	rectUp.id ="up"
	rectUp.isVisible = false;
	rectUp.isHitTestable = true;
	scene.view:insert(rectUp)

	rectDown = display.newRect( 34,display.contentHeight-23, 23,23)
	rectDown:setFillColor(1,0,0)
	rectDown.id ="down"
	rectDown.isVisible = false;
	rectDown.isHitTestable = true;
	scene.view:insert(rectDown)

	rectLeft = display.newRect( 10,display.contentHeight-47,23, 23)
	rectLeft:setFillColor(1,0,0)
	rectLeft.id ="left"
	rectLeft.isVisible = false;
	rectLeft.isHitTestable = true;
	scene.view:insert(rectLeft)

	rectRight= display.newRect( 58,display.contentHeight-47, 23,23)
	rectRight:setFillColor(1,0,0)
	rectRight.id ="right"
	rectRight.isVisible = false;
	rectRight.isHitTestable = true;
	scene.view:insert(rectRight)
endfunction resetPlaneGrid()
	planeGrid = {}
	for i=1, 11 do
		table.insert(planeGrid,0)
	end
endfunction movePlane(event)
	if event.phase == "began" then
          if(event.target.id == "up") then
          	playerSpeedY = -playerMoveSpeed
          end
           if(event.target.id == "down") then
          	playerSpeedY = playerMoveSpeed
          end
           if(event.target.id == "left") then
          	playerSpeedX = -playerMoveSpeed
          end
           if(event.target.id == "right") then
          	playerSpeedX = playerMoveSpeed
          end
     elseif event.phase == "ended" then
       playerSpeedX = 0
       playerSpeedY = 0 
   end
end
function movePlayer()
    player.x = player.x + playerSpeedX
	player.y = player.y + playerSpeedY
	if(player.x < 0) then
		player.x = 0
	end
	if(player.x > display.contentWidth - playerWidth) then
		player.x = display.contentWidth - playerWidth
	end
	if(player.y   < 0) then
		player.y = 0
	end
	if(player.y > display.contentHeight - 70- playerHeight) then
		player.y = display.contentHeight - 70 - playerHeight
	end
endfunction gameLoop()
	numberOfTicks = numberOfTicks + 1
    movePlayer()
 end
return scene
