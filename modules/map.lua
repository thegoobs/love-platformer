local map = {}

function map:new()
	local m = {
		rooms = {} --holds all the rooms
	}

	setmetatable(m, self)
	self.__index = self
	return m
end


function map:add_room(room)
	table.insert(self.rooms, room)
end


return map