--
-- 动画
--

local PAnimation =   class("PAnimation",function()
    return cc.Node:create()
end)

function PAnimation:ctor(aname)
    GResMgr:loadArmature(aname)
    
    self.anim  =  ccs.Armature:create(aname) 
    --以脚的中心点为锚点
    self.anim:setAnchorPoint(0.5,0)

    self:init()
    self:addChild(self.anim)

end

function PAnimation:init()
    self._movementCallback  =   {}
    local function AnimationEvent(armatureBack,movementType,movmentId)
        if(movementType == ccs.MovementEventType.complete)then
            local callback = self._movementCallback[movmentId]
            if callback then
                callback()
                self._movementCallback[movmentId] = nil
            end
        end
    end
    self.anim:getAnimation():setMovementEventCallFunc(AnimationEvent)
end
--播放cocos动画
function PAnimation:playd(animName,loop,callFunc,duration)
    GLog:sysInfo("播放动画",animName)
    --loop=0不循环,loop>0循环播放
    loop = loop or 0
    self._movementCallback[animName]    =   callFunc
    local duration = duration or 0
    self.anim:getAnimation():play(animName,duration,loop)
end

--停止动画
function PAnimation:stop()
    self.anim:getAnimation():stop()
end

--暂停动画
function PAnimation:pause()
    self.anim:getAnimation():pause()
end
--恢复动画
function PAnimation:resume()
    self.anim:getAnimation():resume()
end

--跳到指定帧并停止
function PAnimation:gotoAndPause(frameIndex)
    self.anim:getAnimation():gotoAndPause(frameIndex)
end
function PAnimation:setSpeed(speed)
    self.anim:getAnimation():setSpeedScale(speed)
end

function PAnimation:setAnchorP(x,y)
    self.anim:setAnchorPoint(x,y)
end
return PAnimation
