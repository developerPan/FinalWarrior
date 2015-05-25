local MainView  =   class("MainView")
local PUIHelper  =   require("Utility/PUIHelper")
local RockerViewController  =   require("Rocker/RockerViewController")

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
function MainView:moveMap(heroPosX,state) 
    local landSize = self.land:getContentSize()
    local sceneWidth = PUIHelper:getVisibleSize().width
    if(heroPosX > sceneWidth / 2 and heroPosX < landSize.width - sceneWidth / 2)  then
        local offset = 0
        if state == RockerViewController.STATE.RIGHT then
            offset = -5
        else
            offset = 5
        end
        local posX = self.land:getPositionX()+offset
        if(posX > 0) then posX = 0 end
        if(posX < sceneWidth - landSize.width) then posX = sceneWidth - landSize.width end
        self.land:setPositionX(posX) 
    end 
end

 
--判断地图是否到边缘
function MainView:getLandHeight()
    return self.LANDHEIGHT
end

return MainView