local Role  =   require("Modules/Childs/Role")
local UIBar =   require("Utility/UIBar")
local Monster = class("Monster",function(...)
    return Role.new(...)
end)

function Monster:ctor(...)
    self:updateFace("LEFT")
    self.bloodSlider    =   self:initBloodSlider()
    self.blood = 100
end

function Monster:initBloodSlider()
    local slider =  UIBar.create()
    slider:setAnchorPoint(0.5,0.5)
    self:addChild(slider)
    return slider
end

return Monster