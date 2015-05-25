
local WelcomeScene = class("WelcomeScene")
local WelcomeLayer  =   require("Modules/Welcome/WelcomeLayer")
local PEvent        =   require("Utility/PEvent")
function WelcomeScene.create()
    local inst  =   GClass:extendScene(WelcomeScene)
 
    inst.view = WelcomeLayer.create()
    inst.vc = require("Modules/Welcome/WelcomeController").create(inst.view)
    
    inst:init()   
    inst:addChild(inst.view)
    return inst
end

function WelcomeScene:init()
    --PEvent:registerScriptHanlder(self.view,handler(self.vc,self.vc.onEnter),
    --    handler(self.vc,self.vc.onExit))
end
function WelcomeScene:getVC()
    return self.vc
end

return WelcomeScene