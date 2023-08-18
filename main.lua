--[[
    Author: Clayton Crenshaw
    Date Created: 08/09/2023
    Game Title: Galaga
    Game States:  
        -Opening Menu
        -Play
    Game Rules: Control the ship with the joystick and press the button to fire. Enjoy this classic from 1981
]]
-- library that resizes the screen 
push = require 'push'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 1400
VIRTUAL_HEIGHT = 1000

-- initialize score
player_score = 0

--set background color
love.graphics.setBackgroundColor( 0/255, 0/255, 0/255, 1 )

local my_background = nil

local logo = nil

local opening_menu_timer = 0

local soundData = love.sound.newSoundData('sounds/opening_theme.mp3')

--set the font
local font = love.graphics.newFont('assets/font.ttf', 24)

function love.load()
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        resizable = true,
        vsync = true
    })

    love.graphics.setDefaultFilter( 'nearest', 'nearest' )
    --initialize the ship struct
    ship = {
        x = WINDOW_WIDTH / 2,
        y = WINDOW_HEIGHT - 10,
        w = 30,
        h = 10,
        sprite = love.graphics.newImage("assets/ship.png")
    }

    --initialize the laser struct
    laser = {
        x = ship.x + 41,
        y = ship.y + 20, 
        w = 5,
        h = 5,
        flag = "hold"
    }

    --initialize the game state
    state = 'opening_menu'

    -- seed the random number generator so that calls to random are always random
    math.randomseed(os.time())

    --set the background image
    my_background = love.graphics.newImage('assets/background.png')

    --set the logo on the menu state
    logo = love.graphics.newImage('assets/logo.png')

    sounds = {
        ['opening'] = love.audio.newSource('sounds/opening_theme.mp3', 'static'),
        ['laser'] = love.audio.newSource('sounds/laser.mp3', 'static'),
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
	ship.x = ship.x - (90 * dt)
    	if laser.flag == "hold" then
            laser.x = laser.x - (90 * dt)
        end
    
        if ship.x < 0 then
            ship.x = 0
            laser.x = 50
        end	

    end

    if love.keyboard.isDown("right") then
        ship.x = ship.x + (90 * dt)
		if laser.flag == "hold" then
            laser.x = laser.x + (90 * dt)
        end

	
        if ship.x > (WINDOW_WIDTH - 100) then
            ship.x = WINDOW_WIDTH - 100
            laser.x = WINDOW_WIDTH - 45
	    end
    end

        if love.keyboard.isDown("space") then
            laser.flag = "fire"
            sounds['laser']:play()
	    end

        if laser.flag == "fire" then
            laser.y = laser.y - (300 * dt)

        end

        opening_menu_timer = opening_menu_timer + (1 * dt)
                
        if opening_menu_timer > 6 then
            state = 'play'
        end

        if state == 'opening_menu' then
            sounds['opening']:play()
        end
end

function love.draw()
    if state == 'opening_menu' then
        love.graphics.draw(logo, WINDOW_WIDTH / 2.5, WINDOW_HEIGHT / 3)
    end

    if state == 'play' then
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

        love.graphics.setFont(font)

        -- Draws "Hello world!" at position x: 100, y: 200 with the custom font applied.
        love.graphics.print(player_score, 20, WINDOW_HEIGHT / 12)

    end
end
