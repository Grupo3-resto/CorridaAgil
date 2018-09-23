extends Node



func roll_dice():
	randomize()
	var distance = randi()%6 + 1
	$Dice.show_result(distance, $TileMap/Player.position)
	$TileMap.update_player(distance, $TileMap/Player.position)

