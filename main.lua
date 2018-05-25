--PLUGINS
anim8 		= require('plugins.anim8') --sprite animation
bump 		= require('plugins.bump') --platformer AABB collision

collisions = 0
--MODULES
scene		= require('modules.scene')
char 		= require('modules.character') --main character
state 		= require('modules.states') --state updater for objects
particle 	= require('modules.particle')
platform 	= require('modules.platform')
item 		= require('modules.item')
game 		= require('modules.game')
room		= require('modules.room')
trigger		= require('modules.trigger')
door 		= require('modules.door')

collision_filter = function(item, other)
	if other.col_id == "trigger" then
		return "cross" -- go through, no collision
	elseif other.col_id == "platform" then
		return "slide" -- default collision, needed for movement to work
	else
		return "slide"
	end
end



-- Model: love load happens once
function love.load()
	love.graphics.setBackgroundColor(48, 150, 220, 255)

	g = 0.5 -- gravity is positive because Y increases as it goes down

	-- bump world
	world = bump.newWorld(64)

	r1 = room:new()
	r2 = room:new()
	r3 = room:new()

	r1:set_platforms({
		platform:new(50, love.graphics.getHeight() - 275, 100, 25),
		platform:new(200, love.graphics.getHeight() - 350, 100, 25),
		platform:new(250, love.graphics.getHeight() - 400, 100, 25),
		platform:new(400, love.graphics.getHeight() - 400, 100, 200),
		platform:new(600, love.graphics.getHeight() - 400, 100, 25, 600, 700, 1),
		platform:new(0, love.graphics.getHeight() - 200, love.graphics.getWidth(), 200)
	})

	r1:set_doors({
		door:new(love.graphics.getWidth() - 10, 320, r1, r2),
		door:new(love.graphics.getWidth() - 10, 100, r1, r3)
	})

	r2:set_doors({
		door:new(-10, 320, r2, r1)
	})

	r2:set_platforms({
		platform:new(0, love.graphics.getHeight() - 200, love.graphics.getWidth(), 200)
	})

	r3:set_platforms({
		platform:new(0, love.graphics.getHeight() - 200, love.graphics.getWidth(), 200)
	})


	r3:set_doors({
		door:new(-10, 300, r3, r1)
	})

	game.curr_room = r1

	game:start()
end

-- Controller: updates on tick dt
function love.update(dt)
	scene:update(dt) -- each game object's update function is fired on tick
end

-- View: Where all rendering happens
function love.draw()
    scene:draw() --this is where all game objects are drawn
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat == false then
		if scancode == "r" then
			game:reset()
		end
	end

	if scancode == "w" and isrepeat == false then
		char:move_y()
	end
end