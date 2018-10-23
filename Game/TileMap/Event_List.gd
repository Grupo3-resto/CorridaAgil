extends Node


enum state {ACTIVE, INACTIVE}

var questionsAsked = 0
var eventState = ACTIVE


func _on_Player_has_stopped(): 
	if eventState == ACTIVE:
		var dialogue = get_parent().get_parent().get_node("HUD").get_node("Dialogue")
		var event = get_parent().get_parent().get_node("HUD").get_node("Event_Cards")
		var t = Timer.new()
		t.set_wait_time(0.25)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		#mostra dialogo
		dialogue.insert("pergunta", questionsAsked) #LEMBRETE: usar questionAsked apenas provisoriamente
		dialogue.show_dialogue()
		yield(dialogue, "dialogue_end")
		#mostra carta de eventos
		event.insert("positive", 0)
		event.show_event()
		yield(event, "event_end")
		if questionsAsked < (dialogue.dialogData["pergunta"].size() - 1):
			questionsAsked += 1 
		eventState = INACTIVE
		t.queue_free()
	else:
		eventState = ACTIVE

