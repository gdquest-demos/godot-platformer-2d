extends State


signal jumped

onready var jump_delay: Timer = $JumpDelay

const X_ACCELERATION: = 3000.0


func unhandled_input(event: InputEvent) -> void:
	var move: = get_parent()
	if event.is_action_pressed("jump"):
		if move.velocity.y >= 0.0 and jump_delay.time_left > 0.0:
			move.velocity = move.calculate_velocity(
					move.velocity, move.speed, Vector2(0.0, move.JUMP_SPEED), 1.0, Vector2.UP)
		emit_signal("jumped")
	else:
		move.unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	move.physics_process(delta)
	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	elif owner.ledge_detector.is_against_ledge(sign(move.velocity.x)):
		_state_machine.transition_to("Ledge", {move_state = move})
	
	if owner.is_on_wall():
		var wall_normal: float = owner.get_slide_collision(0).normal.x
		_state_machine.transition_to("Move/Wall", {"normal": wall_normal, "velocity": move.velocity})

func enter(msg: Dictionary = {}) -> void:
	var move: = get_parent()
	move.velocity = msg.velocity if "velocity" in msg else move.velocity
	move.acceleration = Vector2(X_ACCELERATION, move.ACCELERATION.y)
	jump_delay.start()


func exit() -> void:
	var move: = get_parent()
	move.acceleration = move.ACCELERATION
