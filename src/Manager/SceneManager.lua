local SceneManager = class("Manager/SceneManager")

function SceneManager:changeScene(sceneName)
    GLog:sysInfo("change Scene "..sceneName)
    local scene = require(string.format("Modules/%s/%sScene",sceneName,sceneName)).create()
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

function SceneManager:ctor()

end
return SceneManager