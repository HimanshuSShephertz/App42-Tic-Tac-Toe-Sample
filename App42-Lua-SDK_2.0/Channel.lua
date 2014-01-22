--author Himanshu Sharma
local Channel = {}
local channelName = ""
local description = ""
function Channel:new()
  o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Channel:getChannelName()
    return self.channelName
end
function Channel:setChannelName(_channelName)
    self.channelName = _channelName  
end
function Channel:getDescription()
    return self.description;
end
function Channel:setDescription(_description)
    self.description = _description  
end
return Channel