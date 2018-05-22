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

	world:add(char, char.x, char.y, char.w, char.h)
	game.curr_room:init()
end

function game:lose()

end

function game:go_to(room)
	game.just_moved = true -- hotfix for door splicing
	
	scene:flush() --get rid of all things in scene
	game.curr_room:flush() --remove the room from the world

	game.curr_room = room -- New current room, needs to be updated

	--put the character back in the right spot
	scene:add(char)
	char.x = love.graphics.getWidth() - char.x
	world:update(char, char.x, char.y) --"teleport character to new location"

	scene:add(room)
	game.curr_room:init()
end

return game