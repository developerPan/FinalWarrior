local UpgradeViwe   =   class("UpgradeView")
local PUtility  =   require("Utility/PUtility")
local PChild    =   require("Utility/PChild")
function UpgradeViwe.creare()
    local inst = GClass:extendView("layer_upgrade",UpgradeViwe)
    PChild:bindChildren(inst,inst)
    PChild:bindChildren(inst.Panel_1,inst)
    inst:bindListener()
    return inst
end

function UpgradeViwe:bindListener()
    PUtility:bindButton(self.btn_back,function()
        self:removeFromParent()
    end)
    
    PUtility:bindButton(self.btn_attack,function()
        self:buy(2)
    end)
    
    PUtility:bindButton(self.btn_defense,function()
        self:buy(3)
    end)
    
    PUtility:bindButton(self.btn_blood,function()
        self:buy(1)
    end)
    
    PUtility:bindButton(self.btn_crit,function()
        self:buy(4)
    end)
end

function UpgradeView:updateLabel()

end

function UpgradeView:updateStoneLabel(value)
    self.label_stone:setString(value)
end
function UpgradeView:buy(type)
    if(type == 1)then
        
    elseif(type == 2)then
    
    elseif(type == 3)then
    
    elseif(type == 4)then
    
    else
    
    end
end
return UpgradeViwe