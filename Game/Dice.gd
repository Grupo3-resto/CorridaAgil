extends Node2D


func hide_dice():
	$dice_1.hide()
	$dice_2.hide()
	$dice_3.hide()
	$dice_4.hide()
	$dice_5.hide()
	$dice_6.hide()


func _ready():
	hide_dice()


func show_result(result, pos):
	hide_dice()
	position = pos
	position.x += 200
	
	if result == 1:
		$dice_1.show()
	elif result == 2:
		$dice_2.show()
	elif result == 3:
		$dice_3.show()
	elif result == 4:
		$dice_4.show()
	elif result == 5:
		$dice_5.show()
	elif result == 6:
		$dice_6.show()

