extends "res://src/Player/States/State.gd"


func _on_Skin_animation_finished(name: String) -> void:
	if name == "ledge":
		_state_machine.transition_to("Move/Idle")


func setup(player: KinematicBody2D, state_machine: Node) -> void:
	.setup(player, state_machine)
	_player.skin.connect("animation_finished", self, "_on_Skin_animation_finished")


func enter(msg: Dictionary = {}) -> void:
	if not "move_state" in msg:
		return
	
	var player_global_position_start: = _player.global_position
	_player.global_position = (
			_player.ledge_detector.ray_top.global_position
			+ Vector2(_player.ledge_detector.ray_length * sign(msg.move_state.velocity.x), 0.0))
	_player.global_position = _player.floor_detector.get_floor_position()
	
	msg.move_state.velocity = Vector2.ZERO
	var anim_data: = {
		'from': player_global_position_start,
		'to': _player.global_position,
	}
	_player.skin.play('ledge', anim_data)