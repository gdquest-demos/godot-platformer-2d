extends State
# Takes control away from the player and makes the character spawn


func _on_Player_animation_finished(_anim_name: String) -> void:
	_state_machine.transition_to('Move/Idle')


func enter(msg: Dictionary = {}) -> void:
	assert("last_checkpoint" in msg)
	owner.stats.set_invulnerable_for_seconds(2)
	owner.global_position = msg.last_checkpoint.global_position
	owner.is_active = false
	owner.camera_rig.is_active = false
	owner.skin.play("spawn")
	owner.skin.connect("animation_finished", self, "_on_Player_animation_finished")


func exit() -> void:
	owner.is_active = true
	owner.camera_rig.is_active = true
	owner.skin.disconnect("animation_finished", self, "_on_Player_animation_finished")
