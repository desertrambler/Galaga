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

local my_background = nil

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
        h = 5,
        flag = "hold"
    }
	--initialize the laser timer
	canShoot = true
	canShootTimerMax = 0.2 
	canShootTimer = canShootTimerMax

    -- seed the random number generator so that calls to random are always random
    math.randomseed(os.time())

    --set the background image
    my_background = love.graphics.newImage('background.png')

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
	ship.x = ship.x - (90 * dt)
 	laser.x = laser.x - (90 * dt)
    
        if ship.x < 0 then
        ship.x = 0
        laser.x = 50
        end	

    end

    if love.keyboard.isDown("right") then
        ship.x = ship.x + (90 * dt)
        laser.x = laser.x + (90 * dt)
	
	if ship.x > (WINDOW_WIDTH - 100) then
		ship.x = WINDOW_WIDTH - 100
		laser.x = WINDOW_WIDTH - 45
	end
    end

    --shoot lasers with the spacebar         
         canShootTimer = canShootTimer - (1 * dt)
         if canShootTimer < 0 then
                 canShoot = true
         end

        if love.keyboard.isDown("space") and canShoot then
        	laser.y = laser.y - (300 * dt)
            laser.flag = "fire"
        	canShoot = false
		    canShootTimer = canShootTimerMax
	    end

        if laser.flag == "fire" then
            laser.y = laser.y - (300 * dt)
        end
end

function love.draw()

    --set color to white for prototyping, draw two rectangles to represent the ship and the lasers it fires
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(my_background)
    --love.graphics.rectangle("fill", ship.x, ship.y, ship.w, ship.h)
    love.graphics.draw(ship.sprite, ship.x, ship.y)

    --set laser color to red
    love.graphics.setColor(240/255, 0/255, 0/255)
    love.graphics.rectangle("fill", laser.x, laser.y, laser.w, laser.h)

    --set color to random for stars
    --love.graphics.setColor(math.random(0, 255)/255, math.random(0, 255)/255, math.random(0, 255)/255)
    --love.graphics.rectangle("fill", star.x, star.y, star.w, star.h)

end
