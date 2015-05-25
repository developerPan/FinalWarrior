local Role = require("Modules/Childs/Role")
local PUIHelper  =   require("Utility/PUIHelper")
local Hero  =   class("Hero", function(...)
    return Role.new(...)
end)

function Hero:ctor(...)
    print("~~~~")
    self:updateFace("RIGHT")
    self.att = 44
    self.def = 15 
    self.runSpeed = 5
    self.attRectX = 5 --攻击距离
    self.attRate = 0.6  --以秒为单位
    self.time = 0  
    self.lastAttTime = 0 
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

return Hero