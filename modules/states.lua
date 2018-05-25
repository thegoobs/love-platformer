-- State manager for character module
local state = {}

function state:set(obj)
	local s = obj.state --temp state
	local d = obj.dir --temp dir
	local x, y, c, l = world:check(obj, obj.x + obj.dx, obj.y + g)

	if obj.dx == 0 and obj.dy == 0 and (obj.state ~= "WALL_CLING" and obj.state ~= "JUMP") then
		s = "STANDBY"
	end

	if obj.dx ~= 0 and obj.dy == 0 and obj.state ~= "JUMP" then
		s = "RUN"

		--check collisions
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

	if obj.dy > 0 and obj.state == "JUMP" then
		s = "FALL"
	end

	for i = 1, l do
		if c[i].normal.x ~= 0 and l == 1 and c[i].other.h > obj.h and obj.wall_jump == true and s ~= "JUMP" and obj.y > c[i].other.y then
			s = "WALL_CLING"
		end
	end

	-- get direction
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
