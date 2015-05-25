local RockerLayer   =   class("RockerLayer",function()
    return cc.LayerColor:create(cc.c4b(255,9,9,255))
end)
function RockerLayer:ctor(fname_bg,fname_dot)
    fname_bg    =   fname_bg    or  "icon/rocker_bg.png"
    fname_dot   =   fname_dot   or  "icon/rocker_dot.png"
    
    self:setContentSize(cc.size(1,1))
    self.bg    =   ccui.ImageView:create(fname_bg)
    self.dot   =   ccui.ImageView:create(fname_dot)
    self.bg:setScale(1.7)
    self.dot:setScale(1.7)
    self:addChild(self.bg)

    self:addChild(self.dot)
    self.bg:setPosition(cc.p(self.bg:getContentSize().width/2+80,self.bg:getContentSize().height/2+50))
    self.dot:setPosition(cc.p(self.bg:getContentSize().width/2+80,self.bg:getContentSize().height/2+50))
    self.dot:setTouchEnabled(false)
    self.bg:setTouchEnabled(false)
    return layer
end

function RockerLayer:setTrans(isTranslucent)
    for i=1,#self:getChildren() do
        --打开透明度
        self:getChildren()[i]:setCascadeOpacityEnabled ( true )
    end
    self:setCascadeOpacityEnabled ( true )
    if(isTranslucent)then
        for i=1,#self:getChildren() do
            self:getChildren()[i]:setOpacity(120)
        end
    else
        for i=1,#self:getChildren() do
            self:getChildren()[i]:setOpacity(255)
        end
    end
end


return RockerLayer