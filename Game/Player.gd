extends Node2D

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()
var path = []


func start(pos):
	position = pos
	target = position

func _process(delta):
	if path.size() > 0:
		target = path[0]
		velocity = (target - position).normalized() * speed * delta
		if(position - target).length() < 5:
			velocity = Vector2(0,0)
			path.pop_front()
		position += velocity