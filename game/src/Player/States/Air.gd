tool
extends State
"""
Manages Air movement, including jumping and landing.
You can pass a msg to this state:
{
	velocity: Vector2, to preserve inertia from the previous state
	impulse: float, to make the character jump
}
The player can jump after falling off a ledge. See unhandled_input and jump_delay.
"""

signal jumped

onready var jump_delay: Timer = $JumpDelay

export var acceleration_x: = 3000.0


func _get_configuration_warning() -> String:
	return "" if $JumpDelay else "%s requires a Timer child named JumpDelay" % name


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
	move.physics_process(delta)

	# Landing on the floor
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if move.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)

	elif owner.ledge_detector.is_against_ledge(sign(move.velocity.x)):
		_state_machine.transition_to("Ledge", {move_state = move})

	if owner.is_on_wall() and move.velocity.y > 0:
		var wall_normal: float = owner.get_slide_collision(0).normal.x
		_state_machine.transition_to("Move/Wall", {"normal": wall_normal, "velocity": move.velocity})


func enter(msg: Dictionary = {}) -> void:
	var move: = get_parent()
	move.velocity = msg.velocity if "velocity" in msg else move.velocity
	if "impulse" in msg:
		move.velocity = calculate_jump_velocity(msg.impulse)
	move.acceleration = Vector2(acceleration_x, move.acceleration_default.y)
	move.max_speed.x = max(abs(move.velocity.x), move.max_speed_default.x)
	jump_delay.start()


func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	var move: State = get_parent()
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)


func exit() -> void:
	var move: = get_parent()
	move.acceleration = move.acceleration_default
