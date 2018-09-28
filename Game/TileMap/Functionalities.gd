extends Node2D
#em faze de testes

var dialogue_box = preload("res://Objects and Functionalities/Dialogue.tscn")
var count = 0

func _on_Player_has_stopped():
	count += 1
	match count:
		1:
			var buttons = ["Tem a visão do que a equipe fara", "Liderar a equipe" , "Não sei"]
			var NewDialogue = dialogue_box.instance()
			add_child(NewDialogue)
			NewDialogue.display_choices(buttons, Vector2(60, 5), Vector2(20, 50))
			NewDialogue.set_dialogue("Um dos seus desenvolvedores não entendeu a função do dono do produto\n e vc precisa explicar:")
		_:   #default
			pass