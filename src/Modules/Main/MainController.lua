local MainController    =   class("MainController")
local PChild    =   require("Utility/PChild")
local PUtility  =   require("Utility/PUtility")
local PAnimation    =   require("Utility/PAnimation")
local RockerViewController  =   require("Rocker/RockerViewController")
local Hero      =   require("Modules/Childs/Hero")
local Role      =   require("Modules/Childs/Role")
local Monster   =   require("Modules/Childs/Monster")
local PEvent    =   require("Utility/PEvent")
local PUIHelper =   require("Utility/PUIHelper")
local KeyboardController    =   require("Modules/Keyboard/KeyboardController")
local TransitionController  =   require("Modules/Transition/TransitionController")
function MainController.create(view,menuView)
    
    local inst  =   MainController.new()
    inst.view = view
    inst.menuView = menuView
    PChild:bindChildren(view,inst)
    inst:init()
    return inst
end
function MainController:init()
    self.LANDHEIGHT =   self.view:getLandHeight()  
    --初始化摇杆 
    self.rockerVC = self:initRocker()
    self.hero = self:initHero()
    self.monsters = self:initMonsters()
    self.kbdVC  =   self:initKeyboard()
    self:bindAllListener()
    self:startUpdate()
end

function MainController:bindAllListener()
    local function onEnter()
    
    end
    
    local function onExit()
        self.view:unscheduleUpdate()
    end
    PEvent:registerScriptHanlder(self.view,onEnter,onExit)
end
 

--处理走路相关
function MainController:handlerWalk()
    --处理角色不能超过左边界
    local landSize = self.view.land:getContentSize()
    if((self.hero:getPositionX() < 50 and self.rockerVC.state == RockerViewController.STATE.LEFT) or
        (self.hero:getPositionX() >landSize.width - 150 and self.rockerVC.state == RockerViewController.STATE.RIGHT) )then
        GLog:testInfo("超出屏幕边界")
        return
    end

    if(self.rockerVC.state == RockerViewController.STATE.LEFT or self.rockerVC.state == RockerViewController.STATE.RIGHT)then
        if(self.hero:getState() ~=Role.STATE.ATTACK)then 
            local heroPosX = self.hero:getPositionX()
            self.view:moveMap(heroPosX,self.rockerVC.state)
            self.hero:run(self.rockerVC.state) 
        end
    elseif(self.rockerVC.state == RockerViewController.STATE.CANCEL)then
        if(self.hero:getState() ==Role.STATE.RUN)then
            self.hero:stopAction()
        end
    else

    end
end

function MainController:gameOver()
    print("@@game Over")
end

function MainController:handleAttack()
    local percent = self.hero:getHpPercent() 
    if(percent ~= self.menuView.slider:getPercent())then --减少刷新次数，血量有变化才刷新 
        self.menuView:setSlider(percent)
        if percent <= 0 then
            self:gameOver()
        end
    end
end
function MainController:startUpdate()
    --帧刷新update
    local function Update() 
        self:handlerWalk()
        self:handleAttack()
    end
    self.view:scheduleUpdateWithPriorityLua(Update,0)
    
end

--檢測英雄此時能攻擊的對象
function MainController:checkHeroAttTargets()
    local rectX = self.hero.bodyWidth + self.hero.attRectX
    local targets = {}
    for key, monster in ipairs(self.monsters) do
       if monster then
           local distance = math.abs(self.hero:getPositionX() - monster:getPositionX())
    	   if(distance <= rectX)and monster.hp > 0 then --可以攻击
                table.insert(targets,monster)
    	   end
	   end
	end
	return targets
end
--初始化键盘
function MainController:initKeyboard()
    local kvc = KeyboardController.new()
    local keyboardView = kvc.view
    self.view:addChild(keyboardView)
    keyboardView:setPosition(cc.p(736,30))
    
    --监听键盘事件
    PUtility:bindTouchedButton(kvc.btn_attack,function()
        if(self.hero:getState() ~= Role.STATE.ATTACK)then
            self.rockerVC:stopRocker() 
            self.hero:attack(self:checkHeroAttTargets()) 
            end
    end,0.2)
    
    PUtility:bindButton(kvc.btn_jump,function()
        self.hero:jump()
    end)

    PUtility:bindButton(kvc.btn_skill,function()
      --  self:clearMonsters()
     --   self:playTrasition()
        local tranVC = TransitionController.new()
        tranVC:playTransition(self.superlevel,self.view,1)
     
    end)
    return kvc
end
--初始化摇杆
function MainController:initRocker()
    local rockerVC  =   RockerViewController.create()
    
    local rockerView    =   rockerVC:getView()
    rockerView:setPosition(cc.p(0,0))
    self.view:addChild(rockerView)
    
    rockerVC:startRocker()
    return rockerVC
end

--添加主角
function MainController:initHero()
    local hero =  Hero.new("jiaoyuenvshen") 
    hero:setPosition(self:getFixedPosition(0,0))
    hero:setHp(200)
    hero:setMaxHp(200)
    self.menuView:setSlider(hero:getHpPercent())
--    hero:fixPos(30,0)
--    hero:bindRect(Role.RECTKEY.ATTACK,200,145,0)
--    hero:bindRect(Role.RECTKEY.HIT,100,145,-10)
    self.view.land:addChild(hero,100)
    return hero
 
end

--添加怪物们
function MainController:initMonsters()
    local monsters = {}
    local monster = Monster.new("xunjiechihou")
    monster.mainController = self
    monster:startUpdate()
    monster:setPosition(self:getFixedPosition(400,0))
--    monster:fixPos(30,0)
    self.view.land:addChild(monster)
    --monster.bloodSlider:setPosition(cc.p(monster:getContentSize().width/2,monster:getContentSize().height/2))

    monster:setLocalZOrder(1)
    table.insert(monsters,monster)
    
    return monsters
end
function MainController:getFixedPosition(x,y)
    return cc.p(x+170,y+self.LANDHEIGHT)
    
end
return MainController