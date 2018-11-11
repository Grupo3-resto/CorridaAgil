extends Control

func _on_NovoJogo_pressed():
	get_tree().change_scene('res://main.tscn')


func _on_Personagem_pressed():
	get_tree().change_scene('res://Personagem/Personagem.tscn')


func _on_Recordes_pressed():
	get_tree().change_scene('res://Recordes/Recordes.tscn')
