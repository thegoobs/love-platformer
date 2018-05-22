local trigger = {}

function trigger:new(x, y, w, h)
	local t = {
		x = x,
		y = y,
		w = w,
		h = h,
		activated = false, --flips to tru when collided with by character

		col_id = "trigger"
	}

	setmetatable(t, self)
	self.__index = self

	return t
end

function trigger:activate()
	--placeholder whatup
end

function trigger:update(dt)
	self.activated = false
end

function trigger:draw()
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.setColor(255, 255, 255, 255)
end

return trigger