local WelcomeController = class("WelcomeController")
local PChild    =   require("Utility/PChild")
local PUtility  =   require("Utility/PUtility")
function WelcomeController.create(view)
    local inst = WelcomeController.new()
    PChild:bindChildren(view,inst)
    inst.view = view
    inst:bindAllListener()
    return inst
end
function WelcomeController:bindAllListener()
    --[[PUtility:bindButton(self.btn_start,function()
        GSceneMgr:changeScene("Main")
    end)]]
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