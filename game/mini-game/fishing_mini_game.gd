extends Node2D

@export var progress_size = Vector2(0,234)


@export var starting_progress = 25.0
@export var max_progress = 100.0

@export var gain_speed = 13.0
@export var loss_speed = 6.0


var current_progress : float

var is_winning = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_progress = starting_progress
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_winning:
		current_progress += delta * gain_speed
	else:
		current_progress -= delta * loss_speed
	if current_progress >= max_progress:
		win_game()
	if current_progress <= 0:
		lose_game()
	
	update_progess_line()
	pass

func update_progess_line() -> void: # updates the visual part so that it reflects the value of current_progress
	
	$Progress.clear_points()
	$Progress.add_point(progress_size)
	$Progress.add_point(progress_size - progress_size * 2 * (current_progress / max_progress))
	
	$Progress.modulate.r = absf(max_progress - current_progress) / max_progress
	$Progress.modulate.g = current_progress / max_progress
	
	pass


func win_game() -> void:
	pass

func lose_game() -> void:
	pass


func _on_test_win_toggle_toggled(toggled_on: bool) -> void:
	is_winning = toggled_on
	pass # Replace with function body.
