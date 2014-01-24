local storyboard = require( "storyboard" )
local App42API = require("App42-Lua-API.App42API")
local User  = require("App42-Lua-API.User")
local JSON  = require("App42-Lua-API.JSON")
require("App42-Lua-API.DeviceType")
require("Constant")
local App42APIServices = {}
local pushCallBack = {}
local findGameStorageCallBack = {}
local storeDeviceCallBack = {}
local updateGameStorageCallBack = {}
local loginCallBack = {}
local logoutCallBack = {}
local getAllCallback = {}
local updateGamePushCallBack = {}
local createGameCallBack ={}
local gameObject= {}
local gameUserListCallBack = {}
local deleteGameCallBack = {}
local userService = App42API:buildUserService()
local pushService = App42API:buildPushNotificationService()
local storageService = App42API:buildStorageService()
local notificationList = {}

function gameUserListCallBack:onException(object)
  if object:getAppErrorCode() == 2602 then
    native.showAlert( "Notification ", "You have not challenge to any one for a game.", { "OK" } )
  end
end

function deleteGameCallBack:onException(object)
  if object:getMessage() ~= nil then 
    native.showAlert(object:getMessage(),object:getDetails(),{"ok"} )
  end
end

function updateGameStorageCallBack:onException(object)
  if object:getMessage() ~= nil then 
    native.showAlert(object:getMessage(),object:getDetails(),{"ok"} )
  end
end

function loginCallBack:onException(object)
  if object:getMessage() ~= nil then 
    native.showAlert(object:getMessage(),object:getDetails(),{"ok"} )
  end
end

function storeDeviceCallBack:onException(object)
  if object:getAppErrorCode() == 1700 then
    storyboard.gotoScene( "Menu" )
  elseif object:getMessage() ~= nil then
      native.showAlert(object:getMessage(),object:getDetails(),{"Back"} ) 
  end
end

function pushCallBack:onException(object)
  if object:getAppErrorCode() == 1700 then
    native.showAlert(object:getMessage(),object:getDetails(),{"Back"} ) 
  end
end
function App42APIServices:authenticateUser(userName,password)
  userService:authenticate(userName,password,loginCallBack)
end
function App42APIServices:getUserList()
  userService:getAllUsers(getAllCallback)
end
function App42APIServices:registerUser(userName,password,emailId)
  userService:createUser(userName,password,emailId,loginCallBack)
end
function App42APIServices:regisetrForDevice(userId,deviceToken,deviceType)
  pushService:storeDeviceToken(userId,deviceToken,deviceType,storeDeviceCallBack)
end
function App42APIServices:pushMessage(gameObject,userName)
  pushService:sendPushMessageToUser(Constant.GameName..userName,JSON:encode(gameObject),pushCallBack)
end
function App42APIServices:createGame(userName,remoteUser)
  gameObject[Constant.GameFirstUserKey] = userName
  gameObject[Constant.GameSecondUserKey] = remoteUser
  gameObject[Constant.GameStateKey]=  Constant.GameStateIdle
  gameObject[Constant.GameBoardKey]=  Constant.GameIdleState
  gameObject[Constant.GameWinnerKey]= "";
  gameObject[Constant.GameNextMoveKey]= remoteUser
  gameObject[Constant.GameIdKey]= tostring(math.random(os.time()))
  pushService:sendPushMessageToUser(Constant.GameName..remoteUser,"You have challenge for a game by "..userName,pushCallBack)
  storageService:insertJSONDocument(Constant.App42DBName,Constant.App42UserGamesCollectionPrefix..userName,
		gameObject,createGameCallBack)    
  storageService:insertJSONDocument(Constant.App42DBName,  Constant.App42UserGamesCollectionPrefix..remoteUser,
		gameObject,createGameCallBack)
end
function App42APIServices:getUserGameList()
  local collName = Constant.App42UserGamesCollectionPrefix..App42API:getLoggedInUser()
  storageService:findAllDocuments(Constant.App42DBName,collName,gameUserListCallBack)
end
function App42APIServices:updateGame(gameObj,userName)
  local collName1 = Constant.App42UserGamesCollectionPrefix..gameObj[Constant.GameFirstUserKey]
  local collName2 = Constant.App42UserGamesCollectionPrefix..gameObj[Constant.GameSecondUserKey]
  local id = gameObj[Constant.GameIdKey]
  pushService:sendPushMessageToUser(userName,"Your turn",updateGamePushCallBack)
  storageService:updateDocumentByKeyValue(Constant.App42DBName, collName1,Constant.GameIdKey, id, gameObj,
    updateGameStorageCallBack)
  storageService:updateDocumentByKeyValue(Constant.App42DBName, collName2,Constant.GameIdKey, id, gameObj,
    updateGameStorageCallBack)
end
function App42APIServices:deleteGame(gameObject)
  local collName1 = Constant.App42UserGamesCollectionPrefix..gameObject["user_one"]
  local collName2 = Constant.App42UserGamesCollectionPrefix..gameObject["user_two"]
  local id = gameObject["game_id"]
  pushService:sendPushMessageToUser(gameObject["user_one"],"You Loose the game",updateGamePushCallBack)
  storageService:deleteDocumentsByKeyValue(Constant.App42DBName, collName1,Constant.GameIdKey, id,
    deleteGameCallBack)
  storageService:deleteDocumentsByKeyValue(Constant.App42DBName,collName2,Constant.GameIdKey,id,
    deleteGameCallBack)
end
function App42APIServices:logout()
   userService:logout(Constant.sessionId, logoutCallBack)
end
function logoutCallBack:onSuccess(object)
    storyboard.gotoScene( "SignUp")
end

function getAllCallback:onSuccess(object)
    Constant.data = object
    storyboard.gotoScene( "Challenge" )
end

function gameUserListCallBack:onSuccess(object)
  Constant.GameUserList = object:getJsonDocList()
  for i=1, table.getn(object:getJsonDocList()) do
      Constant.UserGameObject = object:getJsonDocList()[i]:getJsonDoc()
  end
    storyboard.gotoScene( "GameList")
end

function deleteGameCallBack:onSuccess(object)
    storyboard.gotoScene( "Menu")
end
function updateGameStorageCallBack:onSuccess(object)
--   storyboard.gotoScene( "Menu")
end
function loginCallBack:onSuccess(object)
  Constant.sessionId = object:getSessionId()
  App42API:setLoggedInUser(object:getUserName())
  App42APIServices:regisetrForDevice(Constant.GameName..object:getUserName(),Constant.deviceToken,
    DeviceType.ANDROID)
end
function storeDeviceCallBack:onSuccess(object)
  storyboard.gotoScene( "Menu" )
  native.showAlert( "Notification ", "You are successfully registered", { "OK" } )
end
function pushCallBack:onSuccess(object)
  native.showAlert( "Notification ", "Your game challenge has successfull send", { "OK" } )
end
return App42APIServices