extends State
# Moves the player freely around the world, ignoring collisions.
# This state has its own movement code so it doesn't depend on or mess with the Move state
# Use the move_* input to move the character, or click
# debug_sprint, assigned to Shift on the keyboard and B on an XBOX controller, moves the character faster


var velocity := Vector2.ZERO
const speed := Vector2(600.0, 600.0)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('toggle_debug_move'):
		_state_machine.transition_to('Move/Air', {'velocity': Vector2.ZERO})
	if event.is_action_pressed('click'):
		owner.position += owner.get_local_mouse_position()


func physics_process(delta: float) -> void:
	var direction := get_move_direction()
	var multiplier := 3.0 if Input.is_action_pressed('debug_sprint') else 1.0
	velocity = speed * direction * multiplier
	owner.position += velocity * delta
	Events.emit_signal("player_moved", owner)


func enter(_msg: Dictionary = {}):
	owner.is_active = false


func exit():
	owner.is_active = true


func get_move_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
