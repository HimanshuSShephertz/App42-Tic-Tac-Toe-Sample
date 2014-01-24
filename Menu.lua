local storyboard = require( "storyboard" )
local widget = require("widget")
local App42API = require("App42-Lua-API.App42API")
local App42APIServices = require("App42APIServices")
local menuScene = storyboard.newScene()
local image
local gameListBtn= {}
local logOutButton = {}
local challengeButton = {}

function menuScene:createScene( event )
  local group = self.view
  image = display.newImage( "images/background.png")
	group:insert( image )
  local header = display.newImage( "images/header.png")
  header.x = display.contentWidth*.5
  header.y = math.floor(display.screenOriginY + header.height*0.5)
	group:insert( header )
  
  local footer = display.newText( "Copyright© 2013 ShepHertz Technologies Pvt Ltd.", 0, 0, native.systemFont, 10 )
	footer:setTextColor( 0 )	
	footer:setReferencePoint( display.CenterReferencePoint )
	footer.x = display.contentWidth * 0.5
	footer.y = 490
	group:insert( footer )
  
  challengeButton =  require("widget").newButton
  {
    left = (display.contentWidth-220)/1,
    top = display.contentHeight - 400,
    label = "Challenge",
    width = 150, height = 40,
    onEvent = function(event) 
      if "ended" == event.phase then
        print("Lua Called")
        App42APIServices:getUserList()
      end
    end
  }
  gameListBtn =  require("widget").newButton
  {
    left = (display.contentWidth-225)/1,
    top = display.contentHeight - 300,
    label = "GameList",
    width = 150, height = 40,
    onEvent = function(event) 
      if "ended" == event.phase then
        App42APIServices:getUserGameList()
      end
    end
  }
  logOutButton =  require("widget").newButton
  {
    left = (display.contentWidth-110)/1,
    top = display.contentHeight - 100,
    label = "Log Out",
    width = 100, height = 40,
    onEvent = function(event) 
      if "ended" == event.phase then
        App42APIServices:logout()
      end
    end
  }
end
function menuScene:enterScene( event )
  local group = self.view
  challengeButton.isVisible = true  
  gameListBtn.isVisible = true
  logOutButton.isVisible = true

end
function menuScene:exitScene( event )
	local group = self.view
  challengeButton.isVisible = false  
  logOutButton.isVisible = false
  gameListBtn.isVisible = false
end
function menuScene:destroyScene( event )
	local group = self.view
end

menuScene:addEventListener( "createScene", menuScene )
menuScene:addEventListener( "enterScene", menuScene )
menuScene:addEventListener( "exitScene", menuScene )
menuScene:addEventListener( "destroyScene", menuScene )

return menuScene