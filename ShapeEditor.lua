local class = require("30log")
local ShapeEditor = class("ShapeEditor")
function ShapeEditor:init()
    self.shapeTypes = {"circle","polygon","edge","chain"}
    self.shapeType = self.shapeTypes.circle

    self.isClicking = false
    self.clickStartX = 0
    self.clickStartY = 0
    self.clickEndX = 0
    self.clickEndY = 0
end

function ShapeEditor:mousepressed(x,y,button,isTouch,presses)
    if (shapeType == "circle") then

    elseif (shapeType == "polygon") then

    elseif (shapeType == "edge") then

    else -- chain shape

    end
end
function ShapeEditor:mousereleased(x,y,button,isTouch,presses)
end

return ShapeEditor