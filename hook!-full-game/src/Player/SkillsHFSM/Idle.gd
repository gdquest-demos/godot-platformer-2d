extends "res://src/Player/SkillsHFSM/Skill.gd"


onready var jump_delay: Timer = $JumpDelay


func ready(player: KinematicBody2D) -> void:
	.ready(player)
	var move: = get_parent()
	# force update once at start of game
	player.move_and_slide(move.velocity, _player.FLOOR_NORMAL)


func unhandled_input(event: InputEvent) -> void:
	get_parent().unhandled_input(event)


func physics_process(delta: float) -> void:
	if _player.is_on_floor() and get_parent().get_move_direction().x != 0.0:
		_player.transition_to("Move/Run")
	elif not _player.is_on_floor():
		_player.transition_to("Move/Air")


func enter(msg: Dictionary = {}) -> void:
	var move = get_parent()
	move.speed = move.XY_MAX_SPEED
	move.velocity = Vector2.ZERO
	if jump_delay.time_left > 0.0:
		move.velocity = move.calculate_jump_velocity(move.velocity)
		_player.transition_to("Move/Air")