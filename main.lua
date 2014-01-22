local storyboard = require "storyboard"
local App42API = require("App42-Lua-API.App42API")
local App42Log= require("App42-Lua-API.App42Log")
local JSON= require("App42-Lua-API.JSON")
require("Constant")
local App42APIServices = require("App42APIServices")
App42API:initialize(Constant.apiKey,Constant.secretKey)
--App42API:setLocalURL("http://","192.168.1.31",8082)
App42Log:setDebug(true)
storyboard.gotoScene( "SignUp" )
local function onNotification( event )
    if event.type == "remoteRegistration" then
      Constant.deviceToken = event.token
    elseif event.type == "remote" then
        native.showAlert( "Notification", event.alert, { "OK" } )
    end
end
 
Runtime:addEventListener( "notification", onNotification )