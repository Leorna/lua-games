--[[
    This class handles states transitions
]]


StateMachine = {}

function StateMachine:new(states)
    local this = {}
    setmetatable(this, self)
    self.__index = self

    this.empty = {
        render = function ()  end,
        update = function () end,
        enter = function () end,
        exit = function () end
    }

    this.states =  states or {}
    this.current = this.empty

    return this
end


function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) --state must exist
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