--PLUGINS
anim8 		= require('plugins.anim8') --sprite animation
bump 		= require('plugins.bump') --platformer AABB collision

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
	world:add(char, char.x, char.y, char.w, char.h)

	r1 = room:new()
	r1:set_platforms({
		platform:new(50, love.graphics.getHeight() - 275, 100, 25),
		platform:new(200, love.graphics.getHeight() - 350, 100, 25),
		platform:new(250, love.graphics.getHeight() - 400, 100, 25),
		platform:new(400, love.graphics.getHeight() - 400, 100, 200),
		platform:new(600, love.graphics.getHeight() - 400, 100, 25, 600, 700, 1),
		platform:new(0, love.graphics.getHeight() - 200, love.graphics.getWidth(), 200)
	})

	scene:add(char)
	scene:add(r1)
	scene:add(trigger:new(300, 300, 10, 10))
end

-- Controller: updates on tick dt
function love.update(dt)
	scene:update(dt)
end

-- View: Where all rendering happens
function love.draw()
	love.graphics.print(char.state, 100, 100)
    scene:draw()
end