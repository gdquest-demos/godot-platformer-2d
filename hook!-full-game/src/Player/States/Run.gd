extends "res://src/Player/SkillsHFSM/Skill.gd"


func unhandled_input(event: InputEvent) -> void:
	get_parent().unhandled_input(event)


func physics_process(delta: float) -> void:
	var move: = get_parent()
	if _player.is_on_floor():
		if move.get_move_direction().x == 0.0:
			_player.transition_to("Move/Idle")
	else:
		_player.transition_to("Move/Air")
	move.physics_process(delta)