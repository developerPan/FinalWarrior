local PathConstants ={}
PathConstants.PATH    =   {
    COCOS_PLIST  =   "animation/frame/%s0.plist",
    COCOS_TEXTURE   =   "animation/frame/%s0.png",
    COCOS_EJSON     =   "animation/frame/%s.ExportJson"
}

function PathConstants.getCocosEPath(fname)
    return string.format(PathConstants.PATH.COCOS_EJSON,fname)
end

function PathConstants.getCocosTexture(fname)
    return string.format(PathConstants.PATH.COCOS_TEXTURE,fname)
end

function PathConstants.getCocosPlist(fname)
    return string.format(PathConstants.PATH.COCOS_PLIST,fname)
end

return PathConstants