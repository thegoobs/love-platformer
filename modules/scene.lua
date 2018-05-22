local scene = {}
scene.objects = {}

function scene:add(obj)
	table.insert(scene.objects, obj)
end

function scene:find(obj)
	for _, i in ipairs(scene.objects) do
		if i == obj then
			return true
		end
	end

	return false
end

function scene:remove(obj)
	if scene:find(obj) then
		table.remove(scene.objects, obj)
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