extends TileMap

var half_tile_size = get_cell_size() / 2
var grid = get_used_cells ()  #array de todas as celulas usadas
var player_tile = grid.find(Vector2(0,0)) #guarda o id da celula que o player esta posicionado
var passed_cell = [Vector2(0,0)]

func get_center(cell):
	var pos = map_to_world(cell)
	pos.x += half_tile_size.x
	pos.y += half_tile_size.y
	return pos


func _ready():
	$Player.start(get_center(grid[player_tile]))


func search_for_neighbors(cell):
	var aux = cell
	var neighbors = []
# na direita
	aux.x = cell.x + 1
	aux.y = cell.y
	if grid.has(aux) and !passed_cell.has(aux):
		neighbors.push_back(aux)
# em baxo
	aux = cell
	aux.x = cell.x
	aux.y = cell.y + 1
	if grid.has(aux)  and !passed_cell.has(aux):
		neighbors.push_back(aux)
# na esquerda
	aux = cell
	aux.x = cell.x - 1
	aux.y = cell.y
	if grid.has(aux) and !passed_cell.has(aux):
		neighbors.push_back(aux)
# em cima
	aux = cell
	aux.x = cell.x
	aux.y = cell.y - 1
	if grid.has(aux)  and !passed_cell.has(aux):
		neighbors.push_back(aux)
	
	return neighbors


func update_player(distance, pos):
	var cell = world_to_map(pos)
	for i in range(distance):
		var neighbors = search_for_neighbors(cell)
		if neighbors.size() > 0:
			cell = neighbors[0]
			passed_cell.push_back(cell)
			player_tile = grid.find(cell)
			$Player.target = get_center(grid[player_tile])
			
			var t = Timer.new() # Timer p/ o player seguir o caminho
			t.set_wait_time(.3)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free() 
