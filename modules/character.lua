local char = {}

function char:new()
	local c = {
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

	c.grid = anim8.newGrid(c.w, c.h, c.img:getWidth(), c.img:getHeight())
	c.standby = anim8.newAnimation(c.grid('1-4', 1), 0.2)
	c.run = anim8.newAnimation(c.grid('1-4', 2), 0.125)
	c.jump = anim8.newAnimation(c.grid(1, 3), 0.01)
	c.wall_cling = anim8.newAnimation(c.grid(1, 4), 0.01)

	c.anim = c.standby --default


	setmetatable(c, self)
	self.__index = self
	return c
end

function char:animate(dt)
	if self.state == "STANDBY" then
		self.anim = self.standby
	elseif self.state == "RUN" then
		self.anim = self.run
	elseif self.state == "JUMP" or self.state == "FALL" then
		self.anim = self.jump
	elseif self.state == "WALL_CLING" then
		self.anim = self.wall_cling
	end

	 if self.dir == "L" and self.anim.flippedH == false then
	 	self.anim:flipH()
	 elseif self.dir == "R" and self.anim.flippedH == true then
	 	self.anim:flipH()
	 end

	self.anim:update(dt)
end

function char:move_x(dx)
	self.dx = dx
end

function char:move_y()
	if self.state == "WALL_CLING" and self.wall_jump == true then
		self.wall_jump = false
		self.dy = -1 * self.max.jump_dy

		if self.dir == "R" then
			self.dx = -1 * self.max.jump_dx
		else
			self.dx = self.max.jump_dx
		end
	else
		if self.curr_jump < self.max.jumps then
			self.dy = -10
			self.curr_jump = self.curr_jump + 1
		end
	end
end


function char:key_handler(scancode, isrepeat)
	if love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
		self.dx = -4
	elseif love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
		self.dx = 4
	else
		if math.abs(self.dx) ~= self.max.jump_dx then --if wall jump, keep going anyways
			self.dx = 0 --stop moving dawg, tight jumpies
		end

		if self.state == "RUN" and self.wall_jump == true then
			self.dx = 0
		end
	end
end

function char:collision_handler()
	local before_col_dy = self.dy
	local x, y, c, l = self.x + self.dx, self.y + self.dy, nil, nil
	self.x, self.y, c, l = world:move(self, x, y, collision_filter)

	for i = 1, l do
		if c[i].other.col_id == "platform" then -- Only do extra handling for platforms
			if c[i].normal.y > g then
				self.dy = c[i].normal.y or 0
				self.col = true
			elseif c[i].normal.y < 0 then
				self.dy = 0
				self.col = false
				self.wall_jump = true -- allow for new wall bounce
				self.curr_jump = 0 -- reset jumps
			end

			if c[i].normal.x ~= 0 then
				self.dy = before_col_dy
				self.col = true
			end

			if c[i].other.dx ~= 0 then
				self.x = self.x + c[i].other.dx
			end

		elseif c[i].other.col_id == "trigger" and game.just_moved == false then
			c[i].other:activate()
		end
	end

	if l == 0 then self.col = false end
end

--function to set states based on the priority of states
function char:move(dt)
	-- Always effected by gravity
	self.dy = self.dy + g 

	self:key_handler()
	self:collision_handler()

	if self.state == "WALL_CLING" then
		self.dy = 0
	end
end

function char:update(dt)

	self.state, self.dir = state:set(self)
	self:animate(dt)
	self:move(dt)
end

function char:draw()
	self.anim:draw(self.img, self.x, self.y)
end

return char