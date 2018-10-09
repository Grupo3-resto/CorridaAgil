extends CanvasLayer



func _on_Player_has_stopped():
	var pos = get_parent().get_parent().get_node("Player").position
	var player_tile = get_parent().get_node("Path").world_to_map(pos)
	match player_tile:
		Vector2(2,-1), Vector2(3,-1),Vector2(4,-1),Vector2(5,-1):
			var dialogue = get_parent().get_parent().get_node("HUD").get_node("Dialogue")
			dialogue.new_dialogue(dialogue.get_question_options(0), dialogue.get_dialog_text("pergunta", 0))
		_:   #default
			pass

