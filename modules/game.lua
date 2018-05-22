local game = {
	states = {"START", "GAME", "PAUSE", "LOSE", "RESET"},
	state = "START",
	map = {}, --holds a bunch of rooms
	score = 0,
}

function game:load_scene(scene)
	game.scene = scene
end

function game:update(dt)
	game.scene:update(dt)
end

function game:start()

end

function game:lose()

end

return game