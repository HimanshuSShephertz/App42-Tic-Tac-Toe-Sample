--author Himanshu Sharma
local  App42ResponseBuilder = require("App42-Lua-API.App42ResponseBuilder")
local JSON = require("App42-Lua-API.JSON")
local Channel = require("App42-Lua-API.Channel")
local PushNotification = require("App42-Lua-API.PushNotification")
local PushNotificationResponseBuilder = {}

function PushNotificationResponseBuilder:buildResponse(jsonString)
  local pushNotification = require("App42-Lua-API.PushNotification")
  local pushNotificationJSONObj = App42ResponseBuilder:getServiceJSONObject("push",jsonString)
    if(pushNotificationJSONObj == nil) then 
      pushNotification:setStrResponse(jsonString)
      pushNotification:setResponseSuccess(App42ResponseBuilder:isResponseSuccess(jsonString))
      pushNotification:setTotalRecords(App42ResponseBuilder:getTotalRecords(jsonString))
    else 
      pushNotification =  PushNotificationResponseBuilder:buildPushNotificationObject(pushNotificationJSONObj)
      pushNotification:setStrResponse(jsonString)
      pushNotification:setResponseSuccess(App42ResponseBuilder:isResponseSuccess(jsonString))
    end
  return pushNotification
end
function PushNotificationResponseBuilder:buildPushNotificationObject(pushJSONObject)
  local pushNotification =  PushNotificationResponseBuilder:buildObjectFromJSONTree(pushJSONObject)
  local channelArray = {}
  if pushJSONObject.channels ~= nil then
    local channelJSONArray = pushJSONObject.channel
    if table.getn(channelJSONArray) > 0 then
      for i=1, table.getn(channelArray) do
        channelArray[i] = PushNotificationResponseBuilder:buildChannelObject(channelJSONArray[i])
      end 
    else
        channelArray = PushNotificationResponseBuilder:buildChannelObject(channelJSONArray)
    end
      pushNotification:setChannelList(channelArray)
  end
  return pushNotification
end
function PushNotificationResponseBuilder:buildChannelObject(jsonObject)
  local channelList = Channel:new();
  if(jsonObject.channelName ~= nil)then
    channelList:setChannelName(jsonObject.channelName)
  end
  if(jsonObject.description ~= nil) then
    channelList:setDescription(jsonObject.description)
  end
  return channelList
end
function PushNotificationResponseBuilder:buildObjectFromJSONTree(jsonObject)
  local object  = PushNotification:new()
  if(jsonObject.deviceToken ~= nil)then
    object:setDeviceToken(jsonObject.deviceToken)
  end
  if(jsonObject.message ~= nil) then
    object:setMessage(jsonObject.message)
  end
  if(jsonObject.userName ~= nil) then
    object:setUserName(jsonObject.userName)
  end
  if(jsonObject.expiry ~= nil) then
    object:setExpiry(jsonObject.expiry)
  end
  if(jsonObject.deviceType ~= nil) then
    object:setDeviceType(jsonObject.deviceType)
  end
  return object
end
return PushNotificationResponseBuilder