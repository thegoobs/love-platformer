--PLUGINS
anim8 = require('plugins.anim8') --sprite animation
bump = require('plugins.bump') --platformer AABB collision

--MODULES
char = require('modules.character') --main character
state = require('modules.states') --state updater for objects

--Model
function love.load()
	love.graphics.setBackgroundColor(48, 150, 220, 255)

	g = 0.5 --positive because Y increases as it goes down

	test = 0
	--bump world
	world = bump.newWorld(64)
	world:add(char, char.x, char.y, 40, 40)
	world:add("floor", 0, love.graphics.getHeight() - 200, love.graphics.getWidth(), 200)
	world:add("platform", 50, love.graphics.getHeight() - 275, 100, 25)
end

--Controller
function love.update(dt)
	char:update(dt)
end

--View
function love.draw()
    love.graphics.print(char.state, 400, 300)
    love.graphics.print(tostring(char.col), 400, 320)
    love.graphics.print(test, 400, 330)

    char.anim:draw(char.img, char.x, char.y)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 200, love.graphics.getWidth(), 200)
    love.graphics.rectangle("fill", 50, love.graphics.getHeight() - 275, 100, 25)
end