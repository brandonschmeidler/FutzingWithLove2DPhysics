local inpsect = require('inspect')

function colorFixture()
    return 0.6,1.0,0.6,0.125
end

function colorContactFixture()
    return 0.2,0.2,1.0,0.25
end

function colorContactPoint()
    return 1.0,0.6,0.5,0.7
end

function colorJoint()
    return 1.0,0.2,0.4,0.7
end

function drawPhysicsShape(mode,body,shape,r,g,b,a)
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

function drawPhysicsBodies(world)
    local bodies = world:getBodies()
    for _, body in pairs(bodies) do
        local fixtures = body:getFixtures()
        for _, fixture in pairs(fixtures) do
            local shape = fixture:getShape()
            drawPhysicsShape('fill',body,shape,colorFixture())
        end
    end
end

function drawPhysicsContacts(world)
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
            drawPhysicsShape('fill',body,shape,colorContactFixture())
        end

        love.graphics.setColor(colorContactPoint())
        local points = {contact:getPositions()}
        for i=1,#points,2 do
            local px = points[i]
            local py = points[i+1]
            love.graphics.circle('fill',px,py,4)
        end
        love.graphics.setColor(1,1,1,1)
    end
end

function drawPhysicsJoints(world)
    love.graphics.setColor(colorJoint())
    local joints = world:getJoints()
    for _,joint in pairs(joints) do
        local jointType = joint:getType()
        local ax,ay,bx,by = joint:getAnchors()
        -- if (jointType == "distance") then
        --     love.graphics.line(ax,ay,bx,by)
        -- elseif (jointType == "friction") then

        -- elseif (jointType == "gear") then

        -- elseif (jointType == "mouse") then

        -- elseif (jointType == "prismatic") then

        -- elseif (jointType == "pulley") then

        -- elseif (jointType == "revolute") then

        -- elseif (jointType == "rope") then

        -- else -- if jointType == "weld" then

        -- end
        love.graphics.line(ax,ay,bx,by)
        love.graphics.circle('fill',ax,ay,3)
        love.graphics.circle('fill',bx,by,3)
    end
    love.graphics.setColor(1,1,1,1)
end

function drawPhysicsWorld(world)
    drawPhysicsBodies(world)
    drawPhysicsContacts(world)
    drawPhysicsJoints(world)
end

function beginContact(a,b,col)
    --local ax,ay = col:getPositions()
    --local nx,ny = col:getNormal()

    local ad = a:getUserData()
    local bd = b:getUserData()
    if (ad == nil) then ad = "NIL" end
    if (bd == nil) then bd = "NIL" end
    print(ad .. " collides with " .. bd)
    if (col:getPositions() == nil and col:isEnabled()) then
        if (a:isSensor()) then print(ad .. " is a sensor") end
        if (b:isSensor()) then print(bd .. " is a sensor") end
    else
        print(inpsect({"Positions", {col:getPositions()},"Normal",col:getNormal()}))
    end
end

function endContact(a,b,col)
    print(a:getUserData() .. " ends collision with " .. b:getUserData())
end

function preSolve(a,b,col)
end

function postSolve(a,b,col,normalImpulse,tangentImpulse)
end


function love.load()
    local pixelMeterScale = 32
    world = love.physics.newWorld(0,9.81 * pixelMeterScale,true)
    world:setCallbacks(beginContact,endContact,preSolve,postSolve)

    local w,h = love.graphics.getDimensions()

    objects = {}

    objects.boundary = {}
    objects.boundary.body = love.physics.newBody(world,0,0)

    objects.boundary.shape = {}
    objects.boundary.shape[1] = love.physics.newEdgeShape(0,0,w,0)
    objects.boundary.shape[2] = love.physics.newEdgeShape(0,h,w,h)
    objects.boundary.shape[3] = love.physics.newEdgeShape(0,0,0,h)
    objects.boundary.shape[4] = love.physics.newEdgeShape(w,0,w,h)

    objects.boundary.fixture = {}
    for i=1,#objects.boundary.shape do
        objects.boundary.fixture[i] = love.physics.newFixture(objects.boundary.body,objects.boundary.shape[i])
        objects.boundary.fixture[i]:setUserData("Boundary Edge " .. i)
    end

    objects.ball = {}
    objects.ball.body = love.physics.newBody(world,w/2,0, "dynamic")
    objects.ball.shape = love.physics.newCircleShape(15)
    objects.ball.fixture = love.physics.newFixture(objects.ball.body,objects.ball.shape,5)
    objects.ball.fixture:setUserData("Ball")

    objects.sensorPad = {}
    objects.sensorPad.body = love.physics.newBody(world,w/2,h/2 + h/2/2)
    objects.sensorPad.shape = love.physics.newRectangleShape(w,h*0.45)
    objects.sensorPad.fixture = love.physics.newFixture(objects.sensorPad.body, objects.sensorPad.shape)
    objects.sensorPad.fixture:setUserData("High Friction Pad")
    objects.sensorPad.fixture:setSensor(true)

end

function love.update(dt)
    local timescale = 1
    world:update(dt * timescale)
end

function love.draw()
    drawPhysicsWorld(world)
end