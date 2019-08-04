tool
extends State
"""
Manages Air movement, including jumping and landing.
You can pass a msg to this state, every key is optional:
{
	velocity: Vector2, to preserve inertia from the previous state
	impulse: float, to make the character jump
	wall_jump: bool, to take air control off the player for controls_freeze.wait_time seconds upon entering the state
}
The player can jump after falling off a ledge. See unhandled_input and jump_delay.
"""


signal jumped

onready var jump_delay: Timer = $JumpDelay
onready var controls_freeze: Timer = $ControlsFreeze

export var acceleration_x: = 5000.0


func enter(msg: Dictionary = {}) -> void:
	var move: = get_parent()
	move.velocity = msg.velocity if "velocity" in msg else move.velocity
	move.acceleration.x = acceleration_x
	if "impulse" in msg:
		move.velocity += calculate_jump_velocity(msg.impulse)
	if "wall_jump" in msg:
		controls_freeze.start()
		move.acceleration = Vector2(acceleration_x, move.acceleration_default.y)
		move.max_speed.x = max(abs(move.velocity.x), move.max_speed_default.x)
		jump_delay.start()


func unhandled_input(event: InputEvent) -> void:
	var move: = get_parent()
	# Jump after falling off a ledge
	if event.is_action_pressed("jump"):
		if move.velocity.y >= 0.0 and jump_delay.time_left > 0.0:
			move.velocity = calculate_jump_velocity(move.jump_impulse)
		emit_signal("jumped")
	else:
		move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	var direction: Vector2 = move.get_move_direction() if controls_freeze.is_stopped() else Vector2(sign(move.velocity.x), 1.0)
	move.velocity = move.calculate_velocity(
		move.velocity,
		move.max_speed,
		move.acceleration,
		delta,
		direction
	)
	move.velocity = owner.move_and_slide(move.velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)

	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)

	elif owner.ledge_detector.is_against_ledge(sign(move.velocity.x)):
		_state_machine.transition_to("Ledge", {move_state = move})

	if owner.is_on_wall():
		var wall_normal: float = owner.get_slide_collision(0).normal.x
		_state_machine.transition_to("Move/Wall", {"normal": wall_normal, "velocity": move.velocity})


func exit() -> void:
	var move: = get_parent()
	move.acceleration = move.acceleration_default


"""
Returns a new velocity with a vertical impulse applied to it
"""
func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	var move: State = get_parent()
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)


func _get_configuration_warning() -> String:
	return "" if $JumpDelay else "%s requires a Timer child named JumpDelay" % name
