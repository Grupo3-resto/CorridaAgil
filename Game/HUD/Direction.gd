extends Control

func show_buttons(arr):
	self.show()
	var dir = ["Right", "Down", "Left", "Up"]
	for i in range(4):
		if arr[i] != null:
			get_node(dir[i]).show()


func hide_buttons():
	self.hide()
	get_node("Right").hide()
	get_node("Down").hide()
	get_node("Left").hide()
	get_node("Up").hide()