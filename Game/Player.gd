extends Node2D

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()


func start(pos):
	position = pos
	target = position

func _process(delta):
	velocity = (target - position).normalized() * speed * delta
	
	if(position - target).length() < 5:
		velocity = Vector2(0,0)
	position += velocity