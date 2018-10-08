extends Node

signal next_dialogue
var DialogueCount = 1
var PanelSize
var dialogData

export(Array, String) var ButtonList #array de cada alternativa
export(String, MULTILINE) var LabelDialogue = ""  #texto que vai aparecer no painel

func _ready():
	PanelSize = Vector2($Panel.margin_right - $Panel.margin_left , $Panel.margin_bottom - $Panel.margin_top)
	display_choices()
	display_dialogue()
	load_json()

#pos representa a posição extrema esqueda do botão
#a oos valores x e y de pos precisa ser um numero entre 0 a 100 independente das margins do Panel
#ex: (0,0) extremidade esquerda ou (50,50) meio....
func set_pos(pos, size, choice_button): 
	choice_button.margin_left = PanelSize.x*(pos.x/100)
	choice_button.margin_right = choice_button.margin_left + PanelSize.x*(size.x/100)
	choice_button.margin_top = PanelSize.y*(pos.y/100)
	choice_button.margin_bottom = choice_button.margin_top + PanelSize.y*(size.y/100)


#cria butoes que representam escolhas 
func display_choices(button_array = ButtonList, size = Vector2(20, 5), pos = Vector2(40, 50)):
	if button_array != null :
		var number_of_buttons = button_array.size()
		if number_of_buttons > 6:
			print("erro!!!: O maximo de butões permitido é 6")
		else:
			for i in range(number_of_buttons):
				var choice_button = Button.new()
				choice_button.set_name(button_array[i])
				$Panel.add_child(choice_button)
				choice_button.text = button_array[i]
				choice_button.set_clip_text(true)
				choice_button.connect("pressed", self, "_on_choice_button_pressed") 
				if number_of_buttons < 4:
					set_pos(Vector2(pos.x, pos.y + 12*i) , size , choice_button) 
				else:
					if i < 3:
						set_pos(Vector2(pos.x, pos.y + 15*i) , size , choice_button)
					else:
						set_pos(Vector2(pos.x, pos.y + 15*(i - 3)) , size , choice_button)
func display_dialogue(dialogue = LabelDialogue):
	$Panel/RichTextLabel.clear()
	$Panel/RichTextLabel.text = dialogue
	
func _on_Button_pressed():
	DialogueCount -= 1
	if DialogueCount == 0:
		$Panel.hide()
	else:
		emit_signal("next_dialogue")
func _on_choice_button_pressed():
	$Panel.hide()

#Carrega o json como um dicionario em dialogData
func load_json():
	var file = File.new()
	file.open("res://dialogo.json", File.READ)
	var dialogData = JSON.parse(file.get_as_text()).result
	file.close()

#Retorna o texto do dialogo a ser exibido
#Input: type: Tipo de dialogo, por enquanto eh "pergunta" ou "dialogo"
#		index: indice do dialogo no vetor
func get_dialog_text(var type, var index):
	return dialogData[type][index]["text"]

#Retorna as opcoes da pergunta no indice index
func get_question_options(var index):
	return dialogData["pergunta"][index]["opcoes"]