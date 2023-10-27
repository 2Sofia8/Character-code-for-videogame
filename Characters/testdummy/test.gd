extends KinematicBody2D
#This character is called TESTDUMMY
const UP_Direction := Vector2.UP
export (int) var speed = 600
var jump_power = 2000  # jump power to control the jump height
var gravity = 2000     # gravity for jump
var velocity = Vector2()
var friction: float = 0.1
var crouching_friction: float = 0.070
var is_crouching_floor = false  # Variable to track crouching state
var walkspeed = 1
var player_number = 1
var double_tap_time = 0.2
var last_input_time = 0

func _physics_process(delta):	
	var input_vector = Vector2()
		# Check if the character is crouching
	if Input.is_action_pressed("ui_down"+str(player_number)) and is_on_floor():
		is_crouching_floor = true
	else:
		is_crouching_floor = false
	#character cant move nor attack when crouching:
	if not is_crouching_floor: 
		if Input.is_action_pressed("ui_right"+str(player_number)):
			input_vector.x += walkspeed
			get_node( "Sprite" ).set_flip_h(false)
				# Check for sprinting right (double-tap detection)
			if Input.is_action_just_pressed("ui_right"+str(player_number)):
				var current_time = OS.get_system_time_secs()
				if current_time - last_input_time <= double_tap_time:
					walkspeed = 2
				else:
					walkspeed = 1  # Reset speed to walking
					last_input_time = current_time
		if Input.is_action_pressed("ui_left"+str(player_number)):
			input_vector.x -= walkspeed
			get_node( "Sprite" ).set_flip_h(true)
				# Check for sprinting left (double-tap detection)
			if Input.is_action_just_pressed("ui_left"+str(player_number)):
				var current_time = OS.get_system_time_secs()
				if current_time - last_input_time <= double_tap_time:
					walkspeed = 2
				else:
					walkspeed = 1.5  # Reset speed to walking 
				last_input_time = current_time


#here comes some movement shenanigans
	if is_crouching_floor:
		# Apply special crouching friction to slow down when crouching
		velocity.x = lerp(velocity.x, 0, crouching_friction)
	else:
		# Apply regular movement friction when not crouching
		if input_vector == Vector2():
			velocity.x = lerp(velocity.x, 0, friction)
		else:
			velocity.x = input_vector.x * speed
		if Input.is_action_pressed("ui_up"+str(player_number)) and is_on_floor():
		# Check if the player is on the ground and the "ui_up" key is pressed
			velocity.y = -jump_power  # Apply an upward force for jumping
	# Apply gravity
	velocity.y += (gravity * 1.5) * delta
	if Input.is_action_pressed("ui_down"+str(player_number)) and not is_on_floor():
	   # Increase the fall speed when "ui_down" is pressed mid-jump
		velocity.y += gravity * (delta * 1.8)
	# Update the character's position
	velocity = move_and_slide(velocity, UP_Direction)

#here comes animation related stuff
onready var _animated_sprite = $Sprite
enum PlayerState { IDLE, CROUCH, HITHARD, HITSOFT, JUMP, WALK, RUN } #still havent implemented run bellow.
var current_state = PlayerState.IDLE

func _ready():
	# Connect the animation_finished signal to the _on_AnimatedSprite_animation_finished function
	_animated_sprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	
	# initial state = IDLE and play the idle animation
	current_state = PlayerState.IDLE
	_animated_sprite.play("idle")

#animation based on states
func _process(_delta):
	match current_state:
		PlayerState.WALK:
			_animated_sprite.play("walk")
			if Input.is_action_pressed("ui_down"+str(player_number)):
				_animated_sprite.play("crouch")
				current_state = PlayerState.CROUCH
			elif Input.is_action_pressed("ui_hit_hard"+str(player_number)):
				current_state = PlayerState.HITHARD
				_animated_sprite.play("hithard")
			elif Input.is_action_pressed("ui_hit_soft"+str(player_number)):
				current_state = PlayerState.HITSOFT
				_animated_sprite.play("hitsoft")
			elif Input.is_action_pressed("ui_up"+str(player_number)):
				current_state = PlayerState.JUMP
			elif Input.is_action_just_released("ui_right"+str(player_number)) or Input.is_action_just_released("ui_left"+str(player_number)):
				current_state = PlayerState.IDLE

		PlayerState.IDLE:
			_animated_sprite.play("idle")
			if Input.is_action_pressed("ui_right"+str(player_number)) or Input.is_action_pressed("ui_left"+str(player_number)):
				_animated_sprite.play("walk")
				current_state = PlayerState.WALK
			if Input.is_action_pressed("ui_down"+str(player_number)):
				_animated_sprite.play("crouch")
				current_state = PlayerState.CROUCH
			elif Input.is_action_pressed("ui_hit_hard"+str(player_number)):
				current_state = PlayerState.HITHARD
				_animated_sprite.play("hithard")
			elif Input.is_action_pressed("ui_hit_soft"+str(player_number)):
				current_state = PlayerState.HITSOFT
				_animated_sprite.play("hitsoft")
			elif Input.is_action_pressed("ui_up"+str(player_number)):
				current_state = PlayerState.JUMP

		PlayerState.CROUCH:
			if Input.is_action_pressed("ui_down"+str(player_number)):
				_animated_sprite.play("crouch")
			if Input.is_action_just_released("ui_down"+str(player_number)):
				current_state = PlayerState.IDLE
				_animated_sprite.play("idle")
		PlayerState.JUMP:
			if Input.is_action_pressed("ui_hit_hard"+str(player_number)):
				_animated_sprite.play("hithard")
				current_state = PlayerState.HITHARD
			elif Input.is_action_pressed("ui_hit_soft"+str(player_number)):
				_animated_sprite.play("hitsoft")
				current_state = PlayerState.HITSOFT
			elif Input.is_action_just_pressed("ui_down"+str(player_number)):
				_animated_sprite.play("crouch")
				current_state = PlayerState.CROUCH
			# No need to check for animation_finished here; handled in _on_AnimatedSprite_animation_finished
			pass
func _on_AnimatedSprite_animation_finished():
	match current_state:
		PlayerState.HITHARD, PlayerState.HITSOFT, PlayerState.JUMP, PlayerState.WALK, PlayerState.RUN:
			current_state = PlayerState.IDLE
			_animated_sprite.play("idle")
