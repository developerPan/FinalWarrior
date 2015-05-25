local KeyboardController    =   class("KeyboardController")
local KeyboardView          =   require("Modules/Keyboard/KeyboardView")
local PChild        =   require("Utility/PChild")
function KeyboardController:ctor()
    self.view   =   KeyboardView.create()
    PChild:bindChildren(self.view,self)
end

return KeyboardController