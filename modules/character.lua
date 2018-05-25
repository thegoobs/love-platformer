local char = {
	col_id = "character",

--kinematics
	x = 0,
	y = 100,
	w = 40,
	h = 40,

	dx = 4,
	dy = 2,

	max = {
		dx = 4,
		dy = 25,

		jump_dx = 2,
		jump_dy = 10,
		jumps = 2
	},

--animations
	img = love.graphics.newImage("character_base.png"),
	anim = nil,

--state machine
	state = "STANDBY",
	dir = "R",
	col = false,
	wall_jump = true, --true means ready to wall jump
	curr_jump = 0, --true means ready to double jump

--equipment
	equip = {
		head = nil,
		chest = nil,
		arm_r = nil,
		arm_l = nil,
		feet = nil
	}
}

char.grid = anim8.newGrid(char.w, char.h, char.img:getWidth(), char.img:getHeight())
char.standby = anim8.newAnimation(char.grid('1-4', 1), 0.2)
char.run = anim8.newAnimation(char.grid('1-4', 2), 0.125)
char.jump = anim8.newAnimation(char.grid(1, 3), 0.01)
char.wall_cling = anim8.newAnimation(char.grid(1, 4), 0.01)

char.anim = char.standby --default

function char:animate(dt)
	if char.state == "STANDBY" then
		char.anim = char.standby
	elseif char.state == "RUN" then
		char.anim = char.run
	elseif char.state == "JUMP" or char.state == "FALL" then
		char.anim = char.jump
	elseif char.state == "WALL_CLING" then
		char.anim = char.wall_cling
	end

	 if char.dir == "L" and char.anim.flippedH == false then
	 	char.anim:flipH()
	 elseif char.dir == "R" and char.anim.flippedH == true then
	 	char.anim:flipH()
	 end

	char.anim:update(dt)
end

function char:move_x(dx)
	char.dx = dx
end

function char:move_y()
	if char.state == "WALL_CLING" and char.wall_jump == true then
		char.wall_jump = false
		char.dy = -1 * char.max.jump_dy

		if char.dir == "R" then
			char.dx = -1 * char.max.jump_dx
		else
			char.dx = char.max.jump_dx
		end
	else
		if char.curr_jump < char.max.jumps then
			char.dy = -10
			char.curr_jump = char.curr_jump + 1
		end
	end
end


function char:key_handler(scancode, isrepeat)
	if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
		char.dx = -4
	elseif love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
		char.dx = 4
	else
		if math.abs(char.dx) ~= char.max.jump_dx then --if wall jump, keep going anyways
			char.dx = 0 --stop moving dawg, tight jumpies
		end

		if char.state == "RUN" and char.wall_jump == true then
			char.dx = 0
		end
	end
end

function char:collision_handler()
	local before_col_dy = char.dy
	local x, y, c, l = char.x + char.dx, char.y + char.dy, nil, nil
	char.x, char.y, c, l = world:move(char, x, y, collision_filter)

	for i = 1, l do
		if c[i].other.col_id == "platform" then -- Only do extra handling for platforms
			if c[i].normal.y > g then
				char.dy = c[i].normal.y or 0
				char.col = true
			elseif c[i].normal.y < 0 then
				char.dy = 0
				char.col = false
				char.wall_jump = true -- allow for new wall bounce
				char.curr_jump = 0 -- reset jumps
			end

			if c[i].normal.x ~= 0 then
				char.dy = before_col_dy
				char.col = true
			end

			if c[i].other.dx ~= 0 then
				char.x = char.x + c[i].other.dx
			end

		elseif c[i].other.col_id == "trigger" and game.just_moved == false then
			c[i].other:activate()
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

	if char.state == "WALL_CLING" then
		char.dy = 0
	end

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