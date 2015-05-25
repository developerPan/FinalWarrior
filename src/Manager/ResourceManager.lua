local ResourceManager   =   class("ResourceManager")
local poolCurr  =   {}
--加载cocos动画
function ResourceManager:loadArmature(fname,resArr)
    resArr  =   resArr  or poolCurr.armatures
   --[[ GLog:testInfo("~~~~~",fname)
    for index,file in pairs( resArr ) do
        if file == fname then
        	return resArr
        end
    end]]
    GLog:sysInfo("加载动画资源 "..GPathConst.getCocosTexture(fname)..GPathConst.getCocosPlist(fname)..GPathConst.getCocosEPath(fname))
    self.armatureMgr:addArmatureFileInfo(GPathConst.getCocosEPath(fname) )
    --table.insert( resArr , fname)
    return resArr
end

function ResourceManager:ctor()

    self.armatureMgr    =   ccs.ArmatureDataManager:getInstance()
    self.animPool   =   {}
end
return ResourceManager