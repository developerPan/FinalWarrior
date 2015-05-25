local Role = require("Modules/Childs/Role")
local PUIHelper  =   require("Utility/PUIHelper")
local Hero  =   class("Hero", function(...)
    return Role.new(...)
end)

function Hero:ctor(...)
    print("~~~~")
    self:updateFace("RIGHT")
    self.att = 24
    self.def = 15 
    self.runSpeed = 5
    self.attRectX = 5 --攻击距离
    self.attRate = 0.6  --以秒为单位
    self.time = 0  
    self.lastAttTime = 0 
end

function Hero:updeteState(dt) 
    self.time = dt + self.time 
end

--攻击检测
function Hero:checkAttack()
    if(self.time - self.lastAttTime >= self.attRate) then  --可以攻击
        self.lastAttTime = self.time  
        return true
    else
        return false 
    end 
end

function Hero:startUpdate()
    local function update(dt)
        self:updeteState(dt)
    end
    self:scheduleUpdateWithPriorityLua(update,1/60)
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
    self:runRoleAction(Role.STATE.JUMP)
end

--普通攻击
function Hero:normalAttack(targets) 
    local loop  = 0
    self.anim:setSpeed(2)
    self:setPositionX(self:getPositionX() + self.anim:getScaleX() * 20 )
    local func = function() self:runRoleAction(Role.STATE.IDLE) end
    self.anim:playd(Role.STATE.ATTACK,loop,func,0) 
    for key, target in ipairs(targets) do 
         if(target.hp > 0) then
            target:beHitted(self)
         end 
    end 
end

function Hero:specialAttack(targets)
    local loop  = 0
    self.anim:setSpeed(1)
    self:setPositionX(self:getPositionX() + self.anim:getScaleX() * 30)
    local func = function() self:runRoleAction(Role.STATE.IDLE) end
    self.anim:playd(Role.STATE.ATTACK,loop,func,0) 
    for key, target in ipairs(targets) do 
        if(target.hp > 0) then
            target:beCritHitted(self)
        end 
    end 
end

function Role:beHitted(attacker)
    self.lastAttTime = self.lastAttTime + (self.time - self.lastAttTime) / 2 --攻击间隔延时 
    if(attacker:getPositionX() > self:getPositionX()) then  --在右侧
        self:setPositionX(self:getPositionX() + 10)
    else
        self:setPositionX(self:getPositionX() - 10)
    end  
    self:runRoleAction(Role.STATE.HIT) 
    self.state = Role.STATE.HIT
end

function Role:beCritHitted(attacker)
    self.lastAttTime = self.time  --攻击间隔重置 
    local mul = 1
    if(attacker:getPositionX() > self:getPositionX()) then  --在右侧
        mul = -1 
    end 
    
    local jumpAct = cc.JumpBy:create(0.4,cc.p(20*mul,0),50,1)
    local jumpForAct = cc.Spawn:create(jumpAct,cc.MoveBy:create(0.5,cc.p(80*mul,0))) 
    self.jumpState = Role.JUMPSTATE.JUMPING
    local actions = cc.Sequence:create(jumpForAct,cc.CallFunc:create(function() 
        self.state = Role.STATE.IDLE
    end))
    self:runAction(actions)       
    self:runRoleAction(Role.STATE.HIT) 
    self.state = Role.STATE.HIT
end

return Hero