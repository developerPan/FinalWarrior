local TransitionController  =   class("TransitionController")
local PChild                =   require("Utility/PChild")
local TransitionLayer       =   require("Modules/Transition/TransitionLayer")
local PUIHelper             =   require("Utility/PUIHelper")
function TransitionController:ctor()
    self.view = TransitionLayer.create()
    
end

function TransitionController:playTransition(level,tarLayer,time)
    time = time or 1
    level = level or 1
    tarLayer:addChild(self.view)
    self.view:setLevelLabel(level)
    local function PlayAct(obj)
        obj:setOpacity(0)
        obj:setScale(0)
        local act1 = cc.Spawn:create(cc.ScaleTo:create(time/3,3),cc.FadeIn:create(time/3))
        --消失
        local act2 = cc.FadeOut:create(time/3*2)
        obj:runAction(cc.Sequence:create(act1,act2,cc.CallFunc:create(function()
            self:playHunshiAct()
        end)))
    end
    PlayAct(self.view.label_num)
    PlayAct(self.view.image_round)
    
end

function TransitionController:playHunshiAct()
    local stone1 = ccui.ImageView:create("hunshi.png")
    stone1:setScale(0.2)
    stone1:setPosition(PUIHelper:getScreenCenter())

    self.view:addChild(stone1)
  
      -- 贝塞尔曲线配置结构  
      local bezier = {  
        cc.p(10, 30),  
        cc.p(20,  50), 
        cc.p(70,-88),
        cc.p(120, -100),  
      } 
      -- 以持续时间和贝塞尔曲线的配置结构体为参数创建动作  
    local bezierAct = cc.BezierBy:create(0.6, bezier) 
    local jumpAct   =   cc.JumpBy:create(0.6,cc.p(60,0),20,2)
    local flyToAct  =   cc.Spawn:create(cc.MoveTo:create(0.6,cc.p(800,600)),cc.FadeOut:create(0.6))
    stone1:runAction(cc.Sequence:create(bezierAct,jumpAct,flyToAct,cc.CallFunc:create(function()
        self.view:removeFromParent()
    end)))
end
return TransitionController