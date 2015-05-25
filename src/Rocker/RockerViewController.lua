local RockerViewController  =   class("RockerViewController")
local RockerLayer           =   require("Rocker/RockerLayer")
RockerViewController.STATE  ={
    LEFT  =   "LEFT",
    RIGHT =   "RIGHT",
    CANCEL  =   "CANCEL",
    NOACTION    =   "NOACTION"
}

function RockerViewController.create(fname_bg,fname_dot)
    local inst  =  RockerViewController.new() 
    inst.view = RockerLayer.new(fname_bg,fname_dot)
    return inst
end

function RockerViewController:getView()
    return self.view
end


function RockerViewController:startRocker()
    --减少状态刷新
    self.lastX  =   self.view.dot:getPositionX()

    --默认为无操作状态
    self.state = RockerViewController.STATE.CANCEL
    --设置半透明
    self.view:setTrans(true)
    local function updateDotPos(posX,posY)
        --小范围移动不做处理
         if(posX-self.lastX>5 and self.state ~= RockerViewController.STATE.RIGHT)then
            self.state = RockerViewController.STATE.RIGHT
            print("朝向变更",self.state)
            
         elseif(self.lastX-posX>5 and self.state ~= RockerViewController.STATE.LEFT)then
            self.state = RockerViewController.STATE.LEFT
            print("朝向变更",self.state)
            
         end
 
        if(cc.rectContainsPoint(self.view.bg:getBoundingBox(), cc.p(posX,posY) ))then  --是否在去圈内
            self.lastX  =   posX
            self.view.dot:setPosition(cc.p(posX,posY))
        else
            --摇杆圆盘半径长60，缩放比例1.7 
            local m1 = self.view.bg:getPositionX()
            local m2 = self.view.bg:getPositionY()
            local x = 60*1.7*(posX-m1)/math.sqrt(math.pow((posX-m1),2)+math.pow((posY-m2),2))+m1
            local y = m2 - (x-m1)*(m2-posY)/(posX-m1)  
            self.view.dot:setPosition(x,y)
            
        end
    end
    local function onTouchBegan(sender,eventType)
        if(cc.rectContainsPoint(self.view.bg:getBoundingBox(), sender:getLocation() ))then
            updateDotPos(sender:getLocation().x,sender:getLocation().y)
            self.view:setTrans(false)   --不做半透明处理
            self.forceStop  =   nil
            --GEventMgr:dispatchEvent(RockerViewController.EVENT.ROCKDIRCHANGE,"left")
            return true
        --初次点击不在区域内不处理
        end
    end

    local function onTouchMoved(sender,eventType)

        updateDotPos(sender:getLocation().x,sender:getLocation().y)
        
    end

    local function onTouchCancled(sender,eventType)
        --强制关闭监听

        updateDotPos(sender:getLocation().x,sender:getLocation().y)
        self.state  =   RockerViewController.STATE.CACNCEL
        
    end

    local function onTouchEnded(sender,eventType)
       -- self.view.dot:setPosition(cc.p(self.view.bg:getPositionX(),self.view.bg:getPositionY()) )
        --强制关闭监听

        updateDotPos(sender:getLocation().x,sender:getLocation().y)
        self.view:setTrans(true)
        self.state  =  RockerViewController.STATE.CANCEL 
        
    end
    
    local listener  =   cc.EventListenerTouchOneByOne:create()
    --listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchCancled,cc.Handler.EVENT_TOUCH_CANCELLED)
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    
 
    local eventDispatcher   =   self.view:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority( listener ,self.view)
end

--得到控制状态
function RockerViewController:getState()
    return self.state
end
function RockerViewController:stopRocker()
    self.forceStop = true
end
function RockerViewController:ctor()

end
return RockerViewController