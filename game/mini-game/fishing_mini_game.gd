extends Node2D

signal mini_game_ended(did_player_win : bool) # emitted once game resolves


@export var progress_size = Vector2(0,234)


@export var starting_progress = 25.0
@export var max_progress = 100.0

@export var gain_speed = 13.0
@export var loss_speed = 6.0

@export var top_border : Node2D
@export var bot_border : Node2D

@export var fish : Node2D
@export var fish_speed = 45
var fish_direction = -1


@export var catcher : Node2D
@export var catcher_speed = 20
var catcher_inertia = 0


var current_progress : float

var is_winning = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_progress = starting_progress
	
	_on_fish_trashing_timer_timeout() # calling this once at start makes the fish not move the exact same way every time the game starts
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
	move_fish(delta)
	

	move_catcher(delta)
	pass

func update_progess_line() -> void: # updates the visual part so that it reflects the value of current_progress
	
	$Progress.clear_points()
	$Progress.add_point(progress_size)
	$Progress.add_point(progress_size - progress_size * 2 * (current_progress / max_progress))
	
	# evil color change
	$Progress.modulate.r = absf(max_progress - current_progress) / max_progress
	$Progress.modulate.g = current_progress / max_progress
	
	pass

func move_fish(delta : float) -> void:
	fish.position.y += delta * fish_speed * fish_direction
	fish.position.y = max(fish.position.y, top_border.position.y)
	fish.position.y = min(fish.position.y, bot_border.position.y)
	pass

func move_catcher(delta : float) -> void:
	if Input.is_action_pressed("ui_accept"):
		catcher_inertia -= delta * 15.0
	else:
		catcher_inertia += delta * 2.0
	catcher.position.y += delta * catcher_speed * catcher_inertia
	if catcher.position.y < bot_border.position.y :
		catcher_inertia *= -1
	if catcher.position.y > top_border.position.y :
		catcher_inertia *= -1
	catcher.position.y = max(catcher.position.y, top_border.position.y)
	catcher.position.y = min(catcher.position.y, bot_border.position.y)
	pass

func win_game() -> void:
	mini_game_ended.emit(true)
	pass

func lose_game() -> void:
	mini_game_ended.emit(false)
	pass


func _on_test_win_toggle_toggled(toggled_on: bool) -> void:
	is_winning = toggled_on
	pass # Replace with function body.


func _on_fish_trashing_timer_timeout() -> void:
	if randf()>0.5: # flip a coin
		fish_direction *= -1 # if heads - flip fish_direction 
		
	if randf()>0.5: # flip another coin
		fish_speed *= 1.4 # if heads - speed up fish
	else:
		fish_speed *= 0.8# if tails - slow it down
	
	pass # Replace with function body.
