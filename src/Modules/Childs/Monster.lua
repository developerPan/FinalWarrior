local Role  =   require("Modules/Childs/Role")
local UIBar =   require("Utility/UIBar")
local Monster = class("Monster",function(...)
    return Role.new(...)
end)

function Monster:ctor(...)
    self:updateFace("LEFT")
    self:initBloodSlider() 
    self.bloodPercent = 100
    self.att = 20
    self.def = 15
    self.hp = 100
    self.maxhp = 100
    self.spyRectX = 300
    
    self.attRectX = 5 --攻击距离
    self.attRate = 0.8  --以秒为单位
    self.time = 0  
    self.lastAttTime = 0
    self.runSpeed = 3
end

function Monster:startUpdate()
    local function update(dt)
    	self:updeteState(dt)
    end
    self:scheduleUpdateWithPriorityLua(update,1/60)
end

function Monster:initBloodSlider()
    self.bloodSlider =  UIBar.create()
    self.bloodSlider:setAnchorPoint(0.5,0.5)
    self.bloodSlider:setPositionX(0)
    self.bloodSlider:setPositionY(150)
    self:addChild(self.bloodSlider) 
end 

function Monster:updateBloodSlider() 
    local percent = self:getHpPercent() 
    if(percent ~= self.bloodPercent)then --减少刷新次数，血量有变化才刷新 
        self.bloodSlider:setPercent(percent) 
        self.bloodPercent = percent
    end
   
end

--小怪的AI 
function Monster:updeteState(dt)
    if self.hp <= 0 and self.state == Role.STATE.HIT then
        return
    end
    
    self.time = dt + self.time
	local heroPosX = self.mainController.hero:getPositionX()
    local distance = math.abs(heroPosX - self:getPositionX()) 
    if(distance <= self.spyRectX) then  --达到感知范围
        if(distance <= self.attRectX + self.bodyWidth) and self.mainController.hero.hp > 0 then --达到攻击距离  并且主角未死亡
            self:checkAttack()
        else    --没达到
            self:moveToPlayer(heroPosX)
        end
    else  --没有达到
        self:stopAction()
    end
--    self:updateBloodSlider()
end


--向主角移动
function Monster:moveToPlayer(heroPosX)
	if(self:getPositionX() > heroPosX) then  --向左走
	   self:run("LEFT")
	else  --向右走
	   self:run("RIGHT")
	end
end

--攻击检测 有技能放技能
function Monster:checkAttack()
    if(self.time - self.lastAttTime >= self.attRate) then  --可以攻击
        self.lastAttTime = self.time 
        self:attack({self.mainController.hero})  
    end
    	
end

--死亡表现
function Monster:deathAin() 
    local func = cc.CallFunc:create(function()self:setVisible(false) end)
    self.anim:runAction(cc.Sequence:create(cc.FadeOut:create(0.6),func))
end

function Role:beHitted(attacker)
    self.lastAttTime = self.time 
    if(attacker:getPositionX() > self:getPositionX()) then  --在右侧
        self:setPositionX(self:getPositionX() - 30)
    else
        self:setPositionX(self:getPositionX() + 30)
    end
    self:runRoleAction(Role.STATE.HIT) 
    self.state = Role.STATE.HIT
end

function Role:beCritHitted(attacker)
    self.lastAttTime = self.time
    local mul = -self.anim:getScaleX() 
    local jumpAct = cc.JumpBy:create(0.4,cc.p(20*mul,0),80,1)
    local jumpForAct = cc.Spawn:create(jumpAct,cc.MoveBy:create(0.5,cc.p(160*mul,0))) 
    self.jumpState = Role.JUMPSTATE.JUMPING
    local actions = cc.Sequence:create(jumpForAct,cc.CallFunc:create(function() 
        self.state = Role.STATE.IDLE
    end))
    self:runAction(actions)        
    self:runRoleAction(Role.STATE.HIT) 
    self.state = Role.STATE.HIT
end

--普通攻击
function Monster:normalAttack(targets) 
    local loop  = 0
    self.anim:setSpeed(1) 
    local attacker = targets[1]
    if(attacker:getPositionX() > self:getPositionX()) then  --在右侧
        self:setPositionX(self:getPositionX() + 15)
    else
        self:setPositionX(self:getPositionX() - 15)
    end 
    local func = function() self:runRoleAction(Role.STATE.IDLE) end
    self.anim:playd(Role.STATE.ATTACK,loop,func,0)
    attacker:beHitted(self)
end

function Monster:specialAttack(targets)
    local loop  = 0
    self.anim:setSpeed(0.5) 
    local attacker = targets[1]
    if(attacker:getPositionX() > self:getPositionX()) then  --在右侧
        self:setPositionX(self:getPositionX() + 15)
    else
        self:setPositionX(self:getPositionX() - 15)
    end 
    local func = function() self:runRoleAction(Role.STATE.IDLE) end
    self.anim:playd(Role.STATE.ATTACK,loop,func,0)
    attacker:beCritHitted(self)
end

return Monster