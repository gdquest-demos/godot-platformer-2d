extends State
# Pulls the character up a ledge, temporarily taking control away from the player


func _on_Skin_animation_finished(name: String) -> void:
	if name == "ledge":
		_state_machine.transition_to("Move/Run")


func enter(msg: Dictionary = {}) -> void:
	assert("move_state" in msg and msg.move_state is State)
	
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	
	var start: Vector2 = owner.global_position
	var ld = owner.ledge_wall_detector
	owner.global_position = ld.get_top_global_position() + ld.get_cast_to_directed()
	owner.global_position = owner.floor_detector.get_floor_position()
	msg.move_state.velocity.y = 0.0
	owner.skin.play('ledge', {from = start - owner.global_position})


func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
