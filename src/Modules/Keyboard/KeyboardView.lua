local KeyboardView  =   class("Keyboard/KeyboardView")
function KeyboardView.create()
    local inst = GClass:extendView("layer_keyboard",KeyboardView)
    return inst
end


return KeyboardView