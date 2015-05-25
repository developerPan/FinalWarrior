local UIBar     =   class("UIBar")
function UIBar.create()
    local inst = GClass:extendView("layer_uibar",UIBar)
    inst:init()
    return inst
end

function UIBar:init()

end
return UIBar