extends Node

export (Vector2) var FirstTile

var half_tile_size 
var grid= []         #array de todas as celulas usadas
var player_tile      #guarda o id da celula que o player esta posicionado
var passed_cell = [] #guarda posição das celulas na quais o player ja passou
var Player 

func get_center(cell):
	var pos = $Path.map_to_world(cell)
	pos.y += half_tile_size.y
	return pos


func _ready():
	half_tile_size = $Path.get_cell_size() / 2
	grid = $Path.get_used_cells ()  #array de todas as celulas usadas
	player_tile = grid.find(FirstTile)
	Player = get_parent().get_node("Player")
	passed_cell.push_back(FirstTile)
	Player.start(get_center(grid[player_tile]))


func search_for_neighbors(cell):
	var aux = cell
	var neighbors = [null, null, null, null]
	
# na direita
	aux.x = cell.x + 1
	aux.y = cell.y
	if grid.has(aux) and !passed_cell.has(aux):
		neighbors[0] = aux
# em baio
	aux = cell
	aux.x = cell.x
	aux.y = cell.y + 1
	if grid.has(aux)  and !passed_cell.has(aux):
		neighbors[1] = aux
# na esquerda
	aux = cell
	aux.x = cell.x - 1
	aux.y = cell.y
	if grid.has(aux) and !passed_cell.has(aux):
		neighbors[2] = aux
# em cima
	aux = cell
	aux.x = cell.x
	aux.y = cell.y - 1
	if grid.has(aux)  and !passed_cell.has(aux):
		neighbors[3] = aux
	
	return neighbors


func update_player_path(path):
	var teste = path.back()
	var i = 1
	while i < path.size():
		if path[i].x == path[i - 1].x:
			i += 1
			while i < path.size():
				if path[i].x == path[i - 1].x:
					i += 1 
				else:
					player_tile = grid.find(path[i - 1])
					Player.path.push_back(get_center(grid[player_tile]))  #adicona ao path se for a utima posição da array 
					break
			player_tile = grid.find(path[i - 1])
			Player.path.push_back(get_center(grid[player_tile])) 
		
		elif path[i].y == path[i - 1].y:
			i += 1
			while i < path.size():
				if  path[i].y == path[i - 1].y:
					i += 1
				else :
					player_tile = grid.find(path[i - 1])
					Player.path.push_back(get_center(grid[player_tile]))  #adicona ao path se for a utima posição da array
					break 
			player_tile = grid.find(path[i - 1])
			Player.path.push_back(get_center(grid[player_tile])) 


func ssize(array):
	var count = 0
	for i in range(4):
		if typeof(array[i]) != TYPE_NIL:
			count += 1
	return count


func get_first_non_nil(array):
	var ret = 0
	while(array[ret] == null):
		ret += 1
	return ret


func update_player(distance, pos):
	var cell = $Path.world_to_map(pos)
	var path = [cell]
	var dAux = distance
	var cellAux
	for i in range(distance):
		var neighbors = search_for_neighbors(cell)
		var size = ssize(neighbors)
		if size > 0:
			if size > 1:
				update_player_path(path)
				cellAux = path[path.size() - 1]
				path.clear()
				path.push_back(cellAux)
				distance = dAux
				get_parent().get_node("HUD/Direction").show_buttons(neighbors)
				yield(get_parent().get_node("HUD"), "direction_pressed")
				cell = neighbors[get_parent().get_node("HUD").dir]
				get_parent().get_node("HUD/Direction").hide_buttons()
			else:
				cell = neighbors[get_first_non_nil(neighbors)]
			dAux -= 1
			passed_cell.push_back(cell)
			path.push_back(cell)
	update_player_path(path)