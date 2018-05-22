-- State manager for character module
local state = {}

function state:set(obj)
	local s = obj.state --temp state
	local d = obj.dir --temp dir

	if obj.dx == 0 and obj.dy == 0 then
		s = "STANDBY"
	end

	if obj.dx ~= 0 and obj.dy == 0 then
		s = "RUN"

		--check directly below obj
		local x, y, c, l = world:check(obj, obj.x, obj.y + g)
		for i = 1, l do
			if obj.dx == c[i].other.dx then
				s = "STANDBY"
			end
		end
	end

	--jump and fall is checked after the running
	if obj.dy < 0 then
		s = "JUMP"
	end
	if obj.dy >= 0 and obj.state == "JUMP" then
		s = "FALL"
	end

	if d ~= nil then
		if obj.dx > 0 then
			d = "R"
		elseif obj.dx < 0 then
			d = "L"
		end
	end

	return s, d or obj.dir
end

return state
