extends State


func _on_Cooldown_timeout() -> void:
	_state_machine.transition_to("Aim")


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	owner.cooldown.connect("timeout", self, "_on_Cooldown_timeout")
	
	owner.is_aiming = false
	owner.cooldown.start()

	var target: HookTarget = owner.get_hook_target()
	if target:
		owner.arrow.hook_position = owner.snap_detector.target.global_position
		target.hooked_from(owner.global_position)

	owner.emit_signal("hooked_onto_target", owner.get_target_position())


func exit() -> void:
	owner.cooldown.disconnect("timeout", self, "_on_Cooldown_timeout")
	