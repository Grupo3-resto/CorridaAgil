extends Node

enum state {ACTIVE, INACTIVE}

export (Array) var eventSpots = []
export (Array) var questionSpots = []

var eventState = ACTIVE
var questionsAsked = 0

func _on_Player_has_stopped(): 
	if eventState == ACTIVE:
		var dialogue = get_node("/root/main/HUD/Dialogue")
		var event = get_node("/root/main/HUD/Event_Cards")
		var t = Timer.new()
		t.set_wait_time(0.25)
		self.add_child(t)
		if eventSpots.has(get_parent().grid[get_parent().player_tile]):
			t.start()
			yield(t, "timeout")
			#mostra carta de eventos
			event.insert("positive", 0)
			event.show_event()
			yield(event, "event_end")
			eventState = INACTIVE
		else:
			t.start()
			yield(t, "timeout")
			#mostra dialogo
			dialogue.insert("pergunta", questionsAsked) #LEMBRETE: usar questionAsked apenas provisoriamente
			dialogue.show_dialogue()
			yield(dialogue, "dialogue_end")
			if questionsAsked < (dialogue.dialogData["pergunta"].size() - 1):
				questionsAsked += 1 
		t.queue_free()
	else:
		eventState = ACTIVE

