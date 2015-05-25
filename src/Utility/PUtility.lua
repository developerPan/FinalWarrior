local PUtility = {}

function PUtility:bindButton(btn,func)
    local baseScale = btn:getScale()
    local function touchEvent(sender,eventType)
            if(eventType == ccui.TouchEventType.began)then
                btn:setScale(0.9*baseScale)
            elseif(eventType == ccui.TouchEventType.canceled)then
            btn:setScale(baseScale)
            elseif(eventType == ccui.TouchEventType.moved)then
            
            elseif(eventType-1 == ccui.TouchEventType.ended-1)then
                func()
            btn:setScale(baseScale)
            else
                
            end
    end
    btn:addTouchEventListener(touchEvent)
end
function PUtility:bindAnimButtion(btn,func)
    local finished = false
    local function touchEvent(sender,eventType)
        if(eventType == ccui.TouchEventType.began)then
        
        elseif(eventType == ccui.TouchEventType.canceled)then

        elseif(eventType == ccui.TouchEventType.moved)then

        elseif(eventType-1 == ccui.TouchEventType.ended-1)then
            func()
        else

        end
    end
    btn:addTouchEventListener(touchEvent)
end
function PUtility:bindTouchedButton(btn,func,sec)
    sec = sec or 0.2
    local schedule  = cc.Director:getInstance():getScheduler()
    local entryId 
    local function Update()
        print("~~")
    end
    local function StartUpdate()
        entryId =  schedule:scheduleScriptFunc(func,sec,false)
    end
    
    local function StopUpdate(scheduleEntry)
        schedule:unscheduleScriptEntry(entryId)
    end
    local function touchEvent(sender,eventType)
        if(eventType == ccui.TouchEventType.began)then
            func()  --先调用一次
            StartUpdate()
        elseif(eventType == ccui.TouchEventType.canceled)then
            StopUpdate()
        elseif(eventType == ccui.TouchEventType.moved)then

        elseif(eventType == ccui.TouchEventType.ended)then
            StopUpdate()
        else

        end
    end
    btn:addTouchEventListener(touchEvent)
end
return PUtility