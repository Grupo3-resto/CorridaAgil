extends CanvasLayer

signal roll_dice

func _on_RollDice_pressed():
	emit_signal("roll_dice")

