local door = {}
setmetatable(door, trigger) --setting the metatable of the new door instance will copy all of its functions over

function door:new(x, y, r1, r2)
	local d = trigger:new(x, y, 25, 80) --a door is a trigger, need to overwrite functions
	d.r1 = r1
	d.r2 = r2 --first indexed room is starting room, second is where it leads (in theory, there should always be a door that mirrors this)

	setmetatable(d, self)
	self.__index = self
	return d
end

function door:update(dt)
end

--because trigger and door share this function name, the function will be overwritten
function door:activate()
	game:go_to(self.r2) --second room, r2
end

return door