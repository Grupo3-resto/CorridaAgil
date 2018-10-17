extends Node


signal event_end
var eventData
var eventList = []
var eventCount = 0

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
	else:
		show_event()


func load_json():
	var file = File.new()
	file.open("res://event.json", File.READ)
	eventData = JSON.parse(file.get_as_text()).result
	file.close()


func get_event(type, index):
	return eventData[type][index]["text"]