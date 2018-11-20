extends CanvasLayer

signal roll_dice

func _on_RollDice_pressed():
	emit_signal("roll_dice")


func _on_Voltar_menu_pressed():
	get_tree().change_scene('res://TitleScreen/TitleScreen.tscn')