local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require( "widget" )
local App42API = require( "App42-Lua-API.App42API" )
local JSON = require( "App42-Lua-API.JSON" )
local tictacsprites = require( "tictactoe_sprites" )
local App42APIServices = require("App42APIServices")
-- Define the board and turn variable
local board ,submitButton,piece
local playerTurn = 1
local isTurnClick = false
local pieces = nil
local opponent = ""
local isExit = false
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
  
  isTurnClick = false
  print(isExit)
  print(isTurnClick)
  isExit = false
  if isExit == false then
--  if Constant.UserGameObject["board"] ~= nil then
    checkBoard(Constant.UserGameObject["board"])
    setPlayerTurn(Constant.UserGameObject["user_two"],Constant.UserGameObject["user_one"])
--  end
	-- Load the background image
	local bg = display.newImage( "images/tictactoe_bg.png" )
	group:insert( bg )

	-- Pieces group
	pieces = display.newGroup( )
	group:insert( pieces )
	
	-- Create an image sheet
	imagesheet = graphics.newImageSheet( "images/tictactoe_sprites.png", tictacsprites:getSheet( ) )
	
	-- Add the buttons
	for i = 1, 3 do
		for j = 1, 3 do
			addGridButton( group, i, j )
		end
	end
  submitButton =  require("widget").newButton
  {
    left = (display.contentWidth-200)/1,
    top = display.contentHeight - 40,
    label = "Submit",
    width = 100, height = 30,
    onEvent = function(event) 
      if "ended" == event.phase then
          local gameObject = {}
            gameObject[Constant.GameFirstUserKey] = Constant.UserGameObject["user_one"]
            gameObject[Constant.GameSecondUserKey] = Constant.UserGameObject["user_two"]
            gameObject[Constant.GameStateKey]=  Constant.GameStateIdle
            gameObject[Constant.GameWinnerKey]= "";
            gameObject[Constant.GameNextMoveKey]= opponent
            gameObject[Constant.GameIdKey] = Constant.UserGameObject["game_id"]
            gameObject[Constant.GameBoardKey] = board
            App42APIServices:updateGame(gameObject,Constant.GameName..opponent)
            storyboard.gotoScene( "Menu")   
       end
    end
  }
end
end
function setPlayerTurn(ownerName,remoteUser)
  if ownerName == App42API:getLoggedInUser()  then
    opponent = remoteUser
    playerTurn = 1
  else
    playerTurn = 2 
    opponent =ownerName
    end
end

function checkBoard(boardValue)
  if boardValue == "eeeeeeeee" then
    board =  { { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } }
  else
    board = boardValue
  end
end
-- Check if somebody has won
function checkWinner( )
	local winner = 0
	
	-- Check if no more moves are possible (draw)
	local occupied = 0
	for i = 1, 3 do
		for j = 1, 3 do
			if ( board[i][j] > 0 ) then
				occupied = occupied + 1
			end
		end
	end
	if ( occupied == 9 ) then
		winner = 3
	end
	
	-- Rows
	for i = 1, 3 do
		if ( board[i][1] == board[i][2] ) and ( board[i][2] == board[i][3] ) and (board[i][1] ~= 0 ) then
			winner = board[i][1]
		end
	end
	
	-- Columns
	for i = 1, 3 do
		if ( board[1][i] == board[2][i] ) and ( board[2][i] == board[3][i] ) and (board[1][i] ~= 0 )  then
			winner = board[1][i]
		end
	end
	
	-- Diagonals
	if ( board[1][1] == board[2][2] ) and ( board[2][2] == board[3][3] ) and (board[1][1] ~= 0 )  then
		winner = board[1][1]
	end
	if ( board[3][1] == board[2][2] ) and ( board[2][2] == board[1][3] ) and (board[3][1] ~= 0 )  then
		winner = board[3][1]
	end
	
	-- Return the winner
	return winner
end

function okComplete( event )
  App42APIServices:deleteGame(Constant.UserGameObject)
end

function valueEvent(event)
  local px = event.target.px
  local py  = event.target.py=
  if isTurnClick ==  false then
    if board[px][py] ~= nil then
      addPiece(px,py,playerTurn)
      isTurnClick = true
    end
  end
end
-- Add an invisible button to a grid position (px, py)
function addGridButton( group, px, py )
	local btn = widget.newButton
	{
		left = 26 + 95 * (px - 1),
		top = 130 + 95 * (py - 1),
		width = 80,
		height = 80,
    onEvent = valueEvent,
		addPiece(px,py,board[px][py])
	}
	btn.px = px
	btn.py = py
	btn.isVisible = false
	btn.isHitTestable = true
end
function addPiece( px, py,playerTurn )
  	if playerTurn ~=0 then
        piece = display.newImage( imagesheet, tictacsprites:getFrameIndex( "piece_" .. playerTurn ) )
        piece:setReferencePoint( display.TopLeftReferencePoint )
        piece.x = 36 + 95 * (px - 1)
        piece.y = 140 + 95 * (py - 1)
        pieces:insert( piece )
			board[px][py] = playerTurn
			winner = checkWinner( )
      if ( winner > 0 ) then
        if winner ==2 then
          native.showAlert( "Notification ", "You win.", { "OK" }, okComplete )
        elseif winner ==1 then
          native.showAlert( "Notification ", "You win.", { "OK" }, okComplete )
        elseif winner ==3 then
          native.showAlert( "Notification ", "Match draw", { "OK" },okComplete )
        else
        end
      end
			
			if ( playerTurn == 1 ) then
				playerTurn = 2
			else
				playerTurn = 1
			end
		end
	end
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	submitButton.isVisible = false
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.views
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene