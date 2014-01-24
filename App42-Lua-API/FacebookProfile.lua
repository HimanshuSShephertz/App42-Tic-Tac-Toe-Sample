--author Himanshu Sharma
local FacebookProfile = {}
local name = nil
local picture = nil
local id= nil

function FacebookProfile:new()
  o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end
function FacebookProfile:getName()
    return name
end
function FacebookProfile:setName(_name)
    name = _name  
end
function FacebookProfile:getPicture()
    return picture
end
function FacebookProfile:setPicture(_picture)
    picture = _picture  
end
function FacebookProfile:getId()
    return id
end
function FacebookProfile:setId(_id)
    id = _id  
end
return FacebookProfile