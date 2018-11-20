extends Node

func _ready():
	$HUD/Dialogue.insert("dialogo", 0)
	$HUD/Dialogue.insert("dialogo", 1)
	$HUD/Dialogue.show_dialogue()

func roll_dice():
	randomize()
	var distance = randi()%6 + 1
	$HUD/Dice.show_result(distance, get_node("TileMap/Path/Player").position)
	$TileMap.update_player(distance, get_node("TileMap/Path/Player").position)
