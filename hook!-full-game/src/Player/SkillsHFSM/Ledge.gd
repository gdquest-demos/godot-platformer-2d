extends "res://src/Player/SkillsHFSM/Skill.gd"


func _on_Skin_animation_finished(name: String) -> void:
	if name == "ledge":
		_player.transition_to("Move/Idle")


func ready(player: KinematicBody2D) -> void:
	.ready(player)
	_player.skin.connect("animation_finished", self, "_on_Skin_animation_finished")


func enter(msg: Dictionary = {}) -> void:
	if not "move_skill" in msg:
		return
	
	var player_global_position_start: = _player.global_position
	_player.global_position = (
			_player.ledge_detector.ray_top.global_position
			+ Vector2(_player.ledge_detector.ray_length * sign(msg.move_skill.velocity.x), 0.0))
	_player.global_position = _player.floor_detector.get_floor_position()
	
	msg.move_skill.velocity = Vector2.ZERO
	_player.skin.animate_ledge(player_global_position_start, _player.global_position)