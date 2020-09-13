StateMachine = {}


function StateMachine:new(states)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.empty = {
        render = function()end,
        update = function()end,
        enter = function()end,
        exit = function()end
    }

    o.states = states or {}
    o.current = o.empty

    return o
end


function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end


function StateMachine:update(dt)
    self.current:update(dt)
end


function StateMachine:render()
    self.current:render()
end