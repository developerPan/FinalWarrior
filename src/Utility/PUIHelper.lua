local PUIHelper = {}
function PUIHelper:getVisibleSize()
    return cc.Director:getInstance():getVisibleSize()
end

function PUIHelper:getScreenCenter()
    local size = cc.Director:getInstance():getVisibleSize()
    return cc.p(size.width/2,size.height/2)
end

return PUIHelper