extends Node


signal choice_selected
signal dialogue_end

enum state {NORMAL, BIFURCACAO}

var PanelSize
var dialogData
var number_of_buttons = 0
var DialogueList = [] #Uma lista com os textos para cada dialogo 
var ChoiceList = []   #Uma lista com as opções para cada dialogo 
var AnswerList = []   #Uma lista com as respostas de cada dialogo
var StateList = []
var DialogueCount = 0 #O numero de dialogos a serem mostrados em sequencias
var chooseDir = null
var teste = true


func shuffleList(list):
	randomize()
	var shuffledList = [] 
	var correct
	var x
	var indexList = range(list.size())

	for i in range(list.size()):
		x = randi()%indexList.size()
		if indexList[x] == 0:
			correct = i
		shuffledList.append(list[indexList[x]])
		indexList.remove(x)
	return [shuffledList, correct]

func _ready():

	$Panel.hide()
	PanelSize = Vector2($Panel.margin_right - $Panel.margin_left , $Panel.margin_bottom - $Panel.margin_top)
	load_json()

#insere um novo dialogo na lista de dialogos a serem mostrados
func insert(type, index, arr = null):
	DialogueCount += 1
	DialogueList.push_back(get_dialog_text(type, index))
	if type == "pergunta":
		ChoiceList.push_back(get_question_options(index)[0])
		AnswerList.push_back(get_question_options(index)[1])
		StateList.push_back(NORMAL)
	elif type == "Bifurcação":
		var dir = ["Right", "Down", "Left", "Up"]
		var auxList = []
		for i in range(4):
			if arr[i] != null:
				auxList.push_back(dir[i])
		ChoiceList.push_back(auxList)
		AnswerList.push_back(-1)
		StateList.push_back(BIFURCACAO)
	else:
		ChoiceList.push_back(null)
		AnswerList.push_back(-1)
		StateList.push_back(NORMAL)

#mostra dialogos inseridos na lista
func show_dialogue():
	if DialogueCount > 0:
		if teste:
			teste = false
			$Panel.show()
			display_dialogue(DialogueList[0])
			if ChoiceList[0] != null:
				var shuffle = shuffleList(ChoiceList[0])
				ChoiceList[0] = shuffle[0]
				display_choices(ChoiceList[0], shuffle[1])
	else:
		print("erro!! não existem dialogos na lista")

#pos representa a posição extrema esqueda do botão
#a oos valores x e y de pos precisa ser um numero entre 0 a 100 independente das margins do Panel
#ex: (0,0) extremidade esquerda ou (50,50) meio....
func set_pos(pos, size, choice_button): 
	choice_button.margin_left = PanelSize.x*(pos.x/100)
	choice_button.margin_right = choice_button.margin_left + PanelSize.x*(size.x/100)
	choice_button.margin_top = PanelSize.y*(pos.y/100)
	choice_button.margin_bottom = choice_button.margin_top + PanelSize.y*(size.y/100)


func set_size(button_array):
	var BiggerString = 0
	for i in range(button_array.size()):
		if button_array[i].length() > BiggerString:
			BiggerString = button_array[i].length()
	if BiggerString < 47: 
		return Vector2(BiggerString * 2 + 4, 15)
	else:
		return Vector2(98, 15)

#cria butoes que representam escolhas 
func display_choices(button_array = null, resposta = -1):
	if button_array != null :
		if button_array != null :
			$Panel/Button.hide() #esconde botão 
			number_of_buttons = button_array.size()
			var size = set_size(button_array) #defini o tamanho dos botões 
			var teste1 = get_node("Panel").get_children()
			if number_of_buttons > 6:
				print("erro!!!: O maximo de butões permitido é 6")
			else:
				for i in range(number_of_buttons):
					var choice_button = Button.new()
					choice_button.set_name("button" + str(i))
					$Panel.add_child(choice_button)
					choice_button.text = button_array[i]
					choice_button.set_clip_text(true)
					if StateList[0] == NORMAL:
						choice_button.connect("pressed", self, "_on_choice_button_pressed", [i, resposta]) 
						#posiciona cada botão dependendo do numero de botões 
						if number_of_buttons < 4:
							set_pos(Vector2((100 - size.x)/2, 45 + 18*i) , size , choice_button)
						else:
							if i < 3:
								set_pos(Vector2((50 - size.x)/2, 45 + 18*i) , size/2 , choice_button)
							else:
								set_pos(Vector2((50 + (50 - size.x)/2), 45 + 18*(i - 3)) , size/2 , choice_button)
					else:
						#posiciona os botões de acordo com a direção que eles indicam
						if choice_button.text == "Up":
							set_pos(Vector2((100 - size.x)/2, 35) , size , choice_button)
							choice_button.connect("pressed", self, "_on_choice_button_pressed", [3, resposta]) 
						elif choice_button.text == "Down":
							set_pos(Vector2((100 - size.x)/2, 75) , size , choice_button)
							choice_button.connect("pressed", self, "_on_choice_button_pressed", [1, resposta]) 
						elif choice_button.text == "Right":
							set_pos(Vector2(70, 55) , size , choice_button)
							choice_button.connect("pressed", self, "_on_choice_button_pressed", [0, resposta]) 
						elif choice_button.text == "Left":
							set_pos(Vector2(30, 55) , size , choice_button)
							choice_button.connect("pressed", self, "_on_choice_button_pressed", [2, resposta]) 


#recebe texto do painel
func display_dialogue(dialogue = ""):
	$Panel/RichTextLabel.clear()
	$Panel/RichTextLabel.text = dialogue

#connect com butão proximo ou fechar
func next_or_end():
	teste = true
	DialogueCount -= 1
	DialogueList.pop_front()
	ChoiceList.pop_front()
	AnswerList.pop_front()
	StateList.pop_front()
	if DialogueCount == 0:
		$Panel.hide()
		get_node("/root/main/HUD/RollDice").show()
		emit_signal("dialogue_end")
	else:
		var teste1 = get_node("Panel").get_children()
		show_dialogue()
	

#quando uma das alternativas é pressionada
func _on_choice_button_pressed(id, resposta):
	var index = 0
	while index < number_of_buttons:
		var nId = index + 10
		get_node("Panel").get_node("button" + str(index)).set_name("button" + str(nId))
		get_node("Panel").get_node("button" + str(nId)).queue_free()
		index += 1
	
	if(id == resposta):
		get_node("/root/main/HUD/Score").score += 200
		get_node("/root/main/HUD/Score").update_score()
	if StateList[0] == BIFURCACAO:
		chooseDir = id
	next_or_end()

#Carrega o json como um dicionario em dialogData
func load_json():
	var file = File.new()
	file.open("res://dialogo.json", File.READ)
	dialogData = JSON.parse(file.get_as_text()).result
	file.close()

#Retorna o texto do dialogo a ser exibido
#Input: type: Tipo de dialogo, por enquanto eh "pergunta" ou "dialogo"
#index: indice do dialogo no vetor
func get_dialog_text(type, index):
	return dialogData[type][index]["text"]

#Retorna as opcoes da pergunta no indice index
func get_question_options(index):
	return [dialogData["pergunta"][index]["opcoes"], dialogData["pergunta"][index]["correct"]]


