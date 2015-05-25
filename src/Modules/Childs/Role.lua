local Role  =   class("Role",function() 
    return cc.Layer:create()
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
    self:runAction(Role.STATE.IDLE)
    self:setScale(0.7)
    return self
end

function Role:setHp(hp)
    if(hp<0 or hp == nil)then 
        hp = 0 
        return false 
    end
    self.hp = hp
    return true
end

function Role:getHp()
    return self.hp
end

function Role:getHpPercent()
    if(self.hp and self.maxHp)then
        return self.hp/self.maxHp
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

function Role:runAction(actState,duration,func,loop)
    if(self.aframe)then self.aframe:setVisible(false)end
    self.state = actState
    if(actState == Role.STATE.IDLE)then
        loop  =   loop or 1
        self.anim:setSpeed(1)
    elseif(actState == Role.STATE.ATTACK)then
        loop  =   loop or 0
        self.anim:setSpeed(3)
        if(self.aframe)then self.aframe:setVisible(true) end
        self.anim:setPositionX(self.anim:getPositionX()+15)
        func = function() self:runAction(Role.STATE.IDLE) end
    elseif(actState == Role.STATE.HIT)then
        loop  =   loop or 0
        self.anim:setSpeed(1)
        func = function() self:runAction(Role.STATE.IDLE) end
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
            self.anim:runAction(cc.Sequence:create(jumpForAct,cc.CallFunc:create(function()
                self.jumpState = Role.JUMPSTATE.END
                self.state = Role.STATE.IDLE
            end)))
        end
        return
    end

    self.anim:playd(actState,loop,func,duration or 0)

end
function Role:getAnimation()
    return self.anim
end
function Role:beHitted()
    self:runAction(Role.STATE.HIT)
end
function Role:attack()

    self.attackCounts = self.attackCounts+1
    if(self.attackCounts >= 3)then--重击
        self.attackCounts = 0
        self:specialAttack()
    else
        print("普通攻击")
        self:runAction(Role.STATE.ATTACK)
    end
end

function Role:specialAttack()

end
function Role:run(cmd,isInPlace)
    local RockerVC  =   require("Rocker/RockerViewController")
    if(isInPlace ~= true)then
        if(cmd == "LEFT")then
            self:setPositionX( self:getPositionX()-5 )
        elseif(cmd == "RIGHT")then
            self:setPositionX(self:getPositionX()+5)
        end
    end
    --更新头的朝向
    self:updateFace(cmd)
    if(self.state == Role.STATE.RUN)then return end
    self:runAction(Role.STATE.RUN)

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
    self:runAction(Role.STATE.IDLE)
end
return Role