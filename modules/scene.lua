local scene = {}
scene.objects = {}

function scene:add(obj)
	table.insert(scene.objects, obj)
end

function scene:find(obj)
	for i = 1, #scene.objects do
		if scene.objects[i] == obj then
			return i
		end
	end

	return -1
end

function scene:remove(obj)
	local index = scene:find(obj)
	if index ~= -1 then
		table.remove(scene.objects, index)
	end
end

function scene:flush(obj)
	for i = 1, #scene.objects do
		table.remove(scene.objects)
	end
end

function scene:update(dt)
	for _, i in ipairs(scene.objects) do
		i:update(dt)
	end
end

function scene:draw()
	for _, i in ipairs(scene.objects) do
		i:draw()
	end
end

return scene