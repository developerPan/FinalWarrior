local MainView  =   class("MainView")

function MainView.create()
    --背景层
    local inst =    GClass:extendScene(MainView)
    inst:init()
    
    return inst
end

function MainView:init()
    local land = ccui.ImageView:create("bg.png")--cc.LayerColor:create(cc.c4b(0,255,255,255))
    self.land = land
    self:initMap()
end
--初始化地图
function MainView:initMap()
    self.LANDHEIGHT =   197
    --land:setContentSize(cc.size(1136,200))
    self.land:setAnchorPoint(0,0)
    self.land:setPosition(0,0)
    self:addChild(self.land,0)
end
--移动地图
function MainView:moveMap(float)
    print("~~~",self.land:getPositionX())
    if((self:getContentSize().width/2+self.land:getPositionX()>50 and float <0)
    or (self.land:getPositionX()<0 and float >0))then--地图要超出又边界后不移动,留白50是因为动画的锚点没做在脚下，牺牲一部分的地图
        self.land:setPositionX(self.land:getPositionX()+float)
        return true
    else
        print("地图不移动")
        return false
    end
end

--判断地图是否到边缘
function MainView:getLandHeight()
    return self.LANDHEIGHT
end

return MainView