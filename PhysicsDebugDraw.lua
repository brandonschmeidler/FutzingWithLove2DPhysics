local style = {}
style.fixture = function() return 0.6, 1.0, 0.6, 0.125 end
style.contactFixture = function() return 0.2, 0.2, 1.0, 0.25 end
style.contactPoint = function() return 1.0, 0.6, 0.5, 0.7 end
style.joint = function() return 1.0, 0.2, 0.4, 0.7 end

love.physics.drawShape = function(mode,body,shape,r,g,b,a)
    local shapeType = shape:getType()
    love.graphics.setColor(r or 1,g or 1,b or 1,a or 1)

    if (shapeType == "circle") then
        local cx,cy = body:getWorldPoints(shape:getPoint())
        local crad = shape:getRadius()
        love.graphics.circle(mode,cx,cy,crad)
    elseif (shapeType == 'polygon') then
        love.graphics.polygon(mode,body:getWorldPoints(shape:getPoints()))
    else
        love.graphics.line(body:getWorldPoints(shape:getPoints()))
    end

    love.graphics.setColor(1,1,1,1)
end

love.physics.drawBodies = function(world)
    local bodies = world:getBodies()
    for _, body in pairs(bodies) do
        local fixtures = body:getFixtures()
        for _, fixture in pairs(fixtures) do
            local shape = fixture:getShape()
            love.physics.drawShape('fill',body,shape,style.fixture())
        end
    end
end

love.physics.drawContacts = function(world)
    local contacts = world:getContacts()
    local text = ""
    for i,contact in ipairs(contacts) do
        local fixtures = {contact:getFixtures()}
        for _, fixture in pairs(fixtures) do
            local fd = fixture:getUserData()
            if (fd == nil) then fd = "NIL" end
            text = text .. ' ' .. fd .. '\n'
            local body = fixture:getBody()
            local shape = fixture:getShape()
            love.physics.drawShape('fill',body,shape,style.contactFixture())
        end

        love.graphics.setColor(style.contactPoint())
        local points = {contact:getPositions()}
        for i=1,#points,2 do
            local px = points[i]
            local py = points[i+1]
            love.graphics.circle('fill',px,py,4)
        end
        love.graphics.setColor(1,1,1,1)
    end
end

love.physics.drawJoints = function(world)
    love.graphics.setColor(style.joint())
    local joints = world:getJoints()
    for _,joint in pairs(joints) do
        local jointType = joint:getType()
        local ax,ay,bx,by = joint:getAnchors()
        love.graphics.line(ax,ay,bx,by)
        love.graphics.circle('fill',ax,ay,3)
        love.graphics.circle('fill',bx,by,3)
    end
    love.graphics.setColor(1,1,1,1)
end

love.physics.drawWorld = function(world)
    love.physics.drawBodies(world)
    love.physics.drawContacts(world)
    love.physics.drawJoints(world)
end