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
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	get_node("/root/main/HUD/RollDice").hide()
	position = pos
	position.x += 200
	position.y += 200
	hide_dice()	
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
	yield(t, "timeout")
	t.queue_free()
	get_node("/root/main/HUD/RollDice").show()
	hide_dice()
	

