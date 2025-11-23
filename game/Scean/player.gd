extends CharacterBody2D

# Character properties:
@export var speed : float = 180
var character_direction : Vector2


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	character_direction.x = Input.get_axis("move_left","move_right")
	character_direction.y = Input.get_axis("move_up","move_down")
	
	if character_direction:
		velocity = character_direction * speed
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
