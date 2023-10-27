extends Control
func _ready():
	$VBoxBOTONES/Jugar.grab_focus()
func _on_Jugar_pressed():
	get_tree(). change_scene("res://CharaSelect/Character-Selection.tscn") 
func _on_Salir_pressed():
	get_tree().quit()
