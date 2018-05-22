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

	world:add(t, t.x, t.y, 10, 10)

	return t
end

function trigger:activate()
	love.graphics.setColor(0, 255, 0, 255)
end

function trigger:update(dt)
end

function trigger:draw()
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	love.graphics.setColor(255, 255, 255, 255)
end

return trigger