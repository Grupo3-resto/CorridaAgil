extends Node

var DialogueList = []

func _ready():
	set_dialogue_list()

func roll_dice():
	randomize()
	var distance = randi()%6 + 1
	$Dice.show_result(distance, $TileMap/Player.position)
	$TileMap.update_player(distance, $TileMap/Player.position)

func set_dialogue_list():
	DialogueList.push_back("Explicar o scrum")
	$HUD/Dialogue.DialogueCount += 1
	
	DialogueList.push_back("Vamos começar")
	$HUD/Dialogue.DialogueCount += 1


func _on_Dialogue_next_dialogue():
	$HUD/Dialogue.display_dialogue(DialogueList[0])
	DialogueList.pop_front()