local room = {
	id_ctr = 0 -- Keep track of how many rooms are made
}

function room:new()
	local r = {
		id = room.id_ctr,	-- unique id used for doorwars and connecting the map
		platforms = nil, 	-- all room structure
		statics = nil, 		-- all room decorations
		enemies = nil, 		-- all room enemies
		collectibles = nil 	-- all room collectibles
	}

	-- Object/class inheritence with two lines of code
	setmetatable(r, self)
	self.__index = self

	room.id_ctr = room.id_ctr + 1
	return r
end

-- Array of platforms becoming the only platforms in the room
function room:set_platforms(platforms)
	self.platforms = platforms
end

-- Spot check to add a platform to an already existing table
function room:add_platform(platform)
	table.insert(self.platforms, platform)
end

-- Random generation of rooms
function room:generate()

end


function room:update(dt)
	for _, i in ipairs(self.platforms) do
		i:update(dt)
	end
end

function room:draw()
	for _, i in ipairs(self.platforms) do
		i:draw(dt)
	end
end

return room