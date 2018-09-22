extends Node



func roll_dice():
	randomize()
	var distance = randi()%6 + 1
	$TileMap.update_player(distance)
	$Dice.show_result(distance, $TileMap/Player.position)
