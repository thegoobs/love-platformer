local state = {}

function state:set(obj)
	local s = obj.state --temp state
	local d = obj.dir --temp dir

	if obj.dx == 0 and obj.dy == 0 then
		s = "STANDBY"
	end

	if obj.dx ~= 0 and obj.dy == 0 then
		s = "RUN"
	end

	--jump and fall is checked after the running
	if obj.dy < 0 then
		s = "JUMP"
	end
	if obj.dy >= 0 and obj.state == "JUMP" then
		s = "FALL"
	end

	if obj.dx > 0 then
		d = "R"
	elseif obj.dx < 0 then
		d = "L"
	end

	return s, d
end

return state
