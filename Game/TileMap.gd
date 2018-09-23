extends TileMap

var half_tile_size = get_cell_size() / 2
var grid = get_used_cells ()  #array de todas as celulas usadas
var player_tile = grid.find(Vector2(0,0)) #guarda o id da celula que o player esta posicionado
var passed_cell = [Vector2(0,0)] #guarda posição das celulas na quais o player ja passou

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


func update_player_path(way):
	var teste = way.back()
	var i = 1
	while i < way.size():
		if way[i].x == way[i - 1].x:
			i += 1
			while i < way.size():
				if way[i].x == way[i - 1].x:
					i += 1 
				else:
					player_tile = grid.find(way[i - 1])
					$Player.path.push_back(get_center(grid[player_tile]))  #adicona ao path se for a utima posição da array 
					break
			player_tile = grid.find(way[i - 1])
			$Player.path.push_back(get_center(grid[player_tile])) 
		
		elif way[i].y == way[i - 1].y:
			i += 1
			while i < way.size():
				if  way[i].y == way[i - 1].y:
					i += 1
				else :
					player_tile = grid.find(way[i - 1])
					$Player.path.push_back(get_center(grid[player_tile]))  #adicona ao path se for a utima posição da array
					break 
			player_tile = grid.find(way[i - 1])
			$Player.path.push_back(get_center(grid[player_tile])) 


func update_player(distance, pos):
	var cell = world_to_map(pos)
	var way = [cell]
	for i in range(distance):
		var neighbors = search_for_neighbors(cell)
		if neighbors.size() > 0:
			cell = neighbors[0]
			passed_cell.push_back(cell)
			way.push_back(cell)
	update_player_path(way)
