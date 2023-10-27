extends Node2D

var sprite: Sprite 
var speed = 500.0  # Adjust the speed to your preference
var followingMouse = false
signal p1cursor
signal p1selected
	
func _ready():
	sprite = $SpriteP1
	set_process_input(true) # Enable input processing
	sprite.texture = preload("res://Pointers/p1cursor.png")
func _process(_delta):
	if followingMouse:
		followMouse()
		sprite.texture = preload("res://Pointers/p1cursor.png")
	else:
		followKeyboard()
		# Change texture to "p1cursor" when any WASD key is pressed
	if Input.is_action_pressed("ui_left1") or Input.is_action_pressed("ui_right1") or Input.is_action_pressed("ui_up1") or Input.is_action_pressed("ui_down1"):
		sprite.texture = preload("res://Pointers/p1cursor.png")
func followMouse():
	position = get_global_mouse_position()

func followKeyboard():
	var input_vector = Vector2(0, 0)
	if Input.is_action_pressed("ui_left1"):
		input_vector.x -= 2
	if Input.is_action_pressed("ui_right1"):
		input_vector.x += 2
	if Input.is_action_pressed("ui_up1"):
		input_vector.y -= 2
	if Input.is_action_pressed("ui_down1"):
		input_vector.y += 2

	# Normalize the input_vector so diagonal movement isn't faster
	input_vector = input_vector.normalized()

	position += input_vector * speed * get_process_delta_time()

func _on_GrabAreaP1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# Mouse Pressed on Sprite
			if sprite.get_rect().has_point(sprite.to_local(event.position)):
				followingMouse = true
				sprite.texture == preload("res://Pointers/p1cursor.png")
		else:
			# Mouse Released
			sprite.texture = preload("res://Pointers/p1selected.png")
			followingMouse = false
			

func _input(event):
	# Toggle Sprite Texture and FollowingMouse State with Spacebar
	if event is InputEventKey and event.scancode == KEY_SPACE and event.pressed:
		if sprite.texture == preload("res://Pointers/p1cursor.png"):
			sprite.texture = preload("res://Pointers/p1selected.png")
		else:
			sprite.texture = preload("res://Pointers/p1cursor.png")


func _on_Sprite_texture_changed():
		if sprite.texture == preload("res://Pointers/p1cursor.png"):
			emit_signal("p1cursor")
		else:
			emit_signal("p1selected")

