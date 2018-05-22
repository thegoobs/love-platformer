--PLUGINS
anim8 		= require('plugins.anim8') --sprite animation
bump 		= require('plugins.bump') --platformer AABB collision

--MODULES
scene		= require('modules.scene')
char 		= require('modules.character') --main character
state 		= require('modules.states') --state updater for objects
floor		= require('modules.floor')
particle 	= require('modules.particle')
platform 	= require('modules.platform')
item 		= require('modules.item')
game 		= require('modules.game')
room		= require('modules.room')

--Model
function love.load()
	love.graphics.setBackgroundColor(48, 150, 220, 255)

	g = 0.5 -- gravity is positive because Y increases as it goes down

	-- bump world
	world = bump.newWorld(64)
	world:add(char, char.x, char.y, 40, 40)
	world:add(floor, 0, love.graphics.getHeight() - 200, love.graphics.getWidth(), 200)

	r1 = room:new()
	r1:set_platforms({
		platform:new(50, love.graphics.getHeight() - 275, 100, 25),
		platform:new(200, love.graphics.getHeight() - 350, 100, 25),
		platform:new(250, love.graphics.getHeight() - 400, 100, 25),
		platform:new(400, love.graphics.getHeight() - 400, 100, 200),
		platform:new(600, love.graphics.getHeight() - 400, 100, 25, 600, 700, 1)
	})

	scene:add(char)
	scene:add(r1)
end

-- Controller
function love.update(dt)
	scene:update(dt)
end

-- View
function love.draw()
	love.graphics.print(char.state, 100, 100)
	if char.col == true then
		love.graphics.print("yes", 100, 200)
	end
    floor:draw()
    scene:draw()
end