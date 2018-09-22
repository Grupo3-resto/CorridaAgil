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


func update_player(distance):
		player_tile += distance
		$Player.target = get_center(grid[player_tile])



