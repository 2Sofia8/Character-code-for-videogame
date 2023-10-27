extends Node2D

var spritep2: Sprite 
var speed = 500.0  # Adjust the speed to your preference
var followingMouse = false
signal p2cursor
signal p2selected
	
func _ready():
	spritep2 = $SpriteP2
	set_process_input(true) # Enable input processing
	spritep2.texture = preload("res://Pointers/p2cursor.png")
func _process(_delta):
	if followingMouse:
		followMouse()
		spritep2.texture = preload("res://Pointers/p2cursor.png")
	else:
		followKeyboard()
		# Change texture to "p1cursor" when any WASD key is pressed
	if Input.is_action_pressed("ui_left2") or Input.is_action_pressed("ui_right2") or Input.is_action_pressed("ui_up2") or Input.is_action_pressed("ui_down2"):
		spritep2.texture = preload("res://Pointers/p2cursor.png")
func followMouse():
	position = get_global_mouse_position()

func followKeyboard():
	var input_vector = Vector2(0, 0)
	if Input.is_action_pressed("ui_left2"):
		input_vector.x -= 2
	if Input.is_action_pressed("ui_right2"):
		input_vector.x += 2
	if Input.is_action_pressed("ui_up2"):
		input_vector.y -= 2
	if Input.is_action_pressed("ui_down2"):
		input_vector.y += 2

	# Normalize the input_vector so diagonal movement isn't faster
	input_vector = input_vector.normalized()

	position += input_vector * speed * get_process_delta_time()



func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# Mouse Pressed on Sprite
			if spritep2.get_rect().has_point(spritep2.to_local(event.position)):
				followingMouse = true
				spritep2.texture == preload("res://Pointers/p2cursor.png")
		else:
			# Mouse Released
			spritep2.texture = preload("res://Pointers/p2selected.png")
			followingMouse = false
			
func _input(event):
	# Toggle Sprite Texture and FollowingMouse State with Spacebar
	if event is InputEventKey and event.scancode == KEY_ENTER and event.pressed:
		if spritep2.texture == preload("res://Pointers/p2cursor.png"):
			spritep2.texture = preload("res://Pointers/p2selected.png")
		else:
			spritep2.texture = preload("res://Pointers/p2cursor.png")


func _on_Sprite_texture_changed():
		if spritep2.texture == preload("res://Pointers/p2cursor.png"):
			emit_signal("p2cursor")
		else:
			emit_signal("p2selected")
