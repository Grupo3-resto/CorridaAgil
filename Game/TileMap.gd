extends TileMap

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2
var grid = get_used_cells () 
var player_tile = 0


func get_center(pos):
	pos = map_to_world(pos)
	pos.x += half_tile_size.x
	pos.y += half_tile_size.y
	return pos


func _ready():
	$Player.start(get_center(grid[player_tile]))
	pass


func get_input():
	if Input.is_action_pressed('click'):
		player_tile += 1
		$Player.target = get_center(grid[player_tile])


func _process(delta):
	if $Player.velocity == Vector2(0,0):
		get_input()

