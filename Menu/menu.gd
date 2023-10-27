extends Control

func _ready():
	$VBoxBOTONES/Jugar.grab_focus()
	
func _on_Jugar_pressed():
	$TransitionScreen.transition()
	get_tree(). change_scene("res://CharaSelect/CharacterSelect2D.tscn")

func _on_Salir_pressed():
	$TransitionScreen.transition()
	get_tree().quit()
