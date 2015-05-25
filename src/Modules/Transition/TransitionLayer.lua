local TransitionLayer   =   class("TransitionLayer")
local PChild            =   require("Utility/PChild")
function TransitionLayer.create()
    local inst = GClass:extendView("layer_transition",TransitionLayer)
    PChild:bindChildren(inst,inst)
    return inst
end

function TransitionLayer:setLevelLabel(level)
    self.label_num:setString(level)
end

return TransitionLayer