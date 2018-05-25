local game = {
	states = {"START", "GAME", "PAUSE", "LOSE", "RESET"},
	state = "START",
	map = {}, --holds a bunch of rooms
	score = 0,
	curr_room = nil,
	just_moved = false
}

function game:load_scene(scene)
	game.scene = scene
end

function game:update(dt)
	game.scene:update(dt)
end

function game:start()
	scene:add(char)
	scene:add(r1)

	if world:hasItem(char) == false then
		world:add(char, char.x, char.y, char.w, char.h)
	else
		char.x = 0
		char.y = 100
		world:update(char, char.x, char.y)
	end

	game.curr_room = r1
	game.curr_room:init()
end

function game:lose()

end

function game:flush()
	scene:flush() --get rid of all things in scene
	game.curr_room:flush() --remove the room from the world
end

function game:go_to(room)
	game:flush()

	local prev_room = game.curr_room
	game.curr_room = room -- New current room, needs to be updated

	--put the character back in the right spot
	scene:add(char)

	local curr_door = game.curr_room:find_door(game.curr_room, prev_room)
	char.x = curr_door.x
	char.y = curr_door.y + curr_door.h - char.h

	if char.x > love.graphics.getWidth()/2 then
		char.x = char.x - char.w
	else
		char.x = char.x + curr_door.w
	end

	world:update(char, char.x, char.y) -- teleport character to new location

	scene:add(room)
	game.curr_room:init()
end

function game:reset()
	game:flush()
	game:start()
end

return game