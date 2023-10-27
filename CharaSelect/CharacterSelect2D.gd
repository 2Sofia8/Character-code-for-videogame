extends Node2D
var is_focused : bool = false
var is_selected : bool = false
var player_number

func _on_Volver_pressed():
	get_tree(). change_scene("res://Menu/menu.tscn")
func _on_A_Pelear_pressed():
	get_tree(). change_scene("res://Stages/Cancha/ground.tscn")
#chatgpt

func _ready():
	set_process_input(true)
	#this thing bellow is making this script listen to these signals
	$PointerP1.connect("p1cursor", self, "p1cursor")
	$PointerP1.connect("p1selected", self, "p1selected")
	$PointerP2.connect("p2cursor", self, "p2cursor")
	$PointerP2.connect("p2selected", self, "p2selected")
	
func p1cursor():
	print("p1 is focused")
func p1selected():
		print("p1 is selected")
func p2cursor():
	print("p2 is focused")
func p2selected():
		print("p2 is selected")
