local MainMenuLayer = class("MainMenuLayer")
local PChild        =   require("Utility/PChild")
MainMenuLayer.RESOURCE_JSON_FILE    =   "layer_menu"

function MainMenuLayer.create()
    local inst = GClass:extendView(MainMenuLayer.RESOURCE_JSON_FILE,MainMenuLayer)
    PChild:bindChildren(inst,inst)
    inst:init()
    return inst
end

function MainMenuLayer:init()

end

function MainMenuLayer:setSlider(percent)
    self.slider:setPercent(percent*100)
end

return MainMenuLayer