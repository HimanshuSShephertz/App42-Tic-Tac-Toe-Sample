local JSON  = require("App42-Lua-API.JSON")
local storyboard = require( "storyboard" )
local widget = require("widget")
local tableView = require("GameUserListView")
local ui = require("GameUserListUi")
local App42API= require("App42-Lua-API.App42API")
local App42APIServices = require("App42APIServices")
require("Constant")
local gameListScene = storyboard.newScene()
display.setStatusBar( display.HiddenStatusBar ) 
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight,gameList, backButton, detailScreenText,image,listBackground,navBar,gameObject
local detailScreen = display.newGroup()
local gameListData = {}
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
 if Constant.GameUserList[id]["jsonDoc"]["next"] == App42API:getLoggedInUser() then
    Constant.UserGameObject = Constant.GameUserList[id]["jsonDoc"]
    storyboard.gotoScene( "Game","slideLeft", 800)
  else
    Constant.UserGameObject = Constant.GameUserList[id]["jsonDoc"]
    native.showAlert( "Notification ", "Wait for your apponent", { "OK" } )
  end
end

function backButtonRelease( event )
    storyboard.gotoScene( "Menu" ,"slideLeft", 800)
end

local function scrollToTop()
	gameList:scrollTo(topBoundary-1)
end
function gameListScene:createScene( event )
	local group = self.view
end
function gameListScene:enterScene( event )
	local group = self.view	
  for j=1 , table.getn(Constant.GameUserList) do
    gameListData[j] = {}
    gameListData[j].userName = Constant.GameUserList[j]["jsonDoc"]["next"]
      if Constant.GameUserList[j]["jsonDoc"]["next"] == App42API:getLoggedInUser() then
          gameListData[j].message = "Your Turn"
      else
          gameListData[j].message = Constant.GameUserList[j]["jsonDoc"]["next"].." Turn"
      end
    gameListData[j].image = "images/userImage.png"
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
  gameList = tableView.newList{
    gameListData=gameListData, 
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

      local message =  display.newText( row.message, 0, 0, native.systemFont, 12 )
      message:setTextColor(180,180,180)
      group:insert(message)
      message.x = message.width*0.5 + img.width + 20
      message.y = userName.y + userName.height + 3
      return group   
    end 
  }
  listBackground = display.newRect( 0, 0, gameList.width, gameList.height )
  listBackground:setFillColor(255,255,255)
  gameList:insert(1,listBackground)
  gameList.isVisible = true
end

function gameListScene:exitScene( event )
	local group = self.view
  gameList.isVisible = false
  backButton.isVisible = false
  navBar.isVisible = false
end
function gameListScene:destroyScene( event )
	local group = self.view
	display.remove(gameList)
	display.remove(backButton)	
	display.remove(navBar)	
end

gameListScene:addEventListener( "createScene", gameListScene )
gameListScene:addEventListener( "enterScene", gameListScene )
gameListScene:addEventListener( "exitScene", gameListScene )
gameListScene:addEventListener( "destroyScene", gameListScene )

return gameListScene