extends CanvasLayer

var questionsAsked = 0


func shuffleList(list):
    var shuffledList = [] 
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList


func _on_Player_has_stopped(): 
	var dialogue = get_parent().get_parent().get_node("HUD").get_node("Dialogue")
	var event = get_parent().get_parent().get_node("HUD").get_node("Event_Cards")
	var randomIndexArr = []
	#Cria um array com todos os indices das perguntas
	for i in range(dialogue.dialogData["pergunta"].size()):
		randomIndexArr.push_back(i)
	#randomiza os indices
	randomIndexArr = shuffleList(randomIndexArr) #DEFEITO: Aparece mesma pergunta mais de uma vez
	#mostra dialogo
	dialogue.insert("pergunta", questionsAsked) #LEMBRETE: usar questionAsked apenas provisoriamente
	dialogue.show_dialogue()
	yield(dialogue, "dialogue_end")
	#event.insert("positive", 0)
	#event.show_event()
	#yield(event, "event_end")
	if questionsAsked < (dialogue.dialogData["pergunta"].size() - 1):
		questionsAsked += 1 

