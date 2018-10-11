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
	var pos = get_parent().get_parent().get_node("Player").position
	var player_tile = get_parent().get_node("Path").world_to_map(pos)
	var randomIndexArr = []
	#Cria um array com todos os indices das perguntas
	for i in range(dialogue.dialogData["pergunta"].size()):
		randomIndexArr.push_back(i)
	#randomiza os indices
	randomIndexArr = shuffleList(randomIndexArr)
	match player_tile:
		Vector2(2,-1), Vector2(3,-1),Vector2(4,-1),Vector2(5,-1):
			#faz uma pergunta aleatoria e passa para a proxima
			dialogue.new_dialogue(dialogue.get_question_options(randomIndexArr[questionsAsked])[0], dialogue.get_dialog_text("pergunta", questionsAsked), dialogue.get_question_options(randomIndexArr[questionsAsked])[1])
			questionsAsked += 1
		_:   #default
			pass

