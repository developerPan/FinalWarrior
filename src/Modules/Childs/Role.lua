local Role  =   class("Role",function() 
    return cc.Node:create()--cc.LayerColor:create(cc.c4b(255,9,9,255))
end)

local PAnimation    =   require("Utility/PAnimation")
Role.STATE  =   {
    IDLE    =   "idle",
    ATTACK  =   "attack",
    HIT     =   "hit",
    RUN     =   "run",
    JUMP    =   "jump",
}

Role.JUMPSTATE  =   {
    JUMPING =   "jumping",
    END     =   "jump_end"
}

Role.RECTKEY    =   {
    ATTACK  =   "attack",
    HIT     =   "hit"
}

function Role:ctor(animName,actList)
    self.anim =  PAnimation.new(animName)
    self.anim:setAnchorP(0.5,0)
    self:addChild(self.anim,100)
    self:initActionList(actList)
    self.attackCounts = 0
    self:runRoleAction(Role.STATE.IDLE)
    self:setScale(0.7)  
    
    self.bodyWidth = 80 --身长   判断攻击距离时需要算上该宽度
    self:setContentSize(100,100)
    return self
end

--设置攻击距离
function Role:setAttRectX(rectX)
	self.attRectX = rectX
end

function Role:getAttRectX(rectX)
    return self.attRectX
end

function Role:setHp(hp)
    if(hp<0 or hp == nil)then 
        hp = 0 
        return false 
    end
    self.hp = hp
    return true
end

function Role:reduceHp(dam)
    if(dam and dam >= 0)then 
        self.hp = self.hp - dam
        if(self.hp <= 0) then
            self.hp = 0
            self:deathAin()
            return false
        else
            return true
        end    
    end 
   
end


--死亡表现
function Role:deathAin() 
	self.anim:runAction(cc.FadeOut:create(0.8))
end
function Role:getHp()
    return self.hp
end

function Role:getHpPercent()
    if(self.hp and self.maxHp)then
        return self.hp/self.maxHp *100
    else
        return 0
    end
end
function Role:setMaxHp(maxHp)
    maxHp = maxHp or 1
    self.maxHp  =   maxHp
   
end

function Role:getMaxHp()
    return self.maxHp
end
function Role:bindRect(key,width,height,float)
    if(key == Role.RECTKEY.ATTACK)then
        if(self.aframe == nil)then
            self.aframe = cc.LayerColor:create(cc.c4b(255,0,0,0))--攻击区域
            self.anim:addChild(self.aframe)
            self.aframe:setPositionX(0)
            self.aframe:setVisible(false)
        end
        self.aframe:setContentSize(width,height)
    elseif(key == Role.RECTKEY.HIT)then
        if(self.hframe == nil)then
            self.hframe = cc.LayerColor:create(cc.c4b(0,255,0,0))--受击区域
            self.anim:addChild(self.hframe)
            self.hframe:setPositionX(0)
        end
        self.hframe:setContentSize(width,height)
    else
        print("错误的rect key")
    end

    self:setContentSize(width,height)
end
function Role:fixPos(x,y)
    self.anim:setPosition(self.anim:getPositionX()+x,self.anim:getPositionY()+y)
end

function Role:initActionList(actList)
    actList =   actList or  {}
    self.actList ={
        idle    =   actList["idle"] or  "idle",
        attack  =   actList["attack"] or "attack",
        hit     =   actList["hit"]  or  "hit",
        run     =   actList["run"]  or  "run"
    }
end
function Role:getState()
    return self.state
end

function Role:runRoleAction(actState,duration,func,loop)
    if(self.aframe)then self.aframe:setVisible(false)end
    self.state = actState
    if(actState == Role.STATE.IDLE)then
        loop  =   loop or 1
        self.anim:setSpeed(1)
    elseif(actState == Role.STATE.ATTACK)then
        loop  =   loop or 0
        self.anim:setSpeed(3)
        if(self.aframe)then self.aframe:setVisible(true) end 
        self:setPositionX(self:getPositionX()+15)
        func = function() self:runRoleAction(Role.STATE.IDLE) end
    elseif(actState == Role.STATE.HIT)then
        loop  =   loop or 0
        self.anim:setSpeed(1)
        func = function() self:runRoleAction(Role.STATE.IDLE) end
    elseif(actState == Role.STATE.RUN)then
        loop  =   loop or 1
        self.anim:setSpeed(1)
    elseif(actState == Role.STATE.JUMP)then
        local mul = self.anim:getScaleX()

        local jumpAct = cc.JumpBy:create(0.5,cc.p(0,0),200,1)
        local jumpForAct = cc.Spawn:create(jumpAct,cc.MoveBy:create(0.5,cc.p(150*mul,0)))
        --[[if(self.jumpState == Role.JUMPSTATE.JUMPING)then    --跳跃并前进
            self.anim:stopAllActions()
            self.jumpState = Role.JUMPSTATE.END
            self.anim:runAction(cc.Sequence:create(cc.Spawn:create(jumpAct,cc.MoveTo:create(0.5,cc.p(self.anim:getPositionX()+100,0))),cc.CallFunc:create(function()

                self.state = Role.STATE.IDLE
            end)))
        else]]if(self.jumpState == nil or self.jumpState == Role.JUMPSTATE.END)then   --没打断的跳跃
            self.jumpState = Role.JUMPSTATE.JUMPING
            local actions = cc.Sequence:create(jumpForAct,cc.CallFunc:create(function()
                self.jumpState = Role.JUMPSTATE.END
                self.state = Role.STATE.IDLE
            end))
            self:runAction(actions)
        end
        return
    end

    self.anim:playd(actState,loop,func,duration or 0)

end
function Role:getAnimation()
    return self.anim
end
function Role:beHitted()
    self:runRoleAction(Role.STATE.HIT)
end
function Role:attack(targets)  
    self.attackCounts = self.attackCounts+1
    local att = 0
    if(self.attackCounts >= 3)then--重击
        self.attackCounts = 0
        self:specialAttack(targets)
        att = self.att * 2
    else
        self:normalAttack(targets)
        att = self.att
    end
    
    for key, target in ipairs(targets) do
        local dam = att - target.def
        if dam <= 0 then dam = 1 end
        print("@@伤害",dam)
        target:reduceHp(dam)
    end 
end

 

function Role:run(cmd)
    local RockerVC  =   require("Rocker/RockerViewController") 
    if(cmd == "LEFT")then
        self:setPositionX( self:getPositionX() - self.runSpeed )
    elseif(cmd == "RIGHT")then
        self:setPositionX(self:getPositionX() + self.runSpeed)
    end 
    --更新头的朝向
    self:updateFace(cmd)
    if(self.state == Role.STATE.RUN)then return end
    self:runRoleAction(Role.STATE.RUN)

end

function Role:updateFace(cmd)
    if(cmd == self.lastFace)then return end
    if(cmd == "LEFT")then
        self.anim:setScaleX(-1)
        --锚点也被反转了
        --if(self.hframe)then self.hframe:setPositionX(self:getPositionX()-self:getContentSize().width) end
        print("左")
    elseif(cmd == "RIGHT")then
        self.anim:setScaleX(1.0)
    end
    self.lastFace = cmd
end

function Role:stopAction()
    if(self.state == Role.STATE.IDLE)then return end
    self.state = Role.STATE.IDLE
    self:runRoleAction(Role.STATE.IDLE) 
end
return Role