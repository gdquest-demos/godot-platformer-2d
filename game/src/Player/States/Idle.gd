tool
extends State


onready var jump_delay: Timer = $JumpDelay


func _get_configuration_warning() -> String:
	return "" if $JumpDelay else "%s requires a Timer child named JumpDelay" % name


func unhandled_input(event: InputEvent) -> void:
	var move = get_parent()
	move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	if owner.is_on_floor() and move.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air")


func enter(msg: Dictionary = {}) -> void:
	var move = get_parent()
	move.enter(msg)
	
	move.max_speed = move.max_speed_default
	move.velocity = Vector2.ZERO
	if jump_delay.time_left > 0.0:
		_state_machine.transition_to("Move/Air")


func exit() -> void:
	get_parent().exit()
