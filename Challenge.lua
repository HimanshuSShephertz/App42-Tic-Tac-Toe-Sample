local JSON  = require("App42-Lua-API.JSON")
local storyboard = require( "storyboard" )
local widget = require("widget")
local tableView = require("tableView")
local ui = require("ui")
local App42API= require("App42-Lua-API.App42API")
local App42APIServices = require("App42APIServices")
require("Constant")
local gameListScene = storyboard.newScene()
display.setStatusBar( display.HiddenStatusBar ) 
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight,challengeList, backButton, detailScreenText,image,listBackground,navBar,gameObject
local detailScreen = display.newGroup()
local challengeData = {}
local detailBg = display.newRect(0,0,display.contentWidth,display.contentHeight-display.screenOriginY)
detailBg:setFillColor(255,255,255)
detailScreen:insert(detailBg)
detailScreen.x = display.contentWidth
 
local selected = display.newRect(0, 0, 50, 50) 
selected:setFillColor(67,141,241,180) 
selected.isVisible = false  

function listButtonRelease( event )
  self = event.target
	local id = self.id
  App42APIServices:createGame(App42API:getLoggedInUser(),challengeData[id].userName)
end

function backButtonRelease( event )
    storyboard.gotoScene( "Menu" )
end

local function scrollToTop()
	challengeList:scrollTo(topBoundary-1)
end
function gameListScene:createScene( event )
	local group = self.view
end
function gameListScene:enterScene( event )
	local group = self.view	
  for j=1 , table.getn(Constant.data) do
    challengeData[j] = {}
    challengeData[j].userName = Constant.data[j]["userName"]
    challengeData[j].email = Constant.data[j]["email"]
    challengeData[j].image = "images/userImage.png"
  end

	image = display.newImage( "images/background.png" )
  group:insert( image )
  navBar = ui.newButton{
    default = "images/header.png",
    onRelease = scrollToTop
  }
  navBar.x = display.contentWidth*.5
  navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)

  backButton = ui.newButton{ 
    default = "images/backButton.png",  
    onRelease = backButtonRelease
  }
  backButton.x = 30
  backButton.y = -13
  backButton.alpha = 1
  
  local topBoundary = display.screenOriginY + 40
  local bottomBoundary = display.screenOriginY + 0
  challengeList = tableView.newList{
    challengeData=challengeData, 
    default="images/listItemBg_over.png",
    onRelease=listButtonRelease,
    top=topBoundary,
    bottom=bottomBoundary,
    callback = function( row )
      local group = display.newGroup()
      local img = display.newImage(row.image)
      group:insert(img)
      img.x = math.floor(img.width*0.5 + 6)
      img.y = math.floor(img.height*0.5) 
      
      local userName =  display.newText( row.userName, 0, 0, native.systemFontBold, 14 )
      userName:setTextColor(255, 255, 255)
      group:insert(userName)
      userName.x = userName.width*0.5 + img.width + 20
      userName.y = 20

      local email =  display.newText( row.email, 0, 0, native.systemFont, 12 )
      email:setTextColor(180,180,180)
      group:insert(email)
      email.x = email.width*0.5 + img.width + 20
      email.y = userName.y + userName.height + 3
      return group   
    end 
  }
  listBackground = display.newRect( 0, 0, challengeList.width, challengeList.height )
  listBackground:setFillColor(255,255,255)
  challengeList:insert(1,listBackground)
  challengeList.isVisible = true
end

function gameListScene:exitScene( event )
	local group = self.view
  challengeList.isVisible = false
  backButton.isVisible = false
  navBar.isVisible = false
end
function gameListScene:destroyScene( event )
	local group = self.view
	display.remove(challengeList)
	display.remove(backButton)	
	display.remove(navBar)	
end

gameListScene:addEventListener( "createScene", gameListScene )
gameListScene:addEventListener( "enterScene", gameListScene )
gameListScene:addEventListener( "exitScene", gameListScene )
gameListScene:addEventListener( "destroyScene", gameListScene )

return gameListScene