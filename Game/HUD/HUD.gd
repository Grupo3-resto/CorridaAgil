extends CanvasLayer

signal roll_dice
signal direction_pressed
var dir

func _on_RollDice_pressed():
	emit_signal("roll_dice")
	

func _on_Right_pressed():
	dir = 0
	emit_signal("direction_pressed")


func _on_Left_pressed():
	dir = 2
	emit_signal("direction_pressed")


func _on_Up_pressed():
	dir = 3
	emit_signal("direction_pressed")

func _on_Down_pressed():
	dir = 1
	emit_signal("direction_pressed")
	


func _on_Voltar_menu_pressed():
		get_tree().change_scene('res://TitleScreen/TitleScreen.tscn')
