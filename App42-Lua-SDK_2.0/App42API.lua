--author Himanshu Sharma
local App42Config = require("App42-Lua-API.App42Config")
local Util = require("App42-Lua-API.Util")
local App42API = {}
local apiKey = ""  
local secretKey = "" 
local defaultACL = ""
local loggedInUser =""
local userSessionId = ""

function App42API:initialize(_apiKey,_secretKey)
  self.apiKey = _apiKey  
  self.secretKey = _secretKey
end
function App42API:getApiKey()
  return self.apiKey
end
function App42API:getSecretKey()
  return self.secretKey
end
function App42API:setLocalURL(protocol,host,port)
  App42Config:setLocalURL(protocol,host,port)
end
function App42API:getDefaultACL()
  return defaultACL
end
function App42API:setDefaultACL(_defaultACL)
  local acl = Util:buildAclRequest(_defaultACL)
  defaultACL = acl
end
function App42API:getLoggedInUser() 
  return loggedInUser
end
function App42API:setLoggedInUser(_loggedInUser)
  loggedInUser = _loggedInUser
end
function App42API:getUserSessionId()
  return userSessionId
end		
function App42API:setUserSessionId(_userSessionId)
  userSessionId = _userSessionId
end		
function App42API:setBaseURL(_baseURL)
  App42Config:setBaseURL(_baseURL)
end
function App42API:buildUserService()
  local userService  = require("App42-Lua-API.UserService")
  return userService
end
function App42API:buildGameService()
  local gameService  = require("App42-Lua-API.GameService")
  return gameService
end
function App42API:buildStorageService()
  local storageService  = require("App42-Lua-API.StorageService")
  return storageService
end
function App42API:buildScoreBoardService()
  local scoreBoardService  = require("App42-Lua-API.ScoreBoardService")
  return scoreBoardService
end
function App42API:buildCustomCodeService()
  local customCodeService  = require("App42-Lua-API.CustomCodeService")
  return customCodeService
end
function App42API:buildRewardService()
  local rewardService  = require("App42-Lua-API.RewardService")
  return rewardService
end
function App42API:buildPushNotificationService()
  local pushNotificationService  = require("App42-Lua-API.PushNotificationService")
  return pushNotificationService
end
return App42API