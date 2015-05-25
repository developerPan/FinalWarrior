local MainScene = class("MainScene")

function MainScene.create()
    local inst = GClass:extendScene(MainScene)
    inst:init()
    
    return inst
end

function MainScene:init()
    --背景层
    local layer = require("Modules/Main/MainView").create()
    layer:setPosition(cc.p(0,0))
    self:addChild(layer)
    --菜单层
    local menuLayer =   require("Modules/MainMenu/MainMenuLayer").create()
    self:addChild(menuLayer)
    --controller
    self.vc         =   require("Modules/Main/MainController").create(layer,menuLayer)
end
return MainScene