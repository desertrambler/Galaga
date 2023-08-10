--[[
    Author: Clayton Crenshaw
    Date Created: 07/03/2023
    Game Title: Galaga
    Game States:  
        -Play
    Game Rules: the computer paddle is the left one and the human controlled one is the right. Otherwise,
    this is my interpretation of the classic game from 1972. Enjoy!
]]
-- library that resizes the screen 
push = require 'push'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 380


-- initialize scores
player_score = 0

--set background color
love.graphics.setBackgroundColor( 0/255, 0/255, 0/255, 1 )

random = math.randomseed(os.time())

function love.load()
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    --initialize the ship struct
    ship = {
        x = WINDOW_WIDTH / 2,
        y = WINDOW_HEIGHT - 90,
        w = 60,
        h = 20,
        sprite = love.graphics.newImage("ship.png")
    }

    --initialize the laser struct
    laser = {
        x = ship.x + 41,
        y = ship.y + 20, 
        w = 5,
        h = 5
    }

end


function love.update(dt)
    -- escape can always be used to exit the game no matter what state we are in
    function love.keypressed(k)
        if k == 'escape' then
            love.event.push('quit') -- Quit the game.
        end
    end

    --controls the ship with the left and right arrows
    if love.keyboard.isDown("left") then
        ship.x = ship.x - (30 * dt)
        laser.x = laser.x - (30 * dt)
    end

    if love.keyboard.isDown("right") then
        ship.x = ship.x + (30 * dt)
        laser.x = laser.x + (30 * dt)
    end

    --shoot lasers with the spacebar
    function love.keypressed(k)
        if k == 'space' then
            laser.y = laser.y - (100 * dt)
        end
    end
end

function love.draw()

    --set color to white for prototyping, draw two rectangles to represent the ship and the lasers it fires
    love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle("fill", ship.x, ship.y, ship.w, ship.h)
    love.graphics.draw(ship.sprite, ship.x, ship.y)

    --set laser color to red
    love.graphics.setColor(240/255, 0/255, 0/255)
    love.graphics.rectangle("fill", laser.x, laser.y, laser.w, laser.h)

end

function shootLasers(dt)
    while laser.y < WINDOW_HEIGHT
        do
            laser.y = laser.y - (100 * dt)
        end
end