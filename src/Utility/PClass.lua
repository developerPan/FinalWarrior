local PClass = {}

--继承
function PClass:extend(target, class)
    local t = tolua.getpeer(target)
    print(target,class)
    if not t then 
        t ={}
        tolua.setpeer(target,t)
    end
    setmetatable(t,class)
    return target
end
--继承自scene
function PClass:extendScene(class)
    local scene = PClass:extend(cc.Scene:create(),class)
    
    return scene
end
--继承自view
function PClass:extendView(view_json,class)
    view_json = view_json..".json"
    --mac 平台下加载studio导出必须用NodeReader
    --win 平台下加载studio导出必须用GUIReader，否则崩溃
    --local view = ccs.GUIReader:getInstance():widgetFromJsonFile(view_json)
    local view = ccs.NodeReader:getInstance():createNode(view_json)
    local inst = PClass:extend(view,class)
    return inst
end

return PClass