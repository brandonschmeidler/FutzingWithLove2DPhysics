local inspect = require('inspect')
require('PhysicsDebugDraw')


function string_to_function(text)
    local func = assert(loadstring(text))
    if (func) then return func end

    return nil
end

function beginContact(a,b,col)
    local ad = a:getUserData()
    local bd = b:getUserData()
    if (ad == nil) then ad = "NIL" end
    if (bd == nil) then bd = "NIL" end
    print(ad .. " collides with " .. bd)
    if (col:getPositions() == nil and col:isEnabled()) then
        if (a:isSensor()) then print(ad .. " is a sensor") end
        if (b:isSensor()) then print(bd .. " is a sensor") end
    else
        print(inspect({"Positions", {col:getPositions()},"Normal",col:getNormal()}))
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
    local func = string_to_function('local a,b,col = ... print(a:getUserData() .. " BOOBIES with " .. b:getUserData())')
    if (func) then beginContact = func end

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
    --drawPhysicsWorld(world)
    love.physics.drawWorld(world)
end