local platform = {}

--constructor
function platform:new(x, y, w, h, x1, x2, dx, y1, y2, dy)
	local obj = {x=x, y=y, w=w, h=h, x1=x1, x2=x2, dx=dx or 0, y1=y1, y2=y2, dy=dy or 0, col_id = "platform"}
	setmetatable(obj, self)
	self.__index = self
	return obj
end


	function platform:update(dt)
		if self.dx ~= 0 then
			self.x = self.x + self.dx

			if self.x < math.min(self.x1, self.x2) or self.x > math.max(self.x1, self.x2) then
				self.dx = self.dx * -1
			end
		end
		if self.dy ~= 0 then
			self.y = self.y + self.dy

			if self.y < math.min(self.y1, self.y2) or self.y > math.max(self.y1, self.y2) then
				self.dy = self.dy * -1
			end
		end

		world:move(self, self.x, self.y)
	end


	function platform:draw()
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end


return platform