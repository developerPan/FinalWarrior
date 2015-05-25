local PChild    =   {}

function PChild:bindChildren(inst,target)
    target = target or inst
    if(inst == nil)then return end
    local childs = inst:getChildren()
    for i=1,#childs do
        local child = childs[i]
        print("@@@@@",child:getName())
        target[child:getName()]   =   child
    end
end

return PChild
