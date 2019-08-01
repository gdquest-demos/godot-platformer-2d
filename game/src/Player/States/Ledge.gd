extends State


func _setup() -> void:
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")


func _on_Skin_animation_finished(name: String) -> void:
	if name == "ledge":
		_state_machine.transition_to("Move/Idle")


func enter(msg: Dictionary = {}) -> void:
	if not "move_state" in msg:
		return

	var start: Vector2 = owner.global_position
	owner.global_position = (
			owner.ledge_detector.ray_top.global_position
			+ Vector2(owner.ledge_detector.ray_length * sign(msg.move_state.velocity.x), 0.0))
	owner.global_position = owner.floor_detector.get_floor_position()

	msg.move_state.velocity = Vector2.ZERO
	owner.skin.play('ledge', {from = start - owner.global_position})
