BaseState = {}


function BaseState:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end


function BaseState:enter()end
function BaseState:exit()end
function BaseState:update(dt)end
function BaseState:render()end