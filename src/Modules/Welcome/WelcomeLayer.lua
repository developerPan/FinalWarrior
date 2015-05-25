local WelcomeLayer = class("Modules/Welcome/WelcomeLayer")
local PChild    =   require("Utility/PChild")
function WelcomeLayer.create()
    local inst = GClass:extendView("layer_welcome",WelcomeLayer)
    inst:init()
    return inst
end

function WelcomeLayer:init()

end

return WelcomeLayer