extends CanvasLayer

var dialogue_box = preload("res://Objects and Functionalities/Dialogue.tscn")


func _on_Player_has_stopped():
	var pos = get_parent().get_parent().get_node("Player").position
	var player_tile = get_parent().world_to_map(pos)
	match player_tile:
		Vector2(4,0), Vector2(5,0),Vector2(6,0):
			var buttons = ["Tem a visão do que a equipe fara", "Liderar a equipe" , "Não sei"]
			var NewDialogue = dialogue_box.instance()
			add_child(NewDialogue)
			NewDialogue.display_choices(buttons, Vector2(60, 5), Vector2(20, 50))
			NewDialogue.display_dialogue("Um dos seus desenvolvedores não entendeu a função do dono do produto\n e vc precisa explicar:")
		_:   #default
			pass

