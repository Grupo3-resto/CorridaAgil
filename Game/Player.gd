extends Node2D

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()

func _process(delta):
	if Input.is_action_pressed('click'):
		target = get_global_mouse_position()
		velocity = (target - position).normalized() * speed * delta
	position += velocity
	if(position == target):
		velocity = (target - position)