local floor = {}

floor.img = love.graphics.newImage("ground.png")
floor.grass = {}
for i = 0, 3 do
	floor.grass[i + 1] = love.graphics.newQuad(i * 64, 0, 64, 64, floor.img:getWidth(), floor.img:getHeight())
end

floor.dirt = {}
for i = 0, 3 do
	floor.dirt[i + 1] = love.graphics.newQuad(i * 64, 64, 64, 64, floor.img:getWidth(), floor.img:getHeight())
end

function floor:draw()
	for i = 0, love.graphics.getWidth(), 64 do
		love.graphics.draw(floor.img, floor.grass[((i/64) % 4) + 1], i, love.graphics.getHeight() - 200)
		love.graphics.draw(floor.img, floor.dirt[((i/64) % 4) + 1], i, love.graphics.getHeight() - 200 + 64)

	end
end


return floor