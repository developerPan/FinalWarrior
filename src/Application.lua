local Application = class("Application",function()
    return cc.Scene:create()
end)

function Application:ctor()
    print("@@ application ctor")
    local glview = cc.Director:getInstance():getOpenGLView()
    glview:setDesignResolutionSize(1136,640,cc.ResolutionPolicy.FIXED_WIDTH)
end

function Application:run()
    self:initGlobalVar()
    --create scene 
    local sceneName = "Main"
    --sceneName = "Welcome"
    --local scene = require("CG")
    GSceneMgr:changeScene(sceneName)
end

function Application:initGlobalVar()
    GClass = require("Utility/PClass")
    GLog    =   require("Utility/PLog")
    GPathConst  =   require("src/PathConstants")
    --MGR
    GSceneMgr = require("Manager/SceneManager").new()
    GResMgr   = require("Manager/ResourceManager").new()
    GEventMgr = require("Manager/EventManager").new()
    
end


return Application