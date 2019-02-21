function colorFixture()
    return 0.6,1.0,0.6,0.125
end

function colorContactFixture()
    return 0.2,0.2,1.0,0.25
end

function colorContactPoint()
    return 1.0,0.6,0.5,0.7
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
            text = text .. ' ' .. fixture:getUserData() .. '\n'
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

function drawPhysicsWorld(world)
    drawPhysicsBodies(world)
    drawPhysicsContacts(world)
end

function beginContact(a,b,col)
    local ax,ay = col:getPositions()
    local nx,ny = col:getNormal()
    print(a:getUserData() .. " collides with " .. b:getUserData() .. " at " .. ax .. "," .. ay .. " with normal " .. nx .. "," .. ny)
end

function endContact(a,b,col)
    print(a:getUserData() .. " ends collision with " .. b:getUserData())
end

function preSolve(a,b,col)
    
end

function postSolve(a,b,col,normalImpulse,tangentImpulse)
end


function love.load()
    local pixelMeterScale = 128
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

    objects.weirdball = {}
    objects.weirdball.body = love.physics.newBody(world,w/2,h/2,"dynamic")
    
    objects.weirdball.shape = {}
    objects.weirdball.shape[1] = love.physics.newCircleShape(-12,0,16)
    objects.weirdball.shape[2] = love.physics.newRectangleShape(12,0,32,32,15)
    objects.weirdball.shape[3] = love.physics.newCircleShape(0,-12,16)

    objects.weirdball.fixture = {}
    for i=1,#objects.weirdball.shape do
        objects.weirdball.fixture[i] = love.physics.newFixture(objects.weirdball.body,objects.weirdball.shape[i],10)
    end
    objects.weirdball.fixture[1]:setUserData("Left Circle")
    objects.weirdball.fixture[2]:setUserData("Right Rectangle")
    objects.weirdball.fixture[3]:setUserData("Bottom Circle")
    objects.weirdball.fixture[1]:setRestitution(0)
    objects.weirdball.fixture[2]:setRestitution(0)
    objects.weirdball.fixture[3]:setRestitution(0)

    objects.ledge = {}
    objects.ledge.body = love.physics.newBody(world,w/2,h * 0.75)
    objects.ledge.shape = love.physics.newEdgeShape(-100,-20,100,20)
    objects.ledge.fixture = love.physics.newFixture(objects.ledge.body, objects.ledge.shape, 0)
    objects.ledge.fixture:setUserData("Ledge")

end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    drawPhysicsWorld(world)
end