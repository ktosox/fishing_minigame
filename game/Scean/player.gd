extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Character properties:
@export var speed : float = 50
var character_direction : Vector2

# main_sm = Main State Machine
var main_sm: LimboHSM


func _ready():
	initate_state_machine()


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	character_direction.x = Input.get_axis("move_left","move_right")
	character_direction.y = Input.get_axis("move_up","move_down")
	
	if character_direction:
		velocity = character_direction * speed
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	flip_sprite(character_direction)
	move_and_slide()

# flips the character sprite on h axle based on the character_direction:
func flip_sprite(character_direction):
	if character_direction.x == 1:
		animated_sprite.flip_h = false
	elif character_direction.x == -1:
		animated_sprite.flip_h = true

# State machine:
func initate_state_machine():
	main_sm = LimboHSM.new()
	add_child(main_sm)

	# Creating new states with their call on enter/ call on update:
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var move_x_state = LimboState.new().named("move_x").call_on_enter(move_x_start).call_on_update(move_x_update)
	var move_y_state = LimboState.new().named("move_y").call_on_enter(move_y_start).call_on_update(move_y_update)

	# Adding the new found states:
	main_sm.add_child(idle_state)
	main_sm.add_child(move_x_state)
	main_sm.add_child(move_y_state)

	main_sm.initial_state = idle_state

	main_sm.add_transition(idle_state, move_x_state, &"to_move_x")
	main_sm.add_transition(idle_state, move_y_state, &"to_move_y")
	main_sm.add_transition(main_sm.ANYSTATE, idle_state, &"state_eneded")

	main_sm.initialize(self)
	main_sm.set_active(true)

# idle state:
func idle_start():
	print("idle state")
	animated_sprite.play("idle")
	

func idle_update(delta: float):
	print("update idle state")
	if velocity.x != 0:
		main_sm.dispatch(&"to_move_x")
	elif velocity.y != 0:
		main_sm.dispatch(&"to_move_y")

# moveing x state:
func move_x_start():
	print("move x state start")
	animated_sprite.play("moveing_side")

func move_x_update(delta: float):
	print("move x state update")
	if velocity.x == 0:
		main_sm.dispatch(&"state_eneded")

# moveing y state:
func move_y_start():
	print("move y state start")
	if character_direction.y == -1:
		animated_sprite.play("moveing_up")
	elif character_direction.y == 1:
		animated_sprite.play("moveing_down")

func move_y_update(delta: float):
	print("move y state update")
	if velocity.y == 0:
		main_sm.dispatch(&"state_eneded")
