local platform = {}

--constructor
function platform:new(x, y, w, h, x1, x2, dx, y1, y2, dy)
	local obj = {x=x, y=y, w=w, h=h, x1=x1, x2=x2, dx=dx, y1=y1, y2=y2, dy=dy}

	function obj:update(dt)
		if obj.dx ~= nil then
			obj.x = obj.x + obj.dx

			if obj.x < math.min(obj.x1, obj.x2) or obj.x > math.max(obj.x1, obj.x2) then
				obj.dx = obj.dx * -1
			end
		end
		if obj.dy ~= nil then
			obj.y = obj.y + obj.dy

			if obj.y < math.min(obj.y1, obj.y2) or obj.y > math.max(obj.y1, obj.y2) then
				obj.dy = obj.dy * -1
			end
		end

		world:move(obj, obj.x, obj.y)
	end


	function obj:draw()
		love.graphics.rectangle("fill", obj.x, obj.y, obj.w, obj.h)
	end

	world:add(obj, obj.x, obj.y, obj.w, obj.h)
	return obj
end


return platform