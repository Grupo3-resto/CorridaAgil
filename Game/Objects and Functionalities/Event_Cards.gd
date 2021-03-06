extends Node


signal event_end
var eventData
var eventList = []
var eventCount = 0
var effects = []

func _ready():
	load_json()

#insere um novo dialogo na lista de dialogos a serem mostrados
func insert(type, index):
	eventCount += 1
	eventList.push_back(get_event(type, index))


func show_event():
	$Event.dialog_text = eventList[0]
	$Event.show()


func event_end():
	eventCount -= 1
	eventList.pop_front()
	if eventCount == 0:
		$Event.hide()
		emit_signal("event_end")
		apply_effects()
	else:
		show_event()


func load_json():
	var file = File.new()
	file.open("res://event.json", File.READ)
	eventData = JSON.parse(file.get_as_text()).result
	file.close()


func get_event(type, index):
	set_effects(type, index)
	return eventData[type][index]["text"]
	
func set_effects(type, index):
	#Indices:
	#	0: typo do efeito[move = 0, socore = 1]
	#	1: Quantidade de casas andadas ou de pontos ganhados
	effects.push_back(eventData[type][index]["effect"])


func apply_effects():
	for i in effects:
		if i[0] == 0:
			get_node("/root/main/TileMap").move(i[1])
		elif i[1] == 1:
			get_node("/root/main/HUD/Score").score += i[1]
	effects.clear()