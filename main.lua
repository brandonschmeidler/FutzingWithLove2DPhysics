local nuklear = require("nuklear")

local ui

function UIMenuBar()
    local width = {
        file = 30,
        help = 60,
        menuItems = 128
    }

    ui:menubarBegin()

    ui:layoutRowBegin("static",30,5)
    ui:layoutRowPush(width.file)
        
    if (ui:menuBegin("File",nil,width.menuItems,30)) then
        
        ui:layoutRow("dynamic",30,1)
        if (ui:menuItem("Exit")) then
            love.event.quit()
        end

        ui:menuEnd()
    end

    ui:layoutRowPush(width.help)
    if (ui:menuBegin("Help",nil,width.menuItems,30)) then
        
        ui:layoutRow("dynamic",30,1)
        if (ui:menuItem("About")) then
            print("Love2D Physics Editor v0.0.0")
        end

        ui:menuEnd()
    end

    ui:menubarEnd()
end

function love.load()
	ui = nuklear.newUI()
end

function love.update(dt)
	ui:frameBegin()
    
    local w,h = love.graphics.getDimensions()
    if (ui:windowBegin("MenuBar",0,0,w,h,"background")) then 
        UIMenuBar()
    end
    ui:windowEnd()

	ui:frameEnd()
end

function love.draw()
	ui:draw()
end

function love.keypressed(key, scancode, isrepeat)
	ui:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	ui:keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
	ui:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	ui:mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	ui:mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
	ui:textinput(text)
end

function love.wheelmoved(x, y)
	ui:wheelmoved(x, y)
end