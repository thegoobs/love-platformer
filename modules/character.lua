local char = {
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

function char:key_handler()
	if love.keyboard.isDown("a") then
		char.dx = -4
	elseif love.keyboard.isDown("d") then
		char.dx = 4
	else
		char.dx = 0 --stop moving dawg, tight jumpies
	end

	if love.keyboard.isDown("w") and char.state ~= "JUMP" and char.state ~= "FALL" then
		char.dy = -10 -- negative is up
	end
end

function char:collision_handler()
	local before_col_dy = char.dy
	local x, y, c, l = char.x + char.dx, char.y + char.dy, nil, nil
	char.x, char.y, c, l = world:move(char, x, y)

	for i = 1, l do
		if c[i].normal.y > g then
			char.dy = c[i].normal.y or 0
			char.col = true
		else
			char.dy = 0
			char.col = false
		end

		if c[i].normal.x ~= 0 then
			char.dy = before_col_dy
			char.col = true
		end

		if c[i].other.dx ~= nil then
			if c[i].other.dx ~= 0 then
				char.x = char.x + c[i].other.dx
			end
		end
	end

	if l == 0 then char.col = false end
end

--function to set states based on the priority of states
function char:move(dt)
	-- Always effected by gravity
	char.dy = char.dy + g 

	char:key_handler()
	char:collision_handler()

end

function char:update(dt)

	char.state, char.dir = state:set(char)
	char:animate(dt)
	char:move(dt)
end

function char:draw()
	char.anim:draw(char.img, char.x, char.y)
end

return char