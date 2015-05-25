local Role = require("Modules/Childs/Role")
local PUIHelper  =   require("Utility/PUIHelper")
local Hero  =   class("Hero", function(...)
    return Role.new(...)
end)

function Hero:ctor(...)
    print("~~~~")
    self:updateFace("RIGHT")
end

function Hero:specialAttack()
    print("重击")
    self:runAction(Role.STATE.ATTACK)
end

function Hero:skip(isForward)
    local base = 1
    print("瞬移")
    if(self.lastFace == "LEFT")then base = -1 end
    if(isForward)then
        self:setPositionX(self:getPositionX()+300*base)
    else    
        self:setPositionX(self:getPositionX()-100*base)
    end
end

function Hero:jump()
    self:runAction(Role.STATE.JUMP)
end

function Hero:isInMiddlePos()
    print("middle",PUIHelper:getVisibleSize().width/2 - self:getPositionX())
    if(math.abs(PUIHelper:getVisibleSize().width/2 - self:getPositionX())<=5)then--每桢移动量是5
        return true
    else
        return false
    end
end
return Hero