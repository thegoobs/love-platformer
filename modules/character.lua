local char = {}
char = {
		id = "character",

--kinematics
		x = 0,
		y = 100,
		w = 16,
		h = 16,

		dx = 4,
		dy = 2,

--animations
		img = love.graphics.newImage("character_base.png"),
		anim = nil,

--state machine
		state = "STANDBY",
		dir = "R",
		col = false,

--equipment
		equip = {
			head = nil,
			chest = nil,
			arm_r = nil,
			arm_l = nil,
			feet = nil
		}
	}

	char.grid = anim8.newGrid(40, 40, char.img:getWidth(), char.img:getHeight())
	char.standby = anim8.newAnimation(char.grid('1-4', 1), 0.2)
	char.run = anim8.newAnimation(char.grid('1-4', 2), 0.125)
	char.jump = anim8.newAnimation(char.grid(1, 3), 0.01)

	char.anim = char.standby --default

function char:animate(dt)
	if char.state == "STANDBY" then
		char.anim = char.standby
	elseif char.state == "RUN" then
		char.anim = char.run
	elseif char.state == "JUMP" or char.state == "FALL" then
		char.anim = char.jump
	end

	 if char.dir == "L" and char.anim.flippedH == false then
	 	char.anim:flipH()
	 elseif char.dir == "R" and char.anim.flippedH == true then
	 	char.anim:flipH()
	 end

	char.anim:update(dt)
end

--function to set states based on the priority of states
function char:move(dt)
	char.dy = char.dy + g

	local x, y, c, l = char.x + char.dx, char.y + char.dy, nil, nil
	char.x, char.y, c, l = world:move(char, x, y)

	for i = 1, l do
		--if collision is bottom of character
		if c[i].normal.y == -1 then
			char.dy = 0
		end
	end

	if love.keyboard.isDown("a") then
		char.dx = -4
	elseif love.keyboard.isDown("d") then
		char.dx = 4
	else
		char.dx = 0
	end

	if love.keyboard.isDown("w") and char.state ~= "JUMP" and char.state ~= "FALL" then
		char.y = char.y - 10
		char.dy = -10
		g = 0.5
	end
end

function char:update(dt)
	char:move(dt)
	char.state, char.dir = state:set(char)
	char:animate(dt)
end

return char