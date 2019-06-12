extends "res://src/Player/SkillsHFSM/Skill.gd"


signal jumped

onready var jump_delay: Timer = $JumpDelay

const AIR_X_ACCELERATION: = 3000.0


func unhandled_input(event: InputEvent) -> void:
	var move: = get_parent()
	if event.is_action_pressed("jump"):
		if move.velocity.y >= 0.0 and jump_delay.time_left > 0.0:
			move.velocity = move.calculate_jump_velocity(move.velocity)
		emit_signal("jumped")


func physics_process(delta: float) -> void:
	var move: = get_parent()
	move.physics_process(delta)
	if _player.is_on_floor():
		_player.transition_to("Move/Idle")
	elif _player.ledge_detector.is_against_ledge(sign(move.velocity.x)):
		_player.transition_to("Ledge", {move_skill = move})


func enter(msg: Dictionary = {}) -> void:
	var move: = get_parent()
	move.velocity = msg.velocity if "velocity" in msg else move.velocity
	move.acceleration = Vector2(AIR_X_ACCELERATION, move.Y_ACCELERATION)
	jump_delay.start()


func exit() -> void:
	var move: = get_parent()
	move.acceleration = Vector2(move.X_ACCELERATION, move.Y_ACCELERATION)