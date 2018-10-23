extends Node2D

signal has_stopped
export (int) var speed = 200

enum direction {RIGHT, DOWN, LEFT, UP}
var playerDirection = RIGHT
var target = Vector2()
var velocity = Vector2()
var path = []


func start(pos):
	position = pos
	target = position
	test_direction()


func change_direction(dir):
	match dir:
		RIGHT:
			if playerDirection == UP:
				$AnimatedSprite.animation = "up-right"
			elif playerDirection == DOWN:
				$AnimatedSprite.animation = "down-right"
			else:
				print("Error! The animation left-right doesn't exist")
			playerDirection = RIGHT
			$AnimatedSprite.playing = true
		DOWN:
			if playerDirection == RIGHT:
				$AnimatedSprite.animation = "right-down"
			elif playerDirection == LEFT:
				$AnimatedSprite.animation = "left-down"
			else:
				print("Error! The animation up-down doesn't exist")
			playerDirection = DOWN
			$AnimatedSprite.playing = true
		LEFT:
			if playerDirection == UP:
				$AnimatedSprite.animation = "up-left"
			elif playerDirection == DOWN:
				$AnimatedSprite.animation = "down-left"
			else:
				print("Error! The animation right-left doesn't exist")
			playerDirection = LEFT
			$AnimatedSprite.playing = true
		UP:
			if playerDirection == RIGHT:
				$AnimatedSprite.animation = "right-up"
			elif playerDirection == LEFT:
				$AnimatedSprite.animation = "left-up"
			else:
				print("Error! The animation down-up doesn't exist")
			playerDirection = UP
			$AnimatedSprite.playing = true

#chama a função change_direction() e recebe a proxima celula como default
func test_direction():
	if get_node("/root/main/TileMap").ssize(get_node("/root/main/TileMap").search_for_neighbors()) == 1:
		var dir = get_node("/root/main/TileMap").search_for_neighbors()[get_node("/root/main/TileMap").get_first_non_nil(get_node("/root/main/TileMap").search_for_neighbors())] - get_parent().get_node("TileMap/Path").world_to_map(position)
		if dir.x != 0 and dir.y == 0:
			if playerDirection == DOWN or playerDirection == UP:
				if dir.x < 0:
					change_direction(LEFT)
				else:
					change_direction(RIGHT)
		if dir.x == 0 and dir.y != 0:
			if playerDirection == RIGHT or playerDirection == LEFT:
				if dir.y < 0:
					change_direction(UP)
				else:
					change_direction(DOWN)


func _process(delta):
	if path.size() > 0:
		target = path[0]
		velocity = (target - position).normalized() * speed * delta
		if(position - target).length() < 20:
			test_direction()
		if(position - target).length() < 5:
			velocity = Vector2(0,0)
			path.pop_front()
			if  path.size() == 0:
				emit_signal("has_stopped")
		position += velocity