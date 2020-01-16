tool
extends State
# Manages Air movement, including jumping and landing.
# You can pass a msg to this state, every key is optional:
# {
	# velocity: Vector2, to preserve inertia from the previous state
	# impulse: float, to make the character jump
	# wall_jump: bool, to take air control off the player for controls_freeze.wait_time seconds upon entering the state
# }
# The player can jump after falling off a ledge. See unhandled_input and jump_delay.


signal jumped

onready var jump_delay: Timer = $JumpDelay
onready var controls_freeze: Timer = $ControlsFreeze

export var acceleration_x := 5000.0


func unhandled_input(event: InputEvent) -> void:
	# Jump after falling off a ledge
	if event.is_action_pressed("jump"):
		if _parent.velocity.y >= 0.0 and jump_delay.time_left > 0.0:
			_parent.velocity = calculate_jump_velocity(_parent.jump_impulse)
		emit_signal("jumped")
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	Events.emit_signal("player_moved", owner)

	# Landing
	if owner.is_on_floor():
		var target_state := "Move/Idle" if _parent.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)

	elif owner.ledge_wall_detector.is_against_ledge():
		_state_machine.transition_to("Ledge", {move_state = _parent})

	if owner.is_on_wall():
		var wall_normal: float = owner.get_slide_collision(0).normal.x
		_state_machine.transition_to("Move/Wall", {"normal": wall_normal, "velocity": _parent.velocity})


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	_parent.acceleration.x = acceleration_x
	_parent.snap_vector.y = 0
	if "velocity" in msg:
		_parent.velocity = msg.velocity 
		_parent.max_speed.x = max(abs(msg.velocity.x), _parent.max_speed.x)
	if "impulse" in msg:
		_parent.velocity += calculate_jump_velocity(msg.impulse)
	if "wall_jump" in msg:
		controls_freeze.start()
		_parent.acceleration = Vector2(acceleration_x, _parent.acceleration_default.y)
		_parent.max_speed.x = max(abs(_parent.velocity.x), _parent.max_speed_default.x)
		jump_delay.start()


func exit() -> void:
	_parent.acceleration = _parent.acceleration_default
	_parent.exit()


# Returns a new velocity with a vertical impulse applied to it
func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return _parent.calculate_velocity(
		_parent.velocity,
		_parent.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)


func _get_configuration_warning() -> String:
	return "" if $JumpDelay else "%s requires a Timer child named JumpDelay" % name
