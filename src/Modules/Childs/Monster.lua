local Role  =   require("Modules/Childs/Role")
local UIBar =   require("Utility/UIBar")
local Monster = class("Monster",function(...)
    return Role.new(...)
end)

function Monster:ctor(...)
    self:updateFace("LEFT")
    self.bloodSlider    =   self:initBloodSlider() 
    self.blood = 100
    self.attRectX = 60 --攻击距离
    self.attRate = 0.6  --以秒为单位
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
    local slider =  UIBar.create()
    slider:setAnchorPoint(0.5,0.5)
    slider:setPositionX(50)
    slider:setPositionY(140)
    self:addChild(slider)
    return slider
end 

--小怪的AI 
function Monster:updeteState(dt)
    self.time = dt + self.time
	local heroPosX = self.mainController.hero:getPositionX()
    local distance = math.abs(heroPosX - self:getPositionX()) 
    if(distance <= self.attRectX) then --达到攻击距离
        self:checkAttack()
    else    --没达到
        self:moveToPlayer(heroPosX)
    end
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
    	self:attack() 
    end
    	
end

return Monster