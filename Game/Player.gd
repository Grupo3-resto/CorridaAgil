extends Node2D

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()
var screensize = Vector2()

func _ready():
	screensize = get_viewport().size

func get_input():
	if Input.is_action_pressed('click'):
		target = get_global_mouse_position()

func _process(delta):
	get_input()
	velocity = (target - position).normalized() * speed * delta
	
	if(position - target).length() < 5:
		velocity = Vector2(0,0)
	position += velocity
	#position.y = clamp(position.y, 0, screensize.y)