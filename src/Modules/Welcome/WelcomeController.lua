local WelcomeController = class("WelcomeController")
local PChild    =   require("Utility/PChild")
local PUtility  =   require("Utility/PUtility")
local UpgradeView   =   require("Modules/Upgrade/UpgradeView")
local DeveloperView =   require("Modules/Developer/DeveloperView")
function WelcomeController.create(view)
    local inst = WelcomeController.new()
    PChild:bindChildren(view,inst)
    inst.view = view
    inst:bindAllListener()
    return inst
end
function WelcomeController:bindAllListener()
    PUtility:bindButton(self.btn_start,function()
        GSceneMgr:changeScene("Main")
    end)
    
    PUtility:bindButton(self.btn_upgrade,function()
        local view = UpgradeView.creare()
        self.view:addChild(view)
    end)
    
    PUtility:bindButton(self.btn_make,function()
        local view = DeveloperView.creare()
        self.view:addChild(view)
    end)
end

function WelcomeController:onExit()
    GLog:testInfo("exit")
end

function WelcomeController:onEnter()
    GLog:testInfo("enter")

end

--开始游戏
function WelcomeController:start()

end
return WelcomeController