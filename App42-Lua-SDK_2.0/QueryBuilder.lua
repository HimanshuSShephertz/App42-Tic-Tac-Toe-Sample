--author Himanshu Sharma
local QueryBuilder = {}
local Query = require("App42-Lua-API.Query")
local JSON = require("App42-Lua-API.JSON")

function QueryBuilder:new()
  o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end
function QueryBuilder:build(key,value,operator)
  local queryObj ={} 
  local jsonObj ={} 
    jsonObj.key =  key
    jsonObj.value = value
    jsonObj.operator=  operator
    queryObj = jsonObj
  return queryObj;
end
function QueryBuilder:buildGeoQuery(geoTag,operator,maxDistance)
  local jsonObj ={} 
    jsonObj.lat =  geoTag:getLat()
    jsonObj.lng = geoTag:getLng()
    jsonObj.operator=  operator
    jsonObj.maxDistance = maxDistance
  return jsonObj;
end
function QueryBuilder:compoundOperator(q1,operator,q2)
  local queryArray = {}
  local jsonObj ={}
  jsonObj.compoundOpt= operator
  queryArray[1] = q1
  queryArray[2] = jsonObj
  queryArray[3] = q2
  return queryArray;
end

return QueryBuilder