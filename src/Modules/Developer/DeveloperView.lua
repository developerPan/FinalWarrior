local DeveloperView =   class("DeveloperView")
local PUtility  =   require("Utility/PUtility")
local PChild    =   require("Utility/PChild")
function DeveloperView.creare()
    local inst = GClass:extendView("layer_make",DeveloperView)
    PChild:bindChildren(inst,inst)
    inst:bindListener()
    return inst
end

function DeveloperView:bindListener()
    PUtility:bindButton(self.btn_back,function()
        self:removeFromParent()
    end)
end
return DeveloperView