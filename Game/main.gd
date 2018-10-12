extends Node

func _ready():
	$HUD/Dialogue.insert("dialogo", 0)
	$HUD/Dialogue.insert("dialogo", 1)
	$HUD/Dialogue.show_dialogue()

func roll_dice():
	randomize()
	var distance = randi()%6 + 1
	$Dice.show_result(distance, $Player.position)
	$TileMap.update_player(distance, $Player.position)
