local EventManager  =   class("EventManager")

function EventManager:ctor()
    self._listeners =   {}
    self.listenerHndleIndex_    =   0
end

function EventManager:dispatchEvent(eventName, ...)
    eventName   =   string.upper(eventName)
    if self._listeners[eventName]    ==  nil then
        GLog:sysInfo("DISPATCH EVENT "..eventName .."BUT NO LISTENER!")
    else
        GLog:sysInfo("DISPATCH EVENT "..eventName)
    end
    
    self.listenerHndleIndex_ = self.listenerHndleIndex_ +1
    local handle = string.format("HANDLE_%d",self.listenerHndleIndex_)
    self._listeners[eventName][handle]  =   listener
    return handle
end

return EventManager