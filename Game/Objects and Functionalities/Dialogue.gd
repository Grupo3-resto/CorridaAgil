extends Node

signal choice_selected
signal dialogue_end
var PanelSize
var dialogData
var number_of_buttons = 0
var DialogueList = [] #Uma lista com os textos para cada dialogo 
var ChoiceList = []   #Uma lista com as opções para cada dialogo 
var AnswerList = []   #Uma lista com as respostas de cada dialogo
var DialogueCount = 0 #O numero de dialogos a serem mostrados em sequencias


func _ready():
	$Panel.hide()
	PanelSize = Vector2($Panel.margin_right - $Panel.margin_left , $Panel.margin_bottom - $Panel.margin_top)
	load_json()

#insere um novo dialogo na lista de dialogos a serem mostrados
func insert(type, index):
	DialogueCount += 1
	DialogueList.push_back(get_dialog_text(type, index))
	if type == "pergunta":
		ChoiceList.push_back(get_question_options(index)[0])
		AnswerList.push_back(get_question_options(index)[1])
	else:
		ChoiceList.push_back(null)
		AnswerList.push_back(-1)

#mostra dialogos inseridos na lista
func show_dialogue():
	if DialogueCount > 0 :
		$Panel.show()
		display_dialogue(DialogueList[0])
		display_choices(ChoiceList[0], AnswerList[0])
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
	if BiggerString < 48: 
		return Vector2(BiggerString * 2, 15)
	else:
		return Vector2(96, 15)

#cria butoes que representam escolhas 
func display_choices(button_array = null, resposta = -1):
	if button_array != null :
		$Panel/Button.hide() #esconde botão 
		number_of_buttons = button_array.size()
		var size = set_size(button_array) #defini o tamanho dos botões 
		if number_of_buttons > 6:
			print("erro!!!: O maximo de butões permitido é 6")
		else:
			for i in range(number_of_buttons):
				var choice_button = Button.new()
				choice_button.set_name("button" + str(i))
				$Panel.add_child(choice_button)
				choice_button.text = button_array[i]
				choice_button.set_clip_text(true)
				choice_button.connect("pressed", self, "_on_choice_button_pressed", [i, resposta]) 
				#posiciona cada botão dependendo do numero de botões 
				if number_of_buttons < 4:
					set_pos(Vector2((100 - size.x)/2, 45 + 18*i) , size , choice_button)
				else:
					if i < 3:
						set_pos(Vector2((50 - size.x)/2, 45 + 18*i) , size/2 , choice_button)
					else:
						set_pos(Vector2((50 + (50 - size.x)/2), 45 + 18*(i - 3)) , size/2 , choice_button)


#recebe texto do painel
func display_dialogue(dialogue = ""):
	$Panel/RichTextLabel.clear()
	$Panel/RichTextLabel.text = dialogue

#connect com butão proximo ou fechar
func next_or_end():
	DialogueCount -= 1
	DialogueList.pop_front()
	ChoiceList.pop_front()
	AnswerList.pop_front()
	if DialogueCount == 0:
		$Panel.hide()
		emit_signal("dialogue_end")
	else:
		show_dialogue()

#quando uma das alternativas é pressionada
func _on_choice_button_pressed(id, resposta):
	var index = 0
	while index < number_of_buttons:
		var tey = ("button" + str(index))
		get_node("Panel").get_node("button" + str(index)).queue_free()
		index += 1
	if(id == resposta):
		get_node("/root/main/HUD/Score").score += 1
		get_node("/root/main/HUD/Score").update_score()
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