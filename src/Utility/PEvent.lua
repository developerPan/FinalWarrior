local PEvent = {}

function PEvent:registerScriptHanlder(layer,enterHdl,exitHdl)
    local function onNodeEvent(eventType)
        if(eventType == "enter")then
            GLog:sysInfo(layer:getName() or "unknown" .."enter")
            enterHdl()
        elseif(eventType == "exit")then
            GLog:sysInfo(layer:getName() or "unknown" .."exit")
            exitHdl()
        end
    end
    layer:registerScriptHandler(onNodeEvent)
end

return PEvent